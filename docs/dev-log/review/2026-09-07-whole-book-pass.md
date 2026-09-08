# Whole-book pass — 2026-09-07

Read-only review of *Stats Hours with Itchy* on `book/preview-machinery`. Scope: `index.qmd` and
all `book/*.qmd` except `book/wk10-relatedness.qmd` (mid-rewrite, explicitly excluded), the rendered
site at `docs/site/` (served at http://127.0.0.1:8934/), and the docs listed below. No file was
edited to produce this report except this one.

This pass ran while other agents in the same session were actively fixing issues in the repo.
Several defects an early check turned up were fixed mid-review by other lanes; where that happened
this report says so and reports the *current* state, verified fresh against the live files —
findings are not relayed from a subagent without a source check against the file as it stands now.

---

## 1. Cross-references

Checked every `Class N`, `Week N`, `rung N`, `Appendix A`, `Preface`, `Coda` mention in `index.qmd`
and the twelve in-scope `book/*.qmd` files against `docs/the-climb.md`'s rung table, and spot-checked
the specific claim attached to each against the target chapter's actual content.

**Defects found: 2 content-level, 1 style/terminology class (≈17 occurrences across 3 files).**

1. **Wrong chapter in a forward reference — `book/wk3-glms.qmd:264`.** The dialogue says: *"This is
   also exactly the point where **Class 6** will tell you that the chicks in one brood are not
   independent... **Class 6** stops pretending, on a file that can [carry a brood identifier]."*
   `book/wk6-random-intercepts.qmd` contains no brood or `BroodNo` content at all — it fits a
   random intercept on `BirdID` (repeated tarsus/wing measurements), a different grouping
   structure. The brood-identified survival analysis this promise describes is in
   `book/wk9-glmms.qmd`, which says so itself: *"A note on the data, and it is the note **Class 3**
   promised... **Class 6** then freed the correlation between rows on `data/2012/BodySize.csv`,
   where the repeated thing was a recapture. This chapter is what happens when the same population
   is handed over with the nest written down."* (`wk9-glmms.qmd:20–23`). Class 3's own forward
   reference names the wrong chapter — it should say Class 9, not Class 6.

2. **Promise not delivered as stated — `book/wk6-random-intercepts.qmd:274`.** *"When a predictor
   varies mostly within groups, the same neglect can make [its standard error] too large, and
   **Week 7** will show you one."* `wk7-random-slopes.qmd` does not deliver a confirming example:
   its worked covariate (mass) is *mostly between*-bird, and the standard error goes **down**, not
   up, when the grouping is added. wk7 is explicit about this (`wk7:205–211, 998`): *"the rule as
   Class 6 stated it is too simple, and this is the correction... a correction to Class 6."* This
   reads as a deliberate self-aware narrative device (the book catching its own earlier
   oversimplification) rather than an error, but the literal promise — a within-group predictor
   example with an inflated SE — is not the example delivered. Flagged for awareness, not as a hard
   defect.

3. **Terminology drift: "Week N" used instead of "Class N" in dialogue**, inconsistent with the
   cast/convention used everywhere else (index.qmd, all other chapters). Content at every site
   checked out correct — only the word is wrong:
   - `book/wk2-linear-models.qmd:71, 480` (2×)
   - `book/wk6-random-intercepts.qmd:189, 406, 502` (3×)
   - `book/wk8-reml-vs-ml.qmd:34, 49, 69, 192, 196, 248, 250, 252, 632, 743, 786` (12×, heaviest in
     this chapter)

**Verified correct** (sampled, not exhaustive): rung 11 forward references in `wk4-overdispersion.qmd`
(location-scale, held for v2 — matches the-climb.md); Appendix A's retired-generator promise
(the-climb.md says Chapter 2's original sparrow generator "lives on there" — confirmed present,
`appendix-a-simulation.qmd:48–108`, and appendix A covers both coverage and the parametric
bootstrap as promised); wk6's own rung-constant introduction ("the correlation between rows...
Not the link, not the variance function, not the slope" — matches the-climb.md's row 6 exactly);
Class 8/rung 8 forward and backward references sampled in wk2, wk5, wk6, wk9.

---

## 2. Counts and mastheads

**Defects found: 1 hard (reader-visible), 1 soft (stale relative to working tree, not a cross-doc
disagreement).**

All twelve in-scope chapters share one `status_note` boilerplate — *"One of ten executed chapters
(1, 2, 3, 4, 5, 6, 7, 8, 9 and Appendix A) of ten planned for version 1, plus a coda"* — and this
agrees with every `footer_note` ("...ten in v1, plus a coda...") and with index.qmd's own per-chapter
status badges. `deck` fields carry no chapter-count claims, so there is nothing to disagree there.

1. **`book/wk2-linear-models.qmd` contradicts itself on the rendered page.** Front matter: `status:
   sample-draft`, `status_tag: "Not the book"` — and the rendered page shows both "Sample draft" and
   "Not the book" badges (confirmed in `docs/site/book/wk2-linear-models.html`). But the same page
   also prints the shared `status_note` boilerplate verbatim: *"One of ten executed chapters (1, 2,
   3, ... and Appendix A)..."* — counting Class 2 among the ten *executed* chapters. A reader on the
   live page sees "Not the book" next to "one of ten executed chapters" in the same breath. This is
   the only chapter where the shared boilerplate wasn't adjusted for a non-standard status.

2. **Soft finding — Class 10's status description is internally consistent but stale against the
   working tree.** `index.qmd:32`, `README.md`'s status table, and `docs/state-of-play.md` all say,
   consistently, that Class 10 is "executed and in review" (not a cross-doc disagreement). But
   `book/wk10-relatedness.qmd` currently carries a 307-insertion/82-deletion uncommitted rewrite
   over its last committed version, and `tools/check-freeze.sh` reports it **STALE** right now
   (edited without re-running/re-freezing) — i.e. not currently in an executed, build-verified state.
   "Executed and in review" is accurate for the last *committed* state on the branch but overstates
   the current working-tree state, which this task's own framing calls "being rewritten."

---

## 3. Look at every page

13 pages × {desktop 1200px, mobile 375px, dark} inspected via headless-Chrome/Playwright screenshots,
read with the Read tool (≈430 slices; full method note preserved from the visual-pass subagent below).
Per the coordinator's update, findings 1–4 and 7 were fixed in the theme at `27193b2`/`5e7546e`
(measured in a live viewport) — **I re-verified this myself against the current
`tools/theme/stats-hours.css` and `book/wk3-glms.qmd` source**, not just the commit message:

- **#1 (dark-mode code contrast)** — fixed: `stats-hours.css:283–297` now defines dark-scheme token
  colours for every `pre code span.*` class (`.kw/.cf`, `.fu/.bu`, `.st/.ss/.vs`, `.dv/.fl/.cn/.bn`,
  `.co/.do/.an`, `.op/.ot/.sc`, `.er/.al`), both under `prefers-color-scheme:dark` and
  `[data-theme="dark"]`.
- **#2 (desktop measure clobbered, ~1150px lines)** — fixed: `.wrap{max-width:min(100%,
  var(--measure))}` (`stats-hours.css:39`) no longer loses to the later mobile-rule selector.
- **#3 (mobile tables clipped)** — fixed: `.wrap table{display:block; max-width:100%;
  overflow-x:auto}` (`stats-hours.css:279`).
- **#4 (mobile inline code clipped mid-token)** — fixed: `p code, li code, td code, th code,
  figcaption code{white-space:normal; overflow-wrap:anywhere}` (`stats-hours.css:280`).
- **#6 (wk3 uncaptioned Poisson worm plot)** — also fixed (not explicitly named in the coordinator's
  note, but confirmed by source and commit `5e7546e`): `wk3-glms.qmd:423–424` now carries `#| label:
  fig-diagnostic-poisson` and a full `#| fig-cap:`, making it Figure 5 like the chapter's other
  figures.
- **#7 (index climb-figure overflow)** — fixed: `figure, figure.quarto-float{margin-left:0;
  margin-right:0; max-width:100%}` (`stats-hours.css:276`).

**Open (not addressed): 1.**

- **#5 — Dark mode: figures are light-grey boxes on the dark page, site-wide.** Every Makie PNG
  figure has an opaque `#F2F4F4` background; on the dark scheme this reads as a bright box against
  the dark page. Seen in every chapter with a figure (wk1, wk2, wk3, wk5, wk6, wk7, wk9, Appendix A;
  confirmed visually in wk1/wk2/wk5/wk9, found by a bright-region scan in the rest, 2–12 figures per
  chapter). This is not a CSS bug the theme can silently absorb — it needs either a border/frame
  treatment or the Julia figures themselves rendered with a transparent background. No fix evident
  in the current CSS or in the recent commit history.

**Observations (not defects, worth knowing, unchanged from the visual-pass subagent):**
- Figure captions in wk1, wk3 (now fixed, see #6 above), wk6, wk8, wk9 are bare "Figure N" with no
  descriptive text, unlike wk2/wk4/wk5/wk7/Appendix A's real captions.
- Multi-panel figures (wk5's 3-panel, wk7's) shrink to ~327px on mobile; axis text there is close to
  illegible even though nothing overflows.
- Appendix A Figure 2's x-axis label is clipped inside the image itself ("bootstra…") — a Makie
  sizing issue, not a CSS one.
- Speaker/speech grid is correct everywhere checked: no speech ever renders in the narrow
  speaker-name column, at any width, on any page — the historical bug AGENTS.md warns about was not
  reproduced anywhere.
- Wide `pre` output blocks (up to ~6990px in wk7) scroll inside their own box at every width; nothing
  else was seen to widen the page.

Full per-page table and capture-method note (including two discarded false-positive capture
artefacts from headless Chrome's window clamping and Playwright's full-page stitching, and how they
were caught) are preserved in scratch at
this session’s scratchpad directory (outside the repo; not retained).

---

## 4. Machine checks

All commands re-run fresh at the end of this review (not relayed from the subagent's earlier pass,
which caught a real but since-fixed issue — see note below).

1. **`sh tools/scrub-check.sh`** → `SCRUB-OK`.
2. **`sh tools/check-freeze.sh`** → `STALE FREEZE: book/wk10-relatedness.qmd ...`, exit 1. Only wk10
   flagged, as expected.
3. **`grep -rn "NEEDS RUNNING\|PLACEHOLDER\|TODO\|FIXME" book/*.qmd index.qmd`** (excl. wk10) → no
   hits.
4. **`grep -rn "Random.seed!" book/*.qmd`** (excl. wk10), fresh: every remaining occurrence matches
   the exception — either prose stating the house rule ("Never `Random.seed!`, which sets a hidden
   global...", `wk1-base-camp.qmd:507`; `wk9-glmms.qmd:1044`), or Appendix A's deliberately-retired
   generator demo, explicitly framed in the surrounding prose as the inferior/retired pattern being
   examined (`appendix-a-simulation.qmd:62–120, 333–367`). **No live, unflagged `Random.seed!` use
   remains.** Note: the visual/machine-checks subagent's own run, earlier in this session, found
   seven live sites in `wk2`, `wk6`, `wk8` and `appendix-a-simulation.qmd` using `Random.seed!`
   ahead of a bare `simulate()` call with no `rng=`. Commit `d09b538` ("rng: chapters 2, 6, 8 and
   Appendix A pass an explicit MersenneTwister to every simulate and rand") — landed by another lane
   during this review — fixed exactly that; I re-ran the grep against the current files and confirm
   it is clean now.
5. **Every `simulate(` call carries `rng =`** (excl. wk10), fresh: confirmed. The only `simulate(`
   occurrences without `rng=` in the current files are prose/comments describing the function, not
   live calls (`wk2:628`, `wk6:665`, `wk7:703`, `wk8:548,758`, `wk9:1049,1064`,
   `appendix-a-simulation.qmd:343`) — same fix as above.
6. **Links in `docs/site/index.html`** → all 23 local targets resolve under `docs/site/`
   (`site_libs/*`, `tools/theme/stats-hours.css`, `book/img/the-climb.svg`, 12 chapter pages); 3
   external `github.com` links excluded as instructed.
7. **`docs/site/book/*_files/figure-html/*.svg` referenced, and every `<img src=` resolves** → all
   41 SVGs (10 chapter dirs, wk10 excluded) are referenced by their page; no orphans. All `<img src=`
   across the 13 in-scope pages resolve (wk0-preface and wk13-coda have no `<img>` tags at all — text
   only, expected).

**Open defects: 0.** (One real issue — #4/#5 above — was found and fixed mid-review by another lane;
reported here as found-and-fixed, not as open.)

---

## 5. Notebooks

`notebooks/` now holds all 13 chapter notebooks including wk10 (regenerated at commit `8e9fe02`,
"notebooks: regenerated for every chapter (thirteen)"). Checked fresh, mtimes compared directly
(not regenerated):

| chapter | qmd mtime | notebook mtime | verdict |
|---|---|---|---|
| wk0–wk2, wk4–wk9, appendix-a, wk13 (11 of 12) | ≤ 10:18:14 | 10:30:40 | notebook current |
| **wk3-glms** | **10:45:50** | **10:30:40** | **notebook older — stale** |

**Open defects: 1.** `book/wk3-glms.qmd` was edited after its notebook was last generated (the same
edit that added the Figure 5 caption, `5e7546e`, landed at 10:45, 15 minutes after the notebook
batch). `notebooks/wk3-glms.ipynb` needs a re-run of `tools/make-notebooks.sh` to pick up the
caption change. All other 11 in-scope chapters' notebooks are current.

---

## 6. Docs drift

Ground truth used: ten chapters executed (1–9 + Appendix A), chapter 10 mid-rewrite, repo private,
DRM.jl issues #727, #753, #758–#764 (checked live via `gh`).

- **Repo visibility**: `gh repo view itchyshin/stats-hours --json isPrivate` → `true`. Confirmed
  private.
- **DRM.jl issues** (`gh issue view --repo itchyshin/DRM.jl`): #727, #753, #758, #759, #760, #761,
  #762, #763, #764 — **all nine currently OPEN**.
- **README.md, docs/state-of-play.md, docs/design/capability-status.md** — per the coordinator's
  note these were refreshed at commit `28ab2d0` ("docs: README status, state of play and coverage
  table to the ten-chapter state; Class 10 in review; engine issues #758–#764"). **I checked the
  current file content directly rather than taking this on trust:**
  - `README.md:21` now reads *"## Status — ten executed chapters of ten classes, plus the preface
    and coda"*, with the table listing **10** — classes 1–9 and Appendix A. No longer stale.
  - `docs/state-of-play.md:84–87` now reads *"Live on main, executed at build and reviewed: the
    preface, classes 1–9, Appendix A and the coda"*, with only chapter 10 listed as "on the branch,
    executed and in review." No longer stale; chapters 7 and 9 (previously omitted) are now named.
  - `docs/design/capability-status.md` now has rows for Class 1, 7, 9, the preface and the coda
    (previously missing), the "Site" row says "ten chapters, the preface and the coda live" (was
    "five chapters"), and the engine-issues row lists "#727, #733, #753, #758–#764" (was missing
    759–764).
  - **These three files: 0 open defects**, confirmed against the live file content, not just the
    commit message.
- **docs/README.md, docs/reader-environment.md** — no contradictions of the ground truth found in
  either file.

**Open defects: 0.**

---

## Summary

| Section | Open defects | Notes |
|---|---|---|
| 1. Cross-references | 2 hard + 1 terminology class (~17 occurrences) | wk3→wk6 broken forward reference is the standout |
| 2. Counts and mastheads | 1 hard (reader-visible) + 1 soft | wk2 page self-contradiction is reader-visible |
| 3. Visual pass | 1 (dark-mode figure backgrounds) | 6 other findings (1–4, 6, 7) fixed mid-review, verified fresh |
| 4. Machine checks | 0 | 1 real issue (bare `Random.seed!` + `simulate()` without `rng=`) found and fixed mid-review |
| 5. Notebooks | 1 (wk3 notebook stale by ~15 min) | 8-of-12-missing gap from earlier in the session is now closed (13/13 exist) |
| 6. Docs drift | 0 | README/state-of-play/capability-status refreshed and verified current |

**Three most consequential findings:**

1. **`book/wk3-glms.qmd:264` sends the reader to the wrong chapter.** It promises that Class 6
   will show chick-in-a-brood non-independence and "stop pretending" with a brood-identified file —
   but Class 6 never touches broods; that content is in Class 9, which independently confirms this
   in its own opening note. A reader following the forward reference from Class 3 lands in the wrong
   chapter for the promised content.

2. **Dark mode: every figure in the book is a bright light-grey box on the dark page.** This is the
   one visual defect from the full 13-page × 3-setting pass that is still open — every other finding
   from that pass was fixed by another lane during this review, verified against current CSS/qmd
   source. It needs a design decision (transparent Makie backgrounds, or a frame/border treatment
   in the theme), not a CSS one-liner.

3. **The live Class 2 page contradicts itself.** It simultaneously shows "Sample draft" / "Not the
   book" badges and a status line claiming to be "one of ten executed chapters" — visible together on
   the rendered page, not just in front matter a reader never sees. Every other chapter's front
   matter was written or adjusted to fit its actual status; Class 2's status_note boilerplate was not.
