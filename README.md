# Stats Hours with Itchy

An open-access statistics book that teaches the whole climb — from the linear model to relatedness
and heritability — **in one engine**: [`drmTMB`](https://github.com/itchyshin/drmTMB) in R and
[`DRM.jl`](https://github.com/itchyshin/DRM.jl) in Julia.

It is a reboot of *Statistical Models with R: An Introduction with Sparrows* (2012, never
published), keeping its office-hours cast, its running organisms, and its habit of leaving the
mistakes in.

**Working title.** The name is deliberately undecided; `stats-hours` is a placeholder.

## Read the sample chapter

**[Class 2 — one line through a cloud of sparrows](https://itchyshin.github.io/stats-hours/)**

Every printed number and figure in it is produced by a cell that runs when the site is built — DRM.jl
0.7.1 (pinned to commit `4d9248f88`) on Julia 1.10.0; drmTMB 0.7.0 on R 4.6.0 in the comparison boxes, pre-rendered from a real run
and labelled. The data are the real 2012 Lundy house sparrows (`data/2012/`).

## Status — ten executed chapters of ten classes, plus the preface and coda

| | |
|---|---|
| Written, executed and reviewed | **10** — classes 1–9 and Appendix A, with the preface and coda (`book/*.qmd`); Class 10 (relatedness and heritability) is executed and in review |
| Version 1 | 10 chapters plus a coda |
| Planned in full | 13 rungs; 11 and 12 are held for version 2 |

See **[docs/the-climb.md](docs/the-climb.md)** for the full outline.

## Why one engine

Most statistics teaching changes packages as it climbs, so a reader relearns syntax at every rung
and never sees that the models are related. Here the verb never changes: `drm`, a formula bundle,
a family. Adding a random effect, modelling the variance, or handing the model a relatedness matrix
is *adding a term*, not switching tools.

The cost is real and stated rather than hidden: a reader who finishes knows this engine, not the
wider ecosystem. Other packages appear in **comparison boxes** — sparingly, and mostly where two
implementations of the same model *disagree*, which is where the interesting pages are.

## The blocker, stated up front

**Neither engine is installable from a registry yet.** DRM.jl is not in Julia General; drmTMB is not
on CRAN. Every package quoted in a comparison box installs in one line, and the engine this book
teaches does not.

That decides the order of work. The installation chapter is written **last**, and the reader
environment — the book should not require anyone to install anything locally — waits on the same
gate.

## Layout

```
index.qmd  the landing page
book/      the chapters, one Quarto file each; book/img/ the climb diagram
docs/      the climb, the writing conventions, the dev-log; docs/site/ is the rendered book
data/      the 2012 sparrow files (with provenance) and per-chapter working data
tools/     the Quarto theme and Lua filter, the Makie/ggplot2 house theme, the figure helpers
```

**Run a chapter on a hosted machine:** `notebooks/` holds one notebook per chapter with a clean-machine
bootstrap cell (engine from GitHub, no registry). The hosted path is **not yet tested** — see
`notebooks/README.md`.

Build the whole site with one command (Quarto 1.6, a `julia-1.10` Jupyter kernel, and the two engine
checkouts are needed; see `Project.toml`):

```
quarto render
```


## Licence

Text, figures and data: CC BY 4.0. Code: GPL-3. See `LICENSING.md`.
