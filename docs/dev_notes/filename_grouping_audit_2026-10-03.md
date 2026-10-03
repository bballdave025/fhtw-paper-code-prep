# Filename/grouping audit — 2026-10-03

The frozen 3,331-image inventory was checked while deriving provenance-aware
group IDs.

An initial parser requiring a five-digit `_NNNNN` image identifier matched
3,227 images and left 104 unmatched.

The unmatched set was then accounted for by source naming convention:

- 75: e-codices-style filenames, principally `-ecod_###`, with optional
  folio/page metadata.
- 19: Cambridge filenames using source-specific hyphenated image identifiers
  rather than the usual underscore-separated `_NNNNN` form.
- 10: miscellaneous naming forms retained for individual inspection.

No filenames were renamed during this audit. Source-specific page/folio/image
identifiers are treated as provenance metadata rather than errors.

Historical filename conventions are preserved in the frozen dataset; the
grouping parser is adapted to the data rather than rewriting the dataset.

Related later archaeology:
`GH/bballdave025/binding-unwinding/bashlog.log` may contain evidence useful 
for reconstructing the earlier dataset supplied to Keith. This is 
deliberately deferred until after the current group-aware split is frozen.
