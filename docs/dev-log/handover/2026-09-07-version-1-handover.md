# Session Handoff: version 1 of *Stats Hours with Itchy* — closed, publication blocked

**Meta** · 2026-09-07, written at the close of the day (05:04 → 11:33 of chapter work, then this
close) · from Claude Code, lane "Rose" · platform-agnostic: either Claude, Codex or Cursor resumes
from this file · companion after-task report:
[`docs/dev-log/after-task/2026-09-07-version-1.md`](../after-task/2026-09-07-version-1.md).

---

## Critical Context

Two things, and getting either wrong costs more than a day.

1. **Do not run `tools/recreate-public.sh`, and do not flip the repository's visibility.**
   **83 of the 147 commits reachable from `main` carry a private absolute path in their trees** —
   the account name and the private folder layout. `recreate-public.sh` step 4 pushes `main`'s
   *entire* history to the new public repository, so recreating publishes all 83.
   `tools/verify-public.sh` would still print `PUBLIC-OK`: it checks only that the three
   force-replaced SHAs (`291f4ac`, `2335fa4`, `b6c03d3`) are gone, which is a different question.
   Measured this morning, at `main` = `8c9e914`.

2. **The Pages site is already publicly readable** even though the repository is private:
   unauthenticated `curl https://itchyshin.github.io/stats-hours/site/` returns 200 today, and the
   three pages checked are byte-identical to the committed `docs/site/`. So the *book* is public and
   the *history* is not. That inverts the usual urgency — a leak in a committed dev-log file matters
   now, not at the flip. One such leak was found and fixed in this close.

---

## What Was Accomplished

**Today, before this close** — version 1 of the book: the preface, Classes 1–10, Appendix A and the
coda, fourteen pages, all linked from the index, every page executed at build under
`execute: freeze: auto`, every spoken number an inline `{julia}` expression, every random draw from
an explicit `MersenneTwister`, one pre-rendered R box per chapter. Seven chapters plus the
preface/coda were written and adversarially reviewed today; **six of eight were blocked at first
review** and rewritten. Seven engine issues (DRM.jl #758–#764) were filed, two of them (#761, #762)
corrected afterwards by reviewers' independent refits.

**This close** — an adversarial re-measurement of the day's claims. Results, in full, in the
after-task report §5 and §7a. The headline:

| claim under test | verdict |
|---|---|
| every page executed at build | **HOLDS** — `check-freeze.sh` exit 0; 12/12 freeze hashes fresh; no `NEEDS RUNNING`; `Random.seed!` only in Appendix A's labelled demo |
| a reviewer's "every number reproduces" | **HOLDS** — nine of chapter 10's pedigree quantities and chapter 1's wing statistics recomputed from the raw CSVs in Python, exact to the last digit |
| the site is one command | **HOLDS** — `_quarto.yml` renders `index.qmd` + `book/*.qmd` into `docs/site`; all 14 inputs re-rendered from the frozen cache diff clean against the committed site |
| every chapter reviewed and passed | **PARTLY** — 9 of 11 review files close on Pass/Accept/Approve; chapter 3's closes on **Block** and the preface/coda's on **REQUIRED**, fixes landed but no close recorded. Every reviewed SHA is on `main`; **no chapter is identical at `main`** to the SHA its verdict names (1–14 commits of drift) |
| `tools/scrub-check.sh` SCRUB-OK | **FALSE at the start of this close** — it exited 1. Fixed here; now `SCRUB-OK` |
| every gate leaf ALL MET | **true of the chapter leaves; the book-level `GATES.md` has four unticked gates**, including `G-scrub` and `G-public` |

**Fixed in this close** (one file, inside the closer's write scope): the leaked scratchpad path at
`docs/dev-log/review/2026-09-07-whole-book-pass.md:144`.

**Found and left for the next lane:** 21 of 45 figures ship with no caption; all thirteen notebooks
are stale and chapter 10's is missing two code cells; two review files have no recorded close;
`leaf-s1:G2` fails on an untracked agent file.

---

## Current Working State

**Working**

- Fourteen pages live and served: `https://itchyshin.github.io/stats-hours/site/`.
- `quarto render` from the repository root rebuilds the whole site into `docs/site/`; `docs/index.html`
  is a hand-written redirect to `site/` and is not touched by the render.
- `sh tools/check-freeze.sh` → `freeze consistent` (exit 0).
- `sh tools/scrub-check.sh` → `SCRUB-OK` (exit 0) **on the working tree only** — see below.
- All thirteen chapters' rng discipline; all twelve freeze hashes fresh.

**In progress / not done**

- Publication. Blocked on the history leak; see Next Immediate Steps.
- Colab and Binder: unmeasured. `docs/reader-environment.md` records a clean-depot proxy only.
  Every "hosted run verified" row in `docs/design/capability-status.md` correctly reads `planned`.
- Chapters 11 and 12 (location-scale, bivariate) held for version 2. Not drafted, not stubbed, not
  promised on the index.

**Broken / blocked**

- `docs/state-of-play.md` "Next" is stale — still says classes 1–9 are live and chapter 10 is in
  review on the branch. It merged at `8c9e914`.
- Every chapter masthead reads *"One of eleven executed chapters … of ten planned for version 1"*,
  which is arithmetically right and reads as a contradiction.
- `handoff_gate.sh` and `check-after-task.R` both exit 1 on the acceptance ledgers. Declared below.

---

## Key Decisions & Rationale

Made today; staged for the vault at `.uinit/brain-proposal/DECISIONS-2026-09-07-draft.md`
(PROPOSE-gated — nobody wrote to `$HUB/`).

1. **One engine.** DRM.jl and drmTMB teach every rung; GLM.jl, MixedModels.jl and lme4 appear only
   in comparison boxes. Decided with its costs on the table; do not relitigate without evidence.
2. **Exposure first in Class 4.** The chapter opens on the exposure (`log(EggNo)` as a free
   covariate, the offset shown in the R box because DRM.jl has none — #727) and only then reaches
   the negative binomial. The first draft fitted NB2 without ever using the exposure and was blocked.
3. **The diagnostic's own null.** A simulation envelope must be built from the null the diagnostic
   actually scores against, refitting where the diagnostic refits. Class 5's first draft drew the
   envelope from a different null and was blocked; the fixed chapter now counts four distinct nulls
   and says which parameters each may re-estimate.
4. **Class 6's adjusted ceiling is the h² bound in Class 10**, not the raw repeatability — and the
   bound is scoped to the decomposition rather than asserted generally (Dohm 2002 cited).
5. **Explicit rng everywhere.** Every `simulate` and `rand` takes a `MersenneTwister` passed in as
   `rng`; never `Random.seed!`, whose global state makes a page's reproducibility depend on what ran
   before it. Appendix A keeps `Random.seed!` as a labelled demonstration of the thing being retired.
6. **A corrected beat has three homes** — dialogue, Summary, Exercises. Written into
   `docs/writing-conventions.md` at `cffbf04` after a correction landed in the dialogue and left the
   exercise asking students to derive the retracted claim.
7. **Batch merges through a worktree**, so the shared checkout stays on its branch while other lanes
   write.
8. **The compact `show(io, fit)` is never used in a chapter** — it labels every family "Gaussian
   location–scale" (DRM.jl #758). The `text/plain` header is correct and is what the chapters print.

---

## Landing State

*(`$HUB` is the operating hub checkout — the one that holds `AGENTS.md`, `protocols/` and `tools/`. Not named here; this file is public-safe.)*

`bash $HUB/tools/handoff_gate.sh "$(pwd)"` — verdict, verbatim:

```
LANDING GATE -- run before writing a handoff.

  XX   stats-hours        book/preview-machinery       2 uncommitted; 1 UNPUSHED on HEAD;
          M docs/dev-log/review/2026-09-07-whole-book-pass.md
         ?? .claude/agents/shannon.md
         + bcd654d reconcile: plan vs actual for version 1 (Melissa)
  XX   stats-hours: acceptance ledger .unlazy/stats-hours/gates/leaf-*.md -- GATES UNMET   (20 of 22)

GATE FAIL -- 20 acceptance ledger(s) have UNMET gates.
```

Re-run after this close's commit; the two report files land, the rest stands as declared.

| Artifact / branch | Committed | Pushed | PR | State |
|---|---|---|---|---|
| `stats-hours` `main` `8c9e914` — version 1, fourteen pages | y | y | n/a (merge) | **LANDED** |
| `stats-hours` `book/preview-machinery` `fc222ce` — same content as `main` | y | y | n/a | **LANDED** |
| `stats-hours` `book/preview-machinery` `bcd654d` — Melissa's plan-vs-actual reconcile | y | **n** | none | **CARRIED-OVER** |
| `stats-hours` `book/preview-machinery` **branch tip** — this close: after-task, handover, and the redaction of the leaked path (`git log -1 --format=%H` on the branch) | y | **n** | none | **CARRIED-OVER** |
| `.claude/agents/shannon.md` — lane-coordinator agent | **n** (untracked) | n | none | **CARRIED-OVER** |
| `.uinit/brain-proposal/*.md` — two vault drafts | n (git-ignored) | n | none | **CARRIED-OVER**, deliberately |
| `.unlazy/stats-hours/**` — 22 gate ledgers | n (git-ignored) | n | none | run state, never a deliverable |

**CARRIED-OVER — why, and how to resume:**

- **`bcd654d`** — committed by a concurrent lane while this close was being written; not this
  closer's to push, and `main` does not need it to be correct.
  Resume: `git -C "<repo>" push origin book/preview-machinery`. Optional; `main` is content-identical
  to `fc222ce` and is what Pages serves.
- **This close's two documents plus the redaction** — committed with scoped staging, not pushed and
  not merged, because pushing another lane's branch state was not this close's mandate. `main` is
  ahead of the branch by eleven merge commits and content-identical (`git diff main
  book/preview-machinery` is empty); the branch is ahead of `main` by `bcd654d` and this commit.
  Resume: `git -C "<repo>" push origin book/preview-machinery`, then merge to `main` as the day's
  merges were done.
- **`.claude/agents/shannon.md`** — untracked, and it is what makes `leaf-s1:G2` fail
  (`FAIL(claude): shannon.md: bad/missing model [inherit]`). Either give it a concrete model line and
  commit it, or delete it. Leaving it untracked keeps a roster gate red for everyone.
  Resume: `node $HUB/skills/unlazy/scripts/gate-check.mjs --root "$(pwd)" --cwd "$(pwd)" --reverify .unlazy/stats-hours/gates/leaf-s1.md`
- **The two vault drafts** — staged under `.uinit/brain-proposal/`, never written to
  `$HUB/`, per the brain-write boundary. They need Shinichi's approval before anything
  is appended to `AGENT_LOG.md` or `DECISIONS.md`.
- **20 UNMET acceptance ledgers** — `gate-check --status` (which reads the recorded boxes) confirms
  every *chapter* leaf is ALL MET; `--reverify` (which re-runs the CHECK commands today, from the
  repo root) fails on 20, mostly because those checks were verified in lane worktrees that no longer
  exist and the ledgers do not declare `WORKTREE:`/`RECEIPT:`. One failure is real (`leaf-s1:G2`,
  above). The book-level `GATES.md` has four gates unticked by design, `G-public` among them.
  **Do not tick them to make a gate green.**

**FINDING-OF-RECORD:** reachable git history on `main` carries a private absolute path in 83 of 147
commits, and neither `tools/recreate-public.sh` nor `tools/verify-public.sh` can detect it —
publication is blocked until history is clean or the publish path stops carrying history.
**vault-note:** [[A repository can be scrubbed at the tip and still leak in every commit that reaches it]]

**FINDING-OF-RECORD:** a source-level check and a screenshot disagreed about chapter 10's figures,
and the screenshot was right — 21 of 45 figures on the live site render with no caption while every
grep, gate and review passed.
**vault-note:** [[Look at the output — a missing caption is invisible to every check that reads the source]]

*(Both vault notes are drafted at `.uinit/brain-proposal/` and are **not yet written**; writing them
is the first item of the brain-proposal approval below.)*

---

## Next Immediate Steps

**The author's, first — two steps, neither of which should be taken yet:**

1. **Publication is NOT recommended today.** See the recommendation below. When it is, the six
   printed steps are `sh tools/recreate-public.sh` (a dry run that prints and executes nothing), then
   `sh tools/verify-public.sh` after the recreate. **Never flip the visibility switch** on the
   existing repository: three pre-scrub SHAs remain retrievable there, which is the whole reason
   recreation exists.
2. **Colab.** Sign in and time the two bootstrap cells in `notebooks/wk2-linear-models.ipynb`, then
   record the measurement in `docs/reader-environment.md` and flip the "hosted run verified" rows in
   `docs/design/capability-status.md` from `planned`. **Regenerate the notebooks first** (step 3
   below) — the ones on disk are stale, and chapter 10's is missing two cells.

**Then, in order, for the next lane:**

3. `sh tools/make-notebooks.sh` — regenerates all thirteen from the current chapters. Then re-run the
   cell-level comparison to confirm chapter 10 regains `reml-two-component` and `leverage-pairs`.
4. **Give the 21 uncaptioned figures captions** — `#| fig-cap:` in chapters 3 (four figures), 6, 8, 9
   and 10. Every one is a real edit to a chapter, so each invalidates its freeze hash and needs a
   re-execute plus render, one file at a time.
5. **Close the two open review records** — append a re-review section to
   `2026-09-07-ch3-stats-review.md` and `2026-09-07-preface-coda-review.md` naming the SHA that
   closed them (`75c3542`/`0805172`, `59eccb1`), or say plainly that they were closed without one.
6. **Resolve `.claude/agents/shannon.md`** (commit with a concrete model, or delete).
7. **Refresh `docs/state-of-play.md`'s "Next"**, and reword the masthead's "eleven … of ten".
8. **Version-2 planning: rungs 11 and 12** — location-scale and bivariate models, the two capabilities
   the one-engine decision names for version 2. Start from `docs/the-climb.md` and
   `docs/design/capability-status.md`; the first question is which of the two DRM.jl supports today
   and to what depth, because that decides which is rung 11.
9. **Fenced, deliberately, and not to be started:** the learning-game lane and the animation lane.
   They are good ideas and they are not version 2.
10. **Symbolizer.jl adoption** when `equations(fit)` exists — the book prints model equations by hand
    today; when the engine can emit them, the chapters should read them from the fit rather than
    restate them, which is the same never-invent-output rule applied to mathematics.

---

## Public-visibility recommendation

**Recommendation: DO NOT publish today.** This is a recommendation, not an act; nothing in this close
touched the repository's visibility or ran any step of the recreate procedure.

**What must be true before the author runs the recreate-from-clean steps, and whether it is true now:**

| # | condition | now |
|---|---|---|
| P1 | `sh tools/scrub-check.sh` returns `SCRUB-OK` on the tree to be published | **TRUE** — after this close's redaction. It was **false** two hours ago, which is why P2 must be checked and not assumed |
| P2 | no commit reachable from `main` carries the private-path pattern in its tree | **FALSE — 83 of 147 commits do.** Blocking |
| P3 | `verify-public.sh` actually tests P2 | **FALSE** — it tests three unreachable SHAs, which is a weaker and different claim |
| P4 | the three force-replaced SHAs are absent from the new repository | true by construction on a fresh repository; keep the check |
| P5 | no `NEEDS RUNNING`/`PLACEHOLDER` anywhere; every page executed at build | **TRUE** — `check-freeze.sh` exit 0, 12/12 freeze hashes fresh |
| P6 | the live pages carry no private path | **TRUE** — three pages fetched and grepped |
| P7 | the content is publication-ready | **NOT YET** — 21 uncaptioned figures (R3), thirteen stale notebooks one of which is missing code cells (R4). None is a privacy risk; all are visible to the first reader who arrives |
| P8 | `GATES.md`'s `G-public` is satisfied — "Rose's signed recommendation, Shinichi's explicit go" | **NOT SIGNED** by this close, on P2 |

**The shortest honest route to publishing:** decide whether history is part of the deliverable. It is
not — the book is the tip. So the cheapest fix is to make the publish path stop carrying history:
create the public repository from a **single orphan commit** of `main`'s tree (`git checkout --orphan`,
one commit, push that), or run a history rewrite (`git filter-repo` over the pattern) and re-verify
with a P2-shaped check. Either way, **add P2 to `tools/verify-public.sh`** so the next person is not
protected by a check that never asked the question. Then fix P7, then re-sign.

---

## Blockers / Open Questions

1. **P2, above.** Blocking, and it needs a decision from Shinichi (orphan commit vs history rewrite),
   not just work.
2. **Is the dev-log part of the public deliverable?** `1b288d5` decided it stays public as the working
   record. That decision is what put a reviewer's scratchpad path on a path to publication. It is
   still the right decision; it needs `scrub-check` run on **every** dev-log commit, not on the tip.
3. **Does the Colab notebook run**, as opposed to returning HTTP 200? `verify-public.sh` checks the
   status code only. Unanswerable without the author's sign-in.
4. **Which of location-scale and bivariate is rung 11?** Depends on DRM.jl capability today; nobody
   has measured it.

---

## Gotchas & Failed Approaches

- **Do not run `handoff_gate.sh` with `sh`.** It uses bash process substitution and dies at line 114
  while a piped `tail` returns 0 — a green exit code for a script that never ran. Use `bash`, and do
  not read a pipeline's status as the command's.
- **Do not `--reverify` the chapter gate ledgers casually.** Their `G5` checks `mv` a `_freeze/`
  directory aside and render twice. On a tree shared with other lanes that is how a committed freeze
  gets destroyed — `tools/check-freeze.sh`'s own header records an earlier version of this repository
  doing exactly that. Re-verify one ledger at a time, and check `_freeze/` afterwards.
- **Do not trust a caption audit that reads normalised text.** The markup carries a literal `&nbsp;`
  entity; a whitespace-normalising regex reports every figure captioned. Key on Quarto's
  `quarto-uncaptioned` class, which is what the renderer emits — or, better, look at the page.
- **Do not quote the last run of a check.** `scrub-check.sh` had been failing for over two hours and
  the summary handed to this close still said `SCRUB-OK`. Re-run it.
- **Do not read `gate-check --status` as a re-verification.** It reads the ticked boxes in the file;
  `--reverify` re-runs the commands. They disagreed here by twenty ledgers.
- **A stale `.git/index.lock` from GitHub Desktop** blocks every commit with no git process behind it.
  Wait 30 s, confirm no git process, then remove it — and never remove one belonging to an in-flight
  operation. `handoff_gate.sh` reports such a lock and refuses to remove it, deliberately.

---

## How to Resume

```sh
cd <the stats-hours checkout>
bash $HUB/tools/lane_preflight.sh . 2>/dev/null || true
git fetch --all --prune && git status --short && git log --oneline -5 --all
```

Read, in this order:

1. `AGENTS.md` — the contract. *Never invent output*; *look at what you built*.
2. This handover.
3. `docs/dev-log/after-task/2026-09-07-version-1.md` — §7a is the issue ledger, §12 the negative space.
4. `docs/state-of-play.md` (stale in its "Next" section — see step 7 above) and
   `docs/design/capability-status.md`.
5. `docs/writing-conventions.md` — the two rules added today.
6. `docs/dev-log/plan-actual/2026-09-07-version-1.md` — the day's plan-vs-actual reconcile.

Then start at **Next Immediate Steps** item 3. Items 1 and 2 are the author's and are not owed by any
lane.

**Classify before you act.** Per the receiving-a-handoff protocol: everything above is `OWED` except
the two author steps (`PROTECTED` — Shinichi's), the publication route (`OWED` only after Shinichi
decides between the orphan commit and the history rewrite), and the chapter files themselves, which
are `PROTECTED` from any lane that has not read the chapter's review first.

---

## Addendum: 2026-09-07, later the same day

Written after the close above, on `book/preview-machinery`. Three things happened between that close
and this line, and two of them change what the sections above tell you to do. Read this addendum
before acting on **Next Immediate Steps**.

### 1. A reader pass over all fourteen pages

A reader persona plus paired readers read every page as a reader would, not as an author does, and
reported the places where a real person could not follow. The report was long and most of it was
fair. The fixes landed in four commits on this branch, `209f06e` (the preface, Classes 1, 2, 6 and 8,
and Appendix A), `9506205` (Classes 4 and 5), `9d70a4e` (Classes 3 and 10), and `34d8796` (Classes 7
and 9), plus one last gloss commit for Classes 3, 4, 5 and 10 that the orchestrator is making as this
is written. Its SHA is not recorded here; it is the tip of the branch.

Four things changed, and they are worth knowing because they are now conventions, not one-off edits.

**Terms are defined where they are first used.** Statistical vocabulary and software vocabulary both.
A reader who meets a word for the first time gets a short gloss in the sentence that introduces it,
not a cross-reference to a chapter they have not read yet.

**Build and review machinery is gone from every public page.** Engine source file names,
stack-trace lines, issue numbers, and the vocabulary of gates and freezes were all visible in the
chapters. None of it means anything to a reader learning regression, and some of it reads as an
apology. It belongs in this dev log, which is where it now lives. Treat this as a rule going forward:
if a sentence would only make sense to somebody who has read the acceptance ledgers, it does not
belong in a chapter.

**Chapter 2's internal "honest note from drafting" was removed.** It was a note from the authors to
the authors that had been left where readers could see it.

**A document filter now trims every error and warning shown on a page.** The chapters deliberately
show failures, because a failure is teaching material. The stack trace under it is not. The filter is
`trim_error_output` in `tools/stats_hours.lua`: it keeps the message, replaces the stack trace with
`(stack trace omitted)`, and drops engine source-location lines wherever they appear, including
inside the "Closest candidates" block that a `MethodError` prints. You do not have to remember to
strip these by hand any more. You do have to check that a newly shown error still reads sensibly
after the trim.

Every edited chapter needs its freeze hash refreshed, and a render was still in flight when this was
written. Run `sh tools/check-freeze.sh` before you trust the site or the freeze counts recorded
higher up this file. Do not assume the twelve fresh hashes described in **Current Working State**
still describe this branch.

### 2. The history leak, and the publication path that answers it

An adversarial close pass went back over the publication question and found that the earlier framing
understated it in one respect and that the fix was cheaper than feared.

The finding first. The private absolute paths are not a tip-of-tree problem that a scrub fixed. They
are in the history: **74 of the 147 commits reachable from `main` carry the pattern in their trees.**
That count comes from the checker now in the repository, and it supersedes the figure of 83 quoted in
**Critical Context**; the finding itself is unchanged either way. So publishing this repository by
pushing its history would publish the paths, and a force-push is not a remedy, because anything
already fetched by SHA stays retrievable whatever the branch tips say afterwards.

Two things were built in response.

`tools/scrub-history-check.sh` asks the question the old check never asked. `tools/scrub-check.sh`
greps the working tree. The new script walks every commit reachable from a ref and greps each one's
tree, then prints `HISTORY-CLEAN` or `HISTORY-NOT-CLEAN` and exits non-zero on the latter. It reads
the pattern from the git-ignored `.scrub-pattern` file, so the script itself never names the thing it
is looking for.

`tools/recreate-public.sh` was rewritten so that the publish path stops carrying history at all. This
is the decision that **Blockers / Open Questions** item 1 was waiting on, and it went the cheap way:
the book is the tip, the history is not part of the deliverable, so publish the tip. Steps 4a to 4c
now read:

- **4a** creates an orphan branch and commits `main`'s tree onto it as a single commit. One commit,
  all of the content, none of the history.
- **4b** runs `sh tools/scrub-history-check.sh public` against that orphan branch. It must print
  `HISTORY-CLEAN`. `main` will never print it and is not expected to.
- **4c** creates the public repository and pushes the orphan branch to its `main`, so the published
  repository's entire history is that one clean commit.

`tools/verify-public.sh` now clones the published repository bare and greps its history, which is an
independent check rather than a restatement of what the recreate script believes. It also warns if
the published repository carries more than three commits, since publication was meant to be one. The
old check for the three force-replaced SHAs is still there; it was never wrong, only narrow.

The script still prints and executes nothing by default. **Publication is the author's action, not an
agent's.** No lane should run it, and the P8 sign-off in the recommendation table is still the
author's to give.

### 3. The acceptance ledgers, and a trap that cost a cycle

Every chapter has a gate ledger under `.unlazy/stats-hours/gates/`, git-ignored, twenty-two of them.
The checker has a failure mode that looks exactly like success and another that looks exactly like
disaster, and both are artefacts of how it is invoked.

Running it with `--approve` alone can report **ALL MET** without running a single check. It is
reading evidence recorded earlier and taking it at face value. Nothing re-ran. A green line here
means nothing about the state of the tree today.

Running `--reverify` afterwards, from a shell whose `PATH` differs from the one the approval was
recorded under, refuses every gate with a message about the approval being bound to a different path,
and reports **UNMET** with zero checks actually run. That looks like the book has fallen over. It has
not. Nothing was tested.

The reliable invocation is `--approve` and `--reverify` **in the same call**, from a shell that has
the `quarto` binary's directory on `PATH`. Say it out loud before you run it, because both failure
modes are silent about what they did not do, and one full cycle was wasted reading a false
**ALL MET** and then a false **UNMET** as if they were measurements. This is the same lesson as the
gotcha above about `--status` versus `--reverify`, one level deeper: the checker will tell you a
verdict whether or not it did any work, so establish that it ran before you believe what it says.

### What is left

Two items, both the author's.

**Publish, then verify.** Run the recreate steps in order and stop at 4b. It must print
`HISTORY-CLEAN` before 4c is allowed to run. If it does not, something in the orphan commit's tree
still carries the pattern and no amount of pushing will fix it. After the push, run
`sh tools/verify-public.sh` and read its history line, not just its final verdict.

**Time the two hosted-notebook bootstrap cells.** This is item 2 of **Next Immediate Steps** above
and is unchanged, except that its point is worth restating: `docs/reader-environment.md` currently
carries a clean-depot proxy, and the book's own rule is that a number either ran or does not belong
on the page. Regenerate the notebooks with `sh tools/make-notebooks.sh` first, then time the cells,
then write the measured numbers in. Only then are the "hosted run verified" rows in
`docs/design/capability-status.md` allowed to move off `planned`.

---

## Closing Addendum: 2026-09-07

Written after the addendum above, closing out version 1. A final acceptance sweep read all fourteen
pages end to end; two of what it found were blockers. A verification pass then caught two regressions
the sweep's own fixes had introduced. Every page now links to every other. And the publication path
was hardened against five distinct ways it could have leaked the history it exists to hide. Read this
section last; it supersedes the open items and the recommendation table above wherever they disagree.

### 1. The final acceptance sweep

Fourteen agents read all fourteen rendered pages, each through one of four lenses: a reader who knows
regression but not this engine, leaked internal machinery, numbers that disagree with the output
printed beside them, and broken cross-references. Every finding those fourteen produced was then
handed to a second agent whose only job was to try to refute it. What survived that adversarial
reproduction was forty-two findings: two blockers, fifteen major, twenty-five minor. Thirty-eight were
fixed (`e616893`, "acceptance sweep: fix 38 confirmed defects across every chapter"). Four were
declined, each with a stated reason, and each reason held up under the same adversarial reading given
to the findings themselves.

### 2. The two blockers, both breaking the rule the book rests on

Both broke the same promise the whole book depends on: that a spoken number is the number the run
printed, not a number that merely looks close enough.

Class 9 said 57.0% where the run printed 57.1%, and said an AIC fell by 165.0 nine lines under a
table that showed 165.18. The cause was the same in both places: rounding a percentage to zero
decimal places in Julia still returns a decimal number, so the prose was quoting a value that had been
rounded and then read as if it were an integer without actually being one. The same idiom was found
and fixed in Classes 3 and 6. The fix is to round to an integer, not to zero decimal places; those are
not the same operation, and only one of them stops the number from silently disagreeing with itself a
few lines later.

Appendix A said a simulated column's spread "is sigma" when the column in question had a spread of
2.124 against a generating sigma of 1.881. The engine was not wrong. The appendix had picked one
column to make its point, and that column turned out to be the second most extreme of two hundred. The
fix does not touch the simulation: the appendix now shows the spread across all two hundred columns,
which demonstrates the same law of large numbers without depending on which single column a reader
happens to be shown.

### 3. A verification pass found that two of the sweep's own fixes caused regressions

This is the part worth remembering longer than the numbers above. Thirteen agents re-read every one of
the thirty-eight fixes on the rendered page, not the diff, and found that two of them broke something
the fix itself did not touch.

Class 1's fix moved two assignments into a cell the reader could see and run, so nothing the chapter's
arithmetic depends on stayed hidden above the fold. That is a good fix in isolation. Its side effect
was to change which statement in the cell came last, and a cell displays the value of its last
expression: a bare fifteen-digit float replaced the summary table the prose immediately goes on to
explain. A reader would have hit a wall of digits where a table used to be, with no visible connection
to the sentence right after it.

The rung-count fix changed two of the six places in the book that state how many rungs it has. A
reviewer had explicitly said, earlier in the day, that those six move together or not at all. This fix
moved two without the other four, so the preface and the coda said twelve while the landing page, the
climb diagram's page, the readme, and ten chapter footers all still said thirteen.

Both were repaired (`70e3573`, "repair two regressions the sweep's own fixes introduced"). The table
is back, with the two assignments still visible in the cell above it. The two files that had drifted
to twelve are back to thirteen, which is also what the climb diagram supports: it draws the coda as
the last box. Making the whole book say twelve remains open for version 1.1; it was not attempted here
because doing it properly means moving all six places at once, and this was a repair, not a redesign.

### 4. Navigation

Not one of the fourteen pages linked to any other. A reader who arrived at a single chapter from a
search result or a shared link had nowhere to go next; the site was fourteen dead ends dressed as a
book. Two pages also told the reader to go look at a diagram on the landing page without linking to
it.

The masthead title is now a link home, and every chapter ends with its neighbours named rather than
merely labelled: which chapter comes before, which comes after, in words a reader would use, not a
file name. This is generated in `tools/theme/masthead.lua` and styled in `tools/theme/stats-hours.css`
(`5788490`, "every page can now reach every other page"), so a chapter added later inherits it rather
than needing hand-written links that will eventually go stale.

### 5. The publication path is now safe, and it was not

A rehearsal of the publish sequence, followed by three people deliberately trying to break it, found
five separate ways it could have published the history it exists to keep private. Recorded here worst
first, because the worst one is the kind that does not announce itself.

The worst was silent. Every leak gate greps for a pattern held in a git-ignored, untracked file. An
unbalanced bracket in that pattern makes `git grep` exit 128, which the calling shell reads as no
match, and the fatal error that would have explained why was swallowed by a redirect. A leaking
history could report clean and nobody would see anything wrong, because nothing printed anything
wrong. All three scripts that grep for the pattern now prove the pattern actually compiles before they
trust any answer it gives them.

Second: after the repository rename step, the remote named `origin` silently resolved to the new
public repository while local `main` still held the full, unsquashed history. One ordinary `git push`
from that state would have republished every leaking commit to the public remote.

Third: the history gate's exit status was being dropped by the script that called it, so the public
repository was created even on a run where the check had failed.

Fourth: the push remote that points at the public repository outlived the run that created it, sitting
in a daily clone where the next unrelated push could have gone to the wrong place entirely.

Fifth: the verifier reported success on an empty repository. That is not a clean bill of health. That
is nothing having been checked, wearing the same green output as a real pass.

The fix to all five is one change of default: the script now runs as a dry run unless it is given an
explicit flag to publish, and the dry run cannot touch GitHub at all (`c5ced47`, "publication: make
the leak gates impossible to bypass"). `tools/recreate-public.sh` with no arguments prints what it
would do and stops. `tools/recreate-public.sh --publish` is the only way to do any of it.

### 6. One gap that cannot be closed

Say this plainly rather than let it hide behind a green checkmark. A commit reachable only by its SHA,
on the far side of a force-push or a deleted branch, is invisible to any check run from outside
GitHub. No local script, however careful, can see it, because it is not reachable from any ref the
script can walk. The verifier now says this every time it runs, in words, rather than implying a clean
bill of health it has no way to give. This is a limit of the method, not a bug waiting to be fixed
later.

### 7. A bug introduced while fixing all of the above, and caught before it shipped

The pass that strips authoring notes out of published pages was written to run over everything under
the published directory. That directory also holds hand-written development notes that were never
meant to be touched by a filter built for rendered HTML. It ran over one of those notes and, in doing
so, emptied a quotation inside a review document, a quotation that exists specifically to cite one of
those development comments as an example. The bug was caught before it was committed, and the
quotation was restored.

All three passes that touch published text now default to the site output directory and act on
`.html` files alone (`188f550`, "post-render: touch rendered pages only, never the notes beside
them"). Record this as its own lesson, separate from the finding itself: a text-level rewrite aimed at
generated output has to be scoped to generated output, by file type or by directory, not trusted to
stay in its lane just because that is what it was written for.

### 8. State at handover

Main is at `11446c4`, one commit ahead of `book/preview-machinery`'s tip and content-identical
otherwise. All twelve acceptance ledgers are green, with the checks actually re-run rather than read
off a previous approval, including the byte-identical double cold render required for each chapter. A
full visual pass found all fourteen pages clean at desktop, mobile and dark, using real device
emulation and measured contrast ratios rather than a glance at a screenshot.

What remains is the author's, in this order: run `tools/recreate-public.sh` with no arguments first,
which is a dry run; run it again with `--publish` once that dry run reports the gate open; then run
`tools/verify-public.sh` and read its history line, not just its final verdict. Time the two hosted
notebook bootstrap cells after publication, not before: the bootstrap fetches from the public raw
content URL and cannot work while the repository is private.

Two things to flag for whoever runs the gates next. The first is the same trap the addendum above
already named, and it recurred during this sweep, which is worth noting on its own: the checker's
`--approve` flag alone can report every gate met, reading previously recorded evidence, without
running a single check. A later `--reverify` run under a different shell `PATH` then refuses every
gate and reports everything unmet, with zero checks actually run. Neither output describes the state
of the book. `--approve` and `--reverify` have to be passed in the same call, from a shell that has the
`quarto` binary's directory on `PATH`, or neither number means anything.

The second is new. The gate that renders a chapter twice cold, to check that the render is
reproducible, moves the chapter's `_freeze/` cache aside before the first render and is supposed to
put it back after the second. On the last chapter gated in this sweep, it did not, and the cache had
to be restored from the commit rather than from the gate's own bookkeeping. Whoever reverifies that
ledger next should check `_freeze/` afterwards, the same caution the Gotchas section above already
gives for a manual `--reverify`, now confirmed against a real run rather than stated as a risk.
