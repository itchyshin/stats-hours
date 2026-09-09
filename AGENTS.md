# Stats Hours with Itchy — contributor and agent contract

## What this repo is

The **manuscript** and the machinery that builds it.

## The architecture

**One engine teaches every rung.** `drmTMB` (R) and `DRM.jl` (Julia) carry the linear model, GLMs,
mixed models, GLMMs, structured random effects and heritability, and — in version 2 —
location-scale and bivariate models. GLM.jl, MixedModels.jl and lme4 appear **only in comparison
boxes**, never as the taught path.

This was decided with its costs on the table. Do not relitigate it; if evidence arrives that
changes it, bring the evidence.

**Scope: an introduction.** Meta-analysis and phylogenetic comparative methods are out — they get
their own book. They may be mentioned, never chaptered.

## The rule that matters most

**Never invent output.** See [docs/writing-conventions.md](docs/writing-conventions.md). A chapter
with plausible-looking invented numbers is a failed deliverable, not a draft.

## Look at what you built

Anything that **compiles, renders or is served** — the page, a figure, a rendered chapter — is not
verified until someone has looked at the **output**. Not the source. Not the exit code. Not the file
size. Not an HTTP 200.

This is written down because it was got wrong: the page was published twice with four speeches
rendering in the narrow speaker-name column, a CSS-grid bug that is obvious in one glance and
invisible in the markup. Every source-level check passed.

If a screenshot is genuinely unobtainable, measure the rendered DOM instead — and say you *measured*
rather than *saw*. Do not let "I checked it" stand in for "I looked at it".

**Looking is not enough either, and this cost the book more than the grid bug did.** A visual pass
later approved pages whose figures were painting an opaque band over the data they existed to be
compared against. It was checking layout, contrast and overflow — page furniture — and nobody was
asking whether the figure communicated. Separately, a chapter spoke of eight points below a
threshold beside a figure containing one, because a caption and the code computing its numbers had
drifted apart. Neither is visible without calibrating the axis from the figure's own gridlines and
recomputing the claim from the marker positions.

So two standing review lenses exist, both read-only, both in `.claude/agents/`:

- **`graphics-editor`** judges a figure as a graphic. Does the reader see the point without being
  told, and is the drawing honest about the size of the effect? It enforces two rules: never paint
  over the data, and never draw a difference the pixels cannot resolve.
- **`coherence-checker`** holds the text to the artifact. Every claim about an output — a count, a
  range, an extreme, an assertion that something is visible — is recomputed from the figure or the
  printed result, and checked everywhere the same claim is repeated.

Run the graphics editor when a figure is made, not after it ships. Run the coherence checker
whenever text changes, a figure changes, or the engine pin moves: those are the three ways the two
halves come apart.

## Before claiming a chapter is done

Run its code. A chapter that has not been executed since its last edit is a draft, whatever the
prose looks like.

## Environment

Julia 1.10 and R 4.6 with local checkouts of DRM.jl and drmTMB. Chapters are Quarto documents
(`book/*.qmd`) whose Julia cells execute at build; R appears only in comparison boxes, pre-rendered
from a real run and labelled as such. The site renders into `docs/site/` with `quarto render`
(never point `output-dir` at `docs/` itself: Quarto cleans its output directory first). The
acceptance ledger lives in `.unlazy/stats-hours/`.

<!-- uinit:project:start -->
This is **.**.
<!-- uinit:project:end -->

<!-- uinit:type-scope:start -->
This project's type could not be determined from repo structure alone; treat
as **mixed** until clarified.
<!-- uinit:type-scope:end -->

<!-- uinit:twin-boundary:start -->

<!-- uinit:twin-boundary:end -->

<!-- uinit:roster-routing:start -->
The team roster is assembled in a later phase of this bootstrap (see
`.uinit/roster.tsv` once generated) and rendered per-platform under `.claude/agents/`
and/or `.codex/agents/`.
<!-- uinit:roster-routing:end -->

<!-- uinit:guards:start -->
- Completion-claim discipline — see brain [[DECISIONS]] D-43 (≥2 NOT-DONE verdicts withhold the claim; a task isn't "done" on say-so).
- Smoke-first — see brain `protocols/after-task.md` (no fix/feature claim without running the smoke/verification check and showing its output).
- Own-the-verifier — see brain Principle 1 (the agent that built a thing does not get to be its only judge; run a fresh check or a named review lens before claiming green).
- Brain-write boundary — see brain [[DECISIONS]] D-37 (never write to the brain vault without explicit approval; stage a draft and propose).
- After-task discipline — see brain [[DECISIONS]] D-6 / `protocols/after-task.md` (every finished slice closes with a repo-visible after-task report, not just a chat summary).
<!-- uinit:guards:end -->

<!-- uinit:codex-doctrine:start -->

<!-- uinit:codex-doctrine:end -->
