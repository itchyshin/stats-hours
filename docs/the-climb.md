# The climb

Twelve rungs and a coda. **Version 1 is chapters 1–10 plus the coda**; 11 and 12 are held for a second
version. Each rung frees one thing the rung before it held fixed — that progression is the book,
not the topic list.

| # | rung | the constant it frees | v |
|---|---|---|---|
| 0 | Preface — why one engine, and what this book will not cover | — | 1 |
| 1 | Base camp — Julia, data frames, files, plots, and **reading Julia's error messages** | — | 1 |
| 2 | The one formula you are allowed — the linear model | *the constant is introduced, not yet freed* | 1 |
| 3 | The shape of the noise — GLMs, logistic and Poisson | the link and variance function, decreed by the family | 1 |
| 4 | When the family lies about the spread — overdispersion, `sigma ~ x` | variance as a fixed function of the mean | 1 |
| 5 | Is the model any good? — residuals, diagnostics, model comparison | *(a service chapter)* | 1 |
| 6 | Rows are not strangers — random intercepts, repeatability | the correlation between rows, set to zero | 1 |
| 7 | Not everyone shares a slope — random slopes | the slope, held constant across groups | 1 |
| 8 | Same model, two answers — REML vs ML, boundaries, optimiser defaults | **the default you never chose** | 1 |
| 9 | Both at once — GLMMs | shape *and* correlation, together | 1 |
| 10 | Not even the groups are strangers — relatedness, phylogeny, space, heritability | the assumption that random effects are independent *of each other* | 1 |
| 11 | Modelling the spread itself — location-scale | σ, pinned to one number | 2 |
| 12 | Two responses at once — bivariate, with a correlation that varies | the second response, set to absent | 2 |
| 13 | Where you go next — a coda, not a rung | *(the same constants reappear)* | 1 |

## The through-line

The villain is **everything an introductory book tells you to assume away**: independence, constant
variance, and one response at a time. Chapters 6, 7 and 10 dismantle independence; 4 and 11 dismantle
constant variance; 12 dismantles the last one.

## Chapter 8 is the spine, not a curiosity

Two correct implementations of one model can disagree, and the reader who cannot say why will
mistake a default for a fact. Chapter 10 then depends on it: heritability is a **ratio of variance
components**, so a reader who does not know the denominator is contested can compute an h² and
believe it.

## What is deliberately absent

**Meta-analysis and phylogenetic comparative methods.** Both are mentioned; neither gets a chapter.
They belong together in a second book, because they are the same statistical problem in different
clothes — non-independence from shared effect sizes, and non-independence from shared ancestry.

## Two threads that run through the rungs (decided 2026-09-06)

**Basic Julia is rung 1.** Base camp teaches the language a reader needs — data frames, files,
plots, and reading error messages — and only its *installation* section waits on the day the
engines are installable in one line. The rest of chapter 1 can be written any time.

**Simulation is a thread and an appendix, not a rung.** A rung frees a constant; simulation is a way
of thinking that every rung uses. From chapter 2 on, each chapter's "Julia stuff" ends with one cell,
*simulate what the model claims*: draw new data from the fitted model, refit, and watch the estimate
wander. **Appendix A — Simulation as a way of thinking** gathers it: seeds, generators, refitting,
coverage as a check on an interval, and the parametric bootstrap. Chapter 2's original sparrow
generator, retired when the real 2012 data arrived, lives on there as the first example.

Both engines can do this today: drmTMB has `simulate()`, and DRM.jl has `simulate(fit; nsim)`, with
`nsim` matching R's own keyword. Chapter 2 still draws from the fitted normal by hand once, because
seeing `rand(Normal(μ̂, σ̂))` is the lesson; from then on the thread uses `simulate`. One trap worth
teaching on the spot: simulated responses carry the mean structure, so subtract `fitted(fit)` before
comparing spreads, or the model will look as if it cannot reproduce its own σ.
