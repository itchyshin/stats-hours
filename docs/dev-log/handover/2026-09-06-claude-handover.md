# Handover — the book lane, to a fresh Claude session

**Date:** 2026-09-06 · **From:** the session that created this repository · **To:** Claude, working in
`stats-hours` · **Repo state at writing:** `main`, clean, fully landed, gate PASS.

Public-safe by construction: this file names no private path, identifier or system, so it survives
the repository being opened up.

---

## 1. Where you are

You are in the book repo. The manuscript and its build tooling live here and nowhere else.

Read first, in order: `AGENTS.md` → `docs/state-of-play.md` → `docs/the-climb.md` →
`docs/writing-conventions.md` → the one written chapter, `book/wk2-linear-models.md`.

**Do not skip `docs/writing-conventions.md`.** It carries the rule that matters most, and it is the
rule most easily broken under time pressure.

## 2. What exists

| | |
|---|---|
| Chapters written | **1** — `book/wk2-linear-models.md`, Week 2, the linear model |
| Chapters planned | 10 in v1, plus a coda; 13 rungs in total |
| Tooling | `tools/book_codegen.py` — emits paired Julia/R blocks from DRM.jl's parity fixtures |
| Published page | `docs/index.html`, served publicly at the repo's Pages URL |
| Repo visibility | **private**, deliberately; it opens up when the owner is ready |

The Week 2 chapter is real: every printed number came from an actual fit and is pasted verbatim,
errors included. Its data are simulated from a stated seed, because the original file is not
readable on this machine, and the chapter says so twice.

## 3. What is decided, and must not be relitigated

- **One engine** teaches every rung. Other packages appear only in comparison boxes.
- **An introduction.** Meta-analysis and phylogenetic comparative methods are out; they get their
  own second book.
- **Quantitative genetics is chapter 10**, in v1, placed *after* the REML/ML chapter — because
  heritability is a ratio of variance components and the reader must meet the divisor argument first.
- **Never invent output.**

Each of these was decided with its costs on the table. If evidence arrives that changes one, bring
the evidence to the owner; do not quietly reverse it.

## 4. CARRIED-OVER — unlanded work, with its resume

**Nothing is carried over in this repository.** `main` is clean and fully landed.

Three items are carried over *elsewhere*, in the packages this book teaches. They are diagnosed and
written up, and none is fixed:

| # | item | state |
|---|---|---|
| 1 | A Gaussian fit prints `NaN` where a Wald statistic belongs, and suppresses genuine scale-side coefficients too | diagnosed against source; patch described, not applied |
| 2 | No R² and no residual SD on the natural scale in the summary | diagnosed; the natural-scale value is already computed internally |
| 3 | `Binomial()` rejects every random slope, while seven other families accept them; the R twin fits the same model | diagnosed; blocks chapter 7 opening on binary data |

**Why none was applied:** the engine repository was under heavy concurrent use at the time — a lane
pre-flight reported thirty live lanes and a foreign-lane-active verdict. Editing it would have been
bleed-through. That is the owner's call to sequence, not yours to force.

## 5. The install question — read the correction, not the first version

An earlier draft of this handover said registration and CRAN were the critical path for the whole
delivery model. **That was wrong.** Both engine repositories are public and one carries a proper
UUID, so `Pkg.add(url=...)` and `remotes::install_github(...)` both work on a clean machine today.
Registry membership buys a one-line install and discoverability, not runnability.

The real cost is first-cell time in a hosted notebook, and the expensive half is the R side, which
compiles C++. Since the book is Julia-first and R lives only in comparison boxes, that half can be
pre-rendered rather than executed.

**Consequence for you:** a hosted runnable book is testable now. Do not defer chapters waiting for a
registry. The one exception stays chapter 1, whose subject is the install path itself.

See `docs/state-of-play.md` for the full version.

## 6. Environment## 6. Environment

- Working directory: this repository.
- Julia 1.10 and R 4.6 are installed, with local checkouts of both engines.
- `tools/book_codegen.py` needs a checkout path: `DRM_JL=<path-to-DRM.jl> python3 tools/book_codegen.py`
- **Quarto is not installed.** Chapters are markdown; `docs/index.html` is generated **by hand** and
  can drift. The markdown is canonical.
- Do not stage anything under `.unlazy/` — it is ignored run state, not a deliverable.

## 7. Verification

A chapter is a draft until its code has been executed since its last edit, whatever the prose looks
like. Before claiming any chapter is done:

1. Run every code block in it and compare the printed output to what the chapter shows.
2. Confirm no `[NEEDS RUNNING]` marker survives in a section you are calling finished.
3. Confirm the six template sections are present, in order.

## 8. Next immediate steps — OWED

1. **A build step**, so `docs/index.html` is generated rather than hand-written. This is the highest
   value item here: it removes a whole class of silent drift and unblocks every later chapter.
2. **Chapter 6 or chapter 8.** Both are outlined, neither needs the blocked machinery, and chapter 8
   is the book's most distinctive page. Chapter 8 is the better choice if only one gets written.
3. **Do not start chapter 1 or chapter 7.** Chapter 1 is the installation chapter and its content
   changes the day registration lands. Chapter 7 teaches random slopes and cannot open on binary
   data until item 3 in §4 is fixed.

## 9. First actions in your session

Run the lane pre-flight for this repository before claiming any file. Then compare this handover
against the current git state and classify each item above as **OWED**, **DONE**, **RETRACTED** or
**PROTECTED** before doing anything else. If something here is already done, say so and move on —
do not redo it.

---

## Resume prompt

```text
Read AGENTS.md and docs/dev-log/handover/2026-09-06-claude-handover.md. Run the handover rehydration steps, reconcile them with the current git state, then continue only the OWED Next Immediate Steps.
```
