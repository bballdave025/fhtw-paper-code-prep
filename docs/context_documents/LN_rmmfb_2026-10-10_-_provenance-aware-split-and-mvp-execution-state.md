*BEGIN: Context Document Header*

# CONTEXT DOCUMENT — Continuation

## Project

**Name:**  
RMMFB / Reused Manuscript Fragments in Bindings

**Description:**  
Research and engineering work for identifying, classifying, and retrieving
reused manuscript material in historical book bindings, including dataset
preparation, computer-vision experiments, explainability, provenance, AWS /
SageMaker execution, and preparation of a minimum-publishable paper for
*Fragmentology*.

---

## Continuation Metadata

**Prepared at:**  
1791672584_2026-10-10T18:49:44-0400

Generated via:

```bash
date +'%s_%Y-%m-%dT%H:%M:%S%z'
```

(Boston, MA time)

**Continued from chat:**  
{{Exact current chat title}}

**Also involving:**
- provenance-aware train/validation/test grouping
- filename archaeology and source-specific naming conventions
- e-codices provenance reconstruction
- final ePaveldas sanity check
- canonical 3,331-image dataset verification
- ontology cleanup and historical filename tokens
- AWS / SageMaker smoke-test planning
- historical Keith experiment reconstruction
- ImageNet-pretrained ResNet-50 baseline
- optional higher-resolution ResNet / tiling ideas
- Guided Grad-CAM / guided-backpropagation attribution
- wild-corpus retrieval
- paper framing and provenance claims
- ruthless MVP scope control

---

## Author / Source

**User (GitHub):**  
@bballdave025

**User (ChatGPT):**  
KaMMA / ChatGPT

---

## Intent for This Context

Resume the RMMFB work without reconstructing the extensive dataset,
provenance, grouping, ontology, and experimental decisions that have already
been made. The immediate goal is to finish the last bounded provenance sanity
check, freeze a leakage-resistant group-aware split of the canonical
3,331-image corpus, run a tiny TRAIN-only SageMaker smoke test, and proceed
through the already-agreed minimum-publishable experiment plan.

The near-term publication goal is a rough but scientifically defensible paper
to send to Lisa Fagin Davis before Sunday, 2026-10-18, if practicable. This
deadline should increase scope discipline rather than trigger redesign.

---

## Usage Instructions

- Treat this document as **authoritative project state**.
- Continue with **minimal re-derivation**.
- Reinterpret only when explicitly requested.
- Distinguish clearly among:
  - completed work;
  - current paper work;
  - optional pickups;
  - future/deferred work.
- Do **not** replace the existing Eightfold Way with a newly invented plan.
- Do **not** reopen frozen dataset archaeology unless a concrete current
  scientific need requires it.
- Do **not** silently rename or normalize historical filenames.
- Do **not** turn every interesting branch into a requirement.
- Give exact shell commands in small executable batches during interactive
  work.
- When returning Markdown containing nested code fences for manual copy/paste,
  use the safe transport pattern:
  - outer four-backtick `markdown` fence;
  - ordinary triple-backtick fences inside it.
- Historical notes containing human artifacts such as `oops` should generally
  remain visible when they illuminate how the dataset was actually produced.
  A history with no mistakes is less informative than an honest one.

Governing scope rules:

> **Capture the branch. Stay on the trunk.**

> **Stop improving the runway. Take off.**

> **Paper first. Evidence second. Portfolio for free. Cool new research only
> if it hitchhikes.**

*ENDOF: Context Document Header*

---

# Current State in One Paragraph

The 3,331-image curated RMMFB dataset has been reconciled exactly against the
canonical Google Drive inventory, the ontology has been cleaned enough for the
paper, and the remaining work before actual model execution has narrowed to
the provenance-aware grouping/split contract. A first filename parser matched
3,227 of the 3,331 images and left 104 source-specific exceptions; those have
now been substantially explained as 75 e-codices-family filenames, 19
Cambridge-family filenames, and 10 individually reviewed miscellaneous forms.
The e-codices archaeology in particular established that some numeric filename
fields were intentionally local enumeration rather than source-system
ordinals, and that some e-codices-derived files do not contain an `ecod`
marker. No explicit ePaveldas marker was found by the final quick grep; one
cheap check against an older known-ePaveldas provenance list remains desirable
if that list is easy to recover. After that, the provenance audit should close:
derive `group_id`, make the group-aware split, inspect counts once, freeze/hash
the manifest, vault the test set, select 32–64 TRAIN images for a real RMMFB
SageMaker smoke test, and move into the Eightfold Way.

---

# Repository State

Primary repository:

```text
bballdave025/fhtw-paper-code-prep
```

Current default branch:

```text
main
```

GitHub state checked while preparing this context document:

```text
main HEAD:
f7e766a167cb5d1f73d8b30f8966ce421f7c65f2
```

Commit message:

```text
Add filename/grouping audit documentation
```

That commit added:

```text
docs/dev_notes/filename_grouping_audit_2026-10-03.md
```

Current `docs/dev_notes/` on GitHub contains:

```text
deferred_until_after_mvp.md
filename_grouping_audit_2026-10-03.md
```

A much fuller replacement has now been drafted in the current chat:

```text
docs/dev_notes/filename_grouping_audit_2026-10-10.md
```

Intended handling:

1. preserve all information from the October 3 file;
2. add the October 10 provenance findings;
3. add any final ePaveldas conclusion if useful;
4. commit the October 10 file;
5. remove the October 3 file once the October 10 document genuinely
   supersedes it.

At the time this context document was prepared, the October 10 replacement
was **not yet visible on GitHub**.

A prior attempt by ChatGPT to update the October 3 file through the GitHub
connector returned HTTP 403. The user subsequently re-enabled/confirmed GitHub
permissions, and the connector now reports repository push permission, but
there is no need to solve connector-write behavior before continuing the
paper. Dave currently sees some benefit in performing the commits himself so
that he remains closely aware of repository history.

---

# Context-Document Convention

Governing README:

```text
docs/context_documents/README.md
```

Current earlier context documents include:

```text
LN_rmmfb_2026-09-09_-_minimum-publishable-paper-plan.md
LN_rmmfb_2026-09-18_-_mvp-scaffold-closed-and-execution-plan.md
```

This document is intended to supersede those as the newest continuation
checkpoint while preserving rather than replacing their valid experiment
planning.

Suggested filename:

```text
LN_rmmfb_2026-10-10_-_provenance-aware-split-and-mvp-execution-state.md
```

---

# Paper Objective and Ruthless Scope

The current objective is not a definitive computer-vision solution to reused
manuscript fragments.

It is the smallest scientifically defensible paper that turns the existing
RMMFB work into:

- a reproducible dataset-based experiment;
- a historically grounded baseline;
- a modern pretrained/fine-tuned comparison;
- interpretable attribution examples;
- one richer-label result;
- and a real retrieval/discovery application to the larger wild corpus.

The paper is the trunk.

The large amount of existing work in:

- ontology construction;
- manual classification;
- provenance-preserving naming;
- dataset preparation;
- source scraping;
- negative/fake-out construction;
- reproducibility tooling;
- and historical model experimentation

should now function as sunk scientific foundation rather than invitations to
keep improving infrastructure.

Useful phrases for scope control:

> No. Interesting, but not minimum viable publication.

> Pick one baseline and run it.

> That belongs after submission.

> Capture the branch. Stay on the trunk.

> Stop improving the runway. Take off.

---

# Canonical Dataset Reconciliation — COMPLETE

Canonical curated tree:

```text
/cygdrive/d/ds/rvc3331
```

Canonical Google Drive inventory:

```text
My Drive/
  __General_Reference/
    R/
      RMMFB_-_final_MVP_push_for_Fragmentology/
        consistentized_3331_dataset.txt
```

Google Drive file ID:

```text
1c2BVTQ9Fgt81FhpLG806d1r4ge5aJ4ZC
```

Size:

```text
235390 bytes
```

The old local copy was renamed:

```text
legacy_local_consistencized_3331_dataset.txt
```

The live filesystem inventory was regenerated from the actual curated tree:

```bash
find ./rvc3331 ... > rvc3331_files.sorted.txt
```

Result:

```text
canonical Drive list: 3331 unique entries
live filesystem list: 3331 unique entries
normalized comparison: identical
```

SHA-256:

```text
4d84562384261999c6bbe81a90d0f922e9e2ab57132fef72d7f7e304985110d4
```

Conclusion:

> **The 3,331-image inventory reconciliation is done.**

Do not restart general dataset archaeology merely to feel more certain.

---

# Dataset-Preparation Evidence

Historical dataset-preparation evidence has been preserved separately.

Google Drive / preserved artifact:

```text
dataset_preparation_examples.zip
```

Drive file ID:

```text
1Eo6j4JhOdnFQc73kUstCwJybZrUQcCLC
```

Size:

```text
353506 bytes
```

The public active paper repo does not need all old preparation logs in its
working tree.

---

# Curated and Wild Corpora

## Curated corpus

```text
3,331 manually curated/classified images
```

Properties include:

- heterogeneous digital libraries/repositories;
- custom physical-role ontology;
- provenance-rich filenames;
- positive binding-reuse cases;
- subtle cases;
- explicit negatives;
- fake-outs/counterexamples;
- multiple images from the same physical/digital host object;
- varying source-specific naming conventions.

## Wild corpus

Recovered/deduplicated candidate corpus:

```text
~41,790 distinct images
```

This corpus is not comprehensively labeled.

Therefore the wild-corpus stage is:

```text
retrieval / discovery
```

not ordinary closed-set evaluation.

Do not claim whole-corpus precision/recall as though every wild image had
ground truth.

Instead:

- save scores;
- preserve ranking;
- preserve provenance;
- favor useful recall;
- review candidates;
- distinguish benchmark evaluation from retrieval/discovery.

---

# Ontology State

The ontology is mature enough for the current paper.

Current codes:

| Code | Short | Meaning |
|---|---|---|
| c1 | `orc` | Outside_Cover_Reuse |
| c2 | `ucr` | Under_Cover_Reuse |
| c3 | `spr` | Spine_Protection_Reuse |
| c4 | `fmr` | Front-back_Matter_Reuse |
| c5 | `obr` | One_Behind_Reuse |
| c6 | `cwa` | Cover_Wraparound_Reuse |
| c7 | `tbr` | Tiny_Background_Reuse |
| c8 | `scg` | Connecting_or_Guard_Reuse |
| c9 | `abg` | Across_Book_Gutter_Reuse |
| c10 | `wpr` | Wrapper_Reuse |
| c15 | `gni` | General_Not_In_Situ_Reuse |
| c101 | `mcl` | Multiple_Classes |
| c102 | `mbr` | Multiple_Binding_Reuse_Classes |
| c103 | `mmx` | Multiple_Mixed_But_All_Not_Binding |
| c111 | `fko` | Fake_Out |
| c112 | `iac` | Important_as_Counter_Example |
| c113 | `suh` | Somewhat_Uneasy_with_Classification_or_Hard — DEPRECATED |
| c121 | `nbr` | No_For_Binding_Reuse |
| c122 | `oic` | No_Binding_Reuse_but_Other_Interesting_Classes |
| c123 | `noi` | Nothing_Interesting |
| c124 | `dnu` | Do_Not_Use |
| c125 | — | Unsure |

Important rules:

- `suh` is deprecated/banished.
- Do **not** resurrect `suh` as an active label.
- Historical filenames retaining `_suh` remain unchanged.
- Active label interpretation ignores the historical `suh` token.
- `pasteboard` is not an ontology class.
- `wpr` remains conceptually/historically valid but has no marked examples in
  the frozen 3,331 corpus.
- `Unsure` has no filename suffix.

The bounded `suh` audit found:

```text
28 files containing _suh
4 also containing _fko
0 hard contradictions
1 reviewed mbr case
```

The ontology/classification repository was updated so that deprecation is
documented consistently.

Repository:

```text
bballdave025/congenial-chainsaw-rmfb-html
```

Historical filename oddities should remain historical evidence rather than
becoming cleanup targets.

---

# Existing Eightfold Way — DO NOT REPLACE

This remains the agreed minimum-publication plan.

## Way 1 — Lock claim and experimental contract before outcomes

Freeze in advance:

- binary question;
- evaluation metrics;
- difficulty tiers;
- split/leakage rules;
- preprocessing;
- input resolution;
- what counts as completion.

The current grouping/split work is part of completing Way 1.

## Way 2 — Reconstruct Keith's historical binary experiment faithfully

Recover as much as practicable of:

- exact or nearest-recoverable cohort;
- filenames/image IDs;
- labels;
- split behavior;
- preprocessing;
- historical resize;
- model/code;
- historical claim/context;
- unrecoverable differences.

This is historical reconstruction, not optimization.

A historical "100%" result must remain cautiously described until leakage and
dataset details have been reconstructed.

## Way 3 — Freeze binary difficulty progression before outcomes

Approximate staircase:

```text
~1000
~1500
~2000
~2500
~3000
optional/full: 3331
```

The first cohort was intentionally easier/obvious.

Keith's later "fouled up" images meant harder/subtler cases, not corrupted
input.

## Way 4 — Fixed pretrained low-resolution baseline

Use:

```text
ImageNet-pretrained ResNet-50
224 x 224 model input
frozen pretrained backbone
small trained binary RMMFB head / linear probe
no backbone fine-tuning initially
```

Important correction to avoid a meaningless baseline:

> A stock 1000-way ImageNet classification head with no RMMFB-trained output
> layer is not the intended binary RMMFB baseline.

The meaningful frozen baseline is:

```text
pretrained frozen feature extractor
+
trained small RMMFB binary classification head
```

## Way 5 — Fine-tune same model at same resolution

Keep:

```text
ResNet-50
224 x 224
```

and then fine-tune for the RMMFB binary task.

Metrics:

- accuracy;
- precision;
- recall;
- F1;
- confusion matrix.

For the retrieval/discovery motivation, recall matters strongly.

## Way 6 — Attribution

Use the already-selected Guided Grad-CAM / guided-backpropagation lineage.

Do **not** launch an attribution-method bake-off.

Useful final examples include:

- correct reuse;
- correct no-reuse;
- false positive;
- false negative;
- easy/salient reuse;
- subtle reuse.

Attribution indicates:

> regions influential to the model's decision

not:

> proof of human reasoning, historical correctness, or causal significance.

## Way 7 — One richer-label experiment

Use the existing ontology for **one** controlled richer-label experiment.

Do not turn the minimum paper into an exhaustive ontology benchmark.

## Way 8 — Freeze useful model and apply to wild corpus

Freeze the selected model/configuration.

Run against:

```text
~41,790 wild candidate images
```

Save:

- scores;
- rankings;
- provenance;
- review state where practical.

Use expert/human review.

This stage demonstrates candidate discovery rather than a fully labeled
population-level benchmark.

---

# Test-Set Vault

The final test partition is a vault.

After the test partition is designated:

> No information from the final test set should influence model-development
> decisions.

This includes more than labels.

Repeatedly viewing:

- test errors;
- test examples;
- Grad-CAM maps;
- guided-backprop maps;
- recurring visual characteristics

can influence later preprocessing/model choices even without consciously
"training on the test set."

Therefore:

- training data may be inspected;
- validation data may guide development under the frozen protocol;
- final test attribution examples should be inspected only after relevant
  model-selection decisions are frozen.

The dataset creator having previously seen/annotated an image before the split
does not automatically invalidate it as a held-out model test observation.
The important operational rule is that the designated test partition stops
feeding subsequent model decisions.

---

# Group-Aware Split Contract

The next core artifact should have at minimum:

```text
relative_path,binary_label,group_id,split
```

Random seed:

```text
137
```

The grouping priority is:

> prevent closely related observations from the same host object, physical
> object, codex, or digitization sequence from leaking across partitions.

This is more important than aesthetically perfect global class percentages.

Desired process:

1. derive strongest cheap `group_id`;
2. split groups, not individual images;
3. inspect train/validation/test counts;
4. inspect binary class balance;
5. inspect for glaring imbalance or pathological groups;
6. rerun or use stratified-group logic only if the first result is obviously
   poor;
7. freeze;
8. hash the manifest;
9. vault the test set.

Do not spend days engineering a theoretically perfect splitter.

Methods-language candidate:

> Images were partitioned using group-aware splitting to prevent images from
> the same source object or closely related digitization sequence from
> appearing in multiple partitions. Within those constraints, class
> distributions were balanced as closely as practicable.

Rare-feature stratification has been **dropped as an MVP requirement**.

If a rare subtype happens to balance imperfectly, that is preferable to
allowing host-object leakage or repeatedly hand-tuning the split after seeing
outcomes.

---

# Smoke-Test Rule

The first AWS/SageMaker test must not touch the final test set.

Only after the group-aware split is frozen:

```text
sample 32–64 random TRAIN images
```

Use those for the tiny plumbing/smoke run.

Purpose:

```text
S3
→ SageMaker
→ JPEG decode
→ exact preprocessing
→ ResNet-50 code path
→ artifact
→ S3
```

The smoke test proves the pipeline.

It does not need scientifically meaningful performance.

---

# AWS / SageMaker Execution Plan

Current lean plan:

- one AWS region for the MVP;
- S3 as durable source/artifact store;
- SageMaker local/container storage as working/cache space;
- use native SageMaker checkpoint behavior where useful;
- prefer Managed Spot for real training;
- if Spot configuration blocks a five-minute plumbing test, a tiny on-demand
  job is acceptable;
- do not turn restart/checkpoint engineering into a separate platform project.

Preferred checkpoint mechanism:

```text
checkpoint_s3_uri
```

with the SageMaker checkpoint directory:

```text
/opt/ml/checkpoints
```

The first job uses:

```text
real RMMFB TRAIN data
```

not CIFAR.

The old CIFAR proving ground has already done its job.

---

# Current Preprocessing Contract

Current MVP model input:

```text
224 x 224
```

For the standard pretrained ResNet-50 path, use the preprocessing associated
with the selected TorchVision pretrained weights rather than inventing a new
normalization path.

Historical dataset preparation appears to have used a consistent conversion
pipeline across curated and wild images.

Working reconstruction:

- source web formats normalized;
- PDFs extracted/rendered to PNG at high quality;
- other image formats passed through ImageMagick conversion to PNG;
- PNG later converted to JPEG with consistent encoder/quality behavior;
- grayscale material represented in RGB-compatible form as needed;
- curated and wild images were intended to undergo consistent normalization.

The exact wording of the PDF/lossless conversion claim should be verified from
scripts/logs before it is stated strongly in the Methods section.

Do not overclaim "lossless" unless the historical script evidence supports the
precise statement.

---

# Resolution State

The MVP resolution is:

```text
224 x 224
```

This is closed for the main baseline.

Keith's historical experiment may have used approximately:

```text
175 x 175
```

but that must be recovered from historical code/log evidence rather than
assumed.

Do not silently rewrite Keith's historical setup to 224.

Higher-resolution work is an optional comparison **after** the 224 pipeline
produces the core paper result.

---

# Filename Parser / Provenance Grouping Audit

## Initial parser

The first parser expected:

```text
source basename
+
_NNNNN
+
optional source metadata
+
controlled RMMFB classification tail
+
.jpg
```

Representative Perl logic:

```perl
if ($file =~ /^(.*)_([0-9]{5})(.*?)((?:_(?:orc|ucr|spr|fmr|obr|cwa|tbr|scg|abg|wpr|gni|mcl|mbr|mmx|fko|iac|suh|nbr|oic|noi|dnu))+)\.jpg$/) {
    ...
}
```

Results:

```text
3227 matched
104 unmatched
```

Among the 3,227 matches:

```text
3193 had no extra middle metadata
34 retained extra source metadata between the five-digit number and class tail
```

Examples of retained middle metadata include forms such as:

```text
f001r
f103r
f058r
f058v
p003
p004
fol012v
fol-3b_reduced
0047A
0047B
0060B
0062A
```

and present-holding identifiers in `CodexRestitutus` filenames.

Conclusion:

> Source-specific middle material is provenance metadata, not malformed junk.

Do not rewrite it out of the filenames.

---

# Accounting for the 104 Initially Unmatched Files

The unmatched set was partitioned into:

```text
75 e-codices family
19 Cambridge family
10 miscellaneous
----------------
104 total
```

The accounting command used source-family clues rather than pretending the
first regex was universal.

The useful development note should preserve this exact accounting.

---

# e-codices Discovery — IMPORTANT

The e-codices audit produced a major clarification:

> Numeric fields in these filenames are not uniformly source-system ordinals.

The e-codices interface did not provide a simple, reliable globally sequential
image number for every source view.

Dave sometimes:

- used the grid view;
- arranged/counting rows manually;
- preserved obvious early sequence numbers;
- retained source folio/page names;
- assigned compact local numbers to later images of interest;
- built tables mapping local enumeration to e-codices display labels and URLs.

This was not merely inferred in 2026.

Old working documents explicitly show the system.

---

# e-codices Google Drive Evidence

Working folder:

```text
My Drive/
  __General_Reference/
    P/
      P2_2025_RMFB_Portable/
        e-codices_to_complete_and_new/
          e_codices_tools_and_discoveries/
```

Direct folder:

```text
https://drive.google.com/drive/folders/1o_U6noI567WEBgHvug818kMtlc8jXobD
```

Important Google Doc:

```text
e-codices_urls_and_base_download_commands
```

URL:

```text
https://docs.google.com/document/d/1WpjBOUT1RlK6UgLX44VJbBB7usm_b7dlJ4zTmXW4VTM/edit
```

It explicitly contains the heading:

```text
My Enumeration (continue beginning, change the later ones)
```

for Aarau, Aargauer Kantonsbibliothek, MsWettF 13.

The examples proceed approximately:

```text
..._00001
..._00007_f001r
..._008_f037r
..._009_f037v
..._010_f058r
..._012_f058v
..._013_f096v
..._014_f097v
..._015_f101r
..._015_f101v
..._016_f103r
..._017
..._018
```

The document even preserves:

```text
Yes, two 15s, oops
```

This is useful historical evidence that these are practical local identifiers,
not a formally guaranteed source ordinal.

Preserve the `oops`.

---

# e-codices Mapping Spreadsheet

Main spreadsheet found:

```text
e-Codices_Completion_dl_info_-_0000_All_w_all_pages
```

URL:

```text
https://docs.google.com/spreadsheets/d/1xfrWcwN93n_DnKkT40Bvjoq-fMVqH8lU8TMN8Q-Wuhw/edit
```

It contains fields for concepts such as:

```text
fname_repoID
fname_title_+OPT
fname_shelfmark
ecod_suffix
img_num_prefix
img_num_sigfigs
previously_named_can_be_JSON
second_prev_named
temp_uniq_page_name
temp_entry_URL
this_page_disp_URL
```

The first substantial codex table maps:

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

to local filename numbers and source URLs.

Interpretation:

> The filename was intended as one layer of a larger provenance mapping, not
> as a complete normalized catalogue record.

The spreadsheet is valuable future infrastructure for:

- codex-wide reconstruction;
- complete sequential downloads;
- throttled acquisition;
- mapping source folio/page labels to local image names;
- building a future larger dataset.

It is **not required before freezing the current 3,331-image split**.

---

# Historical e-codices Filename Lists

Useful files include:

```text
all_ecod_from_2024.txt
instructions_for_getting_all_filenames_and_getting_the_ecod_ones.txt
sorted_uniq_list_of_all_pre_ecod_-_from_2024.txt
```

A particularly useful sentence from the old extraction instructions warns
that searching for `e-cod` markers:

```text
doesn't take care of missing 'e-cod's
```

This directly supports the conclusion:

> Some e-codices-derived files intentionally lack the literal `ecod` marker.

Do not infer source family solely from the presence/absence of that string.

---

# St. Gallen Kantonsbibliothek / VadSlgMs45 Case

One of the final miscellaneous filenames was:

```text
Outside_Cover_Reuse/StGallenKantonsbib_VadSlgMs45_021_orc.jpg
```

The old pre-e-codices filename inventory contains:

```text
StGallenKantonsbib_VadSlgMs45_00001
StGallenKantonsbib_VadSlgMs45_020_p267
StGallenKantonsbib_VadSlgMs45_021
```

Dave recognizes `StGallenKantonsbib` / `VadSlgMs45` as e-codices material.

This is consistent with the manual numbering system:

- preserve an easy first observation as `00001`;
- later use local `020`, `021`, etc.;
- retain a source page locator such as `p267` where useful;
- do not manually count hundreds of uninteresting source views merely to
  manufacture a globally exact ordinal.

Current grouping interpretation:

```text
group_id = StGallenKantonsbib_VadSlgMs45
local_image_id = 021
class = orc
source_family = e-codices
```

Do not rename the file merely to insert `ecod`.

---

# Cambridge Family

The 19 Cambridge-family exceptions primarily reflect a different delimiter
convention.

Example:

```text
Cambridge_MS-ADD-10139-000-00001_orc.jpg
```

The first parser expected `_NNNNN`.

Cambridge uses source-specific hyphenation around the corresponding identifier.

Conclusion:

> Adapt the parser to the source convention; do not rename the frozen files.

---

# Ten Miscellaneous Forms — Current Conclusions

The detailed individual descriptions belong in:

```text
docs/dev_notes/filename_grouping_audit_2026-10-10.md
```

The essential grouping conclusions are:

## Hermetschwil / CodChart139

Examples occur across positive and negative classification directories:

```text
Front-back_Matter_Reuse/
  HermetschwilBndnktnKlstr_CodChart139_045_fmr.jpg

No_For_Binding_Reuse/
  HermetschwilBndnktnKlstr_CodChart139_039_fko_nbr.jpg
```

Both must use:

```text
group_id = HermetschwilBndnktnKlstr_CodChart139
```

This is direct evidence that grouping must cross class directories.

## Basel Universitätsbibliothek / F-III-15a

```text
BaselUniversitatsbib_-_F-III-15a_015_fko_oic_nbr.jpg
```

Use:

```text
group_id = BaselUniversitatsbib_-_F-III-15a
```

## Cologny / CodBodmer82

```text
Cologny_-_CodBodmer82_027_f024v_mmx_nbr.jpg
```

Use:

```text
group_id = Cologny_-_CodBodmer82
```

with `f024v` retained as source/folio metadata.

## Dublin Trinity College / IE-TCD-MS-503

Examples:

```text
DublinTrinityCollege_-_Chronicum_IE-TCD-MS-503_p194-591_nbr.jpg
DublinTrinityCollege_-_Chronicum_IE-TCD-MS-503_p200-609_nbr.jpg
```

Use:

```text
group_id = DublinTrinityCollege_-_Chronicum_IE-TCD-MS-503
```

The `p194-591` / `p200-609` material likely reflects the historical
`binding-unwinding` PDF page/xref extraction convention.

Treat it as a locator, not the host identity.

## Fitzwilliam / MS McClean 20

Odd filename:

```text
MS_20McClean_2067_20_2813v_2014r_29_fko_nbr.jpg
```

This is best understood as a fossil of URL encoding, approximately:

```text
MS_20McClean_%2067%20%2813v%2014r%29
```

or:

```text
MS McClean 20 67 (13v 14r)
```

Working grouping key:

```text
group_id = MS_20McClean
```

The terminal `29` is plausibly an encoded closing parenthesis, not "image 29."

The exact meaning of `67` remains less certain, but that does not block host
grouping.

## Bologna / Erbario Aldrovandi / unresolved volume

```text
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-Z-idk-if-in-volumes-99991_nbr.jpg
```

Important historical semantics:

```text
Vol-Z = unresolved placeholder
idk-if-in-volumes = explicit uncertainty
99991 = local synthetic uniqueness ID
```

Values descending from around `99999` were sometimes used when no trustworthy
source page/image ordinal was available.

Do not treat `99991` as a source ordinal.

## Bologna / Erbario Aldrovandi / Vol. VI

```text
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-VI-60001_orc.jpg
```

Use:

```text
group_id =
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-VI
```

Related frozen filenames include volume-coded forms such as:

```text
Vol-I_10002...
Vol-XII-12001...
```

This makes a local volume-coded numbering convention plausible.

Exact `60001` semantics are not required for the split.

---

# CodexRestitutus Grouping Rule

e-codices `CodexRestitutus` can digitally reconstruct a historical codex whose
surviving fragments are now held in multiple present repositories.

Examples include:

```text
CodexRestitutus-ecod-003_-_BibliaTheodulfi_...
CodexRestitutus-ecod-004_-_FuldaLegendary_...
CodexRestitutus-ecod-005_-_BibliaAlcuini_...
```

For leakage prevention:

> Group by the explicitly reconstructed historical codex rather than by the
> present-day holding institution.

This is intentionally conservative.

It is preferable to slightly over-group related material than to place
closely related fragments from one reconstructed codex into different
partitions.

This grouping choice does **not** make any broader claim about whether a
fragment is in situ, binding reuse, or historically related in every possible
sense.

---

# ePaveldas Final Sanity Check

A final quick explicit-marker search was run:

```bash
find . -type f -iname '*.jpg' -printf '%P\n' |
grep -Ei 'e.?pav|paveldas'
```

Result:

```text
no matches
```

This does **not** prove that the frozen 3,331 contain no images originally
obtained through ePaveldas.

The e-codices audit already demonstrated that source-family markers can
disappear during historical renaming.

Therefore the only remaining provenance question is:

> If an old list/table of known ePaveldas-derived files can be recovered
> cheaply, do those filenames reveal another source-specific convention that
> materially changes `group_id` derivation or interpretation of a numeric
> field?

This is a **bounded sanity check**, not permission to reconstruct the entire
ePaveldas acquisition history.

Decision rule:

```text
If old provenance list is easy to find:
    inspect enough examples to establish grouping convention.
    document only a convention that affects current grouping/provenance.
Else:
    record that no explicit marker survives.
    proceed with the split.
```

Then close the filename/provenance audit.

---

# Filename-Audit Principle

The filenames are historical provenance artifacts.

They are not strings to beautify.

The relevant questions are:

```text
Can we recover host identity?
Can we avoid leakage?
Can we trace a candidate back to useful source context?
```

The irrelevant question for the present paper is:

```text
Can we make every filename conform to one immaculate grammar?
```

Therefore:

> Preserve the filenames; adapt the parser.

---

# Provenance Claim for the Paper

Current evidence supports a cautious claim such as:

> RMMFB does not merely return isolated positive images. Its retained source
> identifiers and object-level grouping permit candidate detections to be
> traced back to host volumes and neighboring observations for expert
> investigation.

This is stronger and more useful than "we have filenames," but weaker than
claiming a complete scholarly catalogue.

Do **not** claim that every image has:

- a verified persistent URL;
- fully normalized repository metadata;
- complete material identification;
- dimensions;
- script/date classification;
- complete physical binding anatomy;
- complete adjoining/reverse imaging;
- expert-validated codicological interpretation;
- a normalized correction/reviewer database.

The current provenance is useful and often reconstructable.

It is not yet a normalized manuscript-catalogue database.

---

# Digital/Host Provenance versus Historical Fragment Origin

Keep these conceptually distinct.

## Digital/host provenance

Can include:

```text
repository
collection
shelfmark
host volume
digital sequence
page/folio/image locator
download/source convention
```

## Historical origin of reused material

May concern:

```text
where the fragment was originally written
when it was written
its first use
when it was discarded
how/when it became binding material
whether it originated near the present host
```

The second category requires historical/codicological evidence.

Do not encode a hypothesis about earlier fragment origin as though it were
established by a digital-source filename.

---

# Paper Framing: Why Provenance Matters

A recovered reused fragment can be historically valuable for reasons far
beyond its original text.

The project discussion has highlighted examples where reused manuscript
material accumulates evidence from multiple phases of use, including:

- original manuscript content;
- later annotations;
- pen trials;
- musical/liturgical evidence;
- property information;
- named people;
- payments;
- houses/gardens;
- vineyards;
- local geography;
- institutional relationships.

This supports the broader motivation for retrieval:

> Finding a reused fragment is not merely a visual-classification endpoint.
> It can reopen a source object for expert historical investigation.

Do not overstate what the model itself knows.

The model surfaces candidates.

Experts interpret them.

---

# Historical Keith Experiment — Current Status

Keith's earlier experiment still needs a faithful reconstruction.

Known/remembered state:

- first cohort roughly `~1000`;
- intentionally easier/obvious reuse;
- large visible reuse often on outside covers;
- later additions were harder/subtler;
- "fouled up" meant made harder, not corrupted;
- historical result may have been described as "100%";
- historical image size may have been around `175 x 175`.

Need to recover from actual evidence:

- exact cohort;
- labels;
- split;
- preprocessing;
- resolution;
- model code;
- evaluation procedure;
- whether related observations crossed partitions;
- exact meaning of historical performance claim.

Potential evidence:

```text
bballdave025/binding-unwinding
```

especially:

```text
bashlog.log
```

The `binding-unwinding` repo also established useful historical filename
semantics:

- PDF-extracted raw names could contain both PDF-page and image-xref
  information;
- a documented rename converted PDF page indexing into a one-based
  five-digit form.

Do not inspect the Keith historical logs now unless needed for current group
parsing.

That archaeology belongs to Way 2 after the split contract is frozen.

---

# Higher-Resolution Branch — CAPTURED AND PARKED

Higher resolution remains scientifically interesting because small reused
fragments can disappear when a large source image is compressed into 224
pixels.

This branch must not displace the 224 baseline.

Current conceptual options:

## A. Standard global 224

```text
full image
→ resize/crop/preprocess to 224
→ ordinary pretrained ResNet-50
```

This is the trunk.

## B. Tile-and-aggregate

Example bounded comparison:

```text
fixed 672 x 672 image
→ 3 x 3 non-overlapping 224 x 224 tiles
→ same ordinary pretrained ResNet-50 on every tile
→ simple predeclared aggregation
```

Optional:

```text
stitch tile attribution maps back into source coordinates
```

Terminology:

- `tile-and-aggregate`
- `tile-and-pool`

Use `stitch` primarily when reassembling spatial outputs/attribution.

Advantages:

- uses the same fully ImageNet-pretrained ordinary ResNet-50 for every tile;
- preserves local fine detail at the network's expected scale;
- makes a cleaner "more pixels observed" comparison.

Costs:

- roughly one network pass per tile;
- weakens/globalizes context depending on aggregation;
- requires a predeclared aggregation rule.

## C. Direct larger input to ordinary TorchVision ResNet-50

Because modern ResNet-50 uses adaptive average pooling, it can technically
accept larger spatial dimensions.

For example:

```text
672 x 672 whole image
→ same ordinary ResNet-50
```

Approximate convolutional compute scales with image area.

Relative to 224:

```text
448  ≈ 4x
672  ≈ 9x
896  ≈ 16x
1120 ≈ 25x
1344 ≈ 36x
1792 ≈ 64x
```

This is not free simply because no tiling loop is written.

## D. Hi-ResNet architecture

Repository investigated:

```text
https://github.com/johnGettings/Hi-ResNet
```

It supports approximately:

```text
448
896
1792
```

square input resolutions.

The architecture does **not** simply feed a larger tensor through an otherwise
unchanged standard ResNet-50.

It replaces the original high-resolution entrance with additional learned
front-end machinery, then feeds into a truncated/surviving ResNet-50 trunk.

Current public repository evidence indicates:

```text
new high-resolution head: randomly initialized
surviving ResNet-50 trunk: standard ImageNet pretrained weights
task head: newly trained
```

No current repository evidence was found that the complete enlarged network,
including the added high-resolution front end, had been pretrained end-to-end
on a correspondingly high-resolution ImageNet training run.

If historical commits/releases later show otherwise, update that conclusion.
Do not search old repo history now merely for curiosity unless this experiment
is actually promoted.

This distinction explains why tile-and-aggregate presently looks cleaner for
RMMFB:

> Every tile passes through an ordinary network whose complete normal visual
> hierarchy already benefited from ImageNet pretraining.

If a genuinely end-to-end ImageNet-pretrained 896/1792 ResNet-like model were
available, its ranking as a candidate experiment would change substantially.

## ResNet versus U-Net conceptual note

A standard classification ResNet does not maintain a dedicated parallel
high-resolution information stream all the way to the decision in the way a
U-Net-style encoder/decoder architecture explicitly reintroduces fine spatial
information through skip connections.

Standard ResNet progressively downsamples spatial representations.

Starting with more pixels can still help, but increasingly fine source detail
must survive repeated learned compression/downsampling.

This is one reason "just train vanilla ResNet on enormous images" is not
automatically the universal optimal approach.

## MVP decision

For the paper:

```text
224 first.
```

If a higher-resolution comparison earns its place after the trunk works:

```text
tile-and-aggregate standard ResNet-50
```

is currently the preferred ruthless first experiment.

A possible fixed version is:

```text
672 x 672
3 x 3 tiles
224 x 224 each
same ResNet-50 backbone
simple frozen aggregation rule
```

Hi-ResNet is later.

No 1792-pixel monster before the paper earns it.

---

# NTEC Branch — PARKED

NTEC:

```text
Nyquist Text Existence Criterion
```

is a separate research branch concerning whether the *existence of writing*
remains recoverable under downsampling/measurement.

It is not the current RMMFB paper.

Relevant conceptual descriptors include:

- scale-space;
- Fourier information;
- gradients;
- entropy;
- regional measurement.

Useful formulation:

> Given this measurement of this region, is enough writing-specific
> information recoverable that NTEC cannot disqualify the region as text?

Two captured examples/addenda include:

## BnF Ms-Lat-18554

```text
BnF_-_Ms-Lat-18554_00021_abg_mcl_mbr_gni_fko_suh.jpg
```

with context near:

```text
00020
```

Possible note:

```text
admin_notes/BnF_Ms-Lat-18554_00021_contextual_text_case.md
```

## Erbario Aldrovandi

```text
UnivBologna-SistemaMusealeDAteneo-AlmaMaterStudiorum_-_ErbarioAldrovandi-Vol-VI-60001_orc.jpg
```

Captured NTEC addendum:

```text
admin_notes/NTEC_addendum_02_measurement_and_regional_dependence_ErbarioAldrovandi.md
```

Regions discussed included:

- primary manuscript text;
- smaller commissioned commentary;
- later reader annotations.

Rule:

> Capture NTEC insights, then return to RMMFB.

---

# Attribution State

Selected publication lineage:

```text
Guided Grad-CAM
guided backpropagation
Grad-CAM-related infrastructure
```

Do not turn exact naming uncertainty into method shopping.

When paper wording matters:

1. inspect the actual implementation;
2. state exactly what computation was performed;
3. use terminology consistent with the implementation.

Attribution is diagnostic/interpretive.

It is not an alternative metric.

---

# Baseline Completion Criteria

The first scientifically meaningful frozen-backbone baseline should produce:

- trained RMMFB binary head;
- validation metrics;
- frozen test evaluation after selection;
- saved predictions;
- confusion matrix;
- enough run metadata to reproduce;
- selected attribution examples after appropriate freezing.

Then fine-tune the same basic model.

Do not change:

```text
architecture + resolution + preprocessing + split
```

all at once.

---

# Wild-Corpus Discovery Completion Criteria

A useful Way 8 artifact should include, at minimum:

```text
source image/provenance identifier
model score
rank
predicted class / threshold decision where relevant
```

Potentially also:

```text
review status
notes
```

Do not require a full production review application for the MVP.

A CSV or similarly durable ranked result can be sufficient.

---

# Current Provenance/Review Opportunity

The current filenames often provide a route back to:

- repository;
- host codex;
- related source images;
- neighboring observations.

This matters for future expert review because the expert should ideally receive
something closer to:

```text
candidate
+
host object
+
neighboring views
+
source path/provenance
```

rather than an isolated crop with no context.

The six-file provenance reconstruction exercise remains a useful possible
methodological artifact:

1. Dave explains three known filenames field-by-field.
2. KaMMA independently reconstructs three harder examples.
3. Record:
   - directly encoded;
   - externally recoverable;
   - inferred;
   - unknown.

This could support a measured provenance/reproducibility claim.

It is not required before the split and first model run.

---

# Current Dev-Note Upgrade

The October 3 note currently on GitHub is short and correct but incomplete:

```text
docs/dev_notes/filename_grouping_audit_2026-10-03.md
```

The October 10 replacement drafted in this chat expands it with:

- initial parser result;
- e-codices findings;
- Google Drive working-material links;
- spreadsheet evidence;
- Cambridge convention;
- all ten miscellaneous filename interpretations;
- CodexRestitutus grouping;
- host versus historical-fragment provenance;
- grouping consequence;
- ePaveldas final sanity check;
- explicit "do not rename frozen files" rule.

Proposed replacement:

```text
docs/dev_notes/filename_grouping_audit_2026-10-10.md
```

After the final ePaveldas note is settled:

```text
add 2026-10-10 note
remove 2026-10-03 note
commit
```

No need to preserve two apparently current audit documents once the latter
fully supersedes the former; Git history preserves the earlier version.

---

# Immediate Next Steps

## Step 1 — Close the ePaveldas sanity check

Already completed:

```bash
find . -type f -iname '*.jpg' -printf '%P\n' |
grep -Ei 'e.?pav|paveldas'
```

Result:

```text
nothing
```

If an old list of known ePaveldas-derived files is easy to locate, inspect only
enough to answer:

```text
Does ePaveldas introduce a source-specific naming convention
that changes group_id derivation or numeric-field interpretation?
```

If no:

```text
document "checked; no grouping-specific convention recovered"
```

and stop.

If yes:

```text
document the convention
make the minimum parser accommodation
```

and stop.

Do not broaden the task.

## Step 2 — Finish/commit the October 10 filename audit

Create:

```text
docs/dev_notes/filename_grouping_audit_2026-10-10.md
```

with the complete safe-transport Markdown drafted in the current chat.

After verifying it contains everything from October 3:

```text
git rm docs/dev_notes/filename_grouping_audit_2026-10-03.md
```

Commit both together or in a small obvious sequence.

## Step 3 — Implement/finalize `group_id`

Produce the minimal manifest:

```text
relative_path,binary_label,group_id,split
```

Use conservative host-object grouping.

Do not rename the 3,331 images.

## Step 4 — Make group-aware split

Use:

```text
SEED = 137
```

Split groups rather than observations.

Inspect:

- partition sizes;
- positive/negative balance;
- obvious giant-group anomalies;
- obvious leakage.

Do not inspect model outcomes because there are none yet.

## Step 5 — Freeze/hash split

Once reasonable:

```text
freeze manifest
compute hash
record split counts
```

From that point:

```text
test = vault
```

## Step 6 — Draw tiny TRAIN-only smoke subset

Random:

```text
32–64 TRAIN images
```

No validation/test samples.

## Step 7 — Run first real SageMaker RMMFB smoke

Prove:

```text
S3
→ SageMaker
→ decode
→ preprocessing
→ ResNet-50 path
→ saved artifact
→ S3
```

Then stop debugging the runway.

## Step 8 — Continue Eightfold Way

Move into:

```text
Keith reconstruction
→ frozen 224 baseline
→ fine-tuning
→ attribution
→ richer labels
→ wild retrieval
```

---

# Explicit Non-Goals Right Now

Do not:

- renumber e-codices filenames;
- normalize all source identifiers;
- reconstruct every original download URL;
- make every provenance record scholarly-catalogue quality;
- investigate every historical repo before splitting;
- redesign the ontology;
- resurrect `suh`;
- perform rare-feature hand-stratification;
- inspect final test attribution during development;
- replace ResNet-50;
- introduce a transformer because it is newer;
- launch a broad higher-resolution architecture bake-off;
- pretrain Hi-ResNet on ImageNet;
- build a U-Net classifier;
- implement NTEC;
- solve complete ePaveldas provenance unless it materially affects grouping;
- solve GitHub connector permissions before useful experimental work;
- turn SageMaker plumbing into a deployment-engineering project;
- sanitize the entire public Git history before the first paper result.

---

# Important Open Questions

These remain legitimate, narrow questions.

1. Does the old ePaveldas provenance list reveal one grouping-relevant filename
   convention?
2. What exact parser/rule set produces a defensible `group_id` for all 3,331
   files?
3. What are the resulting train/validation/test counts and binary label
   distributions under the group-aware split?
4. What exact historical cohort and resolution did Keith use?
5. What exact implementation corresponds to the intended Guided Grad-CAM /
   guided-backprop wording?
6. Does a bounded higher-resolution comparison fit after the 224 paper spine
   is already working?

Question 6 is the only one here that can simply be answered:

```text
No, not before submission.
```

if schedule pressure demands it.

---

# What "Done" Looks Like for the Current Grouping Sprint

The grouping/provenance sprint is done when:

```text
ePaveldas sanity check closed
October 10 dev note committed
every image gets acceptable group_id
group-aware split created
counts inspected
manifest frozen and hashed
test partition vaulted
32–64 TRAIN smoke images selected
```

At that point, **do not find another filename problem** unless a real execution
failure exposes one.

---

# Current Main Research Sequence

The desired continuation is:

```text
close provenance audit
        ↓
derive/freeze group-aware split
        ↓
tiny TRAIN-only SageMaker smoke
        ↓
reconstruct Keith faithfully
        ↓
frozen 224 pretrained ResNet-50 baseline
        ↓
224 fine-tuned ResNet-50
        ↓
final quantitative evaluation
        ↓
Guided Grad-CAM / guided-backprop interpretation
        ↓
one richer-label experiment
        ↓
freeze useful model
        ↓
~41,790-image wild-corpus retrieval
        ↓
expert/human review
        ↓
paper
```

Optional branches hitchhike only if they do not threaten this sequence.

---

# Continuation Anchor

When returning to this work, the correct mental state is:

> The dataset exists.

> The ontology exists.

> The canonical 3,331 are reconciled.

> The filename weirdness has mostly been explained.

> e-codices was not broken; it had a historical local-enumeration system.

> The frozen filenames are evidence, not clutter.

> There is one tiny ePaveldas sanity check left, not a new archaeology project.

> Group the hosts.

> Freeze the split.

> Vault the test set.

> Pull 32–64 TRAIN images.

> Run the real pipeline.

> Then do the science.

And the final rule remains:

> **We have documented the runway. Keep flying.**

*END: Context Document*