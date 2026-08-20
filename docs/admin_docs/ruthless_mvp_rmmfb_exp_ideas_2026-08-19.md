# Ruthlessly MVP RMMFB — Experiment Ideas and Carry-Forward Notes

**Date:** 2026-08-19  
**Status:** Working administrative / experiment-planning note  
**Immediate provenance:** Reconstruction of `cifar10-vanilla-cnn`, especially `test_project_bash/p_01`, `p_03_e2e`, and the repo-level `bin/` utilities.

## Purpose

Capture the experiment-engineering ideas worth carrying into **Ruthlessly MVP RMMFB (RMR)** without turning infrastructure into another project.

The criterion is not a perfect experiment framework. Preserve infrastructure that demonstrably reduces friction, improves reproducibility, or makes AWS/SageMaker execution safer.

## What `p_01` demonstrated

`p_01` was an early end-to-end test of the experiment scaffold itself, not merely a toy CNN. It exercised experiment-directory generation, shell portability/debugging, notebook bootstrapping, environment setup, CIFAR-10 loading, TensorFlow/Keras model construction, training/evaluation, output paths, machine-readable result logging, environment capture, and terminal-session logging.

CIFAR-10 was useful precisely because it was ordinary: infrastructure problems were less likely to masquerade as RMMFB data/model problems.

The four generated notebooks are scaffold slots, not an obligation to populate four notebooks for every experiment.

## What changed by `p_03_e2e`

`p_03_e2e` is the mature local endpoint of this line of work and earned its **end-to-end** name.

The most important progression was not adding more framework. It was making the **execution contract** reliable.

Key changes/findings:

- The substantive experiment moved to `02_training_p_03_e2e.ipynb`; the other scaffold notebooks could remain minimal.
- `TAGDIR` became explicit and resolved to the experiment root rather than accidentally inheriting the notebook working directory.
- Outputs were demonstrated to land under the experiment root, including timestamped training-history CSV and test-summary JSON artifacts.
- The run covered initialization, root resolution, data loading, model construction, training, validation, testing, serialization of results, and verification of the serialized artifacts.
- The CIFAR CNN itself became somewhat more developed, but its scientific score remains secondary to the fact that the execution path became coherent.
- A notebook-local fallback result logger appeared when the corresponding helper file was empty. This was a useful Q&R move for getting the run complete, but RMR should now keep one canonical small logger rather than preserve import-plus-fallback duplication.
- Notebook shell experiments also reinforced that `!cd ..` does not establish persistent notebook process state; explicit Python-side root handling is the correct solution.
- Grad-CAM/Guided Grad-CAM and checkpoint/resume were **not yet part of the completed local run**. That gives a useful boundary between completed historical work and genuinely new RMR work.

Therefore, do not re-solve the `TAGDIR` problem from scratch. **Salvage the mature `p_03_e2e` behavior.**

## What `bin/` adds to the picture

The repo-level `bin/` directory shows that an experiment-capsule/recovery system was already substantially developed.

### `sys_capture.sh`

This is a mature successor to the more ad hoc environment capture visible earlier. It can record:

- Git commit;
- working-tree status;
- uncommitted Git diff;
- Conda state;
- Python/pip/Jupyter information;
- OS/system information;
- core package versions;
- a compact JSON system summary;
- optional tag-specific output;
- a `--json-only` mode.

Importantly, its TensorFlow JSON capture correctly records `tf.__version__`, showing that the earlier attempt to serialize the TensorFlow module itself did not survive into the mature utility.

### `backup_everything.sh`

This script already embodies the useful distinction between an experiment's **intellectual/reproducibility state** and its heavy/re-creatable products.

It deliberately excludes bulky/generated material such as:

- `outputs/`;
- `datasets/`;
- `models/`;
- `.ipynb_checkpoints/`;
- `__pycache__/`;
- terminal I/O lab notebooks.

It can include environment specifications and `bin/`, verifies the archive, computes a SHA-256 checksum, and writes an inclusion audit.

This is very close to the "small experiment capsule" idea we independently arrived at during RMR planning.

### `safe_default_header.sh`

Common shell infrastructure had also begun to centralize project identity. It resolves `PROJECT_ROOT` from the Git root (falling back to the current directory) and exports default `TAG`/`TAGDIR` values when they are not already set.

This is evidence that experiment-root handling was migrating out of one-off notebook fixes into shared infrastructure.

### Historical/specialized utilities

Keep these as useful tools, but do not make them prerequisites for RMR execution:

- `dwb_selective_tree.ps1` — substantial selective-tree utility; useful, but not part of the active RMR mental model.
- `fix_firstline_glitches.sh` — repair tooling born from real cross-platform problems; retain without ritualizing its use.
- `backup_notebooks.sh` — useful concept, but currently contains a historical `p_01` default and should not be treated as canonical until generalized if needed.
- `start_cifar_lab.sh` — CIFAR-specific launcher; preserve the useful ideas rather than requiring this exact launcher for RMMFB.

## The experiment record already has three useful layers

Do **not** invent a new experiment-tracking system before these prove inadequate.

Use:

```text
README_<tag>.md
    human explanation and reconstruction map

run-summary JSON/CSV
    compact facts/configuration/results for a run

sys_capture / Git metadata
    computational provenance
```

When an experiment reaches a state worth freezing, `backup_everything.sh` can optionally create the compact experiment capsule.

For live AWS training, S3 persistence of checkpoints/results is more important than tarball backup. The capsule is principally a completed-experiment/reconstruction artifact.

## Keep the structure scripts

Do **not** refactor `structure.sh` merely to make RMR look smaller. It removes clerical startup work and gives experiments predictable paths.

Bash and PowerShell support are both justified by the project's real Windows/Linux history. For AWS/SageMaker, use Bash as the immediate canonical path.

Before relying on PowerShell again, test/fix the notebook-stub code noticed during review (`$nbTagged` versus `$dst`, plus tag interpolation around `$NbTargets`). Do not spend RMR time on that unless Windows execution becomes immediately relevant.

## Make the experiment root an invariant

Keep each experiment tag-scoped, approximately:

```text
TAGDIR/
├── README_<tag>.md
├── notebooks/
├── scripts/
├── datasets/
├── models/
├── logs/
├── visualizations/
└── outputs/
```

The rule is:

> Paths inside an experiment resolve relative to the experiment root, not whichever notebook or shell happens to be the current working directory.

### Fix / verify `TAGDIR`

`p_01` exposed a concrete path bug. Its helper effectively defaulted to:

```python
tagdir = Path(tagdir or Path.cwd())
```

When called from `TAGDIR/notebooks`, output could therefore land in `TAGDIR/notebooks/outputs/` instead of `TAGDIR/outputs/`.

Later code was already beginning to detect `notebooks/` and move upward. For RMR, make root discovery one explicit invariant rather than rediscovering it independently in multiple notebooks/scripts.

Before changing anything, inspect whether `p_03_e2e` already solved this.

## Keep notebooks minimal

Populate only the notebooks an experiment needs. Split stages only when separation has a concrete benefit: expensive training versus cheap inference, reusable data prep, independent attribution, or checkpointed AWS stages.

Notebook organization is not itself a deliverable.

## Keep the tiny machine-readable run summary

`p_01`'s JSON completion record is worth preserving:

> Every completed run emits one small machine-readable summary of what happened.

For actual RMR training, useful fields may include experiment ID, commit, timestamp, seed, dataset/split, model, weights, input resolution, checkpoint, threshold, recall, precision, F1, confusion counts, output paths, and notes.

Do **not** build a database or experiment-tracking service unless later work proves the small JSON + README approach inadequate.

For the initial no-fine-tuning probe, accuracy is not the scientific question. Record enough to reconstruct model, preprocessing, sampled images, attribution settings, and outputs.

## Use the existing experiment README

Do not create a second bespoke experiment-documentation hierarchy yet. Let `README_<tag>.md` be the human-readable reconstruction record.

Minimally record purpose/question, date, scaffold invocation/options, Git commit, SageMaker/container identity, dataset/split, local/S3 locations, model/checkpoint, notebooks/scripts used, important commands, outputs/checkpoints, observations, failures/deviations, and next step.

The README explains how artifacts fit together; it should not duplicate them.

## Do not duplicate code manually

Do not hand-copy every notebook cell into Markdown. The notebook is already an executable record.

For committed scripts, record **Git commit + repository path** rather than copying their complete contents into every experiment note. Preserve one-off uncommitted scripts with the experiment.

If a human-readable notebook export becomes useful, automate Markdown or `.py` export instead of maintaining two hand-edited sources of truth.

## Preserve clean notebook commits

Continue:

> restart kernel → clear outputs → commit the clean `.ipynb`

This keeps diffs usable. Preserve scientifically useful executed output separately as intentional artifacts: PDF/HTML renderings, result JSON, figures, CSVs, logs, or checkpoint metadata.

## Keep automated terminal lab notebooks

The automatic `script`-based terminal-session logging has paid rent for years. Keep it.

Treat those logs as raw lab records, useful for command reconstruction, debugging history, environment details, dataset QA, provenance, and recovering why a later design choice exists. Do not make manual cleanup of every terminal log a ritual requirement.

## Environment capture: preserve the principle, reduce ceremony

`p_01` captured extensive machine/software state. The principle is excellent: a notebook alone does not fully describe a computational result.

For RMR/AWS, prefer a smaller reproducibility identity when sufficient:

- SageMaker image/container;
- Python version;
- core ML package versions;
- dependency/lock file where useful;
- Git commit;
- hardware/instance type;
- random seeds.

Capture more when an actual reproducibility problem requires it.

## AWS/SageMaker learning path

The next couple of experiments should run **step by step on AWS/SageMaker** for learning. Initially, understanding the execution path matters more than maximum cost optimization.

Learn and document startup, repository bootstrap, S3 placement, local staging/cache, checkpoint writing/restoration, output synchronization, interruption behavior, resume behavior, and survival of logs/results after instance termination.

Only after that path is understood should RMR depend on opportunistic/interruptible capacity. Design later training so losing an instance costs limited compute rather than the experiment.

## CIFAR-10 on AWS: smoke test, not milestone

Repeating the known local CIFAR-10 path on SageMaker is useful if it cheaply answers:

> Can this known experiment execute correctly in the AWS environment?

Do only enough to verify the path. Do not turn CIFAR-10 recreation into a documentation sprint or require feature parity before touching RMMFB.

If convenient, it can also smoke-test Guided Grad-CAM.

## First real RMMFB probe

Preferred near-term probe:

**3331 → 224 px → ImageNet-pretrained ResNet50 → no fine-tuning → Guided Grad-CAM / Grad-CAM visualization.**

Purpose: validate real-data movement through SageMaker, preprocessing, model loading, experiment-root/output handling, attribution code, and the experiment-record/checkpoint/output workflow; also observe what generic ImageNet ResNet50 attends to in historical-document images.

This is a qualitative probing/sanity experiment, **not** evidence that ImageNet classes solve RMMFB.

Generate attribution outputs broadly if cheap, but initially inspect a small deliberate panel: clear positive, subtle/small-feature positive, convincing fake-out, obvious negative, and a weird case. Stop once the attribution pipeline is shown to behave sensibly.

## RMR metric orientation

The RMMFB objective has always been **high recall at the expense of precision**. An old notebook reversed those labels; treat that as a historical label swap, not a change in research objective.

Missing genuine reuse candidates is more costly than sending extra false positives to human review. Future model evaluation should therefore not default to accuracy. Threshold selection/reporting should foreground recall and resulting precision/review burden.

Fake-outs are especially important because they characterize false positives likely to dominate a high-recall system. NTEC may later help rank or characterize convincing fake-outs, but RMR should not wait for the full NTEC program.

## Guided Grad-CAM terminology

Before coding attribution, verify exactly which historical technique was meant by “Guided Grad-CAM.” Keep distinct:

- Grad-CAM;
- guided backpropagation;
- Guided Grad-CAM if implemented as their combination/product.

Do not silently substitute one because a library exposes an easier API.

## Do not refactor working infrastructure without a blocking reason

RMR does not need a cleanup sprint.

Do not spend time merely to remove empty generated scripts, make notebook count configurable, beautify every README, unify every Windows/Linux helper, redesign the Makefile, build a generalized experiment framework, replace terminal logging, rewrite historical notebooks to match current terminology, or reorganize the repo before comparing surviving branches.

Working historical infrastructure can remain ugly if it does not block the next experiment.

## `p_03_e2e` comparison: resolved

The comparison with `p_01` has now been done.

Conclusions:

1. **Experiment-root / `TAGDIR` handling was solved well enough to salvage.**
2. The local CIFAR path became genuinely end-to-end through training, validation, testing, and result serialization.
3. Output paths became predictable and were explicitly verified.
4. Result-summary handling became useful, though the notebook fallback logger should collapse to one canonical implementation for future work.
5. Environment/provenance capture matured further in repo-level `bin/`.
6. Checkpoint/resume was not yet the completed part of the model workflow.
7. Grad-CAM/Guided Grad-CAM was not yet demonstrated in the completed run.
8. The extra scaffold did not force every notebook/script to become substantive; unused slots could remain empty.
9. The historical local machinery is mature enough to **salvage rather than rebuild**.

This closes the main experiment-archaeology question. Further backward-looking inspection should require a concrete need from the AWS/RMMFB work.

## Compare `main` and experiment branches before establishing the canonical start point

There is known historical branch divergence: documentation and development occurred on different machines/branches and not everything was merged as expected.

Before declaring a canonical RMR experiment base:

- compare `main` with `cifar10-vanilla-cnn`;
- identify scaffold changes present only on the experiment branch;
- identify durable documentation/admin material present only on `main`;
- determine whether Windows-side and Linux-side work diverged;
- move only experiment-start essentials to the canonical branch.

Do not merge branches wholesale merely to make history tidy.

Desired outcome:

> `main` contains the smallest reliable machinery needed to start future experiments, plus durable project documentation.

## Provisional carry-forward checklist

1. Tag-scoped experiment directories.
2. Idempotent scaffolding.
3. Bash + PowerShell support; Bash canonical for AWS.
4. Minimal notebooks; populate only what is needed.
5. Explicit random seeds.
6. One reliable `TAGDIR` resolution method.
7. Root-relative paths.
8. Small machine-readable run summaries.
9. Human-readable per-experiment README.
10. Git commit identification.
11. Sufficient environment/container identity.
12. Clean notebook commits with outputs cleared.
13. Separate intentional executed artifacts when outputs matter.
14. Existing automatic terminal-session lab notebooks.
15. Checkpoint/resume before relying on interruptible AWS compute.
16. High-recall-first evaluation for actual RMMFB models.
17. Guided Grad-CAM implemented/named precisely.
18. Refusal to refactor working infrastructure unless it blocks the experiment.

## Immediate sequence

1. Commit this planning/discovery note to `main` under `docs/admin_docs/`.
2. Stop archaeology unless a concrete AWS/RMMFB question requires another historical artifact.
3. Compare `main` and `cifar10-vanilla-cnn` before establishing the canonical experiment-start point; promote only the mature essentials rather than merging history wholesale.
4. Define the first step-by-step SageMaker learning run.
5. Run a minimal CIFAR-10 SageMaker smoke test **only if** it materially helps AWS learning.
6. Learn S3 staging, checkpoint writing/restoration, output persistence, and interruption/resume behavior.
7. Move to the **224 px RMMFB → ImageNet-pretrained ResNet50 → no fine-tuning** qualitative probe.
8. Bring Grad-CAM, guided backpropagation, and Guided Grad-CAM online with terminology/implementation kept explicit.
9. Inspect a small deliberate panel of attribution outputs before expanding interpretation.
10. Only then design the first actual fine-tuned RMR model comparison with high-recall-first evaluation.
11. Once interruption/recovery is understood, make the workflow ready for opportunistic/cheap AWS capacity.

> **Capture the branch. Stay on the trunk.**
