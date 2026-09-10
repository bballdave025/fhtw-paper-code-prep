# Context Documents

This directory contains **continuation-ready context documents** (Lab
Notebook / LN files) for the **RMMFB / Reused Manuscript Fragments in
Bindings** work in `fhtw-paper-code-prep`.

> **Repository customization**
>
> This README has been customized for the RMMFB work. The project marker
> used for context-document filenames is `rmmfb`.
>
> Double-brace placeholders (`{{...}}`) appearing in the templates below
> are intentionally retained. They are filled when creating a future
> context document or Pre-Context-Document Prompt (PCDP).

These are **not** polished documentation. They are:

-   structured snapshots of project state,
-   continuation-ready checkpoints,
-   architecture and design records,
-   "lab notebook" entries for engineering and research progress.

------------------------------------------------------------------------

# Purpose

Each document is designed to answer:

> **If I had to resume this work in a fresh environment, what would I
> need to know?**

They preserve:

-   current architecture and experimental workflow
-   terminology and classification/ontology decisions
-   naming decisions
-   design constraints
-   implementation status
-   experiment status and results
-   next-step execution plans
-   important non-obvious insights
-   active questions
-   deliberately deferred branches

Think of these as **checkpoint files for thinking**, not summaries.

------------------------------------------------------------------------

# Documentation Hierarchy

``` text
README.md
    ↓
Project / Paper Charter
    ↓
Lab Notebook / Context Documents
    ↓
Experiment Notes, Notebooks, Logs, and Outputs
```

Each layer answers a different question.

For RMMFB, context documents may bridge work involving:

-   preparation and QA of historical-document image datasets
-   binary reuse / no-reuse classification
-   richer reuse classifications from the existing ontology
-   stratified experiments across easier and harder reuse cases
-   multiple image resolutions
-   pretrained and fine-tuned computer-vision models
-   explainability / attribution work such as Guided Grad-CAM
-   large-corpus candidate retrieval and expert review
-   provenance and source/custodian constraints
-   FamilySearch-derived material and communication/coordination
-   AWS / SageMaker execution
-   paper preparation and collaborator-facing results
-   exploratory model families deliberately deferred beyond the current
    paper

The context document should preserve enough of the research, domain, and
engineering reasoning that future work can continue without
reconstructing why an experiment exists.

------------------------------------------------------------------------

# Context Document Header Template

Use **double-brace placeholders** (`{{...}}`) rather than angle
brackets.

``` text
*BEGIN: Context Document Header*

# CONTEXT DOCUMENT — Continuation

## Project

**Name:**
RMMFB / Reused Manuscript Fragments in Bindings

**Description:**
Research and engineering work for identifying, classifying, and retrieving
reused manuscript material in historical book bindings, including dataset
preparation, computer-vision experiments, explainability, provenance, and
paper preparation.

---

## Continuation Metadata

**Prepared at:**
{{ssssssssss_YYYY-mm-ddTHH:MM:SS±ZZZZ}}

Generated via:

date +'%s_%Y-%m-%dT%H:%M:%S%z'

(Boston, MA time)

**Continued from chat:**
{{Exact chat title}}

**Also involving:**
- {{Related topic}}
- {{Related topic}}
- *(or: no other subjects specified)*

---

## Author / Source

**User (GitHub):**
@bballdave025

**User (ChatGPT):**
{{optional}}

---

## Intent for This Context

{{1–2 sentences describing what this continuation should enable}}

---

## Usage Instructions

- Treat this document as **authoritative project state**.
- Continue with **minimal re-derivation**.
- Reinterpret only when explicitly requested.
- Distinguish clearly among work already completed, work selected for the
  current paper, optional pickups, and future/deferred work.

*ENDOF: Context Document Header*
```

------------------------------------------------------------------------

# Pre-Context-Document Prompt (PCDP)

Before pasting a context document into a fresh chat, you may send a
short PCDP to establish context and immediate goals.

``` text
## Current Work

Project:
RMMFB — computer-vision research on reused manuscript fragments in
historical book bindings.

Starting with:
- {{Step}}
- {{Step}}
- {{Step}}

---

## Upcoming Context Document

The next message will be a CONTEXT DOCUMENT for:

RMMFB / Reused Manuscript Fragments in Bindings

This continues discussion begun in:

"{{Previous chat title}}"

---

## Timing

Preparation:
{{YYYY-MM-DDTHH:MM:SS±ZZ:ZZ}}

(Optional) New chat:
{{YYYY-MM-DDTHH:MM:SS±ZZ:ZZ}}

---

## Instructions for Next Message

Instructions

- Do not summarize.
- Do not reformat.
- Do not analyze.
- Do not critique.
- Do not extract bullet points.
- Do not optimize language.
- Treat the context document as authoritative state.

Your response should only:

1. Confirm receipt.
2. Confirm readiness to continue.

---

## Immediate Focus

Help me:

{{Concrete, task-oriented, ADHD-friendly next task}}

*End of PCDP*
```

------------------------------------------------------------------------

## Practical Note

In normal use, the **Instructions for Next Message** section is often
**omitted** *for the chat creating the context document*.

Experience has shown that including it sometimes causes models to
interpret the transferred context as operational instructions rather
than as information to pass on. In most cases, the PCDP establishes the
project, immediate focus, and previous chat.

However, giving the directions to the *new* chat (unlike giving them to
the old chat) can reduce confusion and extra explanations where Dave
would prefer to continue cognitive momentum. After it is clear that the
forthcoming Context Document is not a usual prompt, the Context Document
can more easily supply the authoritative project state.

Typical workflow:

``` text
PCDP (optional)
      ↓
Context Document (authoritative)
      ↓
Continue work
      ↓
Update / create new LN document before stopping
```

------------------------------------------------------------------------

# Naming Convention

``` text
LN_rmmfb_YYYY-MM-DD_{{optional-tag}}_-_{{short-slug}}.md
```

Examples:

``` text
LN_rmmfb_2026-09-09_-_minimum-publishable-paper-plan.md
LN_rmmfb_2026-09-10_ctx01_-_resnet50-baseline-and-tiering.md
LN_rmmfb_2026-09-12_parked_-_future-model-families.md
```

`LN` = Lab Notebook. This is Dave's longstanding name for these files,
including from undergrad and industry work.

The RMMFB project marker is:

``` text
rmmfb
```

The optional tag is usually omitted unless it adds useful context.
Examples of useful optional tags:

-   `ctx01`
-   `parked`
-   `submitted-addenda`
-   `pr-for-{{collaborator}}`

When in doubt, omit the optional tag.

Choose the slug to describe the primary research or engineering topic
rather than an incidental implementation detail.

------------------------------------------------------------------------

# What Belongs in a Context Document?

A context document should capture the project's **current research and
engineering state**, not merely what changed.

Typical sections include:

-   Current paper/research objective
-   Current architecture and experimental workflow
-   Dataset state and provenance
-   Label/ontology state
-   Recent implementation or experiment work
-   Current design rationale
-   Constraints and assumptions
-   Results already obtained
-   Active questions
-   Immediate next steps
-   Optional quick pickups
-   Explicitly deferred work

For RMMFB, useful state may additionally include:

-   exact dataset/subset definitions and counts
-   train/validation/test or retrieval protocol
-   stratification decisions
-   image resolutions and preprocessing
-   model initialization and fine-tuning status
-   accuracy, precision, recall, F1, confusion matrices, and per-class
    results where appropriate
-   explainability examples and interpretation
-   distinction between **evaluation** and large-corpus
    **retrieval/discovery**
-   saved inference scores, rankings, and provenance
-   expert-review status
-   source/custodian rights or publication constraints
-   FamilySearch coordination status
-   AWS / SageMaker environment and artifact locations
-   hypotheses that were specified before results were inspected
-   unsuccessful approaches or blockers
-   experiment/model families intentionally deferred

When useful, include small code snippets, directory layouts, equations,
commands, filenames, or artifact paths that reduce future re-derivation.

Do not turn a Context Document into a requirement that every interesting
idea be implemented.

For the current paper work, a useful scope rule is:

> **Capture the branch. Stay on the trunk.**
> 
