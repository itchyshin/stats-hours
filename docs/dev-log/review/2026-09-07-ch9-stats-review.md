# Chapter 9 — adversarial statistical review (as executed)

## Review (dea185e)

Read from the commit — the chapter source, the frozen execute-results, all four rendered SVGs (as
images, at 2×), and `data/ch9/ch9-r-box.R` — with the whole chapter re-derived twice: once in R
without DRM.jl (my own non-adaptive Gauss–Hermite marginal likelihood at K = 20/32/64, Newton on the
per-brood penalised and unpenalised scores, an independent `glmer` sweep at eleven `nAGQ` values, my
own randomised-quantile-residual construction and worm-plot machinery), and once against DRM.jl 0.7.1
itself for the things only the engine can answer.

**Every executed number reproduces exactly.** The filter (1600 of 1950 rows, 484 broods, 696
survivors, 0.4350); the brood-size table (35/86/133/159/68/3, mean 3.3058) and the unanimity counts
(179 / 91 / 214); the fixed-effects fit (−2.7570, 0.6798, SE 0.1934, 0.0504, logLik −986.8062,
AIC 1977.61); the GLMM (−3.9485, 0.9399, SE 0.3327, 0.0812, log σ_b 0.6210 SE 0.0874,
logLik −903.2167, AIC 1812.43) and the derived ratios 1.7196 / 1.6128 / 1.3827 / −165.18; σ_b 1.8609,
V_brood 3.462768, ICC 0.5128; χ² 167.18 with its exactly-halved boundary p; both odds ratios;
the marginal slope 0.6072 with MC SE 0.0056 (at 1000 replicates: 0.6073, SD 0.0574); 4 years,
126 mothers, 0 broods spanning two years; the posterior-mode range −3.219 to 3.049 and the BLUP check
at 4.441e−16 (my own: max |ranef − closed form| = 4.4409e−16 against max |ranef| = 2.8541); 214 / 270;
both residual SDs at seed 909; and the recovery triple 1.8681 / 0.45 / 0.920. My own 32-node
non-adaptive Gauss–Hermite fit, written from scratch in R, reproduces the engine to seven digits
(−3.948529, 0.939932, log σ_b 0.621034, SE 0.332655 / 0.081246 / 0.087392, logLik −903.216718). My own
`glmer` sweep reproduces all three R blocks to every digit they print. All seven citations are exact
on OpenAlex — authors in order, titles, years, journals, volumes, pages, DOIs. Item 1 passes: 30
inline `{julia}` expressions, and the bare numerals in dialogue are Class pointers, "9:00 am",
equation symbols, citation years and list numbers.

The arithmetic is immaculate and the chapter's two hardest ideas — that `fitted` at u = 0 is not the
average over u, and that a unanimous brood has no finite own-evidence estimate — are both right, and
both proved rather than asserted. What is wrong is the engine the box describes, the null three
verdicts are measured against, the cause the year fit is given, and an exercise that cannot run.

## Verdict

**Block** — five failures. The comparison box names an approximation the engine does not use and its
own source forbids the label; the box's "higher log-likelihood means closer to the integral" rule is
refuted by the third R block printed beside it; the `Inf` standard errors are a two-grouping engine
defect, not a four-level variance component, and the chapter's own printed log-likelihood proves the
fit is not at a maximum; Exercise 6 asks for four standard errors that come back `Inf` on the file it
names, on a grouping that is not nested the way the question assumes; and the residual "trap" is
measured against a null the fitted model never had, so the excess it dramatises is what a correct
model produces.

## Findings

1. **blocking** — **the box names an approximation the engine does not use, and the engine's own
source forbids the label.** DRM.jl 0.7.1 integrates a binomial random intercept with **non-adaptive
32-node Gauss–Hermite quadrature**: `src/binomial.jl:148` — *"integrated out per group by 32-node
Gauss–Hermite quadrature"* — and line 158, `z, w = _gauss_hermite(32)`. `src/aghq_1d.jl:10` says it in
terms: **"Do not relabel the production `(1|g)` GHQ-32 `:LA` path as AGHQ."** `marginal = :AGHQ` is
explicitly *rejected* for this family (`binomial.jl:60`). The box teaches Laplace versus **adaptive**
Gauss–Hermite, and puts DRM.jl on the adaptive side: *"Push the quadrature up and the number moves, in
one direction, and settles — on ours"*, and the summary, *"`glmer` and `drmTMB` default to Laplace,
**DRM.jl to quadrature**"*. I confirmed the engine's rule by writing it myself: a from-scratch
non-adaptive 32-node GH likelihood in R reproduces DRM.jl to seven digits on every parameter, every
standard error and the log-likelihood, while 64 nodes and `glmer`'s adaptive rule both converge
elsewhere (σ_b 1.8609128, logLik −903.216513, SE(intercept) 0.332630). These are **two different
approximations that happen to agree to about four significant figures here**, not one integral
computed twice.

   The chapter's own reference 6 convicts it. Pinheiro and Bates' abstract compares four
   approximations and separates exactly these two: *"Gaussian quadrature centered at the conditional
   modes of the random effects"* — adaptive, `glmer`'s — is one of the three it calls "quite accurate
   and computationally efficient", while *"Gaussian quadrature centered at the expected value of the
   random effects"* — non-adaptive, DRM.jl's — is the one it singles out as *"quite inaccurate for a
   smaller number of abscissas and computationally inefficient for a larger number of abscissas"*. So
   the chapter cites the paper that classifies its own engine's method as the one to avoid, and then
   gives that method the other method's name. The closing moral of the section is **"Name the
   approximation with the number"**, and the one approximation the chapter never names is its own.
   The honest version is better teaching: *three* rules on one page — Laplace, non-adaptive GHQ-32,
   adaptive GHQ — agreeing to four figures on a well-behaved fit and to nothing like that at
   `nAGQ = 1`.

2. **blocking** — **"higher log-likelihood means one approximation is closer to the integral" is
refuted by the third R block on the same page.** Itchy: *"Compare the two log-likelihoods before you
decide the difference is cosmetic: one of them is higher, and higher on the same data with the same
parameters means one approximation is simply closer to the integral than the other."* The box prints
`nAGQ = 9` at logLik **−903.2083452** and `nAGQ = 25` at **−903.2165109**. Nine is *higher* than
twenty-five, and the chapter's narrative says twenty-five is the converged one. Quadrature error is
not signed and AGQ does not bound the integral from below. My independent sweep:

   | nAGQ | 1 | 3 | 5 | 7 | **9** | 15 | 21 | **25** | 31 | 41 | 51 |
   |---|---|---|---|---|---|---|---|---|---|---|---|
   | logLik | −912.3730 | −906.0051 | −903.6221 | −903.2347 | **−903.2083** | −903.2167 | −903.2165 | **−903.2165** | −903.2165 | −903.2165 | −903.2165 |
   | brood SD | 1.70001 | 1.75600 | 1.83559 | 1.85889 | **1.86166** | 1.86089 | 1.86092 | **1.86091** | 1.86091 | 1.86091 | 1.86091 |

   It overshoots at 9 and comes back. The same table refutes *"Push the quadrature up and the number
   moves, **in one direction**, and settles"*: the printed 9 → 25 step alone moves the brood SD down.
   Exercise 10's closing clause — *"how you would know which of the two numbers to believe if the
   log-likelihoods had been identical"* — is built on the same false rule and inherits the defect.
   The rule the chapter wants is available and true: run the quadrature up until the number stops
   moving, and report where it stopped.

3. **blocking** — **the `Inf` standard errors are a two-grouping engine defect, and the chapter's own
printed log-likelihood says the fit is not at a maximum.** Itchy: *"That is a singular information
matrix wearing its plainest clothes, and it is **what a four-level variance component looks like from
the inside**."* Two runs on the same engine and the same file say otherwise:

   | fit | logLik | standard errors |
   |---|---|---|
   | `Survival ~ Mass2 + (1\|BroodNo)` | −903.2167 | 0.3327, 0.0812, 0.0874 — all finite |
   | `Survival ~ Mass2 + (1\|YearF)` — **the four-level grouping alone** | −967.8680 | 0.2158, 0.0518, 0.2720 — **all finite** |
   | `Survival ~ Mass2 + (1\|Mum)` — 126 levels, alone | −974.2398 | 0.2221, 0.0555, 0.1763 — all finite |
   | `... + (1\|BroodNo) + (1\|YearF)` — the chapter's | **−904.9719** | `Inf` × 4 |
   | `... + (1\|BroodNo) + (1\|Mum)` — **126 levels** | **−908.5090** | `Inf` × 4 |
   | `Mass2 ~ 1 + (1\|BroodNo) + (1\|Mum)`, **Gaussian** | −2411.4486 | all finite |

   A four-level variance component on its own returns three finite standard errors; a 126-level second
   grouping returns four infinite ones. The failure tracks the *number of grouping terms* on the
   binomial path, not the number of levels, and the Gaussian path with two groupings is fine.

   The corroboration is printed in the chapter and unread. `yr_fit`'s log-likelihood is **−904.9719**,
   *below* the nested `glmm_fit`'s **−903.2167**. A maximised likelihood cannot fall when a parameter
   is added. The fit is not at an optimum, so its information matrix is meaningless before any
   question of estimability arises — and that one line is far stronger evidence for the chapter's own
   thesis (*"Convergence is not evidence. Read the standard errors."*) than the `Inf` column is,
   because it convicts `converged = true` on arithmetic the reader can check.

   The chapter gets this exactly right three sections later, about `ranef()`: *"**This is a limitation
   of the version of the engine this page was built with, not a fact about GLMMs.**"* The same
   sentence is owed to the year fit. The statistical point — that four levels cannot support an
   estimated distribution, and Bolker et al.'s floor — is correct and should stay; what is not
   available is the demonstration, because on this engine the four-level fit succeeds.

4. **blocking** — **Exercise 6 cannot run on the file it names, and its premise about that file is
wrong.** Itchy, promising it: *"if you want a second random grouping in this file there is one with
`{julia} n_mums` levels sitting in the `Mum` column, which is comfortably above anybody's floor, and it
is question six."* Question 6: *"Fit `Survival ~ Mass2 + (1|BroodNo) + (1|Mum)` on it. Report both
variance components and **both standard errors**."* On `data/2012/SparrowSurvival.csv`, that fit
returns **`[Inf, Inf, Inf, Inf]`** and a log-likelihood 5.29 *below* the single-grouping model's. The
student is set to report four standard errors that do not exist, one section after being taught that
`Inf` standard errors are the mark of a grouping that should not have been random — and will conclude,
following the chapter, that 126 levels is below the floor.

   The second half of the question is wrong about the file too. *"Is `Mum` crossed with `BroodNo` or
   nested above it, and how did you decide — from the formula, or from counting in the data file?"*
   Counting in the data file: **184 of 484 broods carry more than one `Mum`** (mothers hold 1 to 17
   broods, median 4). So the two are **partially crossed**, and neither branch of the offered binary
   is the answer. The chapter applies its own excellent test — *"read the first line. No brood appears
   in two years"* — to `Year`, and does not apply it to the grouping it sets as homework.

5. **blocking** — **the residual "trap" is measured against a null the fitted model never had, and the
excess it dramatises is what a correct model produces.** `fig-diagnostic` prints SD 1.0538 and *"the
SD sits 3.05 SE above 1"*; Toto's *"Three standard errors. That is not nothing"* is the pivot of the
section, and Itchy builds the diagnosis on it. But the u = 0 residuals were never standard normal
under the true model, so 1 is not their centre. Simulating the model's own null — draw u and y from
the fit, judge against the same fixed `fitted(u = 0)`, 2000 draws:

   | reference | null mean of the SD | null sd | observed (seed 909) | P(null ≥ observed) |
   |---|---|---|---|---|
   | `fitted()`, u = 0 | **1.0429** | 0.0185 | 1.0538 | **0.278** |
   | averaged over u | **0.9993** | 0.0180 | 1.0144 | **0.191** |

   The simulation confirms the chapter's *theory* precisely — the marginal probability is the correct
   PIT reference (null mean 0.9993) and u = 0 is miscalibrated (1.0429) — and destroys its *evidence*.
   The observed 1.0538 sits **0.58** null-SD above where a correct model puts it, not 3.05 of anything.
   The chapter's own machinery for this exists in Class 5 and is not used here. The correct sentence
   is stronger than the one written: **the model predicts 1.043 for the u = 0 reference, and it
   delivered 1.054** — a prediction met, which is a much better proof that setting u to zero is not
   averaging over u than an unexplained "three standard errors" is. The same applies to the mean: null
   mean of `mean(qres)` is **+0.0568** (sd 0.0320) against the printed 0.0916, P = 0.136.

6. **required** — **"The last block is our fit, to every digit either of them prints, including the
log-likelihood and the AIC" is false, twice, on the page.** `fit-glmm` prints `logLik = -903.2167`;
the `nAGQ = 25` block prints `logLik = -903.2165109`. `fit-glmm` prints `Std.Error 0.3327` on the
intercept; the `nAGQ = 25` block prints `0.3326`. Both are reproducible (finding 1): the converged
adaptive answer is −903.2165131 and 0.332630, the engine's non-adaptive GHQ-32 answer is −903.216718
and 0.332655. They agree on β₀, β₁, SE(β₁), the brood SD to four decimals and the AIC to two — which
is the true and more interesting claim, and it is one clause away.

7. **required** — **both residual standard deviations are one-seed draws, and seed 909 sits at about
the 87th percentile of each.** Over 500 randomisation seeds:

   | | range | mean | sd | seed 909 |
   |---|---|---|---|---|
   | SD, u = 0 reference | 0.9755 – 1.0827 | 1.0363 | 0.0160 | **1.0538** |
   | SD, marginal reference | 0.9329 – 1.0441 | 0.9956 | 0.0167 | **1.0144** |

   At the bottom of the same sweep the chapter's opening beat inverts — SD(u = 0) = 0.9755 is *below*
   one, and *"Three standard errors. That is not nothing"* has nothing to be about. What does survive
   the seed is the thing the chapter actually teaches: the mean gap between the two references is
   0.0407 and seed 909's 0.0394 is typical, so the *contrast* is stable even though neither endpoint
   is. Class 5's own summary rule is *"A verdict that changes with the seed is not a verdict"*, and
   Class 5's `seed-stability` cell is the fix, four cells long.

8. **required** — **"Class 3's standard error was 38.0% too small" is attributed to a number Class 3
did not print, and it measures the wrong shortfall.** Class 3's `logit_fit` is on
`data/2012/ChickSurvival.csv` — **1576** rows, a five-column file with no chick identifier — and
prints slope 0.6999, **SE 0.0514**. Against the GLMM's 0.0812 that is **36.7%** short. The chapter's
38.0% comes from its own `glm_fit` on 1600 rows of `SparrowSurvival.csv` (SE 0.050376), which is the
correct like-for-like comparison and is made explicitly and honestly (*"I want the comparison to be
like for like, so both fits get the same 1600 chicks"*). What is not correct is calling the result
"Class 3's standard error", and the deck states it as a fact about the printed number: *"the standard
error Class 3 printed turns out to have been too small by well over a third."* The two row sets cannot
even be matched — `ChickSurvival.csv` carries no identifier.

   The deeper problem is that 38% compares the standard error of one estimand with the standard error
   of another, and the chapter establishes four sections later that they *are* different estimands
   (*"It was estimating a different thing, roughly correctly, with a standard error that was wrong for
   either"*). The honest measure of how wrong the naive interval was **for its own target** is sitting
   in the chapter's own simulation and never taken out: over 1000 simulated worlds the naive slope's
   true sampling SD is **0.0574** against its nominal **0.0504** — **12.2%** too small, not 38%. The
   same number arrives independently from the z statistics: 13.494 → 11.569, a **14.3%** loss of
   relative precision. Most of the 61% inflation in the standard error is the change of estimand — the
   slope itself grows by a factor of 1.383 — not information lost to clustering. Both numbers belong in
   the chapter; the marginal/conditional section is where they pay off.

9. **required** — **the naive-versus-marginal gap is measured against the standard error the chapter
has just condemned, and the right ruler is in the same cell.** `gap_in_se = (b_glm[2] - marg_slope) /
se_glm[2]` = **1.44**, printed as *"1.4 of its own standard errors"*, glossed *"That is well inside
noise"* and, in the summary, *"well within one and a half of its own standard errors"*. `se_glm[2]` is
the nominal standard error the chapter has spent a section calling 38% too small. The estimator's
actual spread is already computed — `std(marg_slopes)` = 0.056 at 100 replicates, **0.0574** at 1000 —
and in those units the gap is **1.26**. The conclusion survives; the route does not, in the chapter
whose thesis is that a number needs the right error bar. Separately, 1.44 is not "well within" 1.5.

10. **required** — **"It is always smaller, for any link that is not the identity" is false for the
log link, which is the link this book taught in Classes 3 to 5.** Jaro's claim, repeated in the
summary as *"it happens for every non-identity link"*. For a Poisson GLMM with a log link and a normal
random intercept, E[Y | x] = exp(β₀ + β₁x + u); marginalising over u multiplies by exp(σ²/2) and moves
the **intercept only**, so the marginal and conditional rate ratios are identical. The log link is
collapsible for the rate ratio. Simulation (2000 groups of 5, σ_u = 0.8, conditional slope 0.500): the
naive Poisson fit recovers **0.4904**, while the matching logit case attenuates to **0.4335**. A
reader who did Class 4 will reach straight for the counterexample. The claim is true and important for
logit, probit and complementary log-log; it needs that qualifier, and naming the exception is a better
paragraph than the blanket.

11. **required** — **the provenance script does not produce the box, and does not run.** The front
matter promises *"produced once, by hand, with `Rscript` on 2026-09-07 … the script is kept at
`data/ch9/ch9-r-box.R`"*, and the box repeats it. That script fits `drmTMB` and **one** default
`glmer`; the box contains **three** `glmer` blocks (`nAGQ` = 1, 9, 25), so two-thirds of it cannot come
from the script. The formats differ too — the script prints `summary()$coefficients` with separate
`brood SD` / `logLik` / `AIC` lines, while the box prints `--- … ---` headers, a
`sd:mu:(1 | BroodNo)` row inside drmTMB's coefficient table, and `logLik: -912.4` at a precision
`format(…, digits = 10)` never produces. And it aborts: `Rscript data/ch9/ch9-r-box.R` on R 4.6.0 /
drmTMB 0.7.0 / lme4 2.0.1 stops at the first `print` with *"non-numeric argument to mathematical
function"* from `round(summary(m)$coefficients$cond, 4)`. This is **not** an invented-output failure —
my own `glmer` sweep reproduces all three blocks to every digit — but the chapter's provenance claim
is the strongest promise it makes, and on this file it cannot be honoured.

12. **required** — **`fig-diagnostic` is a worm plot the chapter never reads, with 961 of its 1600
points outside the band it drew.** The only sentence about the picture is Toto's, and that is about
`std(qres)`. Counting the plotted points against the plotted envelope: **961 of 1600** lie outside it.
That is not evidence against the model — under the model's own null the count for the u = 0 reference
has median **676** and 95th percentile **1137**, so P = 0.164 — but the chapter publishes a diagnostic
figure in which most points sit outside its own band and says nothing, which is what the repo's "look
at what you built" rule exists to prevent. Two things follow. The band is `sqrt(p(1−p)/n)/φ(theo)`,
the order-statistic envelope for **independent** observations, and cannot be right for 1600 chicks in
484 broods — the same objection the chapter makes about the residuals themselves. And the shape is not
the pure scale error the chapter diagnoses: the least-squares fit through (theoretical quantile,
deviation) has offset **+0.092** and slope **+0.053**, with the far right tail turning *down* to
−0.47 — offset plus curvature, not slope. Under the marginal reference the same plot would have had
**26** points outside against a null median of 23, and offset +0.036 with slope +0.014. Drawing the
second plot is the figure this section wanted.

13. **required** — **`fig-shrinkage`'s legend hands the reader the two words the section spent its
length avoiding.** The plot labels the circles **"raw mean"** and the diamonds **"BLUP"** — hard-coded
at `tools/figures.jl:142–143`, written for Class 6's Gaussian case. Neither is what Class 9 passes in.
The circles are unpenalised log-odds maximisers from the chapter's own Newton solver, not means of
anything; the diamonds are penalised posterior modes, and the chapter is careful for three pages that a
BLUP is exactly what a non-Gaussian fit does not have — it verifies its solver on the **Gaussian**
path *because* that is where BLUPs exist. `fig_shrinkage` needs label arguments, or Class 9 needs its
own helper.

14. **required** — **the `recovery` sentence understates the width it correctly refuses to
over-read.** *"With 100 replicates that interval is too wide to distinguish 95% from a couple of points
below it."* 0.920 with MC SE 0.027 gives **[0.867, 0.973]** — it cannot distinguish 95% from anything
down to about **87%**, which is eight points, not a couple. I reran the chapter's own cell in the
chapter's own engine at R = 1000: coverage **0.9500**, MC SE 0.0069, interval [0.936, 0.964]. The Wald
interval on log σ_b is nominal, and the printed 0.920 was noise — which is the honest thing to say and
a better advertisement for Appendix A than the hedge. The same replicate-count point applies to the
bias line and is not made: at R = 1000 the mean is 1.8681 with MC SE **0.0050**, so the identical bias
is **1.45** MC SE rather than the printed 0.45. The chapter applies "read it as no evidence" to
coverage and not to bias.

15. **required** — **Objective 2's prediction is never computed, and the rule the chapter cites for it
points the other way on this file.** Objective 2: *"Predict, before you fit, what adding the grouping
will do to a standard error."* Exercise 2 tells the reader to *"predict the direction of the
standard-error change from how much your predictor varies within groups versus between them"*, which is
Class 6's stated rule — *"when a predictor varies mostly between groups, ignoring the grouping makes
its standard error too small. When a predictor varies mostly within groups, the same neglect can make
it too large."* The chapter never runs that decomposition. On this file `Mass2`'s brood ICC is
**0.427**: mass varies rather more *within* broods (57%) than between them, so Class 6's rule does not
deliver Class 9's answer. The summary argues instead from the **response** — *"survival is strongly
shared within a nest"* — which is a different mechanism and should say so, especially given finding 8:
in a GLMM the dominant reason the standard error grows is the change of estimand, not lost
information.

16. **required** — **"|u| = 31.8" is a maximum printed as though it were one value.** `stalled =
maximum(abs, u_own[.!mixed])`, and the sentence reads *"on the other 270 the optimiser walks out to
|u| = 31.8 and stops there"*. Over those 270 broods |u| runs **25.10 to 31.76** — median 28.77, 180
distinct values — because the loop stops where `p(1−p)` underflows and that point depends on each
brood's own η. The chapter's reading is right (*"double precision giving up, not an estimate"*), and
the arithmetic behind it is one line: the loop halts near η + u ≈ log 10⁻¹², so u ≈ −27.6 − η, and η
here runs −2.82 to 5.07. A range, or that line, is what belongs on the page.

17. **suggestion** — **the chapter's headline claim about unanimity is asserted and never computed.**
*"If chicks were independent coin flips at roughly the population rate, you would not see that many
unanimous nests of four and five."* True, strikingly, and two lines away: with these brood sizes at
p = 0.4350 the expected number of unanimous broods is **140.7** of 484, and under the chapter's own
fixed-effects fit **157.4**, against **270** observed. In a chapter that makes the model prove
everything else, this one is left to the reader's intuition.

18. **suggestion** — **the chapter recommends putting Year in the mean model and never does it.**
Itchy: *"Put it in the mean model as a fixed effect, where four levels cost you three parameters."* On
this file `Survival ~ Mass2 + YearF + (1|BroodNo)` fits cleanly with six finite standard errors,
logLik **−890.2099**, AIC **1792.42** — twenty AIC below the chapter's headline GLMM. The advice is
right, it takes one cell, and it would sharpen the AIC beat rather than blunt it.

19. **suggestion** — **the recovery histogram validates the printed standard error and never says so.**
`std(sd_hat)` at R = 100 is 0.161, against the fit's own delta-method prediction
σ̂_b × SE(log σ̂_b) = 1.8609 × 0.0874 = **0.1627**. That is the chapter's own doctrine — a standard
error is a prediction about how much the estimate would move if the world ran again — met to three
digits, on the page, unclaimed.

20. **suggestion** — **two unrelated quantities print the identical 4.441e−16.** `posterior-modes`
gives *"largest |gradient| at the answer: 4.441e-16"* and `blup-check` gives *"largest disagreement
with `ranef()`: 4.441e-16"*. Both are genuine — I reproduced the BLUP check independently
(max |ranef − closed form| = 4.4409e−16 against max |ranef| = 2.8541, relative 1.6e−16) — and
4.4409e−16 is 2⁻⁵¹, the canonical two-ulp value, so the coincidence is real. It reads like a
copy-paste, and one clause naming it as two ulp defuses that.

21. **suggestion** — **`fig-two-curves` teaches its caption and could teach the argument.** Eddie's
*"The dashed one is flatter"* and Itchy's *"it never gets as close to either edge"* are both visible.
What is not in the picture is the claim four paragraphs earlier that the naive fit *"was estimating a
different thing, roughly correctly"*: `logistic.(b_glm[1] .+ b_glm[2] .* mass_grid)` is one line, and a
third curve landing near the dashed one is the whole argument in one glance.

22. **suggestion** — **three annotation notes.** Reference 1 (Bolker et al.) has **no abstract in
OpenAlex**, so the front matter's promise — *"Claims about what each source argues are attributed no
more narrowly than a title or abstract supports"* — cannot have been met by the stated method for the
chapter's most load-bearing attribution, the five-or-six-level floor. The claim is correct about the
paper as published; the note should say the check was against the paper. Reference 3's annotation
(*"small numbers of levels, singular fits"*) is narrower than the Harrison et al. abstract, which
speaks of pitfalls and model selection generally. Reference 7's abstract restricts randomised quantile
residuals to *"regression models with **independent responses**"* — the one restriction this chapter's
use violates — and the annotation, which is otherwise the best on the list, does not mention it; the
chapter makes the point in its own summary without connecting it to the source that states it.

23. **suggestion** — **Item 1, the residue.** The summary writes *"**Four** years cannot support an
estimated distribution"* in bare word form where the dialogue correctly uses `{julia} n_years`, and
does the same for *"about two-thirds"* (0.6461), *"well within one and a half"* (1.44) and *"about
three Monte Carlo standard errors"* (3.05). Word form is house style for counts elsewhere in the book,
so this is consistency rather than a rule break — but three of the four are quantities that findings 7,
9 and 5 say should not be quoted at that precision anyway.

**Verified.** The two hardest ideas in the chapter are right and are proved rather than asserted.
`fitted()` on a GLMM really is the u = 0 prediction, setting u to zero really is not averaging over u
on a nonlinear link, and the marginal probability really is the correct PIT reference — my null
simulation puts the marginal reference at 0.9993 and the u = 0 reference at 1.0429, which is the
chapter's claim measured. The unanimous-brood argument is exactly right and is the best page here: the
unpenalised maximiser genuinely does not exist for 270 of 484 broods, the penalised one does, and it is
pulled harder the smaller the nest. The `brood_effects` solver is correct (largest gradient 4.4e−16)
and verifying it on the Gaussian path against `ranef()` is the right move, correctly executed. The
`missingstring` beat is real and reproduces. The AIC / LRT arithmetic closes exactly
(2 × (986.8062 − 903.2167) = 167.179; ΔAIC = 2 − 167.18 = −165.18) and the boundary p-value is exactly
half the naive one, as a 50:50 chi-bar-squared mixture requires. The latent-scale ICC is computed and
labelled correctly, and the refusal to compute a data-scale version with a pointer to reference 4 is
the right call. The `simulate` beat is right — `simulate` does set the random effects to zero, the
refit does land on the boundary, and the chapter reads it correctly as a null-builder rather than a
recovery check. `ranef()` really does return an empty `Dict` and really does raise a `KeyError` when
indexed, and calling that an engine limitation rather than a fact about GLMMs is exactly the standard
finding 3 asks the year fit to be held to. The marginal/conditional beat never calls either one "the"
effect — *"Two odds ratios, both correct"*, *"neither is a compromise"*, *"Ask which one your sentence
needs"* — which is the discipline the brief was worried about, and it holds. All seven citations are
exact. The recovery study's honesty about R = 100 is right in direction even where finding 14 says the
width is understated. And every number on the page ran.

## Re-derivations

- **Fixed-effects logistic** (own IRLS via `glm`): −2.757030, 0.679770; SE 0.193448, 0.050376;
  logLik −986.806159; AIC 1977.6123. z = 13.4939.
- **Non-adaptive Gauss–Hermite GLMM, written from scratch in R** (no DRM.jl, no lme4):
  K = 20 → σ_b 1.8590445, logLik −903.230555; **K = 32 → β (−3.948529, 0.939932), log σ_b 0.621034,
  σ_b 1.8608512, SE (0.332655, 0.081246, 0.087392), logLik −903.216718, AIC 1812.4334**;
  K = 64 → σ_b 1.8609128, logLik −903.216513. DRM.jl 0.7.1 returns σ_b 1.8608514, logLik −903.216718,
  SE [0.332655177605377, 0.08124569943823809, 0.08739200292797743] — the K = 32 row to seven digits.
  Engine source: `binomial.jl:148,158` (GHQ-32), `aghq_1d.jl:10` (do not relabel as AGHQ),
  `binomial.jl:60` (`:AGHQ` rejected for this family).
- **`glmer` sweep**, nAGQ 1/3/5/7/9/15/21/25/31/41/51 — table in finding 2. The three blocks in the
  chapter's box reproduce to every digit: nAGQ 1 → sd 1.7000125, logLik −912.3729611, AIC 1830.745922;
  nAGQ 9 → 1.8616593, −903.2083452, 1812.416690; nAGQ 25 → 1.8609149, −903.2165109, 1812.433022.
- **Data**: 1950 raw rows → 1600 on 484 broods; 696 survivors (0.4350); brood sizes 35/86/133/159/68/3,
  mean 3.3058; 179 all-died, 91 all-lived, 214 mixed; 4 years, 126 mothers, 0 broods spanning two
  years; **184 of 484 broods carry more than one `Mum`** (1–17 broods per mother, median 4).
  `Mass2` brood ICC **0.427**. Expected unanimous broods under independence at p = 0.4350: **140.7**;
  under the fitted GLM: **157.4**; observed **270**.
- **Variance components**: V_brood 3.462767, π²/3 = 3.289868, ICC 0.512802.
- **Posterior modes** (own Newton, the chapter's recursion): range −3.2189 to 3.0494; 214 mixed broods
  keep 0.583–0.830 of their own signal (median 0.710), by brood size 0.583–0.633 (k = 2) up to
  0.744–0.830 (k = 6). Unpenalised |u| on the 270 unanimous broods: **25.10 – 31.76**, median 28.77,
  180 distinct values. Gaussian BLUP check: max |ranef − closed form| **4.4409e−16** against
  max |ranef| 2.8541 (relative 1.6e−16).
- **Marginal simulation, 1000 replicates** (chapter: 100): mean slope **0.6073**, SD **0.0574**,
  MC SE 0.0018, OR 1.8355, attenuation 0.6461. Gap from the naive fit: 0.0725 = **1.44** nominal SE =
  **1.26** true sampling SD. Naive nominal SE 0.0504 against true 0.0574 → **12.2%** short.
  z: 13.494 → 11.569, **14.3%** relative precision lost. Class 3's own printed SE 0.0514 → **36.7%**.
- **Quantile residuals.** Seed sweep, 500 seeds: u = 0 reference 0.9755–1.0827 (mean 1.0363,
  sd 0.0160); marginal reference 0.9329–1.0441 (mean 0.9956, sd 0.0167); seed 909 gives 1.0538 and
  1.0144. Model's own null, 2000 draws (draw u and y from the fit, no refit): SD(u = 0) mean **1.0429**
  sd 0.0185, P(≥ 1.0538) = **0.278**; SD(marginal) mean **0.9993** sd 0.0180, P(≥ 1.0144) = **0.191**;
  mean(r_cond) null mean **+0.0568** sd 0.0320, P(≥ 0.0916) = 0.136; mean(r_marg) null mean −0.0019,
  P(≥ 0.0355) = 0.117. The chapter's 1/√(2n) = 0.0177 is close to the true 0.0184, so clustering
  inflates the Monte Carlo error only slightly — the wrong *centre*, not the wrong width, is the
  problem.
- **Worm plot**, same machinery as `tools/figures.jl` (`erfinv_approx` included): u = 0 residuals,
  **961 of 1600** outside the ±2 SE band, offset +0.0916, slope +0.0533, mean deviation −0.062 below
  θ = −2 and +0.043 above θ = +2; null median 676, 95th percentile 1137, P = 0.164. Marginal residuals,
  **26** outside, offset +0.0355, slope +0.0142; null median 23, P = 0.486.
- **Recovery, R = 1000** (chapter's cell, chapter's engine and seed): mean σ̂_b **1.8681**,
  MC SE **0.0050**, bias 1.45 MC SE; coverage of the Wald interval on log σ_b **0.9500**, MC SE 0.0069,
  interval [0.936, 0.964]; coverage for β₁ 0.9400; mean β̂₁ 0.9438 with SD 0.0868 against the fitted
  SE 0.0812. The chapter's R = 100 result 0.920 ± 1.96 × 0.0271 spans **[0.867, 0.973]**.
  `std(sd_hat)` at R = 100 is 0.161 against σ̂_b × SE(log σ̂_b) = **0.1627**.
- **Two-grouping fits** — table in finding 3. Also `Survival ~ Mass2 + YearF + (1|BroodNo)`:
  logLik −890.2099, AIC **1792.4197**, SE [0.4269, 0.0807, 0.3589, 0.3507, 0.4112, 0.0904], all finite.
- **Collapsibility of the log link** (2000 groups × 5, σ_u = 0.8, conditional slope 0.500): naive
  Poisson recovers **0.4904**; the matching logit case attenuates to **0.4335**.
- **The R box script**: `Rscript data/ch9/ch9-r-box.R` under R 4.6.0 / drmTMB 0.7.0 / lme4 2.0.1 prints
  its header and `rows 1600  broods 484`, then halts — *"non-numeric argument to mathematical
  function"* at `round(summary(m)$coefficients$cond, 4)`. It contains no `nAGQ` argument anywhere.

## One question for Shinichi

Findings 1, 2, 3 and 4 are one question wearing four hats: **what is this chapter allowed to say about
the engine it teaches?**

The chapter is at its best when it tells the truth about DRM.jl 0.7.1 — the `ranef()` section is the
finest page here precisely because it says *"a limitation of the version of the engine this page was
built with, not a fact about GLMMs"*, and then writes the six lines the engine has not, and then
**verifies them where the engine does have an answer**. That is the book's method executed perfectly.
Two sections earlier the chapter does the opposite: it takes an engine defect on the two-grouping
binomial path — `Inf` standard errors, a log-likelihood that went *down* when a parameter was added,
identical behaviour on a 126-level grouping — and builds "the failure mode of the whole week" on it as
though it were a statistical fact about four levels. And the box does the opposite again: it gives the
engine's non-adaptive GHQ-32 a different method's name, in a section whose moral is "name the
approximation".

So: **does Class 9 own the engine's limitations out loud, or work around them?**

If it owns them, the chapter gets *better* and it costs one honest paragraph in each of three places.
The box becomes three rules on one page rather than two — Laplace 1.700, non-adaptive GHQ-32 1.86085,
adaptive GHQ 1.86091 — which is a sharper version of "nobody asked you", because now *nobody has the
same default*, and Pinheiro and Bates' abstract stops being a citation and becomes the argument (it
names DRM.jl's rule as the weak one, which is a startling and true thing for a book to say about its
own engine). The year section keeps its lesson and changes its evidence: the four-level grouping *on
its own* fits fine here, so the demonstration has to be the log-likelihood going down, which is a
better lesson anyway — `converged = true` refuted by arithmetic on the same printout. And Exercise 6
becomes the chapter's best exercise instead of an impossible one: *fit it, report what comes back,
and say which of the two explanations you have been given — 126 levels is too few, or the engine
cannot do two groupings on this family — the output supports.* That is objective 5 with teeth.

If it works around them, then the box must lose the claim that `glmer`'s last block is our fit,
Exercise 6 must move to a grouping that fits, and the year section needs a different demonstration —
and the chapter is smaller.

Two smaller decisions ride on the answer. Finding 5 says the residual section's null is wrong in a way
that makes its own lesson *stronger* when fixed (the model predicts 1.043 and delivers 1.054): does
that beat get rewritten around the prediction, with Class 5's simulate-the-null machinery reused, or
does it keep the "three standard errors" framing? And finding 8 says the chapter has two numbers for
"how wrong was Class 3's interval" — 38% against the conditional estimand, 12% against its own —
which are both true and answer different questions, exactly like the two odds ratios the chapter
handles so well four sections later. Does the deck keep the big one, or does the chapter make the same
move twice and let the standard error have a conditional and a marginal version too? That second
chapter is the one I would want to read.

---

## Re-review (9ca4dfb)

Read from the commit on `book/preview-machinery` — the rewritten chapter, the new frozen
execute-results, the two new/changed SVGs as images, and the rewritten `data/ch9/ch9-r-box.R` —
with every new number re-derived independently: my own DRM.jl-free checks where they apply, and
fresh runs of the engine itself for the fits only it can produce. **I ran the new R script.** It
now emits all four blocks and reproduces the box **byte for byte** on R 4.6.0 / drmTMB 0.7.0 /
lme4 2.0.1.

**Every new executed number reproduces exactly**: the unanimity expectation 140.7; the mass split
0.7886 / 0.9104 and 42.9% between broods; `(1|YearF)` alone at logLik −967.8680 with standard errors
`[0.21581295886382787, 0.05183611707049071, 0.2720383009296088]` and none infinite; `(1|MumF)` alone
at −974.2398 with none infinite and `(1|BroodNo)+(1|MumF)` at −908.5090 with four; the Gaussian
control on the same two groupings, −2413.5356 → **−2411.4486**, log-likelihood **up** and no
infinities; 184 of 484 split broods and 1–17 broods per mother; the |u| range 25.10–31.76, median
28.77, **267 distinct values of 270** at six decimals; the marginal simulation at 1000 replicates
(0.6073, MC SE 0.0018, attenuation 0.6461, true SD 0.0574, 12.2%, gap 1.26); the seed sweep under the
chapter's own `i × 7919` rule — **0.9847 to 1.0850**, **0.9424 to 1.0459**, gap **0.0359 to 0.0459**;
961 and 26 outside the band; and the coverage interval [0.867, 0.973]. The `marginal = :AGHQ`
refusal is verbatim what the engine throws, including the clause *"on `(1 | g)` that is GHQ-32, not
AGHQ"*. My own 500-draw residual null lands on the chapter's: predicted 1.0427/0.9993 against my
2000-draw 1.0429/0.9993. Item 1 now passes with **96** inline `{julia}` expressions (was 30), and the
only bare numerals left in dialogue are Class pointers, equation symbols, `GHQ-32`, `0.7.1`, `#761`,
a date, and the literal seed 909 — which the dialogue itself calls "a number somebody typed once".
The three pre-rendered R constants quoted in prose (`1.700`, `1.860915`, `-903.2165109`, `0.3326`)
are each tagged "from the box", which is the right handling for output Quarto cannot execute.

### Closed

- **Findings 1, 2, 3, 4, 5** — all five blocking failures, closed with executed evidence.
  - **1 (GHQ-32 mislabelled).** The chapter now asks the engine for `:AGHQ`, prints the refusal, and
    reads the clause that names its own rule; the box teaches **three** rules with DRM.jl's named as
    non-adaptive 32-node Gauss–Hermite centred at zero; Pinheiro & Bates is read for what its abstract
    actually separates, *including* that their weak member is this book's engine; #761 is cited. Itchy
    saying *"I had been calling ours adaptive quadrature right up until it corrected me in front of
    you"* is the best repair available and better than the sentence it replaces.
  - **2 (monotonicity).** The rule is gone, replaced by *"quadrature error is not signed and
    quadrature does not bound the integral from below, so a sweep can overshoot and come back"*, with
    the `nAGQ = 9` > `nAGQ = 25` counterexample read out and Exercise 10 rewritten to forbid the
    discarded rule by name.
  - **3 (Inf SEs).** Now demonstrated rather than asserted: `(1|YearF)` alone succeeds with finite
    standard errors, `(1|BroodNo)+(1|MumF)` fails identically on 126 levels, the same two groupings
    fitted Gaussian give no infinities and a log-likelihood that rises, and the falling log-likelihood
    is printed as the arithmetic that convicts `converged = true`. Bolker's floor is kept and its
    demonstration withdrawn. Objective 5 now carries the lesson.
  - **4 (Exercise 6).** Counts the design first (184 of 484, 1–17 broods per mother), answers
    "neither", and fits the two groupings **separately** — both of which run.
  - **5 (residual null).** `residual-null` builds the null from the fit; Itchy explicitly catches
    himself (*"I said 'too wide'. Too wide compared with what?"*); the beat is now a prediction met.
- **Findings 6–11, 13, 16, 17, 23.** "To four decimals … It is not our fit", with both counterexamples
  quoted (finding 6). The 500-seed sweep, with the gap correctly identified as the seed-stable
  quantity because both references are scored on the same draw (7). *"No number here is Class 3's
  number"* plus the 12.2% (8). `se_true` as the ruler, with Momo challenging the choice and the wrong
  1.44 shown as the wrong one (9). Jaro's log-link exception, correct as written (10). The R script
  (11) — verified by running it. A chapter-local `fig_brood_shrinkage` with the section's own words,
  a dotted zero line, and Eddie's line updated to match; I looked at it (13). The |u| range with its
  mechanism (16). The unanimity arithmetic (17). Item 1 (23).
- **Finding 12, in part.** The worm plot is now read, counted, and given a companion: the new
  `fig-diagnostic-marginal` shows the same chicks against the correct reference, and the improvement
  is visible in one glance. One sentence added in the repair is a new defect — see **N1**.
- **Finding 15, in part.** Objective 2 is now computed, predicted from, and honestly reconciled. One
  clause in the reconciliation over-explains — see **N2**.
- **Finding 14, in part.** The coverage width is now stated outright — [0.867, 0.973], *"a gap of 8
  points, which is not 'a couple'"*, which is the exact repair.

### Not closed

- **Finding 14's second half** (now a **suggestion**). The bias line still reads 0.45 MC SE at
  R = 100. The chapter now applies the width discipline to coverage and still not to bias: at
  R = 1000 (my rerun, same engine and seed) the identical bias is **1.45** MC SE, mean 1.8681 with
  MC SE 0.0050 — and the coverage is **0.9500**, so the interval really is nominal. One clause.
- **Findings 18, 19, 20, 21** — all suggestions, all unchanged. Year as a fixed effect is still
  recommended and still not run (`Survival ~ Mass2 + YearF + (1|BroodNo)`: logLik −890.2099, AIC
  **1792.42**, six finite standard errors — twenty AIC below the headline GLMM, and now doubly worth
  a cell since the chapter's year section ends without a working alternative on the page). The
  recovery histogram still validates the printed standard error silently (0.161 against
  σ̂_b × SE(log σ̂_b) = **0.1627**). `posterior-modes` and `blup-check` still both print 4.441e−16.
  `fig-two-curves` still omits the naive fit's own curve.
- **Finding 22, in part.** Reference 6's annotation is now the best on the list and says out loud that
  the paper's weak member is this book's engine. References 1, 3 and 7 are unchanged: Bolker still has
  no OpenAlex abstract behind the five-or-six-level claim, Harrison's annotation is still narrower
  than its abstract, and Dunn & Smyth's *"regression models with independent responses"* — the one
  restriction this chapter's use violates, and which the new band paragraph is groping towards — is
  still not connected to the source that states it.

### New findings

**N1. required — the band paragraph attributes to the envelope a number that is about the
reference, and its own next number says so.** Summary: *"The worm plot's ±2 SE envelope is the
order-statistic envelope for **independent** normals, so on 1600 chicks in 484 broods **it is too
narrow by construction** — 961 points fall outside it under the u = 0 reference and 26 under the
marginal one. Read that as a statement about the envelope, not about the model."* Itchy says it more
sharply: *"961 points outside an independence envelope is a statement about the envelope."* But the
envelope is identical in both plots. What changed between 961 and 26 is the **reference**, which is
the thing the section has just spent four cells establishing — so 961 is a statement about `fitted`,
not about the band. Measured:

| sample | median outside | mean | 95th pct |
|---|---|---|---|
| 1600 genuinely **iid** N(0,1) (2000 draws) | **10** | 68.1 | 331 |
| model's own null, **marginal** reference (1000 draws) | **25** | — | 709 |
| model's own null, **u = 0** reference (1000 draws) | **683** | — | 1176 |

Observed: 26 against the marginal null median of 25, **P = 0.498**; 961 against the u = 0 null
median of 683, **P = 0.164**. So the chapter's *direction* is right and it has the wrong number for
it: clustering does inflate the count, from a median of 10 for independent normals to 25 here — and
**26 against 10** is the evidence for "too narrow", sitting unremarked on the same line. The 961 is
not. There is also a stronger statement available than "too narrow": the null count is so skewed
(iid median 10, mean 68, 95th percentile 331) that the count outside a **pointwise** band is not a
statistic at all, whoever computes it, which retires the reading rather than merely correcting its
width. Note the pointwise nominal 2Φ(−2) × 1600 = 72.8 is above the iid *median* of 10, so the band
is conservative in the median even before clustering.

**N2. required — the two-part decomposition of the 38% does not close, and the leftover runs the
chapter's way.** Itchy: *"The rest of the `38.0%` is not lost information at all: it is the standard
error of a **bigger coefficient**, because the conditional slope is a factor of `1.55` larger than the
marginal one."* The chapter's own four printed numbers do not multiply out. The standard errors show a
factor of **0.0812 / 0.0574 = 1.4154**, not 1.5477; rescaling the naive estimator's true sampling SD
by the coefficient ratio predicts SE(β̂₁) = **0.0888** against the actual **0.0812**, over-predicting by
**9.3%**. The leftover is a fact worth having and it favours the mixed model: its coefficient of
variation is **0.0864** against the naive estimator's **0.0945** at its own target, so the GLMM is
relatively *more* precise, not merely rescaled. The headline survives — on the log scale rescaling is
**72.7%** of the gap, so *"most of that is the estimand changing size"* is right — and what is needed
is a clause saying the two factors are 12.2% and a factor of 1.42, with the coefficient ratio 1.55 as
the reason rather than the arithmetic. In the same paragraph, *"Mass being 57% within-brood is
**exactly why** the honest shortfall is only 12.2%"* is rhetorical rather than measured: the
design-effect heuristic Class 6's rule rests on gives 1 + (k̄ − 1) × ICC_x × ICC_y =
1 + 2.31 × 0.4286 × 0.513 = **1.51**, i.e. an 18.6% shortfall against the observed 12.2% — the same
ballpark, not an identity, and "consistent with" is the honest connective in a chapter that has just
made a virtue of not over-claiming a mechanism.

### Re-derivations (this pass)

- New R script run end to end: all four blocks byte-identical to the box, including
  `logLik: -912.4`, `1.700013 / -912.3729611 / 1830.745922`, `1.861659 / -903.2083452 / 1812.41669`
  and `1.860915 / -903.2165109 / 1812.433022`.
- `marginal = :AGHQ` refusal reproduced verbatim from DRM.jl 0.7.1.
- Gaussian control: brood alone −2413.5356, plus `MumF` −2411.4486; zero infinite standard errors in
  both; mass ICC 0.4286 (42.9% between), SDs 0.7886 / 0.9104.
- `(1|YearF)` alone −967.8680, SEs [0.2158, 0.0518, 0.2720], none infinite. `(1|MumF)` alone
  −974.2398, none infinite. `(1|BroodNo)+(1|MumF)` −908.5090, four infinite.
- Stalled |u|: 25.10–31.76, median 28.77, **267** distinct at six decimals over 270 broods.
- Seed sweep under the chapter's `i × 7919`: u = 0 **0.9847–1.0850**, marginal **0.9424–1.0459**,
  gap **0.0359–0.0459** — exact.
- Band nulls and the iid benchmark: table in N1.
- Decomposition arithmetic: 38.00% / 12.24% / coefficient ratio 1.5477 / SE ratio 1.4154 / predicted
  0.0888 vs actual 0.0812 / CVs 0.0864 and 0.0945 / rescaling 72.7% of the log-gap.
- Recovery at R = 1000 (from the first pass, unchanged): mean 1.8681, MC SE 0.0050, bias 1.45 MC SE,
  coverage 0.9500 (MC SE 0.0069).
- Figures looked at: the new `fig_brood_shrinkage` carries the section's own labels, a dotted zero
  line and a log-odds y-axis, and Eddie's rewritten line matches what is drawn; the new
  `fig-diagnostic-marginal` teaches its caption — the cloud sits inside the band across the whole
  middle with only the discrete tails outside, and set beside the first plot the contrast is the
  argument.

## Re-review verdict

**Pass, with two required repairs.** All five blocking findings and all eleven required findings from
the first pass are closed, and closed the hard way — with cells that run, a control the argument
needed, an engine made to name its own approximation, and a script that now produces the box it
claims to. The chapter is meaningfully better than it was: three of the repairs (the refusal, the
Gaussian control, the residual null) are stronger teaching than the material they replace, and the
two places where Itchy is shown being wrong in front of the class are the best pages in it. The two
new findings are both single sentences written during the repair — one attributing a reference effect
to the plotting envelope, one asserting a decomposition its own numbers do not quite support — and
neither touches a verdict. Four suggestions from the first pass remain open and one (the bias line at
R = 100) has been half-answered.
