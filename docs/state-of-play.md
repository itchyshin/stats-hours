# State of play

Written 2026-09-06, when the book moved into its own repository. Public-safe: this file says what
is decided and what is next, without naming anything private.

## Decided

**One engine.** `drmTMB` (R) and `DRM.jl` (Julia) teach every rung. Other packages appear only in
comparison boxes. The cost — a reader learns this engine, not the wider ecosystem — was weighed and
accepted.

**An introduction, ten chapters plus a coda.** Meta-analysis and phylogenetic comparative methods
are out; they belong together in a second book, because they are the same statistical problem in
different clothes.

**Quantitative genetics is chapter 10**, in version 1, placed *after* the REML/ML chapter. That
ordering is deliberate: heritability is a ratio of variance components, so a reader who has not met
the divisor argument can compute an h² and believe it.

**Never invent output.** See `writing-conventions.md`. This is the rule most likely to be quietly
broken under time pressure, and the one that would do most damage to a teaching text.

## The install question — corrected 2026-09-06

**An earlier version of this document said registry and CRAN publication were the critical path for
the whole delivery model. That was wrong, and the correction matters because it unblocks work.**

Neither engine is in a registry — DRM.jl is not in Julia General, drmTMB is not on CRAN. But **both
repositories are public**, and DRM.jl carries a proper UUID and version. So a clean machine can
install them today:

```julia
using Pkg; Pkg.add(url="https://github.com/itchyshin/DRM.jl")
```
```r
remotes::install_github("itchyshin/drmTMB")
```

Registry membership buys a **one-line install and discoverability**. It does not gate *runnability*.

**What the real cost is:** first-cell time in a hosted notebook. A Julia kernel install, a large
clone, precompilation — and on the R side, drmTMB compiles C++ through TMB, which is the slow half
by a wide margin. Minutes, not seconds.

**The lever that makes it viable now:** the book is Julia-first. R appears only in comparison boxes,
whose output can be **pre-rendered rather than executed**. Drop the live R side and the expensive
half of the setup disappears.

So a hosted, runnable book is available to try **now**, not after CRAN. Registration is still worth
doing — it is the difference between a one-line install and a paragraph of setup — but it is not a
gate, and no chapter should be deferred waiting for it except chapter 1, whose subject *is* the
install path.

## Known problems in the engine, already diagnosed

Three, all confirmed against source. Filed 2026-09-06 as DRM.jl #751, #752, #753. The first two are
fixed in DRM.jl PR #754, merged; every chapter is pinned to the merged commit (`tools/engine-pin.txt`)
and no passage is marked `NEEDS RUNNING`. The third stays open and blocks only chapter 7:

1. **A Gaussian fit prints `NaN` where a Wald statistic belongs**, in the scale block. The
   suppression is keyed on the block name before the statistic is computed — but the same standard
   error is already used to publish a confidence interval on that row, so the package computes the
   statistic and merely refuses to print it. It also suppresses genuine scale-side coefficients,
   where the test *is* meaningful.
2. **No R² and no residual SD on the natural scale.** Both are what an R user looks for first. The
   natural-scale value is already computed internally; printing it is a display change. R² should
   probably not be added at all — it is defensible in one narrow case and misleading elsewhere.
3. **Binomial rejects every random slope**, while seven other families accept them. The R twin fits
   the same model through a fully engineered, tested route — so this is a divergence between the
   twins, and chapter 7 cannot open on binary data in Julia until it is closed.

Found later, while writing chapters 3 and 4 (2026-09-06/07), and filed the same day:

4. **No `offset` in DRM.jl** (#727). drmTMB fits `y ~ x + offset(log(exposure))`; DRM.jl cannot, so
   chapter 4 teaches the exposure as a free `log(EggNo)` covariate and lets the R box show the offset.
5. **BetaBinomial crossed-Laplace soft gap against drmTMB near the boundary** (#733) — not hit by
   chapter 4's fixed-effects fit; noted so chapter 9 does not walk into it.
6. **The compact `show(io, fit)` labels every family "Gaussian location–scale"** (#758); the
   `text/plain` header is right. The chapters never use the compact form.

## Next

Updated 2026-09-07.

1. **Live on main, executed at build and reviewed:** the preface, classes 1–10, Appendix A and the coda — version 1 entire. The repository is still
   private; the six recreate-from-clean steps (`tools/recreate-public.sh` prints them) and
   `tools/verify-public.sh` are the author's, and so is timing the Colab bootstrap cells.
2. **Publication is blocked on history, not content:** the tip is scrubbed but most commits reachable from
   `main` carry a private path (`tools/scrub-history-check.sh main` says so), so the public repository is
   created from ONE squashed commit of `main`'s tree (`tools/recreate-public.sh`, steps 4a–4c) and
   `tools/verify-public.sh` now checks the public repo's reachable history. Both steps are the author's.
3. **Done:** the whole-book pass, Rose's close (`docs/dev-log/after-task/2026-09-07-version-1.md`), the
   handover (`docs/dev-log/handover/2026-09-07-version-1-handover.md`).
5. **Estimate to finish version 1:** about 30–40 lane-hours, measured at 1.5–2.5 hours per executed
   chapter including its adversarial review.
6. **Registration and CRAN** — worth doing, not a gate; only chapter 1's install section waits on it.
