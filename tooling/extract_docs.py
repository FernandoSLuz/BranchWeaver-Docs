"""Extract the public API surface of a Unity package, with its XML doc comments.

Reads `///` comments straight from source, so the generated reference cannot drift
into describing members that do not exist or summaries that were never written.

Output is a JSON document consumed by generate_api.py.
"""
import io
import json
import os
import re
import sys

# --- declaration matching -------------------------------------------------

NAMESPACE = re.compile(r'^\s*namespace\s+([A-Za-z0-9_.]+)')

TYPE = re.compile(
    r'^\s*public\s+((?:sealed\s+|abstract\s+|static\s+|readonly\s+|partial\s+)*)'
    r'(class|struct|interface|enum)\s+([A-Za-z0-9_]+)([^{]*)')

# Public members of a private nested helper are not public API. Keep enough
# scope information to avoid attributing those members to their public parent.
NONPUBLIC_TYPE = re.compile(r'^\s*(?:private|internal|protected)\b[^{};]*\b(?:class|struct|interface|enum)\b')

# The terminator alternatives are tried left to right, so `=>` has to precede the
# bare `=` or every expression-bodied property would read as a field. `=` is in the
# list because fields with initializers (including stable ID tables) do not reach
# their semicolon on the declaration line the parser sees.
MEMBER = re.compile(
    r'^\s*public\s+(?!class\b|struct\b|interface\b|enum\b)'
    r'((?:static\s+|virtual\s+|override\s+|readonly\s+|const\s+|abstract\s+|sealed\s+|'
    r'event\s+|async\s+|extern\s+|unsafe\s+|new\s+)*)'
    r'([A-Za-z0-9_<>\[\],.?:\s]+?)\s+([A-Za-z0-9_]+(?:\s*<[^>{}()]+>)?)\s*(\(|\{|=>|;|=|$)')

# A constructor looks like `public TypeName(` with no return type.
CTOR = re.compile(r'^\s*public\s+([A-Za-z0-9_]+)\s*\(')

ATTRIBUTE = re.compile(r'^\s*\[')
DOC_LINE = re.compile(r'^\s*///\s?(.*)$')
# A conditionally compiled declaration puts `#if SYMBOL` between the doc comment
# and the type, so directives have to be transparent the same way attributes are.
# Otherwise a documented type reads as undocumented -- which is worse than a plain
# gap, because the reference then prints a "not documented" warning over real prose.
DIRECTIVE = re.compile(r'^\s*#\s*(if|else|elif|endif|region|endregion|pragma|nullable|define|undef|line|warning|error)\b')

EXCLUDE_DIR_PARTS = ('Tests', 'InternalTools', 'Internal', 'Library', 'obj', 'Temp')
# Samples are optional shipped examples; the Unity 6-only UIToolkit assembly remains
# in the reference because it is part of the current backend surface. Its support
# guard is visible in the source and is not silently presented as a 2022.3 feature.
EXCLUDE_DIR_PARTS += ('Samples',)
EXCLUDE_TYPE_NAMES = {
    'IMapDevelopmentHost', 'MapDevelopmentCommandResult', 'MapDevelopmentFailureKind',
}
EXCLUDE_MEMBERS = {
    ('MapRuntimeDiagnosticCodes', 'DevelopmentUnsupported'),
}


# --- XML doc comment parsing ---------------------------------------------

def clean_inline(text):
    """Turn XML doc inline tags into Markdown."""
    if not text:
        return ''
    # A cref may carry a documentation-ID prefix ("T:Foo.Bar", "M:Foo.Bar"), which is
    # stripped. The colon has to be required: with it optional, `cref="BattleSnapshot"`
    # matched B as the prefix and the reference rendered as `attleSnapshot`.
    text = re.sub(r'<see\s+cref="(?:[A-Za-z]:)?([^"]+)"\s*/>', r'`\1`', text)
    text = re.sub(r'<see\s+cref="(?:[A-Za-z]:)?([^"]+)"\s*>(.*?)</see>', r'`\2`', text, flags=re.S)
    text = re.sub(r'<see\s+href="([^"]+)"\s*/>', r'\1', text)
    text = re.sub(r'<seealso\s+cref="(?:[A-Za-z]:)?([^"]+)"\s*/>', r'`\1`', text)
    text = re.sub(r'<paramref\s+name="([^"]+)"\s*/>', r'`\1`', text)
    text = re.sub(r'<typeparamref\s+name="([^"]+)"\s*/>', r'`\1`', text)
    text = re.sub(r'<c>(.*?)</c>', r'`\1`', text, flags=re.S)
    text = re.sub(r'</?para>', '\n\n', text)
    text = re.sub(r'<code>(.*?)</code>', r'`\1`', text, flags=re.S)
    text = re.sub(r'<b>(.*?)</b>', r'**\1**', text, flags=re.S)
    text = re.sub(r'<i>(.*?)</i>', r'*\1*', text, flags=re.S)
    text = text.replace('&lt;', '<').replace('&gt;', '>').replace('&amp;', '&')
    text = re.sub(r'<[^>]+>', '', text)          # drop any stray tags
    text = re.sub(r'[ \t]+', ' ', text)
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text.strip()


def section(buffer, tag):
    m = re.search(r'<%s>(.*?)</%s>' % (tag, tag), buffer, flags=re.S)
    return clean_inline(m.group(1)) if m else ''


def named_sections(buffer, tag):
    out = []
    for m in re.finditer(r'<%s\s+name="([^"]+)"\s*>(.*?)</%s>' % (tag, tag), buffer, flags=re.S):
        out.append({'name': m.group(1), 'text': clean_inline(m.group(2))})
    return out


def parse_doc(lines):
    """Turn a list of raw /// lines into structured doc fields."""
    buffer = '\n'.join(lines)
    summary = section(buffer, 'summary')
    if not summary and buffer.strip() and '<' not in buffer:
        # A bare /// comment with no tags is still a summary.
        summary = clean_inline(buffer)
    return {
        'summary': summary,
        'remarks': section(buffer, 'remarks'),
        'returns': section(buffer, 'returns'),
        'value': section(buffer, 'value'),
        'params': named_sections(buffer, 'param'),
        'exceptions': [
            {'name': m.group(1), 'text': clean_inline(m.group(2))}
            for m in re.finditer(
                r'<exception\s+cref="(?:[A-Za-z]:)?([^"]+)"\s*>(.*?)</exception>', buffer, flags=re.S)
        ],
        '_inheritdoc': bool(re.search(r'<inheritdoc\b', buffer)),
    }


def _short_type_name(name):
    name = name.strip()
    name = name.split('<', 1)[0]
    return name.rsplit('.', 1)[-1]


def _parameter_text(code):
    """Return a complete parameter list, including nested default expressions."""
    start = code.find('(')
    if start < 0:
        return ''
    depth = 0
    for index in range(start, len(code)):
        if code[index] == '(':
            depth += 1
        elif code[index] == ')':
            depth -= 1
            if depth == 0:
                return code[start + 1:index]
    return code[start + 1:]


def _generic_constraint_text(code):
    """Return generic where clauses between the parameter list and the body."""
    start = code.find('(')
    if start < 0:
        return ''
    depth = 0
    for index in range(start, len(code)):
        if code[index] == '(':
            depth += 1
        elif code[index] == ')':
            depth -= 1
            if depth == 0:
                tail = code[index + 1:].strip()
                if tail.startswith('where '):
                    tail = tail.split('{', 1)[0].split('=>', 1)[0].strip()
                    return ' ' + tail
                return ''
    return ''


def _inherited_doc(entry, member, by_name):
    """Resolve <inheritdoc /> through a documented base/interface member."""
    bases = [b.strip() for b in entry.get('bases', '').split(',') if b.strip()]
    seen = set()
    candidates = []
    while bases:
        base = bases.pop(0)
        short = _short_type_name(base)
        if short in seen:
            continue
        seen.add(short)
        for candidate in by_name.get(short, []):
            if candidate is entry:
                continue
            bases.extend(b.strip() for b in candidate.get('bases', '').split(',') if b.strip())
            if any(m['name'] == member['name'] and m['doc'].get('summary')
                   for m in candidate['members']):
                candidates.extend(m for m in candidate['members']
                                  if m['name'] == member['name'] and m['doc'].get('summary'))
    if len(candidates) == 1:
        return dict(candidates[0]['doc'])
    if candidates:
        # Multiple interfaces can document the same contract identically. Accept
        # only an exact documentation match; otherwise leave it unresolved.
        first = candidates[0]['doc']
        if all(c['doc'] == first for c in candidates[1:]):
            return dict(first)
    return None


def resolve_inherited_docs(api):
    by_name = {}
    for entry in api.values():
        by_name.setdefault(entry['name'], []).append(entry)
    resolved = 0
    for entry in api.values():
        for member in entry['members']:
            if not member['doc'].get('_inheritdoc'):
                continue
            inherited = _inherited_doc(entry, member, by_name)
            if inherited is not None:
                member['doc'] = inherited
                resolved += 1
    return resolved


# --- file walking --------------------------------------------------------

def parse_file(path, display, out):
    try:
        lines = io.open(path, encoding='utf-8').read().split('\n')
    except Exception:
        return

    namespace = ''
    doc_buffer = []
    current = None
    depth_of_type = None
    entered_body = False
    # Preserve the enclosing type while scanning nested serializable/helper types.
    enclosing = []
    blocked_depth = None
    brace = 0
    # Attributes such as [CreateAssetMenu(...)] often span several lines. While
    # one is open, intervening lines must not clear the pending doc comment.
    attribute_depth = 0

    line_index = 0
    while line_index < len(lines):
        raw = lines[line_index]
        doc = DOC_LINE.match(raw)
        if doc:
            doc_buffer.append(doc.group(1))
            line_index += 1
            continue

        code = raw.split('//')[0]
        stripped = raw.strip()

        # Signatures may wrap after the opening parenthesis. Join the complete
        # declaration before matching so parameter lists and generic constraints
        # are emitted as one compilable signature.
        if (('(' in code and code.count('(') > code.count(')')) and
                (code.lstrip().startswith('public ') or current is not None)):
            while line_index + 1 < len(lines) and code.count('(') > code.count(')'):
                line_index += 1
                code += ' ' + lines[line_index].split('//')[0].strip()
            while line_index + 1 < len(lines) and code.count('(') == code.count(')'):
                continuation = lines[line_index + 1].split('//')[0].strip()
                if not continuation.startswith('where '):
                    break
                line_index += 1
                code += ' ' + continuation

        ns = NAMESPACE.match(code)
        if ns:
            namespace = ns.group(1)
            doc_buffer = []

        matched_declaration = False

        # Unity attributes may share a line with a declaration, e.g.
        # `[Serializable] public sealed class MapUnityEvent ...`.
        declaration_code = re.sub(r'^\s*(?:\[[^\]]*\]\s*)+', '', code)
        t = TYPE.match(declaration_code) if blocked_depth is None else None
        if t:
            modifiers, kind, name, tail = (
                t.group(1).strip(), t.group(2), t.group(3), t.group(4).strip())
            key = namespace + '.' + name
            bases = ''
            if tail.startswith(':'):
                bases = tail.lstrip(':').strip().rstrip('{').strip()
            entry = out.setdefault(key, {
                'kind': kind,
                'modifiers': modifiers,
                'namespace': namespace,
                'name': name,
                'bases': bases,
                'file': display,
                'doc': parse_doc(doc_buffer),
                'members': [],
                'enum_values': [],
            })
            # A partial type declared twice keeps the first non-empty doc.
            if not entry['doc']['summary'] and doc_buffer:
                entry['doc'] = parse_doc(doc_buffer)
            if current is not None:
                enclosing.append((current, depth_of_type, entered_body))
            current = key
            depth_of_type = brace
            entered_body = False
            matched_declaration = True
            doc_buffer = []

        elif blocked_depth is None and current is not None and NONPUBLIC_TYPE.match(declaration_code):
            # Suspend the public parent while a private/internal nested type is open.
            enclosing.append((current, depth_of_type, entered_body))
            current = None
            depth_of_type = brace
            entered_body = False
            blocked_depth = brace
            doc_buffer = []

        elif current is not None and entered_body:
            entry = out[current]

            if entry['kind'] == 'enum':
                # Enum members are bare identifiers, optionally assigned.
                em = re.match(r'^\s*([A-Za-z_][A-Za-z0-9_]*)\s*(=\s*[^,]+)?,?\s*$', code)
                if em and em.group(1) not in ('get', 'set'):
                    entry['enum_values'].append({
                        'name': em.group(1),
                        'doc': parse_doc(doc_buffer),
                    })
                    matched_declaration = True
                    doc_buffer = []
            else:
                ctor = CTOR.match(code)
                mm = MEMBER.match(code)
                if mm is None and entry['kind'] == 'interface':
                    # Interface members are implicitly public and omit the
                    # modifier that MEMBER normally requires.
                    mm = MEMBER.match('public ' + code.lstrip())
                if ctor and ctor.group(1) == entry['name']:
                    params = _parameter_text(code)
                    entry['members'].append({
                        'kind': 'constructor',
                        'modifiers': '',
                        'type': '',
                        'name': entry['name'],
                        'signature': 'public ' + entry['name'] + '(' + params + ')',
                        'doc': parse_doc(doc_buffer),
                    })
                    matched_declaration = True
                    doc_buffer = []
                elif mm:
                    modifiers = mm.group(1).strip()
                    rtype = ' '.join(mm.group(2).split())
                    name = mm.group(3)
                    tail = mm.group(4)
                    # Classify by what terminates the declaration:
                    #   '('  a method
                    #   ';' or '='  a field (possibly with an initializer)
                    #   '{'  a property whose accessors open on this line
                    #   ''   a property whose brace is on the next line
                    #   '=>' an expression-bodied property
                    if 'event' in modifiers:
                        kind = 'event'
                    elif tail == '(':
                        kind = 'method'
                    elif tail == ';' or tail == '=':
                        kind = 'field'
                    else:
                        kind = 'property'
                    signature = 'public ' + (modifiers + ' ' if modifiers else '') + rtype + ' ' + name
                    if tail == '(':
                        signature += '(' + _parameter_text(code) + ')' + _generic_constraint_text(code)
                    if (entry['name'], name) not in EXCLUDE_MEMBERS:
                        entry['members'].append({
                        'kind': kind,
                        'modifiers': modifiers,
                        'type': rtype,
                        'name': name,
                        'signature': signature,
                        'doc': parse_doc(doc_buffer),
                        })
                    matched_declaration = True
                    doc_buffer = []

        # Attributes sit between a doc comment and its declaration, so they must
        # not clear the buffer -- including multi-line ones, which is why the
        # bracket depth is tracked rather than just matching a leading '['.
        opens_attribute = ATTRIBUTE.match(raw) is not None
        inside_attribute = attribute_depth > 0 or opens_attribute
        if opens_attribute or attribute_depth > 0:
            attribute_depth += code.count('[') - code.count(']')
            if attribute_depth < 0:
                attribute_depth = 0

        is_directive = DIRECTIVE.match(raw) is not None

        if not matched_declaration and not inside_attribute and not is_directive and stripped != '':
            doc_buffer = []

        brace += code.count('{') - code.count('}')

        if depth_of_type is not None:
            if not entered_body:
                if brace > depth_of_type:
                    entered_body = True
            elif brace <= depth_of_type:
                if enclosing:
                    current, depth_of_type, entered_body = enclosing.pop()
                    blocked_depth = None
                else:
                    current = None
                    depth_of_type = None
                    entered_body = False
                    blocked_depth = None

        line_index += 1


def collect(root):
    out = {}
    for base, dirs, files in os.walk(root):
        rel = os.path.relpath(base, root).replace('\\', '/')
        parts = rel.split('/')
        # Assembly folders use names such as BranchWeaver.InternalTools; treat
        # the suffix as the excluded component so release-only APIs never leak
        # into the buyer-facing reference when the Assets root is scanned.
        if any(part in EXCLUDE_DIR_PARTS or any(part.endswith('.' + excluded) for excluded in EXCLUDE_DIR_PARTS)
               for part in parts):
            continue
        for name in sorted(files):
            if name.endswith('.cs'):
                parse_file(os.path.join(base, name), rel + '/' + name, out)
    out = {key: value for key, value in out.items()
           if value['name'] not in EXCLUDE_TYPE_NAMES}
    resolve_inherited_docs(out)
    return out


if __name__ == '__main__':
    root, dest = sys.argv[1], sys.argv[2]
    api = collect(root)
    io.open(dest, 'w', encoding='utf-8', newline='\n').write(
        json.dumps(api, indent=1, sort_keys=True))

    types = len(api)
    members = sum(len(v['members']) + len(v['enum_values']) for v in api.values())
    documented = sum(1 for v in api.values() if v['doc']['summary'])
    doc_members = sum(
        1 for v in api.values() for m in v['members'] if m['doc']['summary'])
    print('types: %d (%d with summaries)' % (types, documented))
    print('members: %d (%d with summaries)' % (members, doc_members))
