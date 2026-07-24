"""Render an extracted API surface into MkDocs pages grouped by utility.

Grouping is by *what a type is for*, not by namespace, because a namespace like
BranchWeaver.Core holds 77 types spanning generation, traversal, and persistence --
which is useless as a way to find anything.

Emits:
  reference/index.md          a filterable table of every public type
  reference/<group>.md        one page per utility area, with full descriptions
  reference/coverage.md       honest documentation-coverage report
"""
import io
import json
import os
import re
import sys

KIND_BADGE = {
    'class': 'class',
    'struct': 'struct',
    'interface': 'interface',
    'enum': 'enum',
}

MEMBER_ORDER = {'constructor': 0, 'property': 1, 'field': 2, 'event': 3, 'method': 4}


def slugify(text):
    return re.sub(r'[^a-z0-9]+', '-', text.lower()).strip('-')


def assign_group(entry, rules, fallback):
    """First matching rule wins, so order rules from specific to general."""
    for rule in rules:
        if 'path' in rule and not re.search(rule['path'], entry['file']):
            continue
        if 'namespace' in rule and not re.search(rule['namespace'], entry['namespace']):
            continue
        if 'name' in rule and not re.search(rule['name'], entry['name']):
            continue
        return rule['group']
    return fallback


def first_sentence(text):
    if not text:
        return ''
    flat = ' '.join(text.split())
    m = re.match(r'(.{0,180}?[.!?])(\s|$)', flat)
    return m.group(1) if m else (flat[:180] + ('...' if len(flat) > 180 else ''))


def anchor_for(entry):
    return slugify(entry['name'])


def render_index(groups, order, product, total_types):
    out = []
    out.append('# API reference')
    out.append('')
    out.append('Every public type in %s, grouped by what it is for rather than by '
               'namespace. **%d types.**' % (product, total_types))
    out.append('')
    out.append('!!! tip "Filter as you type"')
    out.append('    Start typing in the box below to narrow the table. '
               'Use the search icon in the header to search the whole site instead.')
    out.append('')

    # A small dependency-free filter. MkDocs Material's own search covers the
    # whole site; this narrows just this table, which is what you want when
    # scanning an API surface.
    out.append('<input type="text" id="api-filter" class="api-filter" '
               'placeholder="Filter types, groups, or descriptions..." '
               'autocomplete="off" aria-label="Filter API types">')
    out.append('<p id="api-filter-count" class="api-filter-count"></p>')
    out.append('')
    out.append('<div class="api-table" markdown>')
    out.append('')
    out.append('| Type | Kind | Area | What it is for |')
    out.append('| --- | --- | --- | --- |')
    for group in order:
        for entry in groups.get(group, []):
            page = slugify(group) + '.md'
            link = '[`%s`](%s#%s)' % (entry['name'], page, anchor_for(entry))
            summary = first_sentence(entry['doc']['summary'])
            if not summary:
                summary = '_Undocumented._'
            summary = summary.replace('|', '\\|')
            out.append('| %s | %s | %s | %s |' % (
                link, KIND_BADGE.get(entry['kind'], entry['kind']), group, summary))
    out.append('')
    out.append('</div>')
    out.append('')
    return '\n'.join(out) + '\n'


def render_group(group, entries, product):
    out = []
    out.append('# ' + group)
    out.append('')
    documented = [e for e in entries if e['doc']['summary']]
    out.append('%d types in this area.' % len(entries))
    out.append('')

    # A compact jump list; a page with thirty types is unusable without one.
    if len(entries) > 4:
        out.append('!!! abstract "On this page"')
        line = '    ' + ' &middot; '.join(
            '[%s](#%s)' % (e['name'], anchor_for(e)) for e in entries)
        out.append(line)
        out.append('')

    for entry in entries:
        out.append('## ' + entry['name'])
        out.append('')
        declaration = 'public %s%s %s' % (
            (entry['modifiers'] + ' ') if entry['modifiers'] else '',
            entry['kind'], entry['name'])
        if entry['bases']:
            declaration += ' : ' + entry['bases']
        out.append('```csharp')
        out.append(declaration)
        out.append('```')
        out.append('')
        out.append('`%s` &middot; <small>%s</small>' % (entry['namespace'], entry['file']))
        out.append('')

        if entry['doc']['summary']:
            out.append(entry['doc']['summary'])
            out.append('')
        else:
            out.append('!!! warning "Not yet documented"')
            out.append('    This type has no summary comment in the source. '
                       'Its name and signature are accurate; the description is missing.')
            out.append('')

        if entry['doc']['remarks']:
            out.append('!!! note "Remarks"')
            for line in entry['doc']['remarks'].split('\n'):
                out.append('    ' + line if line.strip() else '')
            out.append('')

        if entry['kind'] == 'enum' and entry['enum_values']:
            out.append('| Value | Meaning |')
            out.append('| --- | --- |')
            for value in entry['enum_values']:
                text = first_sentence(value['doc']['summary']) or '&mdash;'
                out.append('| `%s` | %s |' % (value['name'], text.replace('|', '\\|')))
            out.append('')

        members = sorted(
            entry['members'], key=lambda m: (MEMBER_ORDER.get(m['kind'], 9), m['name']))
        if members:
            by_kind = {}
            for member in members:
                by_kind.setdefault(member['kind'], []).append(member)

            for kind in ('constructor', 'property', 'field', 'event', 'method'):
                group_members = by_kind.get(kind)
                if not group_members:
                    continue
                label = {'constructor': 'Constructors', 'property': 'Properties',
                         'field': 'Fields', 'event': 'Events',
                         'method': 'Methods'}[kind]
                out.append('**%s**' % label)
                out.append('')
                for member in group_members:
                    signature = member['signature'].replace('|', '\\|')
                    summary = member['doc']['summary']
                    out.append('`%s`' % signature)
                    out.append('')
                    if summary:
                        out.append(':   ' + ' '.join(summary.split()))
                    else:
                        out.append(':   &mdash;')
                    if member['doc']['params']:
                        for param in member['doc']['params']:
                            out.append('    - `%s` &mdash; %s' % (
                                param['name'], ' '.join(param['text'].split())))
                    if member['doc']['returns']:
                        out.append('    - **Returns** &mdash; %s' % ' '.join(
                            member['doc']['returns'].split()))
                    out.append('')

        out.append('---')
        out.append('')

    return '\n'.join(out) + '\n'


def render_coverage(groups, order, product, api):
    total = len(api)
    documented = sum(1 for e in api.values() if e['doc']['summary'])
    members = sum(len(e['members']) for e in api.values())
    doc_members = sum(1 for e in api.values() for m in e['members'] if m['doc']['summary'])

    out = []
    out.append('# Documentation coverage')
    out.append('')
    out.append('Generated from source alongside the reference itself, so it cannot '
               'quietly drift. This page exists because a reference that hides its own '
               'gaps is worse than one that admits them.')
    out.append('')
    out.append('| Scope | Documented | Total | Coverage |')
    out.append('| --- | --- | --- | --- |')
    out.append('| Public types | %d | %d | %d%% |' % (
        documented, total, round(100.0 * documented / max(1, total))))
    out.append('| Public members | %d | %d | %d%% |' % (
        doc_members, members, round(100.0 * doc_members / max(1, members))))
    out.append('')
    out.append('## By area')
    out.append('')
    out.append('| Area | Types | Documented | Coverage |')
    out.append('| --- | --- | --- | --- |')
    for group in order:
        entries = groups.get(group, [])
        if not entries:
            continue
        have = sum(1 for e in entries if e['doc']['summary'])
        out.append('| [%s](%s) | %d | %d | %d%% |' % (
            group, slugify(group) + '.md', len(entries), have,
            round(100.0 * have / len(entries))))
    out.append('')
    out.append('## How to read this')
    out.append('')
    out.append('Low coverage in an area is usually **not** a sign that the types are '
               'unclear. Much of the surface is small immutable data carriers and enums '
               'whose names and signatures are self-describing: a `StableId Id { get; }` '
               'needs no prose.')
    out.append('')
    out.append('The areas worth caring about are the ones you call directly. Those are '
               'listed first on the [reference index](index.md).')
    out.append('')
    return '\n'.join(out) + '\n'


def main(api_path, config_path, out_dir, product):
    api = json.load(io.open(api_path, encoding='utf-8'))
    config = json.load(io.open(config_path, encoding='utf-8'))
    rules = config['rules']
    fallback = config.get('fallback', 'Other')
    order = config['order']

    groups = {}
    for key in sorted(api):
        entry = api[key]
        if config.get('exclude_namespaces'):
            if any(re.search(p, entry['namespace'])
                   for p in config['exclude_namespaces']):
                continue
        group = assign_group(entry, rules, fallback)
        groups.setdefault(group, []).append(entry)

    for group in groups:
        groups[group].sort(key=lambda e: e['name'])

    # Any group produced by a rule but absent from `order` would silently vanish.
    for group in groups:
        if group not in order:
            order.append(group)

    if not os.path.isdir(out_dir):
        os.makedirs(out_dir)

    total_types = sum(len(v) for v in groups.values())
    io.open(os.path.join(out_dir, 'index.md'), 'w', encoding='utf-8', newline='\n').write(
        render_index(groups, order, product, total_types))
    io.open(os.path.join(out_dir, 'coverage.md'), 'w', encoding='utf-8', newline='\n').write(
        render_coverage(groups, order, product, api))

    for group in order:
        entries = groups.get(group)
        if not entries:
            continue
        path = os.path.join(out_dir, slugify(group) + '.md')
        io.open(path, 'w', encoding='utf-8', newline='\n').write(
            render_group(group, entries, product))

    print('%s: %d types across %d areas' % (product, total_types, len(
        [g for g in order if groups.get(g)])))
    for group in order:
        if groups.get(group):
            have = sum(1 for e in groups[group] if e['doc']['summary'])
            print('  %-38s %3d types (%d documented)' % (group, len(groups[group]), have))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
