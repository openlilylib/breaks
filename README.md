# breaks
A utitlity package to maintain break sets

This [openLilyLib](https://openlilylib.org) package provides support for “break sets”
which are used by a number of packages.  A “break set” is a data structure holding 
lists of times for line breaks, page breaks and page turns.  Each entry can be either
a barnumber of a combination of barnumber and (zero-based) measure-position.

Any number of break sets can be registered and later accessed:

```lilypond
\registerBreakSet original-edition
\setBreaks original-edition line-breaks #'(3 (0 2/4) 5 13)
\setBreaks original-edition page-breaks #'(8)
\setBreaks original-edition page-turns #'(15)

\registerBreakSet manuscript
\setBreaks original-edition line-breaks #'(5 10 17 24)
\setBreaks original-edition page-breaks #'(13)
```

Breaks sets are currently used by the [page-layout](https://github.com/openlilylib/page-layout)
and the [partial-compilation](https://github.com/openlilylib/partial-compilation) packages.

`page-layout` uses them to easily apply alternative breaking, for example to reflect different
musical sources, or to have the engraving match the engraver's copy during music entry.

`partial-compilation` uses them to provide support for compiling systems, pages or
ranges thereof.
