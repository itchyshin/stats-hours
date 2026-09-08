# Plan vs actual — the preview campaign, 2026-09-06

Branch `book/preview-machinery`. Plan: `~/.claude/plans/shiny-prancing-dolphin.md` (S0–S15, G0→M1→M2→M3).
Reconciled against `.unlazy/stats-hours/` (GATES.md, ten `gates/leaf-*.md`, `status.log`), the commit
log, Rose's after-task report, and the chapter 8 review.

| axis | planned | actual | tag | owner |
|---|---|---|---|---|
| Scope | S6/S7 wave-1, paused only on sign-in/OK; S9 (ch. 6) stub then completes | S6 held on Colab sign-in; S7 ran once he gave the word; S2 split S2a/S2b as planned; **S4b added mid-campaign** (real 2012 data replaces seeded ch. 2), his decision; **S9 stayed a stub**, never completed | S4b/S6/S7 adaptive (each recorded with a named decision); S9 stub-only is **drift** — nothing closes the "completes after" gap | Ada |
| Evidence | one unlazy gate per slice, EVIDENCE real | 8/10 leaves ALL MET, but Rose's close found `leaf-s9stub:G2` passed from the wrong cwd on an absent file, `leaf-s2a` MET against a spike dir the render-wipe incident had destroyed, `leaf-s2b` state never written back | drift — ledger over-reported until Rose's audit corrected it | Rose |
| Model routing | S12 to a Haiku scout (`scout=1: S0, S12`); ceiling (Opus) ≤1 live | S0 ran as `recon-s0`; **S12 ran under the orchestrator, no Haiku child** — no `s12` agent in the roster; ceiling stayed at 1 (S8 writer, S10 review, Rose's close ran sequentially) | drift on S12 delegation; ceiling budget matches plan | Ada |
| Safety gates | MUST-STOP: cloud-drive download ask-once, issue-filing on public repos, no edits in `../DRM.jl`/`../drmTMB`; preview gated on fixes A+B | S7/S11 both ran only after his word; S10 cycled BLOCK → revision → APPROVE; two `[NEEDS RUNNING]` markers held by design on open PR #754 | adaptive — every gate did what it was built to do | Rose, stats-reviewer |
| Public claims | S13 close feeds M3's public go/no-go | Rose's close explicitly **closes M2, not M3**; recommends against public today (orphaned ch. 8 link, duplicate ch. 2 markdown, no LICENCE, a private-vault name at `docs/dev-log/recon/...:90,93` two prior scrub commits missed) | adaptive — scope correctly compressed, states its own boundary | Rose |
| Handover | S13 → S14 (this file) → S15, in order | the handover file (committed 13:34) already cites "Melissa's reconcile" as read-first, six minutes before this file existed — **S15 ran ahead of S14** | drift — sequencing skip, not a content error | Ada |

## Drift classes worth a guard

- A negative-grep gate with no positive control can pass vacuously (wrong cwd, absent target) —
  guards against a chapter shipping invented output because its gate never actually fired.
- A scrub gate with a fixed string list goes silent on names it was never told to seek — guards
  against a private vault name or dev path reaching the public site once M3 recreates the repo.
- Model routing (Haiku scout vs. orchestrator-direct) should be visible in the ledger itself, not
  reconstructed from an absent agent name — guards against silent escalation with no record of why.
- The S13→S14→S15 dependency chain is not self-enforcing — guards against a handover committed
  before the reconcile it cites exists.

## Carried over

Ledger repair (leaf-s2a, leaf-s2b), this branch — per Rose's after-task Carried-over. `G-scrub`
widening to the vault's name and to `tools/`, `data/`, `index.qmd` — P1/P2 unresolved. DRM.jl #754
merge, then re-render ch. 2 and retire both `[NEEDS RUNNING]` markers. Chapter 6 beyond the stub — no
decision on record to close or extend it. S6 hosted-reader probe — unstarted, waiting on his Colab
sign-in. M3 public go/no-go — not reached; Rose's recommendation stands against it until items 1–4 of
her ordered list land.
