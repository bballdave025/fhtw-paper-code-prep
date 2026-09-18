*BEGIN: Context Document Header*

# CONTEXT DOCUMENT — Continuation

## Project

**Name:**  
RMMFB / Reused Manuscript Fragments in Bindings

**Description:**  
Research and engineering work for identifying, classifying, and retrieving
reused manuscript material in historical book bindings, including dataset
preparation, computer-vision experiments, explainability, provenance, AWS /
SageMaker execution, and a minimum-publishable paper for *Fragmentology*.

---

## Continuation Metadata

**Prepared at:**  
1789749591_2026-09-18T12:39:51-0400

Generated via:

```bash
date +'%s_%Y-%m-%dT%H:%M:%S%z'
```

(Boston, MA time)

**Continued from chat:**  
Current RMMFB MVP-scaffold / Fragmentology execution conversation

**Also involving:**
- ruthless MVP scope control
- AWS / SageMaker bootstrap
- reconstruction of Keith's historical experiment
- 3,331-image curated dataset
- attribution / Guided Grad-CAM / guided backpropagation
- wild-corpus retrieval
- repository cleanup and deferred infrastructure

---

## Author / Source

**User (GitHub):**  
@bballdave025

**User (ChatGPT):**  
KaMMA / ChatGPT

---

## Intent for This Context

Resume RMMFB in a fresh chat **without replanning work that has already been
planned**. The next chat should move quickly from the now-finished MVP scaffold
into AWS / SageMaker execution and the first real RMMFB experiments, using the
existing Eightfold Way and the historical Keith reconstruction plan rather than
inventing a replacement plan.

---

## Usage Instructions

- Treat this document as **authoritative project state**.
- Continue with **minimal re-derivation**.
- Reinterpret only when explicitly requested.
- Distinguish clearly among work already completed, work selected for the
  current paper, optional pickups, and future/deferred work.
- Do **not** redesign the experiment plan merely because another method,
  architecture, attribution method, resolution, or workflow could be better.
- The current goal is a good, defensible, minimum-publishable paper, not the
  globally optimal RMMFB system.
- Dave does not want to spend cognitive effort on transport-layer mechanics he
  already knows. For routine Bash / file / AWS I/O, provide direct commands,
  files, and small executable batches rather than making him re-derive the
  mechanics.
- Governing scope rules:
  - **Capture the branch. Stay on the trunk.**
  - **Stop improving the runway. Take off.**
  - **Paper first. Evidence second. Portfolio for free. Cool new research only
    if it hitchhikes.**

*ENDOF: Context Document Header*

---

# Current State in One Paragraph

The infrastructure-cleanup sprint is complete. `main` is again the canonical
RMMFB branch; the temporary `rmmfb-mvp-scaffold` and `pre-markdown-steps`
branches are gone; `cifar10-vanilla-cnn` remains intentionally as a historical
source/reference branch. The lean `structure.sh` MVP scaffold is merged,
tested, idempotent, and executable. The 3,331-image manifest was removed from
the current public tree and preserved privately; dataset-preparation logs were
removed from this repo after preservation elsewhere. The next useful evidence
must come from **RMMFB itself entering the pipeline**, not from more scaffold
work.

---

# Repository / Branch State

Current intended branch roles:

```text
main
    Canonical current RMMFB workflow.

cifar10-vanilla-cnn
    Historically named source/reference branch containing prior CIFAR work
    plus infrastructure intentionally deferred from the RMMFB MVP.
```

Temporary integration branches used during the scaffold sprint have been
merged/deleted.

The current repository is clean after the merge.

---

# What Was Just Completed

## Lean MVP scaffold

`structure.sh` was cut down to the experiment-start machinery that the current
paper actually needs.

Current behavior:

- Bash/Linux-first.
- executable shell script.
- idempotent experiment creation.
- one clean `--check` path.
- creates:
  - `notebooks/`
  - `datasets/`
  - `models/`
  - `logs/`
  - `visualizations/`
  - `scripts/`
  - `outputs/csv_logs/`
  - `outputs/gradcam_images/`
- creates package markers:
  - `__init__.py`
  - `scripts/__init__.py`
- creates four standard notebooks:
  - `00_data_exploration`
  - `01_model_build`
  - `02_training`
  - `03_inference_quick_explore`
- creates four Python script placeholders:
  - `py_build_model`
  - `py_train_model`
  - `py_inference`
  - `py_utils`
- notebook stubs include:
  - `random`
  - NumPy
  - `SEED = 137`
  - `random.seed(SEED)`
  - `np.random.seed(SEED)`

Framework-specific seeding belongs in actual framework code, not the generic
scaffold.

## Scaffold validation

The scaffold was tested in Termux under `$TMPDIR` because Android/Termux `/tmp`
was not writable in the ordinary expected way.

Validation sequence:

1. create a fresh scaffold;
2. run `--check`;
3. create the same scaffold again;
4. run `--check` again;
5. compare SHA-256 hashes of generated files before and after the second run.

Result:

- both creates succeeded;
- both checks succeeded;
- hashes were unchanged;
- the scaffold is demonstrably idempotent for the tested files.

---

# Deferred Infrastructure — Preserved, Not Abandoned

The following are intentionally **not** part of the MVP scaffold:

- `bin/backup_everything.sh`
- `bin/sys_capture.sh`
- `bin/safe_default_header.sh`
- `bin/helpers.sh`
- notebook-backup helpers
- backup auditing / repair helpers
- `validate_env.py`
- `environment_specifications/`
- `py_touch.py`
- `normalize_eol.py`
- PowerShell scaffolding
- CMD/batch scaffolding
- explicit per-experiment EOL-normalization machinery
- broader cross-platform portability infrastructure

These remain useful historical machinery on `cifar10-vanilla-cnn`.

Rule:

> Promote deferred infrastructure only when a current RMMFB need earns it.

The Linux-first decision is a publication-scope choice, not a claim that
cross-platform support is unimportant.

---

# Data Preservation / Public-Repo Exposure State

## 3,331-image manifest

The labeled manifest:

```text
consistentized_3331_dataset.txt
```

contains 3,331 entries and is scientifically useful.

It has been removed from the current public repo tree and preserved privately
in Google Drive under its truthful `.txt` name.

A prior copy had merely been given a `.png` extension. That extension change was
not meaningful protection and has been removed.

## Dataset-preparation logs

The large `dataset_preparation_examples/` log collection was removed from
`fhtw-paper-code-prep` after being preserved as:

```text
dataset_preparation_examples.zip
```

in both:

- the annotation/provenance repository
  `bballdave025/congenial-chainsaw-rmfb-html`, under
  `code_screenshots_and_text_snippets/`;
- the RMMFB Google Drive reference folder.

The procedural/scientific record is therefore preserved even though those logs
no longer clutter the active paper-code repo.

## Deferred exposure audit

Removing current-tree copies does **not** erase Git history.

A later public-repository exposure audit is explicitly preserved in
`docs/dev_notes/deferred_until_after_mvp.md`.

That later audit should locate:

- copies of the 3,331-image labeled manifest;
- class-bearing filenames;
- provenance-bearing logs;
- copies across Git history, branches, and related repos.

Only after the footprint is known should a decision be made about history
rewriting, e.g. `git filter-repo`.

This is real work, but it is **not** allowed to delay the current paper
execution sprint.

---

# Dataset State

## Curated dataset

Current curated set:

```text
3,331 manually classified images
```

Characteristics:

- purpose-built historical-document / binding dataset;
- custom ontology;
- info-dense provenance-preserving filenames;
- heterogeneous repositories/sources;
- obvious and subtle reuse;
- convincing negatives / fake-outs;
- multiple forms and scales of reuse.

The curated set is now frozen enough to support the minimum-publishable
experiment sequence.

## Wild corpus

Recovered / deduplicated candidate corpus:

```text
~41,790 distinct images
```

This corpus is **not** comprehensively labeled.

Therefore:

- do not report ordinary whole-corpus precision/recall as though it were a
  fully labeled benchmark;
- use model scores/rankings;
- preserve provenance;
- favor recall for discovery;
- use expert/human review of ranked candidates;
- treat this stage as retrieval/discovery, not ordinary closed-set evaluation.

---

# Historical Experiment Lineage

## Keith reconstruction

A major part of the current paper plan is to reconstruct Keith's earlier RMMFB
experiment as faithfully as practical.

The reconstruction is not a vague "similar baseline." It should explicitly
recover, where possible:

- exact or nearest-recoverable image cohort;
- image IDs / filenames;
- labels;
- train/validation/test behavior;
- preprocessing;
- historical resizing;
- model code;
- historical claim/context;
- any unrecoverable differences.

Dave remembers that Keith's code may have used approximately:

```text
175 x 175 px
```

even though the ImageNet-pretrained ResNet lineage normally uses the standard
224-pixel regime.

Do **not** silently normalize the historical experiment to 224. Recover what
Keith actually did from old code, dataset folders, and logs, then record any
remaining uncertainty.

## Historical easy cohort

The first historical cohort was roughly the easier ~1,000 images:

- many outside covers;
- likely many breviaries;
- Bibles;
- notarial/document material;
- large, visually obvious reused material.

The point of reconstructing this stage is partly historical:

> show that a low-resolution treatment can perform very well when the reuse is
> visually large and obvious.

## "Fouled up" / harder images

Keith's "fouled up images" were not random corruption. They were the harder
examples where reused material occupied less of the image or appeared in
smaller/subtler forms.

Those harder images motivate the progression from the easy historical cohort
into increasingly difficult RMMFB data.

---

# Resolution Decision

For ordinary ImageNet-pretrained ResNet-50, the standard image size to carry
forward for the MVP is:

```text
224 x 224 px
```

Earlier project notes contain both 224 and ~240-pixel references. Do not invent
a third number and do not keep reopening the question.

Current operational rule:

- **224 px** for the standard ImageNet/ResNet-50 MVP bridge and main low-res
  experiment;
- recover **Keith's actual historical size** separately, likely around
  175 x 175, from code/logs rather than assumption;
- higher-resolution ResNet work is a later comparison, not a prerequisite for
  getting the first paper result.

The old paper lineage also considered high-resolution ResNet extensions at
approximately 448, 896, and 1792 px. Those remain optional/future unless earned
after the low-resolution paper path is running.

---

# The Existing RMMFB Eightfold Way

This is the agreed plan. Do **not** replace it with a newly invented plan in the
next chat.

## Way 1 — Lock the claim and experimental contract

Freeze the minimum paper claim before looking at outcomes that could tempt
scope drift.

Clarify in advance:

- binary question;
- evaluation metrics;
- difficulty tiers;
- split/leakage rules;
- preprocessing;
- resolution;
- what counts as completion.

## Way 2 — Reconstruct Keith's historical binary experiment

Recover the historical easy cohort and implementation as faithfully as
practical.

Record:

- image IDs / labels;
- split behavior;
- preprocessing;
- actual historical resolution;
- code/model details;
- historical claim;
- unrecoverable differences.

This is historical reconstruction, not retroactive optimization.

## Way 3 — Freeze the binary difficulty progression

Build the predetermined staircase from easy/obvious cases into harder/subtler
cases.

Approximate progression already agreed:

```text
~1,000
~1,500
~2,000
~2,500
~3,000
optional / available: 3,331
```

The original practical framing was roughly +500-image increments after the
historical ~1,000 cohort.

The important idea is not the aesthetics of exact round numbers. It is that
difficulty expansion is defined before outcomes are used to choose the next
set.

## Way 4 — Fixed pretrained low-resolution baseline

Use:

```text
ImageNet-pretrained ResNet-50
224 x 224
no fine-tuning
```

Run the predetermined binary progression.

This asks what the pretrained representation already provides before RMMFB
fine-tuning.

Attribution work belongs here as a diagnostic / interpretation layer, not as a
replacement for quantitative evaluation.

## Way 5 — Fine-tune the same model at the same low resolution

Use the same basic ResNet-50 / 224-pixel setup and fine-tune for the RMMFB
binary task.

Do not change model family and resolution simultaneously.

Report, as appropriate:

- accuracy;
- precision;
- recall;
- F1;
- confusion matrix;
- relevant per-class results.

For discovery/retrieval usage, recall is especially important.

## Way 6 — Attribution / visual explanation

The publication path already selected Guided Grad-CAM / guided-backpropagation
style attribution from the existing project lineage.

Do not launch an attribution-method bake-off for this paper.

Important current scope interpretation:

- use the already-selected guided-backprop / Guided Grad-CAM path;
- do not switch to a newer/better attribution method simply because one exists;
- better attribution variants can belong in later work.

Attribution examples should cover useful categories such as:

- correct reuse;
- correct no-reuse;
- false positive;
- false negative;
- easy/salient reuse;
- subtle reuse.

### Test-set vault concern

Dave does **not** want to casually inspect Guided Grad-CAM / guided-backprop
images for the held-out test set during model-development iterations.

Reason:

Even if labels are not changed, repeatedly seeing what the model attends to in
test examples can influence:

- what future examples are sought;
- what preprocessing is added;
- what types are emphasized;
- what training changes are made;
- how the researcher mentally defines the task.

Operational rule:

> Treat the final test set as a vault. Do not use test-set attribution images
> as development feedback.

If final-paper test examples are shown for interpretation, do so after the
training/model-selection decisions they could influence are frozen.

## Way 7 — One richer-label experiment

After the binary result exists, run one controlled experiment using richer
labels from the existing ontology.

This is intentionally **one** richer-label experiment for the minimum paper,
not a requirement to exhaust the ontology.

## Way 8 — Freeze the useful model and apply it to the wild corpus

Freeze the selected model/configuration.

Apply it to the ~41,790-image wild candidate corpus.

Because the corpus is not comprehensively labeled:

- save scores/rankings;
- preserve provenance;
- favor recall;
- use human/expert review;
- surface plausible discoveries;
- distinguish retrieval/discovery claims from benchmark-evaluation claims.

This is the route from a classifier paper toward actual manuscript-fragment
discovery.

---

# Split / Stratification Questions to Resolve Before Final Runs

The 3,331 set contains rare visual concepts. A naive random split may leave a
small subtype almost entirely in one partition.

Example conceptual case:

```text
10 examples of a particular visual subtype
```

such as wooden covers with writing-bearing leather around the exterior.

The split should be discussed explicitly so that small but important concepts
are represented sensibly across train/validation/test when scientifically
possible.

Illustrative logic Dave raised:

```text
~60 / 20 / 20
```

with a small 10-example subtype perhaps represented approximately as:

```text
6 train
2 validation
2 test
```

The exact rule is not frozen here. The important constraint is:

> make subtype/difficulty representation an explicit pre-outcome design choice,
> not something repaired after looking at performance.

Also consider provenance/group leakage:

- images from the same physical object/source sequence should not casually leak
  across partitions if that would make the benchmark easier in an artificial
  way;
- duplicates/near-duplicates and related captures need deliberate handling.

---

# Benchmark Purity / Future Ground Truth

The 3,331 curated set may serve as the near-term performance benchmark because
it is the data presently available and sufficiently curated for this paper.

It should **not** become an eternal benchmark by habit.

When materially better ground truth exists later:

- establish a new benchmark/evaluation protocol deliberately;
- do not keep tuning forever against the original 3,331;
- preserve the old benchmark for historical comparability if useful;
- distinguish "historical benchmark" from "current best ground truth."

There is no need to literally erase all prior knowledge or "zero out" the old
set. The scientific solution is to create genuinely held-out future evaluation
data or a new benchmark protocol rather than pretending prior exposure can be
forgotten.

---

# The Last Proving-Ground Experiment Before RMMFB

The most recent mature infrastructure experiment was the CIFAR proving-ground
lineage, especially the `p_03_e2e` work.

Its purpose was not to produce an RMMFB scientific result.

It demonstrated / matured patterns for:

- experiment scaffolding;
- experiment-root / `TAGDIR` handling;
- model training and evaluation;
- result logging;
- reproducibility capture;
- notebook/script organization;
- end-to-end execution;
- Grad-CAM / guided-backpropagation infrastructure;
- preserving outputs in a predictable experiment structure.

The conclusion from that line of work is:

> the proving ground has done its job.

Do not recreate CIFAR or further polish that infrastructure before RMMFB runs.

Historical CIFAR code remains a source of proven patterns, not an active
dependency that must be modernized before the paper.

---

# Immediate Bridge Experiment

A previously written project checkpoint captured the desired bridge very
compactly:

```text
3331
→ 224 px
→ ImageNet-pretrained ResNet50
→ no fine-tuning
→ inference
→ Grad-CAM / guided backpropagation / Guided Grad-CAM
```

Purpose:

- validate the real RMMFB data path;
- get RMMFB images through the AWS/SageMaker workflow;
- exercise attribution machinery;
- exercise output/provenance handling;
- verify the cleaned experiment scaffold against real project data.

This bridge is **not** expected to prove that ImageNet features alone solve
RMMFB.

After that:

```text
224 px RMMFB
→ ImageNet ResNet50
→ fine-tuning
→ high-recall quantitative evaluation
```

Only then does the higher-resolution comparison earn its place.

---

# AWS / SageMaker Plan — Already Chosen

Do not invent a new cloud architecture unless the existing plan actually fails.

The active path is:

1. use cleaned `main`;
2. clone/bootstrap it on AWS / SageMaker;
3. create the experiment root with the lean scaffold;
4. distinguish durable S3 source/artifact storage from local SageMaker cache /
   working files;
5. fetch only the inputs needed for the current experiment;
6. run the real RMMFB bridge;
7. write outputs to predictable experiment paths;
8. sync durable outputs/results back to S3;
9. capture enough environment/run metadata for reproducibility;
10. make restart/resume possible without turning restart engineering into a new
    project.

The desired direction is **quickly to running**.

Avoid spending another day recreating transport abstractions, backup systems,
cross-platform wrappers, or generic deployment machinery.

Dave already understands the Bash/file-transport layer. The assistant should
reduce friction by giving exact commands and small files rather than asking him
to repeatedly reason about plumbing.

---

# Publication Scope

The current paper is the smallest scientifically defensible RMMFB paper that
turns the existing dataset/domain work into a real result.

Must-have scientific spine:

- historical Keith reconstruction;
- predetermined binary difficulty progression;
- standard low-resolution ImageNet ResNet-50 baseline;
- same-model fine-tuning;
- quantitative evaluation;
- selected guided-backprop / Guided Grad-CAM interpretation;
- one richer-label experiment;
- frozen-model wild-corpus retrieval/discovery;
- expert/human review of ranked candidates;
- careful distinction between benchmark evaluation and wild-corpus discovery.

Do not expand the current paper into:

- a model-family bake-off;
- a giant attribution-method comparison;
- a many-resolution sweep;
- a tiling system;
- a generalized provenance-reconstruction product;
- a massive FamilySearch inference project;
- gaze/attention research;
- a new ontology-building project;
- a platform-portability project.

Those ideas may be good. They are not prerequisites.

---

# Higher Resolution

Higher-resolution ResNet work remains scientifically interesting because many
RMMFB-positive regions are small.

Historical project material considered high-resolution continuations of
ResNet-50, including approximately:

```text
448
896
1792
```

pixel regimes.

For the current paper:

- first establish the 224-pixel result;
- keep model family fixed when possible;
- only add higher resolution if it can be done without delaying the core paper;
- do not jump directly to 1792 merely because it exists.

The higher-resolution result is a comparison / extension, not the launch pad.

---

# Attribution Terminology Note

Project history uses several related phrases:

- Grad-CAM
- guided backpropagation
- Guided Grad-CAM

The existing publication lineage specifically includes the guided-backprop /
Guided Grad-CAM path.

For the next chat:

> Do not turn terminology cleanup into method shopping.

If exact implementation naming matters for the paper, inspect the actual
existing notebook/code and describe exactly what it computes. Keep the already
selected method rather than changing the scientific plan.

---

# Immediate Next Steps

The next chat should resume with execution, not planning.

## Step 1 — AWS/SageMaker bootstrap

Get the cleaned `main` onto SageMaker and create the first real RMMFB experiment
directory.

Use direct Bash commands.

## Step 2 — Recover the exact historical Keith details needed for reconstruction

Inspect:

- old dataset folders;
- logs;
- Keith's old code;
- historical resizing;
- old split behavior;
- the first ~1,000 easy images;
- the later harder/"fouled up" additions.

Do not spend time reconstructing irrelevant infrastructure.

## Step 3 — Run the 3,331-image 224-pixel pretrained bridge

Get real RMMFB images through:

```text
SageMaker
→ scaffold
→ dataset load
→ pretrained ResNet-50
→ inference
→ selected attribution path
→ saved outputs
```

Completion is "the real path works," not "the final paper model is perfect."

## Step 4 — Freeze split/tiering details before outcome-driven iteration

Resolve:

- train/validation/test split;
- rare-subtype representation;
- provenance/group leakage;
- binary difficulty staircase.

Then run the agreed Eightfold Way.

---

# Explicit Non-Goals for the Next Chat

Do **not**:

- redesign the Eightfold Way;
- revisit whether ResNet-50 is the best architecture;
- replace 224 with a newly suggested input size;
- run an attribution-method survey;
- rebuild backup infrastructure;
- restore PowerShell/CMD;
- solve Git-history sanitization before running experiments;
- rewrite the ontology;
- begin a broad new literature review before the first RMMFB run;
- make Dave manually orchestrate routine Bash/file transport that the assistant
  can express directly.

---

# Important Open Questions — Narrow, Not Invitations to Replan

These are legitimate details still to resolve:

1. What exact input size did Keith's historical code use?
2. What exact historical cohort corresponds to the first ~1,000 images?
3. What split/grouping rule best protects against object/source leakage?
4. What fixed rule should represent rare/subtle visual subtypes across
   train/validation/test?
5. At what point, if any, does a higher-resolution ResNet-50 comparison fit
   without delaying submission?
6. Which exact existing implementation corresponds to the project's intended
   "guided backprop / Guided Grad-CAM" publication wording?

These should be answered from code/data/log evidence where possible.

They are **not** invitations to replace the plan.

---

# Continuation Anchor

When the next chat starts, the desired mental state is:

> The runway work is done.  
> The plan already exists.  
> Start SageMaker.  
> Put RMMFB through the pipe.  
> Reconstruct Keith faithfully.  
> Freeze the split/tiering.  
> Run the Eightfold Way.  
> Get the paper result.

And the governing reminder remains:

> **Capture the branch. Stay on the trunk.**

*END: Context Document*
