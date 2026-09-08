# Chapter 7 — adversarial statistical review (as executed)

## Review (e1a63b8)

Read against the frozen outputs and the four rendered SVGs, with an independent refit of every
model in **lme4 2.0.1 under `REML = FALSE`** (R 4.6.0), a hand-derived origin-shift algebra for the
centring table, an analytic eigen-decomposition of Σ at the uncentred origin, a re-run of the
400-replicate boundary study in DRM.jl at the chapter's own seeds, and a read of
`DRM.jl/src/chibar.jl` and `src/gaussian_ranef.jl`.

**Every executed number reproduces exactly.** The within-bird share table to four decimals
(0.0712 / 0.2680 / 0.4824 / 0.3722 / 0.4176 and all five within-SDs); the random-intercept fit
(σ_u 1.8510, σ 1.1256, logLik −883.5938, AIC 1775.1876); the random-slope fit (σ_0 1.7177,
σ_1 0.4308, ρ +0.2354, σ 1.0179, β₁ 0.1816, logLik −872.6137, AIC 1757.2273); the LR statistic
21.9603 and all three p-values (1.7037e−5, 5.6510e−6, 9.9102e−6); the AIC drop 17.9603; the whole
centring table including the AIC agreeing to 4.32e−12 — and I re-derived that table analytically
rather than by refitting: with `a = w̄ − c`, Var(u₀′) = σ_0² − 2aρσ_0σ_1 + a²σ_1² and
Cov(u₀′, u₁) = ρσ_0σ_1 − aσ_1² give 3.3070/−0.8632, 2.0167/−0.5610 and 2.2134/+0.6566 to four
decimals, so the invariance beat is exactly right; the shrinkage block (86 of 171, SD 1.0857 vs
0.2672, min −5.7895, ratio 0.2461); every residual number (2.1105, 2.1415, 2.0917, 0.7845, 22.9%,
25 of 459, −7.492 / 2.830); and the entire 400-replicate study, seed for seed (142 and 34 throws,
medians 0.0900 and 0.4266, 0.0426 and 0.0000, 0.0620 among 258 survivors, 0.0400 overall). The
pre-rendered R block reproduces too: lme4 ML gives 1.7177 / 0.4308 / +0.2354 / 1.0179 / −872.6137
and REML gives 1.7233 / 0.4353 / +0.2335 / 1.0180 / −875.5085, byte for byte. The chapter says which
estimator throughout and uses ML on both sides of the comparison. All six journal citations check on
OpenAlex. The engine's `lrt_boundary` docstring says exactly what Jaro says it says — 0.25/0.5/0.25
on 0/1/2 df, explicitly conditioned on the two components being **independent** — and Stram & Lee's
50:50 mixture of χ²(1) and χ²(2) is the right reference for intercept → intercept + slope. The
ordering Itchy asks the class to write down (naive most conservative, 50:50 next, engine q = 2 most
liberal) holds for every positive statistic, because χ²(2) stochastically dominates χ²(1); my re-run
confirms it in rejection rates (0.0388 / 0.0620 / 0.0891 among survivors). Item 1 passes cleanly:
**47 inline `{julia}` expressions**, and the only bare numerals in dialogue are "9:00 am", Class and
Exercise numbers, two citation years and the issue number.

The arithmetic is immaculate. What is wrong is the model the arithmetic is computed from, the
diagnosis of the chapter's own crash, and which side of the worm plot the chapter reads.

## Verdict

**Block** — three failures. The chapter's headline σ_1 is 41% smaller in the model that separates
the two questions the chapter itself says its model conflates, and the repair costs one parameter
and buys more AIC than the random slope buys with two; the uncentred `DomainError` is diagnosed as
a singular Σ and a standard deviation driven to zero, and it is neither — the same model fits at the
same maximum in lme4 and in DRM.jl at four other origins; and 23 of the 25 points outside the worm
plot's band are on the **right**, and all 23 are an artefact of standardising by an SD that two bad
rows inflated.

## Findings

1. **blocking** — **β₁ = 0.1816 is a blend of two slopes that differ by 4.9 standard errors, and
separating them costs one parameter, buys more AIC than the random slope, and cuts σ_1 by 41%.**
Itchy's question is a *within*-bird question — *"when a bird is heavier, is its wing measured
longer, and **by the same amount in every bird**?"* — and the chapter answers it with a model that
gives the within-bird and between-bird effects one coefficient. Split them (`wdev` = mass minus the
bird's own mean, `wbar` = the bird's mean mass, centred):

   | model | fixed slopes | σ_0 | σ_1 | ρ | σ | logLik | AIC | npar |
   |---|---|---|---|---|---|---|---|---|
   | `wc + (1\|id)` | 0.1844 (0.0491) | 1.8510 | — | — | 1.1256 | −883.5938 | 1775.1876 | 4 |
   | `wc + (1 + wc\|id)` *(the chapter)* | 0.1816 (0.0608) | 1.7177 | **0.4308** | **+0.2354** | 1.0179 | −872.6137 | 1757.2273 | 6 |
   | `wdev + wbar + (1\|id)` | within **0.0490 (0.0563)**, between **0.5832 (0.0927)** | 1.7478 | — | — | 1.1143 | −871.9449 | **1753.8899** | 5 |
   | `wdev + wbar + (1 + wdev\|id)` | within 0.0618 (0.0602), between 0.5336 (0.0915) | 1.7621 | **0.2541** | **+0.5690** | 1.0695 | −867.5692 | 1749.1383 | 7 |

   Read the third row first. **One extra fixed parameter buys 21.30 AIC**, against the random
   slope's 17.96 for two — the repair the chapter names in one clause and postpones is a bigger and
   cheaper win than the chapter's whole subject, and it beats the chapter's own preferred model
   (1753.89 vs 1757.23) with one fewer parameter. Then read the fixed slopes: the **within-bird
   slope is 0.0490 with a standard error of 0.0563** (z = 0.87), indistinguishable from zero, while
   the between-bird slope is 0.5832 (0.0927); they differ by 0.5343 ± 0.1085, z = 4.92. On this file
   there is no detectable within-bird effect of mass on wing at all, and the whole of β₁ = 0.1816 is
   the between-bird effect leaking into a coefficient the chapter reads as within-bird
   (*"birds that are longer-winged at average mass tend, mildly, to gain more measured wing per
   gram"*). Finally, the random slope **survives** the repair — LR 8.7516, Stram & Lee p = 7.8e−3,
   AIC drop 4.7516 — so the lesson stands, but **σ_1 falls from 0.4308 to 0.2541, ρ rises from
   +0.2354 to +0.5690, and more than half the chapter's LR statistic (13.2 of 21.96) is
   fixed-effect misspecification, not slope heterogeneity.** The mechanism is mechanical and worth
   teaching: `u_1j · wc = u_1j · wdev + u_1j · w̄_j`, so in the chapter's model one per-bird
   deviation has to serve both the bird's own within trend and its intercept, and its estimated
   variance picks up the between/within slope contrast the fixed part refuses to separate. Two of
   the chapter's most-quoted sentences move with it: *"the spread of the slopes is larger than the
   average slope"* and *"A bird keeps roughly a quarter of the slope its own points suggest"*.
   The chapter's honesty here is real and is not the problem — the problem is the destination: see
   finding 4.

2. **blocking** — **the uncentred crash is misdiagnosed, and the chapter's own printed error says
so.** Three sentences fail: *"the intercept and slope become so nearly perfectly correlated that Σ
is numerically singular"*; *"a covariance matrix with a correlation of exactly minus one has no
proper Cholesky factor at all"*; *"something takes the logarithm of a standard deviation that has
been driven to zero"*. The chapter's own executed error is `DomainError with -1.4757395258967641e20`
— a logarithm of **minus 1.5 × 10²⁰**, which is not a standard deviation near zero by any reading.
And Σ at the uncentred origin is not singular: shifting the fitted Σ to `c = 0` gives
Σ = [134.3529, −4.9412; −4.9412, 0.185575], **eigenvalues 0.003845 and 134.5346, det 0.5172,
ρ = −0.98957, `isposdef` true**, condition number 34,993. Its Cholesky exists, and two engines find
it: **lme4 ML fits `Wing ~ Weight + (1 + Weight | BirdID)` to the identical maximum** —
logLik −872.6137, AIC 1757.2273, σ_1 0.4307, ρ −0.98957 — and **DRM.jl itself fits the model at
origins 10, 15, 18 and 20 g**, at ρ = −0.9739, −0.9487, −0.9122 and −0.8632, all at logLik
−872.6137. So the failure boundary sits between 5 g and 10 g, the engine survives ρ = −0.974, and
at 5 g it throws an `AssertionError: isfinite(phi_c) && isfinite(dphi_c)` — a line-search failure,
not the `DomainError` at all. The real mechanism is in `gaussian_ranef.jl:418–447`: the random-effect
Cholesky diagonals are carried as **logs and exponentiated** (`l11 = exp(a); l22 = exp(b)`, and the
printed `L11 0.5410` / `L22 −0.8706` are exactly `log 1.7177` and `log 0.41871`), so a standard
deviation is never fed to `log` anywhere in the objective. The only `log` in the objective is
`logdetM += log(dM)` with `dM = m11*m22 - m21^2`, the 2×2 per-bird determinant. With uncentred mass
the cross term `m21 = Si21 + Σᵢ w·invD` runs to order 27 and `m22` to order 750, so `m11*m22` and
`m21^2` are two large nearly equal numbers and their difference goes negative in floating point.
That is a **conditioning failure in this engine's optimiser**, and centring fixes it because it
drives `Σ w·invD` to zero — which is a better lesson, not a weaker one. As written, *"it is the
difference between a fit and no fit"* is false (it is the difference between a fit and no fit **in
DRM.jl**), *"the crash and the sign change are the same fact"* overstates a shared cause, and the
Julia-stuff bullet generalises the wrong diagnosis into a rule the reader will carry to other data:
*"A logarithm of a negative number, inside the optimiser, means a standard deviation being driven to
zero."*

3. **blocking** — **the worm plot is read on the wrong side, and the excursion it reads is an
artefact of the chapter's own standardiser.** Momo: *"it is not flat on the left"*; Itchy: *"25 of
the 459 points sit outside the pointwise band … The **shape** is not [unremarkable]. The worm is
flat through the middle and **dives on the left only**"*. Counted from the chapter's own arithmetic:
**23 of the 25 outside points sit at positive theoretical quantiles** (sorted ranks 406–437,
quantiles +0.4 to +1.65), where the worm runs systematically *below* the band; **only 2 are on the
left**, and those two are the isolated outliers visible in the SVG at deviation −1.65 and −4.43.
Worse, the 23 are manufactured: `std(cond)` is 0.7845 with those two rows and 0.7185 without, so
dividing by it compresses the bulk and tilts the worm. Restandardise by the MAD (0.7283) and the
count outside falls from 25 to **2, both on the left**; drop the two rows with |z| > 3 and
restandardise the remaining 457 and the count is **0**. The worm is flat and inside the band over
its entire length apart from two bad measurements. The two rows are identifiable and are the better
beat: **TA14548** is recorded at Wing 67.0 among its own 75.5 / 75.0 / 76.5, and **TA14531** at 76.0
among its own 80.3 / 82.0 / 81.0 — and TA14531 is the bird at the far right of the chapter's own
shrinkage caterpillar. Two related numbers also move: the tails are *not* asymmetric in count
(8 residuals below −2, 9 above +2; the asymmetry is two points, not "a few"), and the 22.9%
shortfall is itself inflated by them — without those two rows it is 29.4%. This is the Class 5 trap
sprung on the chapter that invokes Class 5: standardising by the spread the residuals have turns two
outliers into a fake systematic excursion.

4. **required** — **"a decomposition you will meet in Class 10 and an exercise at the bottom of
this page" is two dead pointers.** `book/wk10-relatedness.qmd` (781 lines, written) frees the
independence of random effects *from each other* — relatedness, phylogeny, heritability — and
contains no between-versus-within decomposition; `docs/the-climb.md` confirms that is its subject.
And none of the nine exercises asks for the decomposition: 1 is the repeatability screen, 2 is the
two fits, 3–4 the origin, 5 the caterpillar, 6 the mixture, 7 the null, 8 maximal-or-parsimonious,
9 the outliers. Further reading item 7 repeats the claim — *"the between-versus-within decomposition
this chapter deliberately did not do"* — so a reader who takes the chapter at its word has nowhere
to go. This is the same defect the Class 4 review recorded as its finding 8, and given finding 1 it
is the load-bearing one.

5. **required** — **mass is 58% between-bird, so Class 6's promise is not kept by this predictor,
and the mechanism as stated does not follow from the chapter's own table.** Class 6's rule, in its
own summary: *"With a predictor that varies mostly **between** groups, ignoring the grouping makes
standard errors too small … With a predictor that varies mostly **within** groups the neglect can go
the other way, which is Week 7."* Chapter 7's own repeatability table gives R = 0.5824 for Weight —
**41.8% within, 58.2% between** — so mass is "mostly between" by Class 6's own phrasing, and the
sentence *"Mass is 42.0% within-bird, so the grouping is now soaking up between-bird noise rather
than manufacturing evidence"* asks the reader to apply the rule on the wrong side of it. The
direction is real (0.0547 → 0.0512 in DRM; 0.0548 → 0.0491 in lme4 ML) but the mechanism is not the
within-share: adding `(1|BirdID)` cuts the residual SD from **2.13 to 1.1256**, a 3.6-fold drop in
residual variance, and that precision gain on the within-bird contrasts outweighs the information
lost on the between-bird ones. The honest general statement is that the direction is a trade-off
between those two effects and is **not** determined by which side of 50% the within-share falls on
— which is a correction to Class 6, not an instance of it. (Separately: *"the standard error falls
by a factor of 0.936"* — a *factor* of 0.936 is a multiplication; "falls to 0.936 of its former
value" or "by 6.4%" is what is meant.)

6. **required** — **the conditional-residual explanation drops the correction Class 6 spent a cell
making.** Chapter 7: *"Class 6 removed **one** number per bird and lost a factor of the square root
of one minus one over k. This model removes **two** numbers per bird … Spend two of three points on
a bird's own line and there is very little left over to call a residual."* Class 6's own summary
bullet says the opposite is what actually happens: *"Shrinkage then pushes the spread back **up**,
because a shrunk prediction removes slightly less than the group's real effect."* The numbers
confirm Class 6 and not Class 7. Pooled over this design (85 birds at k = 2, 55 at 3, 31 at 4), the
naive two-parameter factor √(1 − 2/k) is **0.5049 — a 49.5% shortfall**; the observed shortfall is
**22.9%**, i.e. 77% of σ survives where the naive arithmetic predicts 50%. For reference Class 6's
own executed pair was 0.9039 vs 1.0969, a 17.6% shortfall against its naive one-parameter prediction
of 20.8%. So chapter 7 is 5.3 points shorter than chapter 6, not the 29 points its stated reasoning
implies, and **"there is very little left over to call a residual" is contradicted by the chapter's
own number** — most conspicuously for the 85 birds with k = 2 and 170 rows, which would contribute
exactly zero residual if two numbers were really being removed. One line makes the point properly:
shrinkage is doing more work here than the degrees of freedom are.

7. **required** — **Class 5 is invoked for the opposite of what Class 5 executed.** Chapter 7:
*"Class 5 spent an hour teaching you that a correct model routinely puts a good deal more than that
outside a band of this kind, so the count on its own is unremarkable."* Class 5 executed both nulls
and its summary states the result: plain normal samples give *"a median of one point outside, a mean
near seven and a ninety-fifth percentile near a quarter of the sample"*, but simulating from the fit
and **refitting** — the null Class 5 says applies — gives *"a median of nought, a mean near one and
a ninety-fifth percentile of about seven"* out of 163, and Class 5 calls the first null
*"anticonservative by a factor of five"*. Chapter 7 excuses 25 of 459 by appealing to the null Class
5 told the reader to distrust. Given finding 3 the count is not the point, but the citation is
backwards, and the chapter has `slope_study` on the same page and never calibrates the diagnostic
against its own null — which is Class 5's actual doctrine (*"the null must include the fitting"*).

8. **required** — **further reading item 8 names the wrong file, and the file it names would
mislead.** *"DRM.jl documentation, the `capabilities` table and the `(1 + x | g)` rows. Which
families accept a random slope and which reject it, stated plainly."* `docs/src/capabilities.md`'s
random-effect section has no per-family rows at all — it lists a single line,
`Correlated intercept+slope | src/gaussian_ranef.jl | **Tested**`, with no family qualification,
which is exactly the impression a reader must not form given that `Binomial()` refuses. The
per-family statements are in **`docs/src/families.md`** ("the correlated form `(1 + x | g)` is not
implemented", for Tweedie and CumulativeLogit among others). DRM.jl's own
`docs/design/capability-status.md` records that `docs/src/capabilities.md` *"is a real,
evidence-cited audit but is **stale**"*. The quoted error string is right — `src/binomial.jl:115`
is `error("Binomial() supports \`(1 | g)\` on the mean")`.

9. **required** — **Bates et al. (2015) is annotated with the one claim its abstract excludes.**
Item 3: *"the symptom is exactly the degenerate covariance this chapter met at an uncentred
origin."* The abstract says: *"We show that failure to converge typically is **not** due to a
suboptimal estimation algorithm, but is a consequence of attempting to fit a model that is too
complex to be properly supported by the data."* Their degeneracy is data-driven and specification-
driven; the chapter's uncentred degeneracy is coordinate-driven — the chapter itself proves it is
"one model written down five ways", and finding 2 shows lme4 converges on it. So the annotation
imports Bates et al.'s thesis onto the one case their thesis rules out. Everything else in item 3
is supported ("maximal models are routinely over-parameterised", "the data cannot support them",
"a preprint, never in a journal"). Item 1's annotation is fully supported by its abstract (which
says random-intercept-only models give *"too narrow confidence intervals and a substantially
inflated type I error rate"*) — that one is exact.

10. **required** — **Stram & Lee has a published correction and the chapter does not cite it.**
`Corrections: Variance Component Testing in the Longitudinal Mixed Effects Model`, *Biometrics*
(1995) **51**:1196, doi:10.2307/2533038. The chapter makes Stram & Lee (1994) the reference that
overrules the engine, and its moral is *"Read the assumptions on a correction before you take its
p-value"*. Item 5 should be "Stram & Lee (1994, and the 1995 correction)". Two related gaps in the
same item: it is the only journal reference with **no DOI** (10.2307/2533455), and OpenAlex records
its pages as 1171–1171, not the 1171–1177 the chapter prints — so the header's claim that items 1–5
were checked against OpenAlex "(year, journal, volume, pages)" is not quite true of item 5. The page
range as printed is correct; the provenance sentence is what needs the caveat.

11. **required** — **"notice where they are tightest: near the middle, at centred mass zero" is
false, and false for a reason the chapter has just taught.** The spread of the 171 predicted bird
lines is √(V₀₀ + 2xV₀₁ + x²V₁₁) over the BLUP covariance, minimised at
x* = −Cov(û₀, û₁)/Var(û₁) = **−2.339 g**, not 0. Measured: SD 1.4460 at x = −2, **1.4791 at −1,
1.5493 at 0**, 1.6518 at +1, 2.4702 at +6. Under the fitted Σ the minimiser is −0.939. The pencil is
narrowest **left** of centre precisely because ρ is positive — the same tilt the chapter spends
twenty minutes on. And the stated reason (*"that is where the intercept lives and the intercept is
the best-determined thing about a bird"*) would put the minimum at zero only if ρ were zero. This is
a claim about a figure checked by nothing; two lines of arithmetic make it right and make it teach
the ρ lesson twice.

12. **required** — **the 0.0400 rate is quoted with no Monte Carlo standard error, in the chapter
whose own summary bullet demands one.** The bullet reads *"Report simulated rates with their Monte
Carlo standard error"*; the cell prints an MC SE for the two throw rates and for the 0.0620 among
survivors, and none for `0.0400`. It is **0.0098** over 400. That matters to the reading: with
0.0620 ± 0.0150 and 0.0400 ± 0.0098, both intervals cover the nominal 0.05, so Itchy's *"the truth
is between the two"* is right but the honest summary is "we cannot distinguish either bound from
nominal", not a bracket. (Two useful extras from the re-run, which the chapter's own data already
contain: the empirical 95th percentile of the null LR statistic among survivors is **5.4251**
against the Stram & Lee reference's **5.1384**, and *"conservative for the opposite reason"* is
loose — 0.0400 is the correct rate under the chapter's own stated assumption that a throw never
rejects.)

13. **required** — **the control world is not the random-slope fit's own data-generating process.**
`slope_study(V, …)` builds the alternative from `simulate(ri_fit)` — residual noise at
**σ = 1.1256**, the random-intercept fit's σ — with the random-slope fit's covariance `V` added on
top. The random-slope fit's own σ is **1.0179**, so the "control" is a 10.6% over-dispersed hybrid,
and *"a world where the slopes do differ, with the covariance this chapter estimated"* describes
half of it. Using `ri_fit` is correct for the **null** column and wrong for the alternative one.
The direction is conservative (extra noise raises the throw rate and widens σ̂_1), so the argument
survives, but *"the median recovered σ_1 is 0.4266 against a truth of 0.4308"* is a recovery claim
about a model that was never fitted. One clause fixes it, or one substitution: `simulate(rs_fit)`.

14. **required** — **`fig-spaghetti-data` gives every bird two different colours.** The cell draws
points with `color = Cycled(mod1(i, 4))` — the house theme's four-colour palette, `theme_itchy.jl`
line 70 — and joins them with `color = (Makie.wong_colors()[mod1(i, 7)], 0.7)`, a different
seven-colour palette. The two never agree, and it is visible in the rendered SVG: orange points
joined by a yellow line, teal points joined by a blue line. The figure's whole job is to let a
reader follow one bird's captures through a crowded middle, and the colour cue is broken. It also
imports Wong colours into a single figure, off the book's palette.

15. **suggestion** — **the chapter's own simulation contains the evidence for Jaro's verdict and
does not read it out.** The saved LR statistics answer the question the section is about. Among the
258 surviving null replicates the rejection rate at α = 0.05 is **0.0388 naive, 0.0620 Stram & Lee,
0.0891 for the engine's q = 2 mixture** — the mixture Jaro convicts rejects at nearly twice nominal
on this design, which turns "read the docstring" from advice into a measurement. Three lines,
already-computed inputs.

16. **suggestion** — **"three points, two of which had almost the same mass" understates the
chapter's own worst bird.** TA14600's three captures are at 28.5, 28.0 and 28.2 g — **all three**
within half a gram, within-bird SD 0.2517 against the file's average of 0.9907. The stronger
sentence is on the page for the taking. Related: the per-bird reliability
λ_j = σ_1²/(σ_1² + σ²/S_xx,j) has median **0.2764** and mean 0.2995 over the 86 birds, so
*"a bird keeps roughly a quarter"* is right as a shrinkage factor as well as as an SD ratio — worth
saying, since the SD ratio 0.2461 also carries the OLS slopes' own sampling noise (mean sampling SD
of an own-slope is **0.8621**, against σ_1 = 0.4308; predicted SD(OLS) = √(σ_1² + mean sampling
var) = 1.1142 against the observed 1.0857).

17. **suggestion** — **`fig-spaghetti-data`'s caption describes a different figure from its title.**
The caption opens *"Every bird measured at least three times, its own captures joined in order of
mass"*; the figure's own title says **"15 birds, each caught at least three times"**, because the
cell takes every sixth of the 86. `fig-slope-shrinkage`'s caption states its every-sixth rule
explicitly; this one should too. On the substance the figure does teach its claim — segments of
visibly different steepness, some rising and some falling, which is what Toto says.

18. **suggestion** — **"It is the same crash you saw in the second cell" is true of 133 of the 142
failures, not all of them.** Classified by exception type over the same 400 null replicates:
**133 `DomainError`, 9 `AssertionError`** (the line-search `isfinite(phi_c)` failure, the same one
DRM.jl throws at origin 5 g). A clause, and it strengthens finding 2's point that the boundary
announces itself in more than one way.

19. **suggestion** — **Objective 5 promises a stronger result than the chapter delivers.** *"say why
a group with three measurements keeps **almost none** of the slope its own points suggest"* against
an executed answer of *"roughly a quarter"* and a median reliability of 0.28. "Little of" would
match the chapter.

20. **suggestion** — **the marginal-residual comparison is not quite like for like.** `std(rq)` =
2.1105 is compared with `mean(sqrt.(marg))/σ` = 2.0917; the functional that matches an SD is
**`sqrt(mean(marg))/σ` = 2.1063**, which is nearer (and the raw `(y − fitted)/σ` is 2.1415). By
Jensen the printed version is always the smaller of the two. The beat survives — *"about 2.1 times
too wide"* is right either way — but the sentence *"that is the ratio the model itself predicts"*
is claiming an identity that the printed line does not quite compute.

21. **suggestion** — **two comparisons of unlike sets, and one "always" that is a population
statement.** `std(mod)` = 0.2672 is over the **86** birds with k ≥ 3, while σ_1 = 0.4308 is a
parameter for all **171** (the spread over all 171 predicted slopes is 0.2404). And *"The second is
always the smaller of the two, in every mixed model you will ever fit"* is true of
Var(BLUP) = σ_1² − E[posterior var] as a population identity, but the *sample* SD of a handful of
BLUPs is a random quantity and need not obey it. "Always, in expectation" costs two words.

22. **suggestion** — **the file's granularity is not mentioned, and Exercise 9 needs it.**
`Wing` is a whole number in **82%** of rows, so σ = 1.0179 mm is roughly the recording granularity —
worth one clause in a section that tells the reader not to *"quote σ from this fit as if the
residuals were symmetric"*, and worth putting in front of the student who is sent to Exercise 9 to
decide whether the two low rows are broken primaries or dropped digits. Naming the two rows in the
exercise answer (TA14548 at Wing 67.0; TA14531 at 76.0, with all their siblings) would also let the
exercise be marked.

23. **suggestion** — **the chapter omits itself from its own count of executed chapters.**
`status_note` reads *"One of seven executed chapters (2, 3, 4, 5, 6, 8 and Appendix A)"* — seven
items, none of them chapter 7. The same stale string is in chapters 1, 5, 9 and 10, so this is
repo-wide bookkeeping rather than a chapter-7 defect, but this is the chapter where it reads oddest.

24. **suggestion** — **the "five fits" sentence.** *"Fit the same model **five** times, moving the
origin of mass each time … Zero grams, twenty grams, twenty-four, the mean, thirty"*, and later
*"These are not five models. This is one model, written down five ways."* The executed cell fits
**four** (`origins = [20.0, 24.0, w_bar, 30.0]`) and its own printed line says *"largest AIC
difference across the **four**"*. Zero grams is the fit that threw, two sections earlier, and is not
one of the five. Item 1 permits word-form counts in dialogue; it does not permit a word-form count
that the cell below contradicts. Given finding 2, the cleanest repair is to add `0.0` to `origins`
with `#| error: true` and let the reader watch the ρ column and the crash arrive in the same table.

**Verified.** All six journal citations are exact on OpenAlex — Schielzeth & Forstmeier,
*Behavioral Ecology* 20:416–420, doi 10.1093/beheco/arn145 (OpenAlex year 2008; the chapter already
says so); Barr et al., *JML* 68:255–278; Bates et al., arXiv:1506.04967, preprint, never journalled;
Matuschek et al., *JML* 94:305–315; Stram & Lee, *Biometrics* 50:1171; Self & Liang, *JASA*
82:605–610 — and five of the six annotations are supported by title or abstract, the exception being
item 3 (finding 9). Items 6–8 fall outside the header's "items 1 to 5 were checked" claim; item 6
does check out, item 8 does not (finding 8).

## Re-derivations (all independent of DRM.jl unless stated)

- **lme4 2.0.1, `REML = FALSE`, on `data/2012/BodySize.csv` after `dropmissing([:Wing, :Weight])`**:
  459 rows, 171 birds, 85/55/31 at k = 2/3/4, median 3, w̄ = 27.564924. Repeatability table
  reproduced to four decimals for all five columns. `Wing ~ wc`: 0.4430 (0.0548). `+ (1|BirdID)`:
  0.1844 (0.0491), σ_u 1.8510, σ 1.1256, logLik −883.5938, AIC 1775.1876, 4 parameters.
  `+ (1 + wc|BirdID)`: 0.1816 (0.0608), σ_0 1.7177, σ_1 0.4308, ρ +0.2354, σ 1.0179,
  logLik −872.6137, AIC 1757.2273, 6 parameters. REML: 1.7233 / 0.4353 / +0.2335 / 1.0180 /
  −875.5085. (The fixed-effect SEs differ from DRM's 0.0512 and 0.0618 because lme4's ML SEs
  condition on the variance components and DRM's come from the joint Hessian; the estimates and
  likelihoods agree exactly.)
- **Origin-shift algebra, by hand**: `a = w̄ − c`, Var(u₀′) = σ_0² − 2aρσ_0σ_1 + a²σ_1²,
  Cov(u₀′, u₁) = ρσ_0σ_1 − aσ_1². Predicts 3.3070/−0.86321, 2.0167/−0.56100, 2.2134/+0.65660 at
  20/24/30 g and 11.5913/−0.98958 at 0 — matching the chapter's table and lme4's uncentred fit
  (11.5899/−0.98957) to four decimals, and confirming σ_1, σ, β₁ and the likelihood are exactly
  invariant.
- **Σ at origin 0**: [134.3529, −4.9412; −4.9412, 0.185575]; eigenvalues 0.0038446 and 134.5346;
  det 0.5172; `isposdef` true; cond 34,993.
- **DRM.jl at other origins** (engine): fits at 10, 15, 18, 20 g, all at logLik −872.6137, ρ down to
  −0.9739; throws `AssertionError` at 5 g and `DomainError` at 0.
- **Boundary study re-run in DRM.jl at seeds 707/909, 400 replicates** (14.1 s): 142 and 34 throws
  (0.3550 ± 0.0239, 0.0850 ± 0.0139); median σ_1 0.0900 and 0.4266; below 0.01, 0.0426 and 0.0000;
  0.0620 ± 0.0150 among 258 survivors; 0.0400 (± 0.0098) overall. Additionally: null LR median
  0.9288, 95th 5.4251, 99th 9.1707 against the Stram & Lee 95th of 5.1384; rejection among survivors
  0.0388 naive, 0.0891 for the engine's q = 2 mixture; failures were 133 `DomainError` and
  9 `AssertionError`.
- **Mundlak refits** (lme4 ML): `wdev + wbar + (1|id)` → within 0.0490 (0.0563), between 0.5832
  (0.0927), difference 0.5343 ± 0.1085 (z 4.92), logLik −871.9449, AIC 1753.8899;
  `wdev + wbar + (1 + wdev|id)` → σ_0 1.7621, σ_1 0.2541, ρ +0.5690, σ 1.0695, logLik −867.5692,
  AIC 1749.1383; random-slope LR after separating 8.7516 (Stram & Lee p 7.836e−3, AIC drop 4.7516).
  Between-bird variance in mass 2.4253 against a mean within-bird variance of 1.3952.
- **Worm plot**: 25 of 459 outside the same pointwise band, 2 at negative and 23 at positive
  theoretical quantiles, ranks 406–437. Restandardised by MAD (0.7283): 2 outside, both left.
  Dropping the two |z| > 3 rows and restandardising the remaining 457: 0 outside.
  `sd(cond)` = 0.7845 with them, 0.7185 without (shortfall 22.9% → 29.4%). Counts: 2 below −3,
  8 below −2, 9 above +2, none above +3. `sqrt(mean(marg))/σ` = 2.1063 against the chapter's
  `mean(sqrt(marg))/σ` = 2.0917.
- **BLUP line pencil**: Cov(û₀, û₁) = 0.13512, Var(û₁) = 0.05778 → minimum spread at
  wc = −2.339 g; SD 1.4460 / 1.4791 / 1.5493 / 1.6518 / 2.4702 at wc = −2 / −1 / 0 / +1 / +6.
- **Residual degrees of freedom**: pooled √(1 − 2/k) factor 0.5049 (49.5% shortfall), √(1 − 1/k)
  factor 0.7921 (20.8%); Class 6's executed pair 0.9039 vs 1.0969 (17.6%).
- **Engine source**: `chibar.jl:14–17` and its docstring state the 0.5/0.5 (q = 1) and
  0.25/0.5/0.25 (q = 2, **independent**) mixtures, exactly as Jaro reports them;
  `gaussian_ranef.jl:423,444` show `l11 = exp(a); l22 = exp(b)` and `logdetM += log(dM)`;
  `binomial.jl:115` carries the quoted refusal string.
- **Figures**: all four SVGs rendered at 2.2× and looked at.

## One question for Shinichi

Finding 1 puts a real fork in front of the chapter, and the answer is not obvious to me.

The between-versus-within decomposition is not a side note here: on this file it is the *whole* of
the mass effect (within 0.0490 ± 0.0563; between 0.5832 ± 0.0927), it costs one parameter, it beats
the chapter's own preferred model on AIC, and it cuts the chapter's headline σ_1 from 0.4308 to
0.2541 and more than halves its LR statistic. But it is also a different rung's idea, the chapter is
already dense, and the random slope survives the repair.

Three ways out, and I do not think they are equally good:

1. **Keep the model, fix the pointers.** Replace the Class 10 clause with an honest one — "this file
   cannot separate the two questions, and neither can today's model; the decomposition is in Gelman
   & Hill chapter 12" — write the exercise the chapter promises, and add one sentence saying σ_1 and
   ρ are conditional on that conflation. Cheapest, and leaves every number on the page.
2. **Do the decomposition, in one cell, at the end.** Print the four-row table from finding 1 and
   let Momo ask why σ_1 moved. This is the *best page in the chapter* if it works — it is a genuine
   disagreement with a named mechanism and a computable boundary, which is what the conventions
   reserve their best pages for — but it costs ten minutes of class time and it partly undercuts the
   hour's headline number in the last five.
3. **Change the covariate.** Nothing else in the file has both a real within-bird signal and a clean
   separation, so I do not think this is available; tarsus is the counter-example the chapter already
   uses, and bill width is the trap it already teaches.

My own view is 2, framed as the chapter's own honesty paying off rather than as a retraction — the
chapter has already told the reader the blend exists, so showing it is the natural landing, and the
"σ_1 was doing two jobs" mechanism is a better ending than "not everyone shares a slope". But that
is a teaching judgement about the arc of chapters 6–10, not a statistical one, and it is yours.

Secondary, and much smaller: finding 2 means the chapter can either keep the crash as a
*conditioning* lesson (honest, and still ends at "centre, always") or keep it as a *boundary* lesson
(which is what the simulation at the end actually establishes, on the null, correctly). It is
currently trying to be both, and they are different failures. If you want one sentence to carry it,
"the optimiser lost the determinant to floating point, and the reason is where zero is" does the job
and stays true.

---

# Re-review (3d8bc9b, branch `book/preview-machinery`)

Read against the new frozen outputs and the re-rendered spaghetti SVG, with the whole chapter
re-derived from scratch a second time: every model refitted in **lme4 2.0.1 under `REML = FALSE`**,
the Σ-at-each-origin table rebuilt by hand from the shear formula rather than from the chapter's
cell, the worm-plot band recomputed with the exact normal quantile, the 400-replicate alternative
world re-run in DRM.jl at seed 909, and the separated fit run in **both** engines.

**Every executed number in the rewrite reproduces exactly.** Not one mismatch. The new four-model
table (−883.5938 / −872.6137 / **−871.9449** / **−867.5692**, AIC 1775.1876 / 1757.2273 /
**1753.8899** / **1749.1383**, npar 4 / 6 / 5 / 7); the two slopes and their *z*s
(within **+0.0490 SE 0.0563 z 0.87**, between **+0.5832 SE 0.0927 z 6.29**, differing by 0.5343) —
and note that lme4 and DRM.jl agree on these standard errors to four decimals, which they do *not*
do for the unsplit fit; **21.2977** against **17.9603**; LR **8.7516** with Stram & Lee
**7.836e−03**; σ_1 **0.2541**, ρ **+0.5690**, a **41.02%** cut; AIC still favouring the slope by
**4.7516**; the misspecification share **60.1481%**. The Σ table is exactly right at all six
origins — det **0.5172** everywhere (as it must be: the shear matrix [1 a; 0 1] has determinant 1,
so det Σ′ = det(T)² det Σ, and Itchy's one-line reason is correct), minimum eigenvalues
0.003845 / 0.005762 / 0.009532 / 0.046705 / 0.174647 / 0.103840, condition numbers
34993 / 15577 / 5693 / 237 / 17 / 48, ρ −0.98957 up to +0.65659, `isposdef` true at every one — and
DRM.jl's own verdicts reproduce (`DomainError` at 0, `AssertionError` at 5, and fits at 10, 20,
27.565 and 30 all at logLik −872.6137). The pencil cell reproduces (Cov +0.13512, Var(û₁) 0.05778,
*x*\* **−2.3387**, and all six spreads 1.4979 / 1.4437 / 1.4791 / 1.5493 / 1.6518 / 2.4702); the
shortfall cell reproduces (0.7921 / 0.5049 / 0.7707); the pooled residual SD **2.1253** is the ML
figure, correctly (OLS gives 2.1300); the worm splits reproduce (25 = **2 left + 23 right**, MAD
0.7283 → **2**, drop the two and restandardise → **0**, tails 8 / 9 / 2 / 0, SD 0.7845 with them and
0.7185 without); and the new control world reproduces to the replicate — **11 of 400 threw, 0.0275
± 0.0082, all 11 `DomainError` and 0 other, median σ_1 0.4210**. `wdev` and `wbar` are orthogonal to
3.7e−14 and sum to `wc` to machine zero, as the comment claims. Both GitHub issue links resolve
(#753 and #762 return 200; a fabricated issue number 404s, so the check has teeth). Item 1 passes
cleanly and by a wide margin: **102 inline `{julia}` expressions**, up from 47, and the only bare
numerals left in dialogue are "9:00 am", Class and Exercise numbers, two citation years, two issue
numbers, and code fragments (`(1 | g)`, `m21^2`). The "five fits / four executed" contradiction is
gone.

Three things deserve credit rather than comment. The DomainError beat is now **better than the
correction I asked for**: printing Σ's determinant, minimum eigenvalue, condition number and
`isposdef` at origins the engine accepts *and* refuses, then the engine's verdict beside them, makes
the diagnosis falsifiable on the page instead of asserted — and "moving zero is a shear, and a shear
has determinant one" is the right one-line reason, which I had not supplied. The Class 6 correction
is staged as Itchy being caught by his own rule by a student reading his own table back at him, which
is a better use of the finding than a corrected sentence would have been. And the last section does
not soften the arithmetic: *"60% of the evidence I showed you for random slopes was evidence for a
misspecified fixed part"* is the number, said plainly, with the survival of the finding argued from
the p-value rather than asserted.

## Verdict

**Pass** — all three blocking findings are closed, and closed with executed arithmetic rather than
with hedged prose; all eleven required findings are closed; eight of the ten suggestions are closed
and one is a repo-wide item. Five required items remain, and they are the wake of the repair rather
than the original defects: three sentences that the rewrite made stale and did not revisit, one
number the new closing section promised to name and did not, and a rounding idiom that prints a false
tenths digit three times.

## The original findings, one by one

| # | was | now |
|---|---|---|
| 1 | blocking — within/between conflation | **closed** — new closing section, and it goes further than the finding asked |
| 2 | blocking — `DomainError` misdiagnosed | **closed** — and made falsifiable with two new printed tables |
| 3 | blocking — worm read on the wrong side | **closed** — split, MAD, drop-and-restandardise, both rows named |
| 4 | required — Class 10 and the missing exercise | **closed** — Exercise 3 is now the decomposition and Itchy points at it by number; item 7 rewritten |
| 5 | required — mass is 58% between | **closed** — staged as a correction to Class 6, with the residual-SD column added to the cell |
| 6 | required — the df story for the shortfall | **closed** — new `shortfall` cell prints 0.7921 / 0.5049 / 0.7707 and the *k* = 2 reductio |
| 7 | required — Class 5 cited backwards | **closed** — Momo catches it and Itchy retracts it explicitly |
| 8 | required — `capabilities.md` | **closed** — item 8 names `families.md` and warns off `capabilities.md` by name |
| 9 | required — Bates et al. annotation | **closed** — item 3 now quotes the exclusion and reassigns the example to the last section |
| 10 | required — Stram & Lee 1995 correction | **closed** — cited with its DOI, and the header's OpenAlex claim narrowed to year/journal/volume/DOI |
| 11 | required — the pencil "tightest at zero" | **closed** — new `pencil` cell; the reason is now ρ, said three times |
| 12 | required — 0.0400 without its MC SE | **closed** — ± 0.0098, and "400 replicates cannot separate either from 0.05" replaces the bracket |
| 13 | required — hybrid control world | **closed** — `slope_study` now takes the fit, and each world is one model's own generator |
| 14 | required — two colours per bird | **closed** — one palette, one colour per bird (but see N6) |
| 15 | suggestion — the three references unmeasured | **closed** — 0.0388 / 0.0620 / 0.0891 printed with MC SEs, and Jaro's ordering measured |
| 16 | suggestion — "two of which had almost the same mass" | **changed, and now wrong** — see N2 |
| 17 | suggestion — spaghetti caption | **closed** — the every-sixth rule and the one-colour rule are both in the caption |
| 18 | suggestion — 9 `AssertionError`s | **closed** — split by exception type in both worlds, and given its own beat |
| 19 | suggestion — Objective 5 "almost none" | **closed** — "only a little" |
| 20 | suggestion — `mean(sqrt)` vs `sqrt(mean)` | **closed** — both printed, the right one named in the dialogue, Jensen in the comment |
| 21 | suggestion — unlike sets, and "always" | **closed** — "in expectation", with the 86-vs-171 comparison spelled out |
| 22 | suggestion — granularity and the named rows | **closed** — 82% whole numbers, both identifiers in the text and in Exercise 9 |
| 23 | suggestion — Stram & Lee DOI and pages | **closed** |
| 24 | suggestion — `status_note` omits chapter 7 | **not closed** — unchanged; still "One of seven executed chapters (2, 3, 4, 5, 6, 8 and Appendix A)". Repo-wide, so not this chapter's to fix alone |
| 25 | suggestion — "five fits" | **closed** — "four origins", "not four models … four ways" |

## New findings

**N1. required — the R box still says ρ "kills the fit at a far-away origin", which the chapter
retracted three sections earlier.** Itchy, closing the translation box: *"Everything this chapter
said about ρ — that it depends on where zero is, that it changes sign, that it kills the fit at a
far-away origin —"*. That third clause is exactly the claim the origins section demolishes at
length: Σ is positive definite at every origin, the engine sails past ρ = −0.97389, and the failure
is a determinant cancellation in `log(dM)` that has nothing to do with the size of ρ. The chapter now
contains its own correction and its own uncorrected restatement, twenty lines apart, and the
restatement is in the box a reader is most likely to skim. One clause: "that it changes sign, and
that its far-away origin is where this engine's determinant gives out".

**N2. required — the bird named as "the bird this goes worst for" has an own-slope of exactly
zero.** The new `own-slopes` cell computes the *tightest* bird by within-mass SD and labels it
correctly in a comment ("The worst-conditioned bird"). The dialogue then welds it to the wrong
sentence: *"One of them is nearly -5.79 … It is three points and a line drawn through them, and the
last printed line names the bird this goes worst for: TA14528 was caught three times at masses
spanning less than a gram … Divide a difference in wing by a difference in mass that small and you
can get any slope you like."* **TA14528's own least-squares slope is 0.0000** — wings 79, 77, 79 at
masses 25.3, 25.5, 25.7 — and it ranks **82nd of 86** by |own slope|. It is one of the *tamest*
birds in the file, offered as the illustration of getting any slope you like. The −5.79 bird is
**TA14600** (wings 75, 78, 76 at masses 28.5, 28.0, 28.2; within-bird SD 0.2517), which is also the
bird with the largest own-versus-model gap and is the one the caterpillar puts at the far left. This
was introduced by the repair of finding 16, so it is a fresh defect, not a survivor. The better fix
is not a substitution but the contrast the cell has already earned: **two birds with almost the same
tiny mass spread, 0.2000 and 0.2517, one of which came out at exactly 0 and the other at −5.79** —
which is what "you can get any slope you like" actually means, and it is one extra `@printf`.

**N3. required — the "what do I write in a paper" paragraph is now stale, and it is advice.**
It sits at the end of the simulation section, *before* the decomposition, and says: *"That you fitted
a random slope, that it improved AIC by 18.0, that a boundary-corrected likelihood-ratio test against
the random-intercept model gave a p below the number you name…"*. The next section shows that the
18.0 and the 9.9e−6 are the blended model's, that **60.1%** of that evidence was fixed-effect
misspecification, and that the honest figures are **4.75** and **7.8e−03** on the separated model. A
reader who follows the paragraph as written reports the inflated pair. This is the highest-stakes
sentence in the chapter — it is the one that tells them what to publish — and it is the one place the
last section does not come back to. Two candidate repairs: move the paragraph after the decomposition,
or leave it where it is and have Momo ask it again in the last section ("then what do I write?"),
which would also let Itchy retire the framing question of the hour, *"when a bird is heavier, is its
wing measured longer"*, whose answer on this file turns out to be "not detectably" and which is
currently never re-answered in the words it was asked in.

**N4. required — the shrinkage ratio is not among the numbers the last section promises to name, and
it moves further than σ_1 does.** Itchy's contract, set at the top: *"Everything between here and
there is fitted on the blended model, and I will tell you exactly which numbers move when we pull it
apart."* The last section names σ_1, ρ, the LR and the AIC. It does not name the shrinkage ratio,
which is Objective 5's number and the answer to *"A bird keeps roughly a quarter of the slope its own
points suggest."* Refitted on the separated model, with the per-bird slope on `wdev` and each bird's
own least-squares slope computed on the same column (identical to the within-bird slope on `wc`,
since `wbar` is constant within a bird), the ratio is **0.1400**, not 0.2461 — **roughly a seventh,
not roughly a quarter** — and the spread of all 171 separated slopes is **0.1480** against
σ_1 = 0.2541. Both engines agree to four decimals. That is a bigger proportional move than σ_1's own
41%, and it is a more surprising one: halving σ_1 more than halves what the model is willing to say
about any individual bird. One row added to the last section's table, or one sentence, keeps the
promise — and it strengthens the section rather than weakening it.

**N5. required — `round(x, digits = 0)` prints a false tenths digit, three times, and once it
contradicts the cell three lines above it.** The idiom `string(round(100 * p, digits = 0), "%")`
returns a `Float64`, so it renders as "48.0%", "82.0%", "60.0%" — one decimal place of apparent
precision, and in each case the wrong one:

   | spoken | true value | source |
   |---|---|---|
   | bill width "48.0%" within | **48.24%** | `share_within[:BillW]` |
   | Wing whole in "82.0%" of rows | **81.92%** | `mean(Wing .== round.(Wing))` |
   | "60.0% of the evidence … was misspecification" | **60.15%** | and the cell above prints **60.1%** |

   The third is the one that matters: the `mundlak` cell prints `share of the blended LR that was
   fixed-effect misspecification: 60.1%` and Itchy says 60.0% three lines later, from the same
   quantity. A reader who compares them sees the chapter disagree with itself about its own headline
   correction. The fix is the idiom the chapter already uses elsewhere — `round(Int, ...)`, which
   gives "48%", "82%", "60%" and claims no decimal — or `digits = 1` throughout. (The fourth instance,
   the 41.0% cut, is right by luck: the true value is 41.02%.)

**N6. suggestion — the colour fix works for segments and not yet for birds.** One palette per bird is
right and the caption's claim ("drawn in that bird's own single colour") is true, so finding 14 is
closed. But `theme_itchy`'s palette has **four** colours and the cell draws **fifteen** birds, so
`palette[mod1(i, 4)]` gives each colour to three or four birds, and the rendered figure has four teal
segments and four grey ones crossing in the same crowded middle. A segment and its points now match,
which was the defect; colour still does not identify a bird, which was the purpose. Drawing every
twelfth bird instead of every sixth (eight birds, two per colour) or cycling marker shape alongside
colour would finish it.

**N7. suggestion — "the first of two [crashes] in this chapter" is stale.** The `provenance` field
was correctly updated to *"including the one that fails and the two that catch a failure and report
it"*, but Itchy's line under the uncentred cell still says *"it is the first of two in this
chapter"*. There is now exactly one `#| error: true` cell; the origins cell catches and tabulates two
more, and the study catches 142 and 11. The front matter and the dialogue now count differently.

**N8. suggestion — "Here Σ genuinely is collapsing" is inferred about fits that were never
observed.** The distinction the chapter draws between the two `DomainError` mechanisms is right and
important, and the uncentred half of it is demonstrated (Σ printed, `lme4` fitting it). The null half
is not: the replicates that threw returned nothing, so "Σ genuinely is collapsing" is a plausible
inference about unobserved fits, stated as fact, in the same breath as a paragraph about not
pattern-matching. It is measurable — the surviving null fits have median σ_1 = 0.0900 with 4.3% under
a hundredth, and refitting the throwers with a floor on the Cholesky diagonal would show where they
were heading. A hedge would cost four words; the measurement would cost a cell.

**N9. suggestion — one summary bullet mixes the two models.** *"Maximal or parsimonious … the maximal
model is better by AIC, its correlation sits under two standard errors from zero, and most of the
case for it evaporated when the fixed part was specified properly."* The SE that makes the middle
clause true (0.1383, from the R box) belongs to the **blended** ρ of +0.2354; after the repair ρ is
+0.5690 and the chapter never prints an SE for it. The bullet is about the model after the repair and
borrows a standard error from before it. Either say "the blended model's correlation" or drop the
clause, which the bullet does not need.

## Re-derivations (all independent of the chapter's own cells)

- **lme4 2.0.1, `REML = FALSE`**: all four models in the new table, to four decimals, plus the two
  fixed slopes and their standard errors and *z*s, the AIC differences 21.2977 and 17.9603, the two
  LR statistics 21.9603 and 8.7516, both Stram & Lee p-values, the 41.02% σ_1 cut, the 60.1481%
  share, and the 4.7516 the separated model still gives the random slope.
- **DRM.jl 0.7.1**: the same separated fits, identically (logLik −871.9449 / −867.5692, AIC
  1753.8899 / 1749.1383, within +0.0490 SE 0.0563, between +0.5832 SE 0.0927, σ_1 0.2541,
  ρ +0.5690).
- **Σ shear table, by hand** from the fitted V rather than from the chapter's `shifted`: det 0.5172
  at all six origins, and all six minimum eigenvalues, condition numbers, correlations and `isposdef`
  verdicts as printed. The invariance of det Σ under the origin shift is exact, not numerical.
- **Alternative world, DRM.jl, 400 replicates from `rs_fit` at seed 909**: 11 throws (0.0275 ±
  0.0082), 11 `DomainError` and 0 other, median σ_1 0.4210.
- **Worm plot** with the exact normal quantile rather than `erfinv_approx`: 25 outside, 2 at negative
  and 23 at positive quantiles; MAD 0.7283 → 2; drop the two |z| > 3 rows and restandardise the
  remaining 457 → 0; tails 8 / 9 / 2 / 0; SD 0.7845 with and 0.7185 without.
- **Pencil**: Cov +0.13512, Var(û₁) 0.05778, *x*\* −2.3387, spreads 1.4979 / 1.4437 / 1.4791 /
  1.5493 / 1.6518 / 2.4702.
- **Shortfall**: 0.7921, 0.5049, 0.7707. **Pooled residual SD**: 2.1253 (ML) against 2.1300 (OLS) —
  the chapter's is the ML one and is right for a `drm` fit.
- **New, for N2**: TA14528's own slope is 0.0000 (wings 79, 77, 79 at 25.3, 25.5, 25.7), rank 82 of
  86 by |own slope|; TA14600's is −5.7895 (wings 75, 78, 76 at 28.5, 28.0, 28.2), within-bird mass SD
  0.2517, and it is also the bird with the largest |own − model| gap.
- **New, for N4**: separated-model shrinkage, in both engines — own SD 1.0857, model SD 0.1521,
  ratio **0.1400**; spread over all 171 separated slopes 0.1480 against σ_1 0.2541.
- **New, for N5**: 48.2350%, 81.9172%, 60.1481%, 41.0194% — the four quantities passed to
  `digits = 0`.
- **Figures**: the re-rendered spaghetti SVG looked at; the other three are byte-identical to
  e1a63b8 and were looked at in the first pass.
- **Links**: `DRM.jl` issues #753 and #762 both resolve; a control request for issue #999999 returns
  404.

## One question for Shinichi

The rewrite answers my last question by doing the harder thing, and it works. So this one is
smaller and is about where the honesty lands.

The chapter now ends by taking 60% of its own headline apart, and it does that *after* the reader has
spent an hour learning to read σ_1, ρ, the caterpillar and the boundary test on the blended model.
Itchy defends the ordering — *"you cannot see what a random slope is while you are also learning to
split a covariate in two"* — and I think that defence is right. But N3 and N4 are both symptoms of
the same thing: the last section retracts the numbers it happens to name, and the chapter has no
mechanism for the ones it does not. There are at least four (β₁'s reading, the shrinkage ratio, the
paper advice, and the framing question), and a fifth reader will find a sixth.

Two ways to make the ordering safe rather than lucky:

1. **A closing ledger.** End the last section with one small table — *what I said at the time / what
   it is on the separated model* — covering β₁, σ_1, ρ, the LR, the AIC, the shrinkage ratio and the
   paper advice. Seven rows, all already computed or one line away, and it converts a promise into an
   artefact. It also makes the chapter's own discipline visible: this is what "I will tell you
   exactly which numbers move" looks like when it is kept.
2. **Label at the point of use, not once at the top.** Put a short marker — "(blended model)" — on
   the two or three numbers that actually move, where they are said. Cheaper, but it seeds the
   chapter with reminders of a section the reader has not reached.

I would do 1. It is one cell, it closes N3 and N4 together, and a chapter whose moral is *"fit the
decomposition first, then ask whether the within slope varies"* earns the right to that moral by
showing the full cost of not having done so, rather than the four instalments of it that came to
mind.

The smaller version of the same question: N1, N7 and N9 are all sentences that survived a rewrite
which corrected the passage next to them. A grep of the chapter for its own retracted claims — ρ
killing the fit, the crash count, the blended standard error — would catch all three, and is worth
doing once more before this lands.

---

## Third pass (b43e3a0)

Checked the changed passages against the new freeze, re-derived the ledger and the two birds
independently in lme4 ML, and looked at the re-rendered spaghetti SVG.

**The ledger's seven numbers are all correct**, and all seven match my own refits to four decimals:
β₁ 0.1816 → 0.0490, σ_1 0.4308 → 0.2541, ρ 0.2354 → 0.5690, LR 21.9603 → 8.7516, AIC gain
17.9603 → 4.7516, shrinkage ratio 0.2461 → 0.1400, p 9.910e−06 → 7.836e−03. `ratio_sep` is built
the right way — the per-bird slope from `sep_rs` against each bird's own least-squares slope on the
same 86 birds — and reproduces at 0.1400 in both engines. **Both birds are correct**: TA14528 at
masses [25.3, 25.5, 25.7], within-bird SD 0.2000, own slope exactly 0.0000; TA14600 at
[28.5, 28.0, 28.2], SD 0.2517, own slope −5.7895, both now computed from the data rather than named
by hand.

| item | now |
|---|---|
| N1 — R box's "kills the fit" | **closed** — "its far-away origin is where this engine's determinant gives out" |
| N2 — the wrong bird named | **closed** — and closed with the contrast, which is better than a substitution |
| N3 — stale paper advice | **closed** — see below |
| N4 — shrinkage ratio undisclosed | **closed** — in the ledger and in the Summary bullet (0.246 → 0.140) |
| N5 — false tenths digit | **closed** — zero `digits = 0` left, nine `round(Int, …)`; "48%", "82%", "60%", "41%" |
| N6 — palette recycled | **closed** — 8 birds, 4 colours, 2 each, and the caption says why; the two birds sharing a colour are far apart in every pair |
| N7 — "first of two" crashes | **closed** — "the only one that stops the page" |
| N8 — "Σ genuinely is collapsing" | **not closed** (suggestion; unchanged) |
| N9 — borrowed SE in the summary bullet | **closed** — "the blended model's correlation" |

**On leaving the original paper paragraph in place: it reads as the class's arc, not as a
contradiction** — and I would not move it. Three things make it work. Momo quotes the earlier answer
back verbatim (*"An hour ago you told me to report the blended AIC and the blended p"*), so the first
paragraph is retrieved as evidence rather than left lying; Itchy answers *"And that was wrong"* and
names which numbers the misspecification inflated most; and the chapter had already bracketed the
whole span (*"Everything between here and there is fitted on the blended model, and I will tell you
exactly which numbers move"*). It is also the fourth time in the hour that Itchy is caught by his own
rule — Class 6's within-share test, the DomainError story, the Class 5 citation, and now this — so
being wrong in public and then being shown the arithmetic *is* the chapter's grammar by this point,
not a lapse in it. Correcting the first paragraph in place would cost the beat and teach less.

**Verdict: Pass.** All five wake items closed, one suggestion (N8) standing, and one new required
item below.

**T1. required — "the shrinkage ratio moved the most, proportionally" is contradicted by the ledger
three lines above it.** Itchy, immediately after the table: *"Every one of them moved, and the
shrinkage ratio moved the most, proportionally — from 0.2461 to 0.1400"*. Ranked by proportional
move, the ledger's own six rows are ρ **+141.7%**, AIC gain **−73.5%**, β₁ **−73.0%**, LR **−60.1%**,
shrinkage ratio **−43.1%**, σ_1 **−41.0%**. The shrinkage ratio is fifth of six. The claim the
finding actually supports is the *second* half of the same sentence, which is true and is the
interesting one: *"a bigger move than σ_1's own"* — 43.1% against 41.0%, so halving σ_1 more than
halves what the model will say about any one bird. Delete four words ("moved the most,
proportionally —") and the sentence is right and loses nothing.

**T2. suggestion — one ledger row label carries two different baselines.** "AIC gain over
(1|BirdID)" is `aic(ri_fit) − aic(rs_fit)` in the left column and `aic(sep_ri) − aic(sep_rs)` in the
right, i.e. each model against *its own* random-intercept counterpart. That is the right comparison
and the one the section argues from, but the shared label names only one of the two baselines, and a
reader could take 4.75 as the separated model's gain over `wc + (1|BirdID)` — which is 26.0493, in
the separated model's favour. "AIC gain over its own (1|BirdID)" fixes it.
