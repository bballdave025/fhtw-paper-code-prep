# Filename/grouping audit — 2026-10-10

This note supersedes:

`docs/dev_notes/filename_grouping_audit_2026-10-03.md`

It preserves the conclusions from the October 3 audit and adds the
source-specific provenance archaeology completed through October 10.

One final provenance sanity check, especially for ePaveldas-derived material,
may still be worth doing before treating this note as completely closed.

The guiding rule throughout is:

> Preserve the frozen filenames. Adapt the grouping/provenance parser to the
> data. Do not "clean" historical provenance out of the dataset.

---

## 1. Initial parser result

The frozen 3,331-image inventory was checked while deriving provenance-aware
group IDs.

An initial parser required a five-digit `_NNNNN` image identifier before the
controlled RMMFB classification tail.

It matched:

- **3,227 images**

and left:

- **104 unmatched images**

The unmatched set was then accounted for by source naming convention:

- **75 e-codices-family files**
  - principally `-ecod_###` and related forms
  - often with retained folio/page metadata
  - sometimes without a literal `ecod` marker at all
- **19 Cambridge-family files**
  - source-specific hyphenated image identifiers rather than the usual
    underscore-separated `_NNNNN` form
- **10 miscellaneous files**
  - inspected individually below

No filenames were renamed during this audit.

Source-specific page, folio, image, URL-derived, and locally created identifiers
are treated as provenance metadata rather than filename errors.

Historical filename conventions are preserved in the frozen dataset; the
grouping parser is adapted to the data rather than rewriting the dataset.

---

## 2. What the e-codices archaeology established

The e-codices filenames cannot be interpreted as though every numeric field
were a direct source-system sequential image number.

The old working material confirms that DWB was sometimes manually creating a
useful local enumeration because the e-codices interface did not expose an
easy, reliable sequential image number for every displayed image.

The practical workflow included some combination of:

1. preserving obvious early-sequence positions;
2. manually counting image positions in the e-codices grid interface;
3. retaining folio/page labels when available;
4. assigning compact local counters to later images of interest rather than
   counting hundreds of intervening images;
5. preserving repository/shelfmark information in the filename;
6. sometimes retaining previous names and direct source/download URLs in
   auxiliary tables.

This was not merely reconstructed from the present filenames. It is explicitly
visible in the old documentation.

### Google Doc documenting the process

[e-codices_urls_and_base_download_commands](https://docs.google.com/document/d/1WpjBOUT1RlK6UgLX44VJbBB7usm_b7dlJ4zTmXW4VTM/edit)

For:

`Aarau, Aargauer Kantonsbibliothek, MsWettF 13`

the document explicitly labels the naming section:

> My Enumeration (continue beginning, change the later ones)

Examples include:

```text
AarauAargauerKatonsbib_-_MsWettF13-ecod_00001.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_00007_f001r.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_008_f037r.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_009_f037v.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_010_f058r.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_012_f058v.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_013_f096v.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_014_f097v.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_015_f101r.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_015_f101v.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_016_f103r.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_017.jpg
AarauAargauerKatonsbib_-_MsWettF13-ecod_018.jpg
```

The document even preserves the note:

> Yes, two 15s, oops

That is useful evidence: these numbers were serving as practical local
identifiers, not as a formally guaranteed source-system ordinal.

The same document concludes that a table/CSV and a "previous names" reference
would be a better long-term representation.

---

## 3. The e-codices mapping spreadsheet

That table-building work exists here:

[e-Codices_Completion_dl_info_-_0000_All_w_all_pages](https://docs.google.com/spreadsheets/d/1xfrWcwN93n_DnKkT40Bvjoq-fMVqH8lU8TMN8Q-Wuhw/edit)

The spreadsheet includes fields such as:

- `fname_repoID`
- optional title information
- shelfmark / codex ID
- `ecod` marker/suffix
- local image-number prefix
- image-number significant digits
- previous filenames
- second previous filenames
- temporary unique page names
- entry URLs
- page/display URLs

The first substantial codex table maps positions such as:

```text
Front cover
Front paste-down
f. V1r
f. V1v
...
f. 1r
f. 1v
...
```

to local filename numbering and source URLs.

This confirms that the filename was intended to function as one layer in a
larger provenance mapping, not as the sole complete source catalogue.

The spreadsheet appears useful for future:

- reconstruction of provenance;
- sequential downloading;
- throttled downloading;
- rebuilding complete codex image sets;
- mapping source folio labels to local filenames;
- constructing a larger or cleaner future dataset.

It is **not required before freezing the present 3,331-image dataset**.

---

## 4. Relevant e-codices working directory and historical files

Primary working folder:

[e_codices_tools_and_discoveries](https://drive.google.com/drive/folders/1o_U6noI567WEBgHvug818kMtlc8jXobD)

Useful files include:

### Filename extraction instructions

[instructions_for_getting_all_filenames_and_getting_the_ecod_ones.txt](https://drive.google.com/file/d/1kU0luerhFL1umscOm9FOWItt5IvoVjUn/view)

This documents extraction of likely e-codices filenames from the larger image
inventory.

Importantly, the historical instructions explicitly warn that regex matching
for `e-cod` strings:

> doesn't take care of missing 'e-cod's

That directly explains why an e-codices-derived file should not be assumed to
contain the literal token `ecod`.

The same notes record:

- approximately 43,884 filenames before deduplication;
- approximately 41,790 unique filenames afterward;
- an explicit DWB warning about the possibility of human error.

### Historical e-codices filename list

[all_ecod_from_2024.txt](https://drive.google.com/file/d/1gUgO6SpXHoLh7UJKH586V14gvWWmxUy9/view)

This contains numerous examples of the same numbering style:

```text
..._00001
..._00002
..._00003
..._020_p018
..._021_p019
..._022_p454
..._023_p916
```

and similar mixtures of:

- local sequence counters;
- selected later images;
- page numbers;
- folio identifiers;
- binding views;
- source-specific identifiers.

### Larger pre-e-codices inventory

[sorted_uniq_list_of_all_pre_ecod_-_from_2024.txt](https://drive.google.com/file/d/1SkVMaIqLpdq4s6pIHUeJB-Aaz8BewIU8/view)

This is particularly useful when an e-codices-derived filename lacks an
explicit `ecod` token.

---

## 5. Consequences for interpreting e-codices filenames

The parser should **not** assume that:

1. every e-codices-derived filename contains `ecod`;
2. every three-digit or five-digit number is the source site's true sequential
   image ordinal;
3. gaps in the local sequence imply missing source images;
4. `020`, `021`, etc. necessarily correspond to the twentieth and
   twenty-first source images;
5. local sequence values should determine host-object grouping.

Instead, the stable grouping unit should be the host manuscript/codex identity.

Page, folio, image, and local sequence identifiers remain valuable provenance
metadata below that host level.

---

## 6. Cambridge family

The 19 Cambridge-family unmatched files use a source-specific hyphenated image
identifier.

Example:

```text
Cambridge_MS-ADD-10139-000-00001_orc.jpg
```

The original parser missed these because it expected an underscore immediately
before the five-digit image identifier.

These files should remain unchanged.

The parser should recognize the Cambridge convention rather than requiring the
dataset to conform to a newly invented filename syntax.

---

# 7. Ten miscellaneous filenames reviewed individually

## 7.1 Hermetschwil / CodChart139 / 045

```text
Front-back_Matter_Reuse/HermetschwilBndnktnKlstr_CodChart139_045_fmr.jpg
```

Working interpretation:

```text
group_id = HermetschwilBndnktnKlstr_CodChart139
repository/library = HermetschwilBndnktnKlstr
host/shelfmark = CodChart139
local_image_id = 045
class = fmr
```

This is e-codices-like provenance even though the literal `ecod` marker is
absent.

---

## 7.2 Basel Universitätsbibliothek / F-III-15a

```text
No_For_Binding_Reuse/BaselUniversitatsbib_-_F-III-15a_015_fko_oic_nbr.jpg
```

Working interpretation:

```text
group_id = BaselUniversitatsbib_-_F-III-15a
repository = BaselUniversitatsbib
host/shelfmark = F-III-15a
local_image_id = 015
classes = fko_oic_nbr
```

---

## 7.3 Cologny / CodBodmer82

```text
No_For_Binding_Reuse/Cologny_-_CodBodmer82_027_f024v_mmx_nbr.jpg
```

Working interpretation:

```text
group_id = Cologny_-_CodBodmer82
repository = Cologny
host/shelfmark = CodBodmer82
local_image_id = 027
folio_locator = f024v
classes = mmx_nbr
```

The folio information should be preserved as provenance metadata.

---

## 7.4–7.5 Dublin Trinity College / IE-TCD-MS-503

```text
No_For_Binding_Reuse/DublinTrinityCollege_-_Chronicum_IE-TCD-MS-503_p194-591_nbr.jpg
```

```text
No_For_Binding_Reuse/DublinTrinityCollege_-_Chronicum_IE-TCD-MS-503_p200-609_nbr.jpg
```

Both belong to:

```text
group_id = DublinTrinityCollege_-_Chronicum_IE-TCD-MS-503
```

`Chronicum` may be retained as descriptive/popular-title metadata.

The fields:

```text
p194-591
p200-609
```

are consistent with the historical `binding-unwinding` PDF extraction
convention, in which a PDF page and image xref could survive in a filename.

Treat them as source/extraction locators, not as host grouping identifiers.

---

## 7.6 Hermetschwil / CodChart139 / 039

```text
No_For_Binding_Reuse/HermetschwilBndnktnKlstr_CodChart139_039_fko_nbr.jpg
```

This belongs to the same group as item 7.1:

```text
group_id = HermetschwilBndnktnKlstr_CodChart139
```

This is an important grouping example because two observations from the same
host object occur in different classification directories:

- one positive reuse example;
- one `nbr` example.

Therefore grouping must occur **across class directories**.

A split based only on class directory or filename tail could leak one host
object across train/validation/test.

---

## 7.7 Fitzwilliam Museum / MS McClean 20

```text
No_For_Binding_Reuse/MS_20McClean_2067_20_2813v_2014r_29_fko_nbr.jpg
```

The strange-looking internal fields are best explained as a fossil of URL
encoding.

A likely earlier string was approximately:

```text
MS_20McClean_%2067%20%2813v%2014r%29
```

which decodes approximately to:

```text
MS McClean 20 67 (13v 14r)
```

Working interpretation:

```text
group_id = MS_20McClean
institution = Fitzwilliam Museum, Cambridge
host/shelfmark = MS McClean 20
67 = probable source image identifier; exact semantics not fully verified
13v 14r = folio span
29 = encoded ")" fossil, not image number 29
classes = fko_nbr
```

Do not try to normalize this filename in the frozen dataset.

The important grouping information is already recoverable.

---

## 7.8 Bologna / Erbario Aldrovandi / unresolved volume

```text
No_For_Binding_Reuse/UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-Z-idk-if-in-volumes-99991_nbr.jpg
```

The verbose institutional chain was retained deliberately because source
provenance was difficult enough that several institutional names might later
be useful for reconstruction/citation:

```text
UnivBologna
SistemaMusealeDAteneo
AlmaMaterStudiorum
```

Working interpretation:

```text
host/work family =
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi

Vol-Z = unresolved placeholder volume
idk-if-in-volumes = explicit historical uncertainty
99991 = synthetic local uniqueness identifier
class = nbr
```

The `99991` value is **not** a trustworthy source page ordinal.

Historical convention:

values descending from approximately `99999` were sometimes used as synthetic
uniqueness identifiers when a trustworthy source image/page identifier could
not be recovered.

That convention should be documented rather than "corrected."

---

## 7.9 St. Gallen Kantonsbibliothek / VadSlgMs45

```text
Outside_Cover_Reuse/StGallenKantonsbib_VadSlgMs45_021_orc.jpg
```

This case initially looked anomalous because it contains neither a five-digit
source image number nor an explicit `ecod` marker.

The older pre-e-codices inventory resolves the mystery.

It contains exactly:

```text
StGallenKantonsbib_VadSlgMs45_00001
StGallenKantonsbib_VadSlgMs45_020_p267
StGallenKantonsbib_VadSlgMs45_021
```

DWB identifies this manuscript source as e-codices.

The naming pattern is also fully consistent with the separately documented
manual e-codices enumeration strategy:

- preserve an easy beginning as `00001`;
- later retain selected interesting images using compact local counters such
  as `020` and `021`;
- append an actual page/folio locator where useful, e.g. `p267`;
- do not spend time manually counting hundreds of uninteresting intervening
  grid images simply to manufacture a globally exact ordinal.

DWB's 2026-10-10 recollection is that later binding-related views were often
assigned identifiers in this compact local range. He suspects `020` may have
represented a late cover/binding view and `021` a nearby spine or related
binding view.

That exact physical-view reconstruction is a recollection and does **not** need
to become a parser assumption.

For the current split:

```text
group_id = StGallenKantonsbib_VadSlgMs45
local_image_id = 021
class = orc
source family = e-codices
```

Most importantly:

**Do not rename this file merely to insert an `ecod` marker.**

The old filename-extraction instructions explicitly warned that some
e-codices-derived files lacked the marker.

---

## 7.10 Bologna / Erbario Aldrovandi / Vol. VI

```text
Outside_Cover_Reuse/UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-VI-60001_orc.jpg
```

Use the volume-level host key:

```text
group_id =
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-VI
```

with:

```text
class = orc
```

The frozen corpus also contains related filenames such as:

```text
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-I_00001_mbr_ucr_orc.jpg

UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-I_10002-f368r_10002_oic_nbr.jpg

UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-XII-12001-f192r_12001_oic_nbr.jpg
```

That makes it plausible that values such as:

```text
10002
60001
12001
```

belong to a local volume-coded uniqueness/numbering convention rather than
being literal repository-wide image ordinals.

That remains a working inference unless older acquisition material establishes
the exact convention directly.

Nothing about the current group-aware split requires resolving the exact
semantics of `60001`.

This image has also become useful in the separate NTEC measurement/regional
dependence notes, but that is independent of the grouping decision here.

---

# 8. CodexRestitutus special case

Some e-codices material represents digitally reconstructed historical codices
whose surviving fragments are now held by multiple present-day repositories.

Examples include filename families such as:

```text
CodexRestitutus-ecod-003_-_BibliaTheodulfi_...
CodexRestitutus-ecod-004_-_FuldaLegendary_...
CodexRestitutus-ecod-005_-_BibliaAlcuini_...
```

A single reconstructed codex may therefore contain references to multiple
present-day institutions/shelfmarks.

For leakage prevention, the conservative MVP decision is:

> Group observations by reconstructed historical codex when that relationship
> is explicitly encoded, rather than splitting fragments merely because their
> present-day repositories differ.

This may group more aggressively than strictly necessary, but it avoids the
more serious error of allowing closely related observations from one
reconstructed manuscript object to leak across partitions.

---

# 9. Filename provenance versus historical fragment provenance

The filename/grouping work concerns primarily:

- digital-source provenance;
- repository provenance;
- host-volume provenance;
- source image/page/folio provenance;
- acquisition/download provenance.

It does **not** establish the earlier historical origin of the reused fragment.

For example:

```text
repository = BnF
host volume = Ms-Lat-18554
source observation = image 00021
```

does not by itself establish:

- where the reused fragment was originally written;
- when it was written;
- where it was first used;
- when it was discarded;
- when it entered the present binding;
- whether it originated in the same institution as the host volume.

Those are separate historical/codicological questions.

The parser must not smuggle historical-origin claims into digital-source IDs.

---

# 10. Grouping consequence for the MVP split

For the MVP, the goal is **not** to perfectly reconstruct every historical
download operation.

The goal is to derive the strongest cheap host-object grouping key so that
related observations cannot leak across train/validation/test partitions.

Therefore:

- retain source-specific locators;
- retain historical oddities;
- retain uncertainty markers;
- retain URL-encoding fossils;
- retain locally created sequence counters;
- group by host object/codex;
- group by reconstructed historical codex for explicit CodexRestitutus cases;
- group across classification directories;
- do not treat local image counters as host IDs;
- do not rename the frozen 3,331 corpus during this step.

If a stronger grouping interpretation can be recovered cheaply, use it.

If recovering the exact semantics would require historical archaeology that
does not affect host grouping, record the breadcrumb and continue.

---

# 11. Why this is enough for the paper's provenance claim

The frozen RMMFB corpus is not a fully normalized scholarly manuscript
catalogue.

However, many filenames preserve enough structure to recover:

- repository/source collection;
- shelfmark or codex identity;
- host object;
- source image/page/folio locator;
- related observations from the same host;
- historical classification labels.

The current grouping work makes one of those latent relationships explicit:
multiple images from the same host object can be tied together even when they
occur in different RMMFB classes.

This supports a cautious claim of the form:

> RMMFB does not merely return isolated positive images. Retained source
> identifiers and object-level grouping permit many candidate detections to be
> traced back to host volumes and neighboring observations for expert
> investigation.

It does **not** justify claiming that every image currently has:

- a verified persistent source URL;
- a fully normalized shelfmark record;
- complete binding anatomy metadata;
- complete material metadata;
- expert-validated codicological interpretation;
- complete imaging of every adjoining/reverse surface.

---

# 12. Future e-codices work that is explicitly out of scope now

The existing tables could support a much more complete e-codices provenance
system later.

Possible future work includes:

- completing codex-wide tables;
- mapping every local counter to an exact source view;
- retaining persistent source URLs;
- rebuilding complete local codex image sets;
- checking neighboring images automatically;
- tracking previous filename aliases;
- reconstructing missing/unphotographed surfaces where source metadata allows;
- building a larger e-codices-derived training or retrieval dataset.

That work is valuable.

It is also **not required for the current RMMFB MVP**.

The existence of the tables is itself enough to preserve the breadcrumb.

---

# 13. Deferred historical archaeology

Historical `binding-unwinding` logs may contain evidence useful for
reconstructing the earlier binary dataset supplied to Keith.

In particular:

```text
GH/bballdave025/binding-unwinding/bashlog.log
```

may help recover details of the historical experiment.

This belongs to the later Eightfold-Way task of reconstructing Keith's
historical experiment.

It is deliberately deferred until after the current group-aware split is
frozen.

Likewise, exhaustive reconstruction of every e-codices local counter is
deferred.

---

# 14. Remaining sanity check before closing this audit

Before declaring filename/provenance archaeology completely finished, perform
one final targeted check of ePaveldas-derived naming/provenance.

The purpose is **not** to reopen the entire dataset-cleaning project.

The question is only whether ePaveldas introduces another source-specific
filename convention that materially affects the host-object grouping parser or
the interpretation of retained provenance fields.

If not, close the audit.

(There weren't any returned from the following command, so we're good.)

```bash
find . -type f -iname '*.jpg' -printf '%P\n' | \
  grep -Ei 'e.?pav|paveldas'
```

~~If yes, document that convention here and adapt the parser.

Then stop.~~

---

## Final rule

> The filenames are historical provenance artifacts, not strings to beautify.
> Preserve them, extract the strongest cheap host grouping available, freeze
> the split, and move on to the experiment.

Or, less formally:

> We have documented the runway. Keep flying.