# After-task — adversarial close of M2 (chapters written and executed)

Branch `book/preview-machinery`. Verdict: **clean-with-limitations.** The manuscript is sound —
every number I could reach traces to a real run. The evidence machinery is not: the ledger
over-reports, and the public-safety gate has two blind spots with live occupants. Closes M2, not M3.

## 1. Goal

Refute the ledger rather than read it; trace spoken numbers to executed cells; judge the comparison
boxes; walk the repo for what must not go public; view the built site; order what M3 needs.

## 2. Implemented

No production file changed; I own only this report. Produced: a re-run of all ten leaves, two
positive controls, an independent re-derivation in R of every pre-rendered R number, a five-number
trace per chapter, a browser walk at desktop/mobile/dark, and a stale-doc inventory.

## 3a. Decisions and Rejected Alternatives

- **Did not render.** Six CHECKs invoke `quarto render` and the ledger records a render wiping the
  docs tree three times today; those gates are reported unverified-by-me.
- **Verified the pre-rendered R boxes rather than trusting their label** — hand-transcribed, checked
  by nothing in the build, so the one place invented output could survive.

## 4. Files Touched

Created: `docs/dev-log/after-task/2026-09-06-preview-machinery.md`. Read-only elsewhere; scratch
controls written outside the repo.

## 5. Checks Run

| Check | Result |
|---|---|
| `gate-check --status`, 10 leaves | 8 ALL MET; `leaf-s4b` 1 unmet; `leaf-s12` 2 unmet |
| Ch2's 5 spoken numbers re-derived in R from `data/ch2/sparrows.csv` | 5/5 exact |
| Pre-rendered `drmTMB` boxes (2) and `lme4` box (1), re-derived in R | every printed digit |
| Ch8's 5 spoken numbers traced to frozen cell output | 5/5 |
| Masthead versions | all five as installed (DRM.jl 0.7.0, Julia 1.10.0, drmTMB 0.7.0, R 4.6.0, lme4 2.0.1) |
| Executed-since-last-edit · site over HTTP · figures in-page | both pass · 7/7 200 · 4/4 and 5/5 |

**Memory receipt.** Recall first: no `/ask-brain` or `search_notes` query was warranted — repo-local
arc, repo is technical truth. Guards that shaped it: "never invent output" and fix-the-class. Golden
Set: the in-scope known-bad class, a vacuous negative-grep gate, is what Control A tests.

## 6. Tests of the Tests

**Control A — `leaf-s9stub:G2`, a bare negative grep.** Its stored EVIDENCE contains `No such file or
directory` beside `NO-OUTPUT-OK`: it ran with the ledger directory as cwd, so it passed on a file
that was not there. Planting a `julia>` prompt in a copy of the stub, the check correctly fails from
the repo root and still prints `NO-OUTPUT-OK` from the wrong cwd. The check is sound; the recorded
pass carries no information. At `--root .` it passes honestly.

**Control B — the campaign `G-scrub`.** On a scratch tree it fires on a planted absolute home path,
but stays **silent** on a planted private-vault path, whose name is not in its pattern; and it
searches only `docs/` and `book/`, never `tools/`, `data/` or `index.qmd`. Both blind spots have live
occupants (P1, P2). It answers `SCRUB-OK` on this repo today.

**Third, no control needed.** `leaf-s2a` reports ALL MET, but the spike directory three of its gates
attest was destroyed by the render-wipe incident: G3 exits 2, G4 exits 1. `leaf-s3` G1/G2 generate
the SVGs they test, so they cannot fail for absence.

## 7a. Issue Ledger

**Public safety** (the repo is recreated from clean history at M3):

- **P1 — worst.** `docs/dev-log/recon/2026-09-06-s0-recon.md:90` and `:93` name the author's private
  second-brain vault and a path inside it. Two scrub commits landed today (`ae9cf40`, `1faa1c9`) and
  both missed it, because the gate that should catch it cannot see the string.
- **P2.** `tools/scrub-paths.sh:5` has a local dev checkout path in a comment — outside the gate's
  search path.
- **P3.** `docs/dev-log/2026-09-06-wk2-drafting-note.md` (archived verbatim by decision; not edited):
  `:22` describes the author's private file storage and is now stale, `:23` defers a decision to him
  by first name, `:24` argues a private house style rule; same class at `docs/dev-log/review/…:40`.
  Nothing dangerous, but these read as lane notes, not book documents.
- **P4.** `coordination-board.md` and `phase-snapshot.md` are unfilled templates titled `— .`.
- **P5.** No `LICENCE` file, while `README.md:68` leaves the flavour open and the site calls itself
  open access.

**Correctness:**

- **C1 — preview blocker.** The landing page links to **chapter 2 only**; chapter 8 is rendered,
  reviewed, approved and unreachable. `index.qmd:20` and both mastheads still say "one of ten".
- **C2.** `book/wk2-linear-models.md` is still tracked beside the `.qmd` and still says the data are
  simulated (`:510`) — two contradictory chapter 2s.
- **C3.** `tools/Manifest.toml:357` pins DRM.jl by relative path and the root manifest is ignored, so
  a clean machine cannot resolve the build.
- **C4.** Mobile overflow: `scrollWidth` 555px (ch2) / 565px (ch8) at a 375px viewport — code and
  tables push the *page* sideways rather than scrolling in their own container. Dark mode is
  excellent.
- **C5.** `<title>` says "Week 2/8"; breadcrumb and landing say "Class 2/8".
- **C6.** `docs/state-of-play.md:54` is corrupt — a duplicated heading fragment.

**Boxes I would delete.** The convention forbids a box that merely restates the same call in another
language. The two `<details class="drmtmb">` "Same fit in drmTMB" blocks
(`book/wk2-linear-models.qmd:144`, `:281`) are exactly that, and they double the hand-transcribed
surface no build step checks. **Delete both.** Keep the ÷n vs ÷(n−p) disagreement box and the lme4
defaults box — one earned box per chapter, which is what the convention asks.

## 8. Consistency Audit

Stale documentation of the pre-Quarto layout — **14 sentences in 5 files**, none fixed (outside my
ownership), all owed. `AGENTS.md:45-46` ("Quarto is not yet used; chapters are markdown...", false on
three counts) and `CLAUDE.md:9`. `docs/README.md:6` and `:8-9` — the redirect called a rendering, and
"a build step should replace this", which it has. `README.md:18-19` (data called simulated), `:21`,
`:25` (wrong count *and* wrong extension), `:56`, `:57`, `:60-64` (documents `book_codegen.py` as the
build, never `quarto render`). `docs/state-of-play.md:56` ("none yet fixed"), `:72-73` and `:74-75`,
both "Next" items now done. Clean: `writing-conventions.md`, `the-climb.md`, `data/2012/README.md`.

## 9. What Did Not Go Smoothly

The ledger changed under me: `leaf-s12:G6` read UNMET at 13:05 and MET at 13:08, both it and
`status.log` written at 13:07 by another live agent; this close is a 13:08 snapshot. `leaf-s2b` still
reports 7/7 unmet with all EVIDENCE "pending" though `status.log` records it landed: its state was
never written back, and two of its gates now fail *correctly* because S4b superseded them. The report
validator itself runs `gate-check` without `--root .` and mis-reports three leaves — Control A's bug,
in the tool that polices it.

## 10. Known Residuals

Six render-invoking CHECKs unverified by me (`s2a:G2`, `s2b:G1/G5`, `s4b:G2`, `s8:G5`, `s12:G1`).
`leaf-s4b:G6`, `leaf-s12:G3` and `G-numbers` are UNMET **by design** while DRM.jl PR #754 is open —
ch2 carries two `[NEEDS RUNNING]` markers. S6, the hosted-environment probe, never ran, so there is
**no evidence** a reader can run a chapter on a clean machine — a headline claim. Nothing pushed.

## 11. Team Learning

**A negative grep is not a check until you have watched it fail.** Two gates could report success
while looking at nothing — one at the wrong cwd, one at a string it was never told to seek. Rule:
*every prohibition gate ships with a positive control*, run at authoring time with the forbidden
thing present.

**A scrub is a class, not an instance.** Two commits scrubbed one file and both left the vault name
in it, each chasing the string noticed instead of widening the pattern that missed it.

## 12. Cross-Product Coverage

Cross-cutting object: **the ledger as a claim of correctness.**

Covers ✓ — all ten leaves; every read-only CHECK at the repo root; every pre-rendered R block; five
traced numbers per chapter; masthead versions; executed-since-last-edit; HTTP reachability; figures;
desktop/mobile/dark; a private-path sweep over `docs/`, `book/`, `data/`, `tools/`, `index.qmd`,
`README.md`, `AGENTS.md`, `.claude/`.

Does NOT cover ✗ — the six render-invoking CHECKs; render determinism today; chapter 6 (a stub); the
theme self-tests (they regenerate their own evidence); the hosted reader environment (S6 unrun, so
Colab/Binder is unevidenced); the live Pages URL; #754 merged; chapter 2's *statistical* content,
which has had no review like chapter 8's; accessibility; any other browser.

---

## What M3 still needs, in order

1. **Link chapter 8 from the landing page**; fix "one of ten" in `index.qmd` and both mastheads (C1).
2. **Widen `G-scrub`** to the whole tree and the vault's name, then fix P1 and P2 — pattern first.
3. **Choose the licence; commit a `LICENCE`**; update `README.md:68` (P5).
4. **Delete `book/wk2-linear-models.md`** and the two translation boxes (C2).
5. **Fix the mobile overflow** — `overflow-x: auto` on code and table containers (C4).
6. **Decide what `docs/dev-log/` is** — public record, or moved out (P3, P4).
7. **Refresh the six stale documents** (§8); repair `state-of-play.md:54`.
8. **Make the build resolve off-machine** — pin DRM.jl by URL and rev (C3).
9. **Run S6**, or say in the README that the hosted path is untested.
10. **Merge #754**, re-execute ch2, retire the markers, re-run the ledger.

## PUBLIC-VISIBILITY RECOMMENDATION

**Recommend against going public today; recommend it after items 1–4** — the orphaned chapter, the
scrub-pattern widening plus P1/P2, the licence, and the duplicate chapter file. Hours, not days;
items 5–10 can follow in the open.

Not because anything is unsafe. Because the repo would ship a landing page hiding half the finished
work, a second chapter 2 contradicting the first, a note naming a private vault, and no licence on a
page that calls itself open access. The manuscript is ready; the packaging is not. **The act is
Shinichi's; this is a recommendation only.**

## QUESTIONS STILL OPEN

- Is `docs/dev-log/` public record or internal? Blocks item 6 and P3/P4.
- Which CC flavour? Blocks item 3; the site already claims open access.
- Do the two translation boxes go, on the convention as written? Blocks item 4. (The chapter's own
  drafting note anticipated this and said the box "deletes cleanly".)

## CARRIED-OVER

- **Ledger repair**, this branch. `leaf-s2b` unwritten-back and superseded by S4b; `leaf-s2a`
  stale-MET against a deleted spike directory. Resume:
  `node ~/.claude/skills/unlazy/scripts/gate-check.mjs --status --root . .unlazy/stats-hours/gates/leaf-s2b.md`
- **`G-scrub` widening**, this branch. Resume: re-run the scrub grep with the vault name added to the
  alternation and the search widened from `docs/ book/` to the whole tree, minus `.git` and the site.
- **DRM.jl #754**, upstream. Resume: `gh pr view 754 --repo itchyshin/DRM.jl`, then
  `quarto render book/wk2-linear-models.qmd` and delete both `[NEEDS RUNNING]` passages.
- **S6 hosted probe** — unstarted, waits on Shinichi's sign-in.
- A preview server on port 8895 was started from the docs directory for this audit; stop it when done.


---

## Addendum — chapters 6 and A, CI, hosted path (2026-09-06, later)

**Snapshot warning.** Another lane was mid-render; the appendix's freeze vanished mid-audit, so
`tools/check-freeze.sh` reported it missing — the race, not the checker. Its workflow gate passes on
inspection, but `leaf-ci` records both gates **pending**, so `capability-status.md` calling that facet
*covered* over-reports it.

**Numbers traced.** Chapter 6, 5/5 to frozen output: 459 rows / 171 birds; SE ratio 1.2974 (spoken
1.3, "nearly a quarter too small" = 22.9%); effective *n* 273; tarsus 92.9% between-bird; R = 0.7189,
delta CI 0.6556–0.7800 against profile 0.6520–0.7764. **I re-derived the pre-rendered R box
independently from the archived CSV** — SS, MS, F, n₀ 2.682942, R 0.7597694, 85/55/31 birds at
*k* = 2/3/4: every printed digit, the executed Julia cell agreeing. Appendix A, 5/5: 171 birds; slope
1.203; refits mean 1.196, SD 0.19; σ 1.881 / raw 2.013 / dev 1.829; **coverage 0.9600 ± 0.0139 at 200
replicates**, its Monte Carlo error stated four times over.

**h² ≤ R is properly scoped** — the partition (additive + permanent environment, no covariance,
exchangeable within individual) appears in the cell comment, the dialogue, the summary and Further
Reading with a DOI; Dohm (2002) is named four times, the √R caveat kept separate. **One wobble:**
"…1.829, which is σ" — σ was given two clauses earlier as 1.881. That *equality* is the author's,
inside one draw's noise (σ/√2n ≈ 0.10) — which the appendix's own objective 3 says to state.

**Gate refuted — `leaf-s9:G3`.** Its perl catches an invented decimal only on a line beginning
`**Speaker:**`. Controls on a scratch copy: in a speaker line it correctly fails; in a **blockquote**
(the DISAGREE box), a **continuation line**, an **integer**, or a **fenced output block** (the
pre-rendered R box) it **passes, printing `NUMBERS-EXECUTED`** — four blind spots, one of them §6's
exact residual risk. `leaf-sA:G1` is identical.

**Public safety — clean.** Zero hits for the six private patterns across `docs/`, `book/`, `tools/`,
`notebooks/`, `.binder/`, `index.qmd`; widened to the whole tree, only ledger and tool directory names
remain. P1/P2 fixed, licences in place. **Worst residue is voice:** 17 lines in `docs/dev-log/` use
the author's first name, agent names and model tiers — lane notes, not leaks, still blocked on the
open "is `docs/dev-log/` public?" question.

**Hosted path — broken now, and after publication.** While private: Binder cannot build the repo,
Colab's loader 404s, the bootstrap's raw-content fetch throws. **After publication it still breaks:**
`tools/figures.jl`, included first by every chapter, does `using Makie`, which neither the bootstrap
nor `.binder/Project.toml` installs (both local `Project.toml`s do). The bootstrap pins no rev, so
Colab takes DRM.jl `main` HEAD; `.binder/Manifest.toml` pins **0.7.1** while every masthead says
**0.7.0**; `make-notebooks.sh` globs `book/wk*-*.qmd`, so **Appendix A can never get a notebook**
though `capability-status.md` lists it. And **nothing sets `--project`, so no committed environment
reproduces the build.**

**The four pages (port 8898).** Landing: masthead, the climb, four rungs linked, no "one of ten".
Chapter 6: kicker `CLASS 6 / DRAFT`, deck, provenance block, four figures. Appendix A: kicker reads
**`APPENDIX A`**, correctly — though the filter strips "Class 6:" from its H1 and leaves "Appendix A:",
so kicker and H1 repeat. **Mobile overflow was not fixed:** at 375 px chapter 2 **555**, chapter 8
**565** — C4's numbers unchanged though `status.log` records the CSS as acted on; it covers `pre`, not
the DataFrame table. Chapter 6 **526**, Appendix A **418**.

**CARRIED-OVER (revised).** Widen the G3/G1 regex with positive controls; re-run `leaf-ci` in a quiet
tree; add Makie and a rev pin to the bootstrap and `.binder`; widen the notebook glob; regenerate wk6;
reopen mobile overflow; pin `--project`. Unchanged: #754, chapter 2's markers, `leaf-s2a`/`leaf-s2b`,
`docs/dev-log/` public-or-not, and **S6 still unrun** — the hosted findings above are analysis, not a
measured run. The port-8898 preview server was stopped at the end of this pass.

**M3 recommendation. Still against public today — but the blockers have moved from packaging to
claims.** The manuscript is ready: both new pieces trace clean and the path leaks are gone. The
evidence layer is not telling the truth about itself — a mobile fix that measures unchanged, a CI
facet called covered whose gates say pending, a hosted path three documents advertise that cannot
import Makie. Hours, not days. **The act is Shinichi's; a recommendation only.**
