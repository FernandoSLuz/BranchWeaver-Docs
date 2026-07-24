/*
 * Live filter for the API reference index table.
 *
 * Material's own search covers the whole site; this narrows just the table on the
 * API overview page, which is what you want when scanning a large surface. It is
 * deliberately dependency-free and re-binds on navigation.instant page swaps.
 */
(function () {
  'use strict';

  var DEBOUNCE_MS = 90;

  function setup() {
    var input = document.getElementById('api-filter');
    var counter = document.getElementById('api-filter-count');
    if (!input || input.dataset.bound === '1') {
      return;
    }
    input.dataset.bound = '1';

    var table = document.querySelector('.api-table table');
    if (!table) {
      return;
    }

    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr'));
    var haystacks = rows.map(function (row) {
      return row.textContent.toLowerCase();
    });
    var total = rows.length;
    var timer = null;

    function report(shown) {
      if (!counter) {
        return;
      }
      counter.textContent = shown === total
        ? total + ' types'
        : shown + ' of ' + total + ' types';
    }

    function apply() {
      // Every whitespace-separated term must match, so "style enum" narrows to
      // enums in the styling area rather than the union of both words.
      var terms = input.value.toLowerCase().split(/\s+/).filter(Boolean);
      var shown = 0;

      for (var i = 0; i < rows.length; i++) {
        var visible = true;
        for (var t = 0; t < terms.length; t++) {
          if (haystacks[i].indexOf(terms[t]) === -1) {
            visible = false;
            break;
          }
        }
        rows[i].hidden = !visible;
        if (visible) {
          shown++;
        }
      }

      report(shown);
    }

    input.addEventListener('input', function () {
      if (timer) {
        window.clearTimeout(timer);
      }
      timer = window.setTimeout(apply, DEBOUNCE_MS);
    });

    // Escape clears, which is the reflex for any filter box.
    input.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        input.value = '';
        apply();
      }
    });

    report(total);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setup);
  } else {
    setup();
  }

  // navigation.instant replaces the body without a full page load.
  if (window.document$ && typeof window.document$.subscribe === 'function') {
    window.document$.subscribe(setup);
  }
})();
