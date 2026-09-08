# Preface and coda review — 2026-09-07

Reviewed at commit `d875741` (`book/wk0-preface.qmd`, `book/wk13-coda.qmd`,
`_freeze/book/wk0-preface/execute-results/html.json`) against the repository at HEAD. Read first:
`AGENTS.md`, `docs/writing-conventions.md`, `docs/the-climb.md`.

## Review

**1. Chapter claims vs. the chapters on disk.**

- **The two threads.** Confirmed. `book/wk1-base-camp.qmd` reads `data/2012/MBodySize.csv`, the same
  file Class 2 (`book/wk2-linear-models.qmd`) reads — matches the preface's "taught with the same
  data you model in Class 2." The simulation thread is present from Class 2 through Appendix A;
  Appendix A's own opening note confirms it keeps Class 2's retired generator "verbatim, as the
  appendix's first worked example of a seed," matching the preface.
- **The cast table.** Byte-identical between the preface and `docs/writing-conventions.md` (names,
  roles, organisms, row order). No discrepancy.
- **"Errors kept in."** `book/wk1-base-camp.qmd` has exactly four `#| error: true` cells, matching
  "Class 1 breaks things on purpose four times." The Barik et al. (2017) citation used to justify
  it is present in both the preface and the chapter's own Further Reading, worded consistently.
- **The rung list / what is held for v2.** Preface and coda agree with `docs/the-climb.md`: rungs 11
  (location-scale) and 12 (bivariate) are v2; the book stops at rung 10 in v1. Confirmed.
- **Coda on Class 4 (σ moved to repair).** Confirmed against `book/wk4-overdispersion.qmd`: the
  chapter fits `sigma ~ Sex` as the repair for a family that "lies about the spread," matching the
  coda's framing of Class 4 as *repair*, contrasted with rung 11's σ-as-estimand.
- **Coda on Class 10 (four faces of a known covariance).** Confirmed against
  `book/wk10-relatedness.qmd`, which has a dedicated closing section, "Four faces, one idea," with a
  table `animal`/`relmat`/`phylo`/`spatial` over one relatedness matrix — matches the preface's and
  coda's claim precisely, including the phrase "one known, positive-definite matrix."
- **Class 7 / #753 (coda).** `book/wk7-random-slopes.qmd` states almost verbatim what the coda
  claims: `Binomial()` accepts `(1 | g)` and refuses a random slope, "which is DRM.jl issue #753,"
  and that Class 7 does not open on binary data because of it. Confirmed.
- **Chapters 7, 9, 10 are still "in rewrite."** All three carry `status_note` text that lists
  themselves *out* of the executed set ("One of seven executed chapters (2, 3, 4, 5, 6, 8 and
  Appendix A)" — a list that omits the chapter carrying that very sentence). The preface's and
  coda's specific claims about Class 7 and Class 10 content are true against what is on disk today,
  but they rest on chapters not yet counted among the book's finished/landed chapters. See Findings.
- **"Eight executed chapters (1, 2, 3, 4, 5, 6, 8, Appendix A)."** Verified: all eight have matching
  `_freeze/book/<slug>/` directories and `status_note` text agreeing with the preface/coda. `index.qmd`
  lists the same eight, in the same order, as "Executed draft" / "Sample draft" (Class 2).

**2. Engine claims vs. the DRM.jl issue tracker (`gh issue view <n> -R itchyshin/DRM.jl`).**

- **#753** (Binomial rejects random slopes) — **OPEN**. Coda: "still blocks Class 7's binary
  opening." Confirmed true, and matches `book/wk7-random-slopes.qmd` verbatim.
- **#727** (no `offset` in DRM.jl) — **OPEN**. Coda: "a second gap ... DRM.jl has no offset ... (a
  second gap turned up in Class 4)." Confirmed true, and matches `book/wk4-overdispersion.qmd`.
- **#751** (Wald z/p print NaN) and **#752** (no natural-scale residual SD / R²) — both issues show
  **state: OPEN** on the tracker, but the fix for both is **PR #754, state: MERGED**
  (`mergedAt: 2026-09-06T22:03:07Z`), whose merge commit is `4d9248f88db86070cba7ed2ed0b59d051ce622c6`
  — exactly the commit in `tools/engine-pin.txt`. The PR's commit messages explicitly reference and
  resolve both #751 and #752. So the coda's claim ("two of the three ... are fixed and merged, and
  every chapter here is pinned to the commit that carries the fix") is substantively correct. See
  Findings for the open-issue-state nuance.
- **`docs/state-of-play.md`** agrees with the coda on all four numbers (#751, #752 fixed via merged
  PR #754; #753 open, blocks chapter 7 only; #727 open, chapter 4 workaround). Its "Known problems in
  the engine" section text is close to a paraphrase of the coda's own wording.

**3. The executed cell.**

The preface's `build-stamp` cell reads `pkgversion(DRM)`, `tools/engine-pin.txt`, and
`Dates.today()` — none of the three values is typed. The frozen output
(`_freeze/book/wk0-preface/execute-results/html.json`) shows `engine : DRM.jl 0.7.1`,
`pinned : 4d9248f88`, `built : 2026-09-07`; `tools/engine-pin.txt` at both `d875741` and HEAD is
`4d9248f88db86070cba7ed2ed0b59d051ce622c6` (first 9 chars match). The rendered page
(`docs/site/book/wk0-preface.html`, screenshotted live) shows the identical three lines. Confirmed:
frozen output, pin file and live render all agree, and all three quantities are inline
`{julia}` expressions in the surrounding prose, not typed numerals.

**4. Licences, hosted-notebook sentence, reboot-of-2012 sentence.**

- CC BY 4.0 for text/figures/data and GPL-3 for code match `LICENSE` and `LICENSE-CODE` respectively.
  `LICENSING.md` states the same split. **But see Finding 2** — one clause is not supported by the
  actual engines.
- The hosted-notebook sentence ("what has actually been measured ... is written down in
  `docs/reader-environment.md`, which also says which of those numbers is still a proxy") does not
  overpromise: `docs/reader-environment.md` is explicit that it reports a "clean-machine proxy," not a
  measurement on the hosted runtimes themselves, and its "Still unmeasured" section names exactly the
  Colab/Binder numbers that remain proxies. Confirmed accurate.
- `notebooks/wk2-linear-models.ipynb`'s first two cells match the reader-environment numbers cited
  (two-cell bootstrap, ≈3 min to first fit, plotting stack the slow remainder) — consistent.
- The reboot-of-2012 sentence matches `index.qmd` almost word for word ("a reboot of *Statistical
  Models with R: An Introduction with Sparrows*, written in 2012 and never published" /
  "*Statistical Models with R: An Introduction with Sparrows* (2012, never published)"). **But see
  Finding 1** — this date conflicts with `data/2012/README.md`, the file the preface itself cites for
  provenance of the same manuscript's data.

**5. The seven citations (OpenAlex).**

All seven checked by DOI against OpenAlex; title, authors, journal, volume and pages match the text
exactly in every case:

1. Bezanson et al. 2017, *SIAM Review* 59(1):65–98 — match.
2. Bolker et al. 2009, *Trends in Ecology & Evolution* 24(3):127–135 — match (7 authors, all named
   correctly and in order).
3. Chandler & Sweller 1991, *Cognition and Instruction* 8(4):293–332 — match. The OpenAlex abstract
   confirms the claim attributed to it: instruction that forces a reader to mentally integrate
   "disparate sources of mutually referring information" (split attention) costs comprehension, and
   integrated presentation was favoured across the reported experiments. The preface's phrasing
   ("splitting material a reader must mentally integrate ... costs comprehension") is scoped to the
   same condition the paper tested (material that must be integrated) and does not overreach into the
   paper's Experiment 2 caveat (where integration made no difference because the material did not
   need it). Accurate.
4. Peng 2011, *Science* 334(6060):1226–1227 — match, and it is in fact a two-page article, matching
   "Two pages" in the preface's annotation.
5. Rigby & Stasinopoulos 2005, *JRSS-C* 54(3):507–554 — match.
6. Hadfield 2010, *Journal of Statistical Software* 33(2) — match.
7. Hadfield & Nakagawa 2010, *Journal of Evolutionary Biology* 23(3):494–508 — match, and the second
   author is Shinichi Nakagawa, i.e. this book's own author — worth the author double-checking the
   self-citation reads as intended, though nothing here makes it inaccurate.

**6. Writing-conventions item 1 (bare numerals in dialogue) and `Random.seed!`.**

No bare numerals in any `**Character:**` dialogue line in either the preface or the coda (checked by
grep over every dialogue line). No `Random.seed!` anywhere in either file — neither runs a simulation
(the coda runs no code at all, confirmed: no `{julia}` markers, matching its own provenance line "This
page runs no code and prints no numbers").

**7. Rendered pages.**

Screenshotted `http://127.0.0.1:8934/book/wk0-preface.html` and `/book/wk13-coda.html` (the server
on 8934 was already up) via headless Chrome.

- Masthead kicker reads **"PREFACE"** and **"CODA"** respectively (breadcrumb: "STATS HOURS WITH
  ITCHY / PREFACE / DRAFT" and "... / CODA / DRAFT"), matching the `kicker:` frontmatter field in
  each file.
- The cast table on the preface page renders as a proper three-column house-styled table (Itchy /
  Toto / Momo / Eddie / Jaro rows), not collapsed or overflowing into a narrow column.
- The preface's build-stamp code cell and its output block render correctly, matching the frozen
  JSON and the pin file (see item 3).
- The coda's closing scene (stage direction, then Momo/Itchy/Toto/Eddie/Jaro dialogue) renders in the
  house dialogue layout: stage direction in a distinct grey box, each speaker's name as a small-caps
  label above their line. No CSS-grid collapse of the kind flagged in `AGENTS.md`'s "look at what you
  built" warning was observed on either page.

## Findings

**Required**

- **Reboot date conflicts with the provenance file the preface itself cites.** The preface says the
  original manuscript was "written in 2012 and never published"; `index.qmd` repeats "(2012, never
  published)." But `data/2012/README.md` — which the preface names as the provenance source for the
  same manuscript's data ("the provenance ... is in `data/2012/README.md`") — states the recovered
  files are "dated November 2009 – March 2010, **the drafting period** of *Statistical Models with R:
  An Introduction with Sparrows*." That is a roughly two-year discrepancy between the preface's own
  claim and the document it points readers to for that claim's evidence. One of the two dates is
  wrong; fix whichever it is (and check `data/2012/README.md`'s own header, "2012 sparrow data,"
  for the same inconsistency — the directory and file naming assume 2012 throughout).

- **Licence sentence overclaims for DRM.jl.** The preface says the book's code "is GPL-3, matching
  the engines it drives" (unqualified, no per-engine caveat in the preface text itself — the caveat
  only appears in `LICENSING.md`'s parenthetical "(drmTMB is GPL-3)"). `drmTMB` is indeed GPL-3.0 (`gh
  api repos/itchyshin/drmTMB --jq '.license.spdx_id'` → `GPL-3.0`), but **`DRM.jl` is MIT**
  (`GPL-3.0` vs `MIT` respectively). "Matching the engines it drives" (plural) is therefore not true
  of both engines. Not a legal problem (MIT is GPL-compatible), but a factual overclaim in the
  preface's own sentence — either drop "the engines it drives" or qualify it as `LICENSING.md`
  already does.

**Suggestion**

- **#751 and #752 remain in the OPEN state on the DRM.jl tracker** despite being fixed by merged PR
  #754 (verified: PR state MERGED, merge commit = the pin commit, commit messages reference both
  issue numbers). The coda's claim ("fixed and merged") is accurate about the code, but the coda also
  tells the reader to consult the issues directly for current state ("a reader wanting their current
  state should read the issues, not this page") — and the issues themselves do not reflect the fix.
  Worth closing #751/#752 on the tracker (or linking them from PR #754) so the coda's own advice to
  "read the issues" doesn't mislead a reader who does exactly that.

- **`docs/state-of-play.md`'s "Next" section is stale relative to HEAD.** It still lists chapters 1,
  4 and 5 as not-yet-landed ("Then chapter 1 ...", ch4 "blocked" in re-review, ch5 "being drafted"),
  but all three exist at HEAD with matching freeze results, landed in commit `9ee77f9` ("eight
  executed chapters: classes 1, 4 and 5 linked from the index"). This does not make the preface/coda
  wrong — if anything the preface/coda's "eight executed chapters" claim is *more* current than
  `state-of-play.md` — but the task asked whether state-of-play.md agrees, and on this point (chapter
  count/progress, as distinct from the engine-issue section, which does agree) it does not.

- **Preface's and coda's Class 7 / Class 10 claims lean on chapters still "in rewrite."** Both
  chapters' own `status_note` frontmatter excludes them from the executed set, and the task brief
  independently flags them as in rewrite. The specific claims quoted from them (the #753 binary gap
  in Class 7; the "four faces" table in Class 10) are true against the current file content, but nothing
  pins that content the way `writing-conventions.md`'s "three homes" rule pins a correction — if either
  chapter is rewritten before landing, the preface or coda could go stale silently. Worth a
  cross-reference check when 7, 9 and 10 land, mirroring the grep-for-old-wording step the writing
  conventions already require after any correction.

## Verdict

**REQUIRED** — two factual overclaims need fixing (the 2012/2009–2010 date conflict, and the
"matching the engines it drives" licence claim), but nothing here rises to a **blocking** defect: no
invented output was found, both executed pages render correctly in the house layout, the "eight
executed chapters" claim is accurate, and every engine claim checked against the DRM.jl issue tracker
and `docs/state-of-play.md` is substantively true. Fix the two required items before the preface and
coda are called done; the three suggestions are repo-hygiene items, not preface/coda defects.

## Confirmation (HEAD, 2026-09-07)

Checked against `book/wk0-preface.qmd`, `book/wk13-coda.qmd`, `index.qmd`, `LICENSING.md` and
`data/2012/README.md` as they are on disk now (not the reviewed commit `d875741`).

**Required item 1 — the 2012/2009–2010 date conflict.** Closed. The preface no longer says "written
in 2012"; it now reads "It is a reboot of *Statistical Models with R: An Introduction with Sparrows*,
drafted in 2009–2010 (the recovered files are dated November 2009 to March 2010; see
`data/2012/README.md`) and never published" (line 30). `data/2012/README.md` itself states "files
dated November 2009 – March 2010, the drafting period of *Statistical Models with R: An Introduction
with Sparrows*" — the preface's date and its cited source now agree to the month. `index.qmd` agrees:
"*Statistical Models with R: An Introduction with Sparrows* (drafted 2009–2010, never published)"
(line 10). No remaining "2012" date claim about the manuscript's drafting was found in either file
(the directory name `data/2012/` and the README's own "2012 sparrow data" header remain as the
original review flagged them, as a naming artefact rather than a drafting-date claim — the review did
not require renaming the directory, only fixing the date claim, which is done).

**Required item 2 — "matching the engines it drives" licence overclaim.** Closed. The preface's
licence sentence now reads: "the code — the build tooling, the code cells, the templates — is GPL-3,
like `drmTMB`; `DRM.jl` itself is MIT-licensed, so the one-engine rule does not put the two engines
under one licence, and the book's code follows the R twin" (lines 175–177) — no longer claims to match
"the engines it drives" (plural, unqualified). The `LICENSING.md` pointer is present in the same
sentence: "The details are in `LICENSING.md`." Reading `LICENSING.md` directly confirms the CC BY 4.0
/ GPL-3 split and the same `drmTMB`-only qualification the preface now carries.

**The executed cell's three values vs. `tools/engine-pin.txt`.** Confirmed still matching.
`tools/engine-pin.txt` on disk is `4d9248f88db86070cba7ed2ed0b59d051ce622c6`. The frozen output
(`_freeze/book/wk0-preface/execute-results/html.json`, last touched by commit `fc222ce`, the same
commit that landed the two required fixes) prints `engine : DRM.jl 0.7.1`, `pinned : 4d9248f88`,
`built : 2026-09-07` — the pin's first 9 characters match, and both are inline `{julia}` expressions
in the surrounding prose, not typed numerals. (One uncommitted, out-of-scope change is present on
disk: a one-line `status_note` frontmatter edit to the chapter-count wording, unrelated to either
required fix and outside this confirmation's scope.)

**The coda's engine-issue claims vs. the tracker today.** Checked live with
`gh issue view <n> -R itchyshin/DRM.jl`:

- **#727** — state **OPEN**. Matches the coda: "`DRM.jl` has no `offset`... (#727)" and "One is still
  open... A second gap turned up in Class 4" (an open issue, correctly described as open).
- **#753** — state **OPEN**. Matches the coda: "the Julia engine refuses a random slope on a binomial
  fit that its R twin fits without complaint (`DRM.jl` #753), which is why Class 7 does not open on
  binary data."
- **#751** and **#752** — both state **OPEN**, each carrying a comment "Fixed by #754 (merged; commit
  4d9248f is what *Stats Hours with Itchy* pins). Suggest closing." This is exactly the nuance the
  original review flagged as a suggestion, not a defect: the coda's claim ("Two of the three problems
  diagnosed... are fixed and merged, and every chapter here is pinned to the commit that carries the
  fix") is substantively true of the code and the pin, while the issues themselves remain open on the
  tracker pending that "suggest closing." Nothing to fix in the coda text; the suggestion (close
  #751/#752, or link them from #754) remains open on the tracker, as the original review anticipated.

**Item 6 (bare numerals, `Random.seed!`) — unaffected by either fix, re-checked.** No bare numerals in
any `**Character:**` dialogue line in either file; no `Random.seed!` in either file (the coda runs no
code).

**Verdict: CONFIRMED — both required items closed; the preface and coda are done.**
