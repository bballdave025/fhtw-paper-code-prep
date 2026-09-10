# CONTEXT DOCUMENT — Continuation

## Project
**Name:** RMMFB / Reused Manuscript Fragments in Bindings

**Prepared at:** 2026-09-09T20:42:00-0400  
**Continued from chat:** Job Descriptions Analysis  
**User (GitHub):** @bballdave025

## Intent
Preserve the current RMMFB paper, data, provenance, experiment, and engineering state so work can resume without re-deriving the rationale. Immediate continuation: promote only durable experiment-start machinery to `main`, smoke-test a fresh experiment, then move into SageMaker/S3 execution.

> **Capture the branch. Stay on the trunk.**

## 1. Ruthlessly MVP paper objective
The paper should make a small, defensible contribution around computer-vision identification of reused manuscript material in historical bindings, using the existing curated RMMFB data/provenance work rather than expanding into a general historical-document vision platform.

Current paper arc:
1. Reconstruct a Keith-style binary reuse/no-reuse experiment on approximately the original first 1,000 images, as faithfully as surviving records permit.
2. Increase binary difficulty in deliberate, documented, stratified increments of about 500 images: roughly 1,000 → 1,500 → 2,000 → 2,500 → 3,000/available.
3. Use an ImageNet-pretrained ResNet-50 at the intended low resolution. Recent discussion says approximately 240 px; historical material sometimes says 224 px. Resolve this from code/data rather than silently normalizing it.
4. First evaluate without fine-tuning and use **Guided Grad-CAM**.
5. Fine-tune the same ResNet-50 at the same resolution and reevaluate.
6. Run one credible richer-label experiment using the existing ontology/classes.
7. Freeze the best defensible model and use it for **retrieval/discovery** over the larger in-the-wild corpus, preserving scores, rankings, and provenance for expert review.

The binary progression is motivation for the richer problem, not the final contribution. Define strata before inspecting results closely enough to invite result-driven redesign.

## 2. Evaluation versus retrieval
**Evaluation:** defined labeled subsets; report accuracy, precision, recall, F1, confusion matrix, and per-class results where meaningful.

**Retrieval/discovery:** frozen model over the in-the-wild corpus (recent rough discussion ~42k–47k; measure the exact current count). Save scores/rankings/provenance. Do **not** pretend precision/recall are known over unlabeled data. Favor useful candidate discovery/high recall followed by human/domain-expert filtering.

Expected low-resolution limitation: salient reuse may be favored while tiny/background/under-cover cases are missed. Guided Grad-CAM can expose this and motivate later higher-resolution work.

## 3. Model/explainability scope
### Mandatory
- ResNet-50 baseline.
- ImageNet-pretrained initial model.
- Same architecture/resolution before and after fine-tuning.
- Guided Grad-CAM as the selected attribution method.
- One richer-label experiment.

### Optional if cheap
- One higher-resolution ResNet-50 experiment: preferred first luxury because it directly tests the resolution hypothesis.
- Future-architecture skeletons/smoke tests clearly labeled **implemented/smoke-tested, not evaluated**.

### Deferred
EfficientNet/EfficientNetV2, remote-sensing-inspired models, ensembles/voting. Do not turn architecture shopping into the current paper.

## 4. Existing dataset and QA substrate
The curated dataset contains **3,331 manually classified historical-document images**, a reuse/no-reuse hierarchy, and richer three-letter ontology codes.

Established QA/data-engineering story:
1. acquire PDFs/images and preserve provenance;
2. avoid reprocessing known documents;
3. extract embedded PDF rasters where appropriate;
4. inspect odd structures and extraction duplicates;
5. normalize filenames and enforce character hygiene;
6. normalize PNG/TIFF/grayscale inputs toward model-ready sRGB TrueColor JPEGs (quality 92 in important historical workflows);
7. attach/normalize ontology labels;
8. check legal codes;
9. check semantic contradictions such as reuse plus no-reuse;
10. normalize label ordering and inspect combination frequencies;
11. manually inspect flags;
12. rerun checks after corrections.

Philosophy: **inspect → convert/fix → inspect again**.

Canonical 17-code set recorded in QA work:
`abg, cwa, fko, fmr, gni, iac, mbr, mcl, mmx, nbr, oic, orc, scg, spr, suh, tbr, ucr`

Historical extra/bad codes included `cwr`, `max`, `noi`, `une`.

## 5. Extraction/normalization archaeology worth retaining
- `binding-unwinding/unwind_the_binding.py`: PyMuPDF extraction of embedded raster images using page images/xrefs/Pixmap with page/xref provenance.
- `binding-unwinding/README.md`: prerequisites, execution, renaming, logging, reproducibility, image-mode verification.
- `all_to_3ch_gray.py`: conversion toward 3-channel images suitable for TF/Keras.
- ImageMagick/mogrify workflows using sRGB/TrueColor and JPEG quality 92.
- Walkthroughs/consistency logs covering counts, uniqueness, extensions, bad characters, legal codes, semantic checks, and manual corrections.

Do not reproduce all archaeology in the paper; retain enough for reproducibility and a credible dataset-methods section.

## 6. Provenance and FamilySearch boundary
- Preserve source/provenance.
- Do not become a mirror for full-size FamilySearch imagery.
- Determine applicable image/publication rights, including source/custodian constraints.
- Coordinate with FamilySearch contacts before publication where appropriate.
- Keep permission/communication questions distinct from model evaluation.
- Do not let future billion-scale inference ambitions expand the MVP.

Relevant relationship/context includes prior FamilySearch work/volunteering/presentation history and contacts including John Morey, Pi Davies, and Greg Nielsen. Verify rights rather than treating relationships as permission.

## 7. Publication/collaboration strategy
Aim for a small credible paper, not a cathedral. Dr. Lisa Fagin Davis is a particularly valuable potential domain reader/collaborator; use precise titles/roles in formal writing.

Priority strategy discussed: narrow concrete timestamping/preregistration if useful; do not delay experiments to perfect publication strategy. If considering arXiv before *Fragmentology*, verify the journal's current preprint/prior-publication policy first.

## 8. Experiment scaffolding and `structure.sh`
The active scaffold is **`structure.sh`**, not `structure.py`.

It creates tag-scoped experiment locations such as:
- `notebooks/`
- `datasets/`
- `models/`
- `logs/`
- `visualizations/`
- `scripts/`
- `outputs/csv_logs/`
- `outputs/gradcam_images/`

It is intended to be idempotent. `WITH_NB_STUBS=1` can create valid minimal Jupyter notebook stubs.

Critical invariant from mature `p_03_e2e` work:
> Experiment paths resolve relative to experiment root (`TAGDIR`), not the notebook kernel's current working directory.

## 9. Current branch/main promotion decision
Do **not** merge the historical CIFAR branch wholesale merely to tidy history.

Current intent:
1. inspect `structure.sh`;
2. identify its true immediate dependencies;
3. compare those with `main`;
4. promote/cherry-pick/manual-copy only durable experiment-start machinery;
5. smoke-test a brand-new experiment;
6. clone/use cleaned `main` in SageMaker;
7. learn S3/local-cache/output-sync/resume lifecycle with the real RMMFB path.

Likely durable candidates, subject to code review:
- `structure.sh`
- required `.gitignore` / `.gitattributes` behavior
- `bin/safe_default_header.sh`
- `bin/helpers.sh`
- `bin/sys_capture.sh`
- probably `bin/backup_everything.sh`
- mature experiment-root resolution/result-logging pattern

Historical CIFAR notebooks, repair/patch scripts, PowerShell/batch machinery, and old experiment directories remain references unless direct dependencies prove otherwise.

## 10. SageMaker / S3 immediate learning target
Learn the smallest reliable lifecycle:
- clone/bootstrap repository;
- establish experiment root;
- understand S3 source-data vs local SageMaker cache;
- copy/download only what a run needs;
- write outputs predictably;
- sync durable artifacts/results back to S3;
- capture environment/system metadata;
- understand interruption/restart/resume;
- avoid infrastructure more complex than the experiment.

A CIFAR-10 smoke test is allowed only if it answers a concrete AWS lifecycle question.

## 11. Technical Eightfold Way
1. Lock the claim in one sentence.
2. Confirm tiering/stratification protocol.
3. Reconstruct original Keith-style binary experiment (~1,000).
4. Extend binary difficulty in stratified ~500-image increments.
5. Run low-resolution pretrained ResNet-50 without fine-tuning + Guided Grad-CAM.
6. Fine-tune same ResNet-50 at same resolution + evaluate.
7. Run minimum richer-label experiment.
8. Freeze best defensible model + retrieve/rank candidates over wild corpus.

Bonuses only after trunk: higher-resolution ResNet-50; future-model skeleton/smoke tests.

## 12. Deferred gaze/attention branch
Potential future comparison among human/domain-expert gaze and model attribution. Three Inland iC700 720p webcams were acquired as possible hardware.

Initial gate, if ever revived: one camera, normal glasses, realistic distance, center/corner/edge targets, determine whether eye/iris orientation is usable.

Kill criterion: if no recognizable gaze/attention heatmap POC emerges with existing hardware/software in at most roughly one additional focused session, keep it out of MVP.

Earlier expert-gaze work with Dr. Farrell at BYU is relevant provenance if revived; verify details before formal citation/acknowledgment.

## 13. Other explicitly deferred branches
- massive FamilySearch-scale inference;
- multiple new architecture families;
- ensembles;
- full gaze trajectories;
- generalized provenance automation before the small workflow is understood;
- exhaustive operations-document cleanup;
- unrelated archival/genealogy discoveries.

## 14. Immediate next steps
**Now:** review `structure.sh` → determine dependencies → compare with `main` → promote durable minimum → smoke-test fresh experiment.

**Then:** SageMaker clone/bootstrap → S3/local-cache/output-sync lifecycle → first real RMMFB experiment as soon as work can be preserved reliably.

**Paper-facing:** freeze binary tiers; resolve 224-vs-~240 px; resolve original Keith subset if possible; record every run with hypothesis, dataset, preprocessing, model state, result, and artifact location.

## 15. Scope backstop
**Paper first. Evidence second. Portfolio for free. Cool new research only if it hitchhikes.**

The project has enough good ideas. The scientific task now is to make a small number of them produce evidence.

> **Capture the branch. Stay on the trunk.**
