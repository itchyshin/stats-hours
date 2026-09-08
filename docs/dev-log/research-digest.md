# Research digest — what the book stands on

Filed 2026-09-06 from the research that preceded this repository, so it lives in git rather than in
chat. Public-safe: findings and pointers only.

## Why the book has an angle (market survey, 45 sources, 2026-08-28)

Fifteen works teach Julia to statisticians or R users; the shelf is crowded at the bottom and empty at
exactly this book's altitude. Closest: Nazarathy & Klok *Statistics with Julia* (stops at linear
regression); Kaminski *Julia for Data Analysis*; Storopoli et al. *Julia Data Science*; Heiss & Brunner
*Using Julia for Introductory Econometrics* (defers theory to Wooldridge); Rennie's *Introduction to
Julia for R Users* (blog-scale, the only R bridge).

**Five cited absences — the book's actual pitch, each falsifiable:**

1. Frequentist GLMMs with offsets and dispersion. MixedModels.jl warns against dispersion models and
   sends users to Bayes or back to `glmer`. This is what drmTMB / DRM.jl exist to solve.
2. The REML-vs-ML default discrepancy: MixedModels.jl defaults to ML, lme4 to REML; variance components
   differ on small data; no introduction warns the R user. **Chapter 8.**
3. Error-message literacy — nobody teaches reading Julia stack traces and method errors. Cheapest
   chapter, probably the most read; it is what makes R users bounce off Julia.
4. Publication-ready reporting as a day-one topic — "advanced" in Julia, chapter one in R.
5. Self-contained statistical theory taught with the language, not deferred to another book.

The one crowded claim to avoid: another DataFrames.jl tutorial. Position: *"Julia for the working
statistician coming from R"*, never "Julia for data science".

## Format (13 sources)

Left-page-Julia / right-page-R was asked for and rejected on evidence: parallel-text practice and
split-attention research say physically separating two things a reader must integrate hurts
comprehension, and languages differ 2.2–2.9× in length, so fixed page-pairs break on every revision.
The precedent for twin books is *Deep Learning with Python* → *with R*: one spine, two idiomatic
volumes. For a web companion, **tabbed code blocks** solve it at zero split-attention cost.

## Comparison boxes (14 hand-verified sources)

"Our parity suite teaches the method/implementation boundary" has no precedent and is unproven. What
is citable is the **disagreement**: Bolker et al. (2009) carries the optimiser/default taxonomy, and
lme4 ships `allFit()`, which treats cross-implementation disagreement as a diagnostic. Counter-evidence
is real: instructors report multi-tool teaching eats class time; the remedy is "translate one example,
do not dual-code every chapter". Hence `writing-conventions.md`: boxes are rare and earned.

## The engines — diagnosed, not yet fixed (DRM.jl 0.7.0 / drmTMB 0.7.0)

- **A. `NaN` where a Wald statistic belongs**, scale block. `src/summary.jl:73-77` returns `(NaN, NaN)`
  keyed on the block symbol before the statistic is computed, so it also blanks genuine scale-side
  coefficients. `summary.jl:258` already publishes a confidence interval from the same standard error.
  Fix: conditional suppression; print an em-dash where a statistic is deliberately withheld;
  `test_summary_zp_suppress.jl:25-26` must flip (visible behaviour change; NEWS entry).
- **B. No natural-scale residual SD, no R².** `fit.scales[:sigma]` is already computed (read at
  `summary.jl:134`); printing it is display-only and **must be gated to Gaussian** (a shape for Gamma,
  a dispersion for NB2). Add no R² — defensible only for Gaussian identity-link with an intercept and
  constant σ. `dof_residual()` exists, is exported, and is never printed.
- **C. `Binomial()` rejects every random slope**; seven other families accept them; drmTMB fits
  `cbind(success, failure) ~ x + (1 + x | id)`. Unresolved whether deliberate or unimplemented. A book
  question first: with plain 0/1 data the slope SD may be weakly identified — needs a recovery sweep
  before a chapter depends on it. Blocks chapter 7 only.
- Two divergences to state correctly: drmTMB prints no z or p column at all, so the `NaN` is DRM.jl-only
  and must never be presented as "the two engines"; and drmTMB's R bridge to DRM.jl already prints a
  response-scale σ that native Julia does not.
- **Not symmetric on chapter 8's beats:** the chi-bar-squared boundary correction (`src/chibar.jl`) and
  the selective REML comparison guard (`src/comparison.jl`) exist only in DRM.jl; drmTMB's `anova`
  refuses every comparison. Teach both in Julia; say the R twin lacks them (absence, not disagreement);
  cite Self & Liang 1987, Stram & Lee 1994, Bolker et al. 2009 directly.

## Chapter 10 is writable today

`animal(1|id)`, `relmat(1|id)`, `phylo(1|species)`, `spatial(1|site)` are all marked Tested in
`src/gaussian_structured.jl`; `docs/src/tutorials/animal-models.md` derives h². The Gaussian animal
model is closed-form (PGLS / matrix-determinant lemma), so examples stay fast in a hosted notebook.
Four faces of one idea — a random effect whose levels carry a known covariance — hence one chapter.

## An arithmetic trap, already met once

Chapter 2's R² gap (0.397 vs 0.392) is a **mixed divisor** — the raw SD from `describe()` divides by
n − 1, the engine's residual SD by n; the ratio is n/(n − 1) = 1.0087, not √(n/(n − p)) = 1.0132.
Fixed in the chapter and turned into a beat. Check every similar ratio before it ships.

## Reader environment

Both engine repositories are public. A clean hosted machine installs them from a URL today; a registry
buys a one-line install and discoverability, not runnability. The cost that matters is first-cell
time; R appears only in comparison boxes, so its output can be pre-rendered and only the Julia
bootstrap sits on the reader's path.

## Parked, deliberately

A second book pairing phylogenetic comparative methods with meta-analysis (the same statistical problem
in different clothes); a web-based learning game; the animation series, whose first question is
funding. None starts until book one ships.
