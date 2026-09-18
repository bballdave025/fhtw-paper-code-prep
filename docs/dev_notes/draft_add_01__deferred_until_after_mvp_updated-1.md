# Deferred Infrastructure Until After the RMMFB MVP

Status: intentionally deferred  
Primary source branch: `cifar10-vanilla-cnn`  
Target branch for selectively promoted material: `main`

## Purpose

This note records infrastructure that is intentionally **not** part of the first RMMFB MVP scaffold, but which remains potentially valuable for later sprints.

The `cifar10-vanilla-cnn` branch should therefore be preserved under its historical name. It contains both prior CIFAR experiment work and infrastructure that may later be selectively promoted to `main`.

This is **not** a plan to merge `cifar10-vanilla-cnn` wholesale. The rule is:

> Promote deferred infrastructure only when a current RMMFB need earns it.

`main` remains the canonical branch. The CIFAR branch is a source/reference branch for historically developed machinery that has not yet earned inclusion in the MVP.

## Deferred items currently identified

### `bin/backup_everything.sh`

Location:

```text
cifar10-vanilla-cnn:bin/backup_everything.sh
```

Current role on the CIFAR branch:

- creates compressed experiment backups;
- excludes bulky experiment data/model/output paths by default;
- creates SHA-256 checksums;
- creates a simple inclusion audit;
- can optionally invoke:
  - `bin/fix_firstline_glitches.sh`
  - `bin/sys_capture.sh`
  - `bin/backup_notebooks.sh`
  - `validate_env.py`
- can include `environment_specifications/` and `bin/` in an expanded backup.

Why deferred:

The first MVP goal is to prove that `main` can start a clean experiment from scratch. Backup/archive machinery is not required for that test.

Later question:

> Given Git + S3 + run/environment capture, what additional value does this backup layer still provide?

Do not assume Git alone replaces it: Git does not automatically preserve ignored data, environment snapshots, hardware/system state, or arbitrary local run artifacts.

---

### `bin/sys_capture.sh`

Location:

```text
cifar10-vanilla-cnn:bin/sys_capture.sh
```

Current role:

Captures reproducibility metadata including:

- Git commit/status/diff;
- Conda environment information;
- Python version;
- `pip freeze`;
- Jupyter kernels;
- OS and CPU information;
- memory/disk information;
- NVIDIA GPU information when available;
- structured JSON summary;
- optional run notes.

Why deferred:

This is highly relevant to reproducibility and likely useful once RMMFB runs begin on SageMaker, but it is not required merely to create and smoke-test a fresh experiment scaffold.

Likely future use:

Promote or adapt during the first reproducibility / SageMaker execution sprint, before scientifically meaningful model runs are treated as final.

---

### `bin/safe_default_header.sh`

Location:

```text
cifar10-vanilla-cnn:bin/safe_default_header.sh
```

Current role:

Provides development-shell defaults including:

- `set -Eeuo pipefail`;
- sane `IFS`;
- `PROJECT_ROOT` resolution via Git root or current directory;
- `TAG` and `TAGDIR` fallbacks;
- minimal logging helpers.

Why deferred:

`structure.sh` does not currently depend on this file to create an experiment scaffold.

Potential future value:

The `PROJECT_ROOT` / `TAGDIR` pattern may be worth promoting when experiment scripts need a common root-resolution contract.

Important invariant to preserve:

> Experiment paths should resolve from the experiment root (`TAGDIR`), not from an arbitrary notebook working directory.

---

### `bin/helpers.sh`

Location:

```text
cifar10-vanilla-cnn:bin/helpers.sh
```

Current role:

At present, this primarily supplies the `elapsed` stopwatch helper.

Why deferred:

Useful convenience, not required RMMFB experiment infrastructure.

Promotion criterion:

Only promote if an active workflow actually uses it.

---

### Other backup / repair / environment-support files

Examples currently living on `cifar10-vanilla-cnn` include:

```text
bin/backup_notebooks.sh
bin/backup_notebook_bakstamp.sh
bin/audit_backup.sh
bin/fix_firstline_glitches.sh
validate_env.py
environment_specifications/
apply_local_fixes_*.sh
revert_local_fixes_*.sh
```

Why deferred:

These belong to prior infrastructure development, backup/repair workflows, environment capture, or historical troubleshooting. None is required to establish the minimum fresh-experiment scaffold.

Rule:

Do not promote them as a group. Inspect and promote individually only when a present RMMFB requirement exists.

---

### PowerShell / CMD / Windows-oriented infrastructure

Examples include:

```text
structure.ps1
NOTWORKING_structure.bat
bin/dwb_selective_tree.ps1
```

Why deferred:

The immediate MVP path is Linux/Bash-first and is intended to move into SageMaker. Cross-platform support should not become a prerequisite for the first publishable RMMFB experiments.

Historical files may remain useful as references and should not be destroyed merely because they are not part of the current MVP.

---

### Historical CIFAR and experiment artifacts

Examples include:

```text
test_project_bash/
general_lab_notebooks_-_other_examples/
Paper_Code_Prep_01-00-00_CNN_GradCAM_TF.ipynb
bin/start_cifar_lab.sh
```

Why deferred:

These may contain useful implementation patterns, examples, and experiment history, but they should not become dependencies of the RMMFB MVP merely because they exist.

The mature `p_03_e2e` work is particularly valuable as a source for proven patterns such as experiment-root handling and result logging. Those patterns may be copied or adapted later without promoting the whole experiment directory.


## Cross-platform access and democratization — intentionally deferred, not abandoned

The MVP uses Bash/Linux because the publication experiments are expected to run through AWS/SageMaker/EC2. This is a scope decision, not a decision that cross-platform support is unimportant.

Earlier infrastructure on `cifar10-vanilla-cnn` includes:

```text
py_touch.py
normalize_eol.py
PowerShell scaffolding
explicit EOL-handling logic
```

These were built to make experiment setup portable across Windows and Unix-like systems.

That portability matters to the larger RMMFB goal. Scholars, archives, volunteers, students, and small institutions should not need a single preferred workstation environment in order to inspect, adapt, or reproduce the workflow.

For the MVP, the Linux-first path wins because it is the shortest path to a real, reproducible scientific result. After the MVP, reconsider:

- restoring PowerShell (`.ps1`) experiment support;
- restoring `py_touch.py` as an OS-independent file-creation helper;
- restoring `normalize_eol.py` and explicit line-ending normalization;
- testing Windows/Linux portability of the released workflow;
- adding macOS compatibility if a contributor wants to help validate and maintain it.

CMD/batch support should remain lower priority and should return only if a concrete user environment requires it.

Do not interpret removal from the MVP as deprecation. These are deferred accessibility/reproducibility features.

A personal note from the current Linux-biased maintainer:

> I would have loved to make this macOS-compatible from the start, but it would have been cheaper to buy a small orchard than to rent a Mac EC2 instance for one unit test. Walled gardens not included or scaled.

That joke should not be mistaken for a platform policy. I am, admittedly, a Linux snob; macOS-using digital humanists are very much invited to prove me needlessly dramatic by contributing a clean compatibility path, tests, or documentation.

The goal is not “Linux forever.” The goal is “Linux now, broader access when it no longer delays the paper.”


## Branch policy

Long-term intended roles:

```text
main
    Canonical current RMMFB workflow.

cifar10-vanilla-cnn
    Historically named source/reference branch containing prior CIFAR work
    plus infrastructure intentionally deferred from the RMMFB MVP.
```

Temporary integration branches such as:

```text
rmmfb-mvp-scaffold
```

should be merged back to `main` when their narrow purpose is satisfied and then deleted.

No `set-aside-main` branch is required merely to preserve the previous state of `main`; Git history already preserves that history.

## Promotion rule

Before promoting any deferred item, answer:

1. What current RMMFB problem does this solve?
2. Is the same need already covered by Git, S3, SageMaker, or simpler code?
3. What is the smallest useful subset?
4. Can it be tested independently before promotion?
5. Does promoting it make the experiment workflow simpler or merely more complete?

If the answer to (1) is unclear, leave it deferred.

## Guiding principle

> Capture the branch. Stay on the trunk.

Deferred does not mean discarded. It means **preserved without allowing infrastructure work to delay the RMMFB MVP**.
