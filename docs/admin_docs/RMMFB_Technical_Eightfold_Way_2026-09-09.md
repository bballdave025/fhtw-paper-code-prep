# RMMFB Technical Eightfold Way

**Purpose:** Executable route from current repository state to the ruthlessly minimum-publishable experiment sequence.

> **Paper first. Evidence second. Portfolio for free. Cool new research only if it hitchhikes.**

## Before Step 1 — Make the experiment portable
Review `structure.sh`, identify only its true dependencies, promote the durable minimum to `main`, create a fresh experiment tag, verify `TAGDIR`-relative paths and non-clobbering behavior, then use that cleaned `main` in SageMaker.

Do not wholesale-merge branch archaeology merely to tidy history.

## 1 — Lock the claim
Write one sentence stating what the minimum paper tests/demonstrates.

**Done when:** one sentence narrow enough for the following experiments to answer.

## 2 — Freeze the tiering protocol
Define binary reuse/no-reuse progression before results:
~1,000 → ~1,500 → ~2,000 → ~2,500 → ~3,000/available, deliberately introducing harder/more heterogeneous reuse.

**Done when:** deterministic subset definitions or saved manifests reproduce every tier.

## 3 — Reconstruct the Keith-style baseline
Recover the original subset as faithfully as surviving evidence permits. Record image IDs, labels, split protocol, preprocessing, resolution, historical claim/context, and unrecoverable differences.

**Done when:** one reproducible baseline run and saved metrics/artifacts exist.

## 4 — Run stratified binary progression
Repeat across frozen tiers. Minimum metrics: accuracy, precision, recall, F1, confusion matrix. Keep other dimensions controlled.

**Done when:** one compact performance-across-tiers result plus documented tier composition exists.

## 5 — Pretrained ResNet-50 + Guided Grad-CAM
Use ImageNet-pretrained ResNet-50 at selected low resolution, initially without fine-tuning. Resolve the 224-vs-~240 px discrepancy from code/data.

Generate Guided Grad-CAM examples for correct reuse/no-reuse, false positives/negatives, easy/salient reuse, and subtle reuse where available.

**Done when:** metrics plus a small interpretable attribution set exist.

No explainability-method shopping.

## 6 — Fine-tune the same ResNet-50
Fine-tune the same architecture at the same resolution and protocol.

**Done when:** before/after metrics, confusion matrices, and enough Guided Grad-CAM examples expose meaningful changes or persistent failures.

Do not change three dimensions at once.

## 7 — Run one richer-label experiment
Use existing ontology/classes. State explicitly whether the operational task is multi-class, multi-label, hierarchical, or a deliberate projection.

Report support counts, appropriate aggregate/per-class metrics, confusion/error patterns, and domain interpretation.

**Done when:** one defensible richer-label result earns its space in the paper.

## 8 — Freeze and retrieve
Select the best defensible model from labeled evaluation and freeze it. Run it over the larger wild corpus (measure exact count; recent rough estimate ~42k–47k).

Save image/provenance ID, model/run ID, scores, rank, source metadata, and artifact location.

This is **retrieval/discovery**, not evaluation. Do not report precision/recall over unlabeled wild data as if ground truth existed.

**Done when:** durable ranked output plus a manageable expert-review set exists.

## SageMaker/S3 operating loop
**Repository → experiment scaffold → S3 source → local cache → run → local outputs → durable S3 sync → metadata/log checkpoint.**

Know what is source-of-truth, what is cached, what can regenerate, what must survive interruption, and how restart knows what completed.

A CIFAR-10 cloud smoke test is justified only if it answers a concrete lifecycle question.

## Allowed bonuses
1. **Higher-resolution ResNet-50** — preferred first extension because it directly tests the resolution hypothesis.
2. **Architecture skeleton/smoke tests** — e.g. EfficientNetV2 or remote-sensing-inspired models, explicitly labeled **implemented/smoke-tested, not evaluated** unless real experiments are run.

## Explicitly parked
Gaze tracking; ensembles; architecture zoo; massive FamilySearch inference; generalized provenance automation; operations-document cathedral building; wonderful genealogy rabbit holes.

They are not rejected. They are parked.

## Stop condition for a work session
Before stopping: save code; sync irreplaceable outputs; record results/blockers; update/create `LN_rmmfb_*` if state changed materially; write **one concrete next command/action**.

> **Capture the branch. Stay on the trunk.**
