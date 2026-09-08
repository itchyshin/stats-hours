# Chapter 5 — adversarial statistical review (as executed)

## Review (12f0f31)

Read against the frozen outputs and all four rendered SVGs, with the whole chapter re-derived from
scratch and without DRM.jl: hand-written IRLS for all four Poisson fits, a hand-rolled randomised
quantile residual reproducing the engine's RNG stream one `rand` per row, my own worm-plot parts
built both with the chapter's `erfinv_approx` and with the exact normal quantile, and my own null
simulations. **Every executed number reproduces exactly**, to the last printed digit: `171`/`163`;
the sparrow line `1.4173 / 1.4132 / 1.0029 / 1.0029 / 2.620e-14`; the three count-residual rows
(`2.2282 +0.2115 32`, `1.2483 +0.2159 32`, `1.3067 −0.2095 163`), the fitted range `2.5580` to
`5.1389` and the floor `−5.139` / `−4.073`; the worm counts `107` and `51` at seed 1 and `13` and
`9` at seed 2, identical under the exact normal quantile; the null triple `1 / 7.26 / 38` and
`0.0010` / `0.0115`; the seed sweep `1.2575–1.3935`, `78 / 98.9 / 119`, `0 of 200`; the simulated
impossible-bird means `8.83` and `0.61` (analytic `8.8800` and `0.6321`); `1.5679 → 1.1064` with
their nulls; `739.9864 / 653.6131 / 652.8208` and all three AICc values; `−87.1656` and `−0.7923`;
the ΔAIC null `+1.5463 / +0.9380 / 0.1620 / −3.4909 / 0.1050`; `89.1656` and `2.7923` with their
p-values; `1.2618 [1.1490, 1.3857]`, `1.0889 [0.9859, 1.2027]`, `1.1527`, `1.1688`; the 150-row
statistic `21.96374` and its `2.7785e-6`. The pre-rendered R block is right too — I re-ran
`data/ch5/ch5-r-box.R` against drmTMB 0.7.0 and got `739.9864232`, `652.8207945`,
`-1.599374 ×3`, `sd = 1.248268` and the same `anova()` abort, byte for byte; `anova.drmTMB`
does refuse unconditionally, exactly as the box claims. All six citations check on OpenAlex. Item 1
passes cleanly: 76 inline `{julia}` expressions, and the only bare numerals in dialogue are
"Class 2 / 3 / 4 / 8" and four citation years.

The arithmetic is immaculate. What is wrong is the reference distribution it is judged against, the
model that reference exonerates, and one sentence about the chapter next door.

## Verdict

**Block** — four failures, three of which converge on a single sentence. The chapter calibrates its
diagnostic against a standard normal sample when the object being judged is a *fitted* model's
residuals, which is anticonservative by a factor of five and reverses the verdict on the repaired
model; that verdict rests on one randomisation seed which 194 of 200 seeds contradict; the repaired
model is convicted outright by the second statistic the chapter's own Exercise 5 nominates; and the
chapter tells the reader that Class 4's repair was to free the spread, when Class 4 as shipped
teaches this exact mean-structure repair first, on this file, with these numbers.

## Findings

1. **blocking** — **the null the chapter simulates is not the diagnostic's null, and it is
anticonservative by a factor of five.** `null-envelope` draws `z = randn(rng_null, n_fem)` and calls
it "what the diagnostic looks like when the model is RIGHT". It is not: the residuals being judged
come from a *fitted* Poisson, and the chapter's own reference 1 says so in its abstract — quantile
residuals are exactly normal "**apart from sampling variability in the estimated parameters**". I ran
the diagnostic's actual null (simulate from the fit → refit → recompute the RQRs → run the chapter's
own two counters, 4000 draws):

   | null | median outside | mean | 95th pct | 95th pct as % of 163 |
   |---|---|---|---|---|
   | `randn` (the chapter's) | 1 | 7.26 | **38** | 23% |
   | RQRs at the true μ, no refit | 1 | 7.57 | 39 | 24% |
   | simulate → **refit** → RQR (age-only fit) | 0 | 1.32 | **7** | 4% |
   | simulate → **refit** → RQR (repaired fit) | 0 | 1.33 | **7** | 4% |

   The mechanism is exactly the one the chapter names and then mislocates. The enormous skew is the
   freedom of the whole worm to **shift**, and fitting an intercept removes it: centring the same
   `randn` samples alone drops the mean from 7.09 to **1.16** and the 95th percentile from 36 to
   **6**. Discreteness is not the cause — RQRs computed at the true μ without refitting give
   7.57 / 39, indistinguishable from `randn`. Three sentences fail as a result. *"The ninety-fifth
   percentile is 38 … **a correct model can put close to a quarter of its points outside the band and
   be behaving perfectly**"* — for a fitted model it is 7 of 163, about 4%. *"`13` happens in **18%**
   of correct-model draws, so **there is nothing left in the picture to convict it with**"* — under
   the diagnostic's own null, P(≥ 13) = **0.0227** (91 of 4000) and P(run ≥ 9) = **0.0227**. That is
   a rejection at the five per cent level, not a clean bill of health, and it is the chapter's
   headline verdict on its own repaired model. (The age-only verdict moves the other way and
   strengthens: P(≥ 107) goes from 0.0010 to **0 of 4000**.) Objective 3 is *"Calibrate a diagnostic
   by simulating **its own** null rather than by eye"*, and the machinery is already on the page —
   `null-daic` refits both models in every invented world, four cells later.

2. **blocking** — **the repaired model fails the chapter's own headline check, on the statistic
Exercise 5 nominates.** Exercise 5 tells the reader to pick "a fact about your organism the model was
never told — an upper limit it should respect, **a number of zeros**, a maximum, a number of ties".
Run the chapter's own three-line recipe with zeros on the chapter's own repaired fit: the file has
**30** zeros of 163; `Fledglings ~ Age + logEgg` expects **15.49** and simulates a mean of 15.33
(SD 3.32); **0 of 4000** invented worlds reach 30. The observed count is 4.4 simulated SDs out. (The
age-only model expects 7.96 — also 0 of 4000. The maximum is unremarkable in both: P(max ≥ 10) =
0.91.) So the model the chapter exonerates — *"there is nothing left in the picture to convict it
with"* — is convicted decisively by the second statistic a reader is instructed to try, and the
excess zeros are visible in `fig-worm-repaired` as the run of 9 points below the band at theoretical
quantiles −1.75 to −1.35. This is not a defect to hide: it is the best page the chapter could have.
Pearson X²/df on the same fit is 1.1064 with P = 0.235 — a pass — while zeros give P < 0.00025 on
the same model and the same 1000 worlds. That is the chapter's own bullet, *"a check you pass is much
weaker than a check you fail"*, demonstrated rather than asserted, and it points straight at Class 6:
too many zeros and too few middling broods is what unmodelled between-female heterogeneity looks
like.

3. **blocking** — **the repaired model's worm counts are a single-seed headline, and 194 of the 200
seeds say the opposite.** The `seed-stability` cell — the right idea, and the chapter's best
instinct — is run on `pois` only. Over 200 randomisation seeds on `pois2` the count outside runs
**5 to 48, mean 22.6**, and the chapter's seed 2 gives **13, the 18.5th percentile**; the RQR SD runs
**1.0609 to 1.2223, mean 1.1155**, against seed 2's 1.0844. Measured against the model's own null
(finding 1, 95th percentile 7), **194 of the 200 seeds reject**. So *"From `107` points outside to
`13`"* and *"the residual spread is still `1.084`, which is `1.5` Monte Carlo standard errors above
one"* are both the low end of the chapter's own randomisation, and the seed-averaged spread of 1.1155
is 2.3 null-SDs above one rather than 1.5. The chapter states the rule in its own summary — *"A
verdict that changes with the seed is not a verdict"* — and then quotes an unrepeated seed for the
one verdict that turns on it. This is the Class 4 re-review's N2 recurring one rung later, on the
model whose acquittal depends on it.

4. **blocking** — **"it is not the one Class 4 taught" is false about the Class 4 in this repo.**
Itchy: *"the fix is in the column it never saw, and I want to be exact about what kind of fix it is,
**because it is not the one Class 4 taught. Class 4's repair was to free the spread** — a second
formula in the box, a family with a dispersion parameter in it. This is a **mean-structure** repair"*,
and the summary repeats it: *"Extra scatter in a count can be a family that lied about the variance —
Class 4's repair, a second formula in the box — or a predictor missing from the mean."* Chapter 4 at
HEAD teaches the mean-structure repair **first**, on this file, and its own summary bullet is **"Look
for an exposure before you blame the family."** It runs `females.logEgg = log.(females.EggNo)` and
`drm(bf(@formula(Fledglings ~ Age + logEgg)), Poisson(); data = females)`; it prints the same
`0.9503 [0.7343, 1.1664]`, the same `739.9864 → 652.8208`, the same `1.5679 → 1.1064`, the same
impossible mass **8.88 → 0.63** (Class 5's simulated 8.83 and 0.61 are the Monte-Carlo restatement of
those two analytic numbers), the same *"an offset is precisely this coefficient pinned at one"*, and
the same engine gap with its issue link (**#727**, which Class 5 omits). Momo's line in Class 4 is
*"As an offset. I have read ahead."* — she is written in Class 5 as never having met the column.
Three things follow: the sentence is false; the chapter's central narrative beat is a re-discovery
presented as a discovery; and a reader who did Class 4 in order is told that Class 4 taught the
opposite of what it taught. This is the ownership question the Class 4 re-review closed on, answered
by accident and in the wrong direction.

5. **required** — **"the number outside is not five per cent of anything" is contradicted by the
chapter's own printed mean.** Under the reference the chapter actually simulates, the *expected*
number outside is **7.26 of 163 = 4.45%** — which is 2Φ(−2) × 163 = 7.42 to within Monte-Carlo error,
i.e. precisely the pointwise rate Toto quoted. The envelope is well calibrated pointwise; what is
wrong is treating a mean as a description of a single plot when the median is 1 and the 95th
percentile is 38. So Toto is right on average and useless about one picture, and *"you are wrong, but
not in the direction you think"* is right for the wrong reason. Once finding 1 is fixed the sentence
becomes true in the *other* direction — for a fitted model the mean is 1.33, so 5% is an
over-estimate — which is a better beat and needs the correct null to earn it.

6. **required** — **"one long systematic excursion" is two, of opposite sign, and the shape has a
name the chapter cites and never uses.** `fig-worm-poisson` at seed 1 has four runs outside the
band: **48 below** (ranks 7–54), one below, **51 above** (ranks 85–135) and 7 above — 49 points below
the band and 58 above it. A single excursion cannot be "on both sides", and the `longest_run` of 51
is the *upper* run, not the visually dominant left dip. What the picture actually shows is a scale
error: a least-squares line through (theoretical quantile, deviation) has **slope 0.2891** against
SD − 1 = **0.3067**. That is van Buuren and Fredriks' own result — offset ↔ median, **slope ↔
variation**, curvature ↔ skewness — and reference 2 is the paper the chapter cites for the plot. It
also settles Itchy's *"Three numbers, all saying the same thing"* and *"Two counters, one verdict"*:
the SD, the count and the run are **one** thing, the slope, not two counters agreeing (the Class 4
review's finding 12 reappearing). The repaired plot is the same shape attenuated — slope 0.0726
against SD − 1 = 0.0844, with the surviving run of 9 below the band at quantiles −1.75 to −1.35 — so
*"The long systematic excursion is gone"* should read *"shorter, and the same shape"*.

7. **required** — **the simulated ΔAIC null IS the likelihood-ratio test, and the chapter presents
them as different in kind.** For one extra parameter on the same data, ΔAIC = 2 − LR exactly.
Every number in `null-daic` is therefore a χ²₁ number: the median +1.5463 is 2 − median(χ²₁) =
**1.5451**; "negative in 16.2%" is P(χ²₁ > 2) = **0.1573**; and *"our own 0.79 turns up in 10% of
worlds where age does nothing"* is P(χ²₁ ≥ 2.7923) = **0.0947** — the chapter's own printed LRT
p-value, two cells later, arrived at by simulation. Itchy then says *"The second number is the
**likelihood-ratio test**, and it is the one that gives you a reference distribution rather than a
ranking"*, having just built that reference distribution. The beat that is available is better than
the one written: a simulated ΔAIC null **is** the parametric-bootstrap likelihood-ratio test, and
0.105 against 0.0947 is a measurement of how far the χ² approximation can be trusted at n = 163.

8. **required** — **"the interval excludes 1.262. That is a finding" compares an interval with a
point estimate from the same data — and understates its own evidence.** 1.2618 carries a standard
error too, and the two age coefficients are strongly positively correlated because both are driven by
the same age variation. A nonparametric bootstrap (4000 resamples, both models refitted in each)
gives the difference log 1.2618 − log 1.0889 = **0.1474**, SE **0.0412**, **z = 3.58**, and a 95%
interval for the ratio of the two rate ratios of **[1.072, 1.260]**, excluding one. The improper
comparison implies z = 0.1474 / 0.0507 = **2.91**. So the conclusion is right, the route is not, and
the correct route is *stronger* — which is worth the two lines in a chapter whose thesis is that a
verdict needs an error bar rather than an adjective. The machinery is already there: the chapter's own
mediation arithmetic closes to three decimals, 0.0852 + 0.9503 × log 1.1688 = **0.2334** against the
total 0.2325.

9. **required** — **the chapter simulates three different nulls and never says they are different.**
`null-envelope` uses `randn` — no model, no fit. `simcheck-pearson` simulates from the fit but scores
every invented world against the **original** fitted μ, with no refit. `null-daic` refits both models
in every world. The middle choice is exactly why the simulated X²/df mean is 1.0126 and not 1: it is
n/(n − k) = 163/161 = **1.0124**, and the repaired model's 1.0200 is 163/160 = **1.0188**. Itchy reads
it as *"Its simulated mean is 1.013, so yes — and now you know that rather than trusting a textbook"*,
when what he has measured is the fixed-μ value of a statistic whose observed version was computed at
the *fitted* μ. Refitting each world moves the null mean to ≈ 1.00 and the repaired model's
P(sim ≥ obs) from 0.235 to **0.163**. The verdict survives; the doctrine does not, four cells after
Objective 3 announced it.

10. **required** — **the `guard-silence` comment is contradicted by its own code, and the demo never
shows the harm.** The comment reads *"# Two fits of the SAME model on DIFFERENT rows"*; `pois_sub` is
`Fledglings ~ Age` on 150 rows and `pois2` is `Fledglings ~ Age + logEgg` on 163. Different rows
**and** different predictors, so 21.9637 is a real log-eggs effect contaminated by a row artefact, not
the row artefact the comment promises. The direction is benign too: the correct comparison on 163 rows
gives **89.1656**, so dropping 13 rows from the reduced fit *understates* the evidence four-fold and
still returns p = 2.8e−6 — a reader is shown a contaminated answer that happens to agree with the
truth. The sharp demonstration is one number away. Fit the reduced model on the first 140 rows and the
statistic is **−28.11**; on 120 rows, **−127.65**. `lrtest` returns it, and because `comparison.jl`
computes `ccdf(Chisq(Δdof), max(statistic, 0))` the p-value comes back as exactly **1.0** — a quantity
that cannot occur under nesting, reported without complaint. That also softens *"nothing in the
comparison can complain about it"*: the `statistic` field complains loudly once the row drop is large
enough, and is silent only inside the narrow window the chapter happened to pick.

11. **required** — **"model comparison survives the Class 6 repair unchanged" is false for AIC, for
the same reason it is false for the LRT.** The front box: *"Everything here about residuals,
simulation and model comparison survives that repair unchanged, and two things do not: the standard
errors, and the likelihood-ratio test, which meets a boundary the moment a variance component is what
you are testing."* A variance component on the boundary breaks AIC's 2k penalty in exactly the same
way — the effective number of parameters is not k, which is why conditional AIC exists at all.
Naming the LRT and exempting AIC in the same sentence is the one place a reader is actively misled,
and Class 8 is where they will find out.

12. **required** — **reference 6's annotation contradicts the chapter's own executed simulation.**
The annotation: *"a parameter that explains nothing **still shifts AIC by about two**"*. Itchy, from
the cell: *"Its typical value is **1.55, not two** — so 'two units' is the ceiling on a useless
parameter's damage, not its usual size."* Arnold's abstract is on Itchy's side — such models are
"within 2 AIC units (ΔAIC ≤ 2)" *because* the 2-unit penalty is not overcome, i.e. the shift is less
than two. One clause fixes the annotation and it is the chapter's own sentence.

13. **required** — **reference 2's annotation is narrower than the abstract, and drops the result the
chapter needed.** *"Read it for what the detrending buys: the paper's case is that deviations you
cannot see against a diagonal are obvious against a flat line"* is not in the abstract. What the
abstract does say is *"The fit of each parameter curve is closely related to particular features in
the worm plot, namely its offset, slope and curvature"* — which is precisely the reading finding 6
shows this chapter's own two figures demanding. The chapter cites the paper that would have named its
picture, and annotates it with a claim the paper does not make.

14. **suggestion** — **`0.0010` is two draws.** `mean(null_out .>= out_p)` = 0.0010 is **2 of 2000**
(MC SE 0.0007); the run figure 0.0115 is 23 of 2000. Quoted as *"0.1% of correct-model draws"* and
*"1.2% of them"* in the chapter that teaches error bars on simulated quantities.

15. **suggestion** — **3.49 is a noisy tail quantile.** *"one world in forty has a useless parameter
winning by `3.49` AIC or more"*: the asymptotic 2.5th percentile of ΔAIC is 2 − χ²₁(0.975) =
**−3.024**, and my 4000-draw simulation gives −3.141. The chapter's −3.4909 from 1000 draws is about
1.4 Monte-Carlo SE high. The summary's *"more than three units"* is safe; the dialogue's 3.49 is a
digit the seed owns.

16. **suggestion** — **"Pearson residual SD 1.0029" cannot be anything else.** `sigma(gauss)` is the
ML estimate (divisor n) and `std` uses n − 1, so the ratio is forced to be
√(171/170) = **1.002937** — which is what is printed, to seven digits. It reads like a diagnostic
passing and is an algebraic identity. One clause turns it into a point about divisors, which this book
already has a box about.

17. **suggestion** — **"The third is a cloud" is wrong about the picture.** All three panels of
`fig-three-residuals` are four vertical columns, because `Age` takes four values; what separates the
third is that its columns are *continuously filled*, not that it is a cloud. The caption gets this
exactly right ("fall on stripes … a continuous distribution"); Toto's line does not.

18. **suggestion** — **the impossible-bird p-value has a closed form.** P(no impossible row) =
∏ᵢ cdf(Poisson(μ̂ᵢ), EggNoᵢ) = **0.5278**, against the chapter's 0.5390 from 1000 draws (MC SE
0.016). Worth one line in the chapter that insists a simulated tail probability carries an error bar.

19. **suggestion** — **"about a sixth" is a seventh.** 1.1527 is a 15.3% increase; a sixth is 16.7%.

20. **suggestion** — **"Two more refusals exist" — there are four.** `comparison.jl` also throws on
penalized (MAP) fits (`_map_compare_guard`: a shrunk variance component means the LR statistic has no
χ² reference) and on fits with different marginal approximations (`_marginal_compare_guard`: a VA
`loglik` is an ELBO, not a Laplace marginal). Both are later-chapter material, but the sentence reads
as an inventory.

21. **suggestion** — **`residuals(fit; type = :quantile)` does not error without an `rng`.** It
defaults to `Random.default_rng()` and silently uses the global stream. The chapter says
**"Pass the `rng`"** four times and never says what the omission costs, which is the one thing a
reader will find out the hard way — and it is the Class 3 review's finding 5 in a new place.

22. **suggestion** — **`fig-simcheck`'s panels have different y-scales.** Left runs to 200, right to
about 560, with the y-label suppressed on the right. Both hold 1000 worlds so the areas are equal and
the heights are not comparable; a shared axis, or one clause in the caption, removes the trap. (Both
panels do carry their own ticks, so this is a legibility note, not an error — the figure teaches its
caption.)

23. **suggestion** — **`update(fit, newformula; data)` is listed and never used.** All three nested
fits are typed out in full, which is fine, but the bullet promises a verb the chapter does not
demonstrate.

**Verified.** All six citations are exact on OpenAlex — Dunn & Smyth, *JCGS* 5:236–244,
doi:10.1080/10618600.1996.10474708; van Buuren & Fredriks, *Stat Med* 20:1259–1277, doi:10.1002/sim.746;
Gelman, Meng & Stern 1996 (indexed with title, authors and year and **no** journal, volume, pages or
DOI, exactly as the parenthetical says); Akaike, *IEEE TAC* 19:716–723, doi:10.1109/TAC.1974.1100705;
Burnham & Anderson, doi:10.1007/b97636 (OpenAlex records 2004, exactly as the annotation says);
Arnold, *JWM* 74:1175–1178, doi:10.2193/2009-367 — and four of the six annotations are supported by
title or abstract. The three-residual taxonomy is right and the Gaussian coincidence is real to
2.6e−14. The **detrended** framing is correct and the caption says so, closing the Class 4 review's
finding 5 rather than repeating it. Counting the picture with the same `erfinv_approx` that draws it
is the right move and is carried over from Class 4 correctly. The `longest_run` counter is correctly
implemented (I reproduced 51 and 9 independently, and identically under the exact normal quantile).
The seed-stability cell is the chapter's best instinct and its verdict on the *age-only* model is
seed-proof under either null. `aicc` matches `aic + 2k(k+1)/(n − k − 1)` for all three fits.
`anova` really is an alias for `lrtest`; the argument-order guard, the REML guard and the
variance-component warning are all present and described accurately; `residuals` really does throw an
`ArgumentError` naming its two types. The R box is byte-exact on a fresh run and its claim that
`drmTMB::anova()` refuses **every** comparison is literally true of the source. The marginal /
conditional beat is the right beat and Class 4 does not contradict it. "Never accept the null" is
honoured, with the MDE and a positive statement, which closes the Class 3 and Class 4 lineage. And
Momo's impossible-bird statistic is the right kind of statistic, chosen for the right reason.

## Re-derivations (all independent of DRM.jl)

- Poisson fits (own IRLS): `Age` — logLik −367.9932, AIC 739.9864, AICc 740.0614; `logEgg` — −324.8066,
  653.6131, 653.6881; `Age + logEgg` — −323.4104, 652.8208, 652.9717, coefficients
  (−1.1695, 0.0852, 0.9503), SEs (0.2546, 0.0507, 0.1102), logEgg CI [0.7343, 1.1664].
  ΔAIC −87.1656 and −0.7923; LR 89.1656 (p 3.631e−21) and 2.7923 (p 0.0947).
- Rate ratios 1.2618 [1.1490, 1.3857] and 1.0889 [0.9859, 1.2027]; MDE exp(2.8016 × 0.0507) = 1.1527;
  `EggNo ~ Age` rate ratio 1.1688 (SE 0.0278). Mediation closes: 0.0852 + 0.9503 × 0.1560 = **0.2334**
  against the total 0.2325.
- Marginal − conditional log rate ratio **0.1474**, nonparametric bootstrap SE **0.0412** (4000
  resamples), z **3.58**, ratio-of-rate-ratios CI **[1.072, 1.260]**; the interval-versus-point
  comparison implies z = 2.91.
- Gaussian sparrows: residual SD 1.4173, ML σ 1.4132, ratio **1.002937** = √(171/170) exactly.
- RQR (own construction, one `rand` per row, matching `quantile_residuals.jl`): SD 1.3067 at seed 1
  and 1.0844 at seed 2; 107 / run 51 and 13 / run 9, identical with the exact normal quantile.
- Worm run structure, age-only seed 1: runs of (−) 48 at ranks 7–54, (−) 1, (+) **51** at ranks
  85–135, (+) 7 — 49 below, 58 above. Least-squares slope through (theo, dev) **0.2891** against
  SD − 1 = 0.3067. Repaired seed 2: (−) 2, (−) **9** at ranks 7–15 (quantiles −1.75 to −1.35), (+) 1,
  (+) 1; slope 0.0726 against SD − 1 = 0.0844.
- Envelope calibration, 20 000 draws: mean pointwise exceedance **0.0425**, expected count 6.92,
  against the nominal 2Φ(−2) = 0.0455 and 7.42; per-rank rate 0.022 at rank 1, 0.043 mid-sample.
- Null of the counters, 4000 draws each: `randn` mean 7.09 / 95th 36; centred `randn` **1.16 / 6**;
  centred and rescaled 0.28 / 2; RQR at true μ (no refit) 7.57 / 39; **simulate → refit → RQR** 1.32 / 7
  (age-only fit) and 1.33 / 7 (repaired fit), run 95th pct 5. P(≥ 13) = **0.0227** (91/4000),
  P(run ≥ 9) = **0.0227**, P(≥ 107) = **0** (0/4000). Null RQR SD mean 0.9931, SD 0.0538, against
  1/√(2n) = 0.0554.
- Seed sweep on the repaired fit, 200 seeds: outside **5 / 22.6 / 48**, seed 2's 13 at the 18.5th
  percentile; RQR SD **1.0609–1.2223**, mean 1.1155 (2.3 null-SDs above one). 194 of 200 seeds exceed
  the model's own 95th percentile of 7. Age-only sweep reproduces 78 / 98.9 / 119 and 1.2575–1.3935.
- Impossible birds: analytic expectations **8.8800** and **0.6321** (Class 4's printed 8.88 and 0.63);
  P(no impossible row | repaired) = ∏ cdf = **0.5278**.
- Zeros: observed **30** of 163; expected **7.96** (age-only) and **15.49** (repaired); simulated means
  7.96 (SD 2.77) and 15.33 (SD 3.32); P(sim ≥ 30) = 0 of 4000 in both. Maximum: observed 10,
  P(sim max ≥ 10) = 0.906 under the repaired fit.
- Pearson X²/df: observed 1.5679 and 1.1064. Fixed-μ null mean = n/(n − k) = **1.0124** and **1.0188**
  exactly (chapter: 1.0126, 1.0200). Refitting each world: null means 0.996 and 0.999, and the repaired
  model's P(sim ≥ obs) moves 0.235 → **0.163**.
- ΔAIC null: median 2 − median(χ²₁) = **1.5451**; P(< 0) = P(χ²₁ > 2) = **0.1573**;
  P(≤ −0.7923) = P(χ²₁ ≥ 2.7923) = **0.0947**; 2.5th percentile 2 − χ²₁(0.975) = **−3.0239**
  (mine at 4000 draws, −3.141).
- Guard: 150-row reduced fit logLik −334.3923, statistic **21.9637**, p 2.7785e−6, against the correct
  89.1656. Reduced on 140 / 120 / 100 / 80 rows gives **−28.11 / −127.65 / −227.38 / −317.94**, each
  returned with `pvalue = 1.0` by the `max(statistic, 0)` clamp.
- R box re-run on drmTMB 0.7.0 / R 4.6.0: `739.9864232`, `652.8207945`, `-1.599374 ×3`,
  `sd = 1.248268`, and the same `anova()` abort. `anova.drmTMB` aborts unconditionally.

## One question for Shinichi

Findings 2 and 4 are the same question wearing two hats, and it is the one the Class 4 re-review
asked: **what is Class 5's own subject?**

As written, Class 5 borrows Class 4's file, Class 4's two models and Class 4's discovery to carry
three lessons, and the borrowing is what breaks it. The exposure beat is Class 4's, it is done better
there, and repeating it forces Class 5 to say something false about Class 4 (finding 4) and to spend
its simulation section re-deriving a number Class 4 already printed. Meanwhile the statistic that
would have made Class 5's own point — **zeros: 30 observed against 15.3 expected, 0 of 4000 worlds** —
is sitting in the same file, nominated in the chapter's own Exercise 5, and never run.

Swapping them costs nothing and buys a great deal. Momo arrives having *already* paid the exposure in
Class 4 ("I put the eggs in last week"); Eddie asks how she knows the repaired model is any good; the
chapter's own worm plot says it is fine, its own Pearson statistic says it is fine (P = 0.235), and
the zero count convicts it at P < 0.00025 on the same 1000 simulated worlds. That is
*"a check you pass is much weaker than a check you fail"* demonstrated on one model in one cell,
which is the strongest version of this chapter's thesis and currently exists only as a bullet. It
also hands Class 6 its motivation on a plate: too many zeros and too few middling broods is what
unmodelled between-female heterogeneity looks like, and `BodySize.csv` is already promised in the
front box.

The cost is that the two worm plots stop being a before-and-after and become a *warning* — the
repaired model's plot looks clean, is clean by the count, and is wrong. Which is, I think, the better
chapter.

Two smaller decisions ride on the answer. Once finding 1 is fixed, the correct null makes the
envelope section shorter and blunter — a fitted model puts a median of 0 and a 95th percentile of 7
points outside, so a worm plot with a dozen points outside is already suspicious and Toto's "five per
cent" is an over-estimate rather than an under-estimate. Does the chapter keep the `randn` null on
the page as the *wrong* null, side by side with the right one — it is a two-line diff and it teaches
the sampling-variability caveat that reference 1 states in its own abstract — or does it just fix the
cell? And does the ΔAIC calibration (finding 7) get to say out loud that it has computed the
likelihood-ratio test by simulation, which would let the comparison section end on one idea instead
of two?

---

# Re-review (cdf70d2, branch `book/preview-machinery`)

Read against the new frozen outputs and all four rendered SVGs (byte-identical to `12f0f31` — the
captions changed, the pictures did not), with every new number re-derived from scratch and without
DRM.jl: hand-written IRLS throughout, my own randomised-quantile-residual construction, my own
`worm_slope` as a least-squares slope through (theoretical quantile, deviation), my own refit nulls
at 2000 draws in the chapter's own design, my own zeros null at 4000 draws, my own X² refit null and
my own row bootstrap.

**Every executed number in the rewrite reproduces.** Exactly, where the quantity is deterministic:
the slopes `+0.2891` / `+0.3067` and `+0.0726` / `+0.0844`; the below/above splits `49`/`58` and
`11`/`2`; the pointwise prediction `7.42`; `n/(n − k) = 1.0188`; the zeros expectation `15.4866`
printed as `15.49`; the exact impossible-bird expectation `8.8800` against a simulated `8.8340 ±
0.0699` (0.66 Monte-Carlo SE — the agreement Itchy claims); `dAIC −0.7923` against `2 − LR
= −0.7923` to every digit; the 140-row statistic `−28.1070` with `p = 1.0000`; the whole repaired
seed sweep (`1.0609`–`1.2223`, `5` / `22.6` / `48`, seed 2 at the 18th percentile); and the bootstrap
difference `0.1474`. And within Monte-Carlo error everywhere it is simulated:

| quantity | chapter | mine (independent) |
|---|---|---|
| naive null, outside: median / mean / 95th | 1 / 7.15 / 37 | 1 / 7.22 / 37 |
| naive null, draws ≥ 13 | 344 of 2000 | 346 of 2000 |
| refit null (age-only): median / mean / 95th | 0 / 1.24 / 7 ± 0.65 | 0 / 1.25 / 7 |
| refit null run: median / mean / 95th | 0 / 0.97 / 5 | 0 / 0.93 / 5 |
| refit null residual SD: mean / SD | 0.9971 / 0.0546 | 0.9951 / 0.0534 |
| draws ≥ 107 outside; run ≥ 51 | 0 / 0 of 2000 | 0 / 0 of 2000 |
| refit null (repaired): median / mean / 95th | 0 / 1.45 / 8 | 0 / 1.30 / 7 |
| repaired: draws ≥ 13 outside | 48 of 2000 (0.024) | 45 of 2000 (0.0225) |
| repaired: draws with run ≥ 9 | 52 of 2000 (0.026) | 47 of 2000 (0.0235) |
| zeros: sim mean / SD / P(≥ 30) / z | 15.70 / 3.32 / 0 of 1000 / 4.3 | 15.49 / 3.40 / 0 of 4000 / 4.26 |
| X² refit null: mean / P(≥ obs) | 1.0031 / 0.176 | 1.0007 / 0.169 |
| bootstrap: SE / z / CI | 0.0399 / 3.69 / [1.0715, 1.2569] | 0.0409 / 3.60 / [1.0754, 1.2622] |

Two claims about the world also check out. `SparrowSurvival.csv` really does carry `Mum` and
`BroodNo` (with `Dad`, `Year`, 1950 rows), and `BodySize.csv` really is the 460-row repeated-measures
file — so the front box's two file pointers are right. And **"too many zeros and too few middling
broods"** is exactly what the fit says: observed against expected by count is 30/15.5, 15/26.3,
19/29.7, 22/27.5, 31/22.3, 18/16.2, 15/10.8 — excess at zero, a deficit right through one to three,
excess again at four and six. That is a mixture signature, and it is a better sentence than the
chapter knows: the number is not on the page.

Item 1: **125 inline `{julia}` expressions**, up from 76. The only bare numerals in dialogue are
"Class 2 / 3 / 4 / 6 / 8", four citation years and the issue number `#727`.

The prose is much better and the arithmetic is now doing the work. One thing did not get rewritten
with the rest of it.

## Verdict

**Block** — one blocking finding, and it is the third consecutive chapter in which **Exercise 3**
preserves the error the prose has just fixed. All four original blocking findings are closed, closed
with executed arithmetic, and three of them are closed better than I proposed. Five required items
remain, none of which touches a verdict.

## The original findings, one by one

| # | was | now |
|---|---|---|
| 1 | blocking — the wrong null | **closed, and improved on** |
| 2 | blocking — zeros convict the repaired model | **closed** |
| 3 | blocking — single-seed headline | **closed** |
| 4 | blocking — "not the one Class 4 taught" | **closed** |
| 5 | required — "not five per cent of anything" | **closed** |
| 6 | required — "one long excursion" / the slope | **closed, except one phrase (N3)** |
| 7 | required — ΔAIC is the LRT | **closed, and it restructured the section** |
| 8 | required — interval versus point estimate | **closed** |
| 9 | required — three unnamed nulls | **closed in the summary, not in the dialogue (N2)** |
| 10 | required — guard comment and a toothless demo | **closed** |
| 11 | required — AIC and the boundary | **closed** |
| 12 | required — Arnold's annotation | **closed, better than I proposed** |
| 13 | required — van Buuren's annotation | **closed, except one phrase (N3)** |
| 14 | suggestion — `0.0010` is two draws | **closed** |
| 15 | suggestion — 3.49 is noisy | **closed** |
| 16 | suggestion — the 1.0029 identity | **not closed** |
| 17 | suggestion — "the third is a cloud" | **closed** |
| 18 | suggestion — a closed form for the check | **closed in a better place** |
| 19 | suggestion — "about a sixth" | **closed** |
| 20 | suggestion — "two more refusals" | **closed, but misfiled (N6)** |
| 21 | suggestion — the silent default `rng` | **closed** |
| 22 | suggestion — `fig-simcheck` y-scales | **not closed** |
| 23 | suggestion — `update` unused | **closed** |

**1 closed, and improved on.** Both nulls are now run side by side, the naive one is named as the
wrong one rather than deleted, and the *mechanism* is on the page in one sentence — "the intercept is
estimated from the very numbers it is then judged against — the worm is pinned through the middle by
construction". The 95th percentile has been given a bootstrap error bar (`7 ± 0.65`), which I did not
think to ask for, and `0 of 2000` is reported with the rule of three — *"the most you may say is
smaller than about three in two thousand"* — which closes finding 14 in the same clause. The
Dunn–Smyth abstract is quoted for the caveat, which is the right authority.

**2 closed.** `simcheck-zeros` is the cell I wanted and it does more than I asked: it runs on the
*same 1000 worlds* as the figure, so the pass and the fail are genuinely one experiment on one model,
and it ends by naming the next model and the file that supports it. *"That is the honest ending of a
diagnostic — not 'the model is fine', not 'the model is wrong', but 'here is the thing it does not
believe, and here is the file you need'"* is the best sentence in the chapter.

**3 closed.** `seed-stability-repaired` reports the range, the plotted seed's percentile within its
own randomisation (18th), and 191 of 200 rejecting. My own sweep is identical; the 191 depends on
this model's null 95th percentile landing at 8 rather than 7 (mine gives 194 at 7), so the count is
Monte-Carlo-sensitive at ±3 while the conclusion is not remotely.

**4 closed.** Momo now says *"This is last week. I convicted this model in Class 4"*, Itchy credits
Class 4's own bullet verbatim, #727 is cited, and — better than a deletion — the repetition is turned
into the chapter's own lesson: Class 4's **exact** 8.8800 against this class's **simulated** 8.8340,
agreeing inside the Monte-Carlo error of the second, with the moral that most statistics worth
choosing have no closed form. That is a use for the overlap rather than an apology for it.

**5, 7, 8, 10, 11, 12, 15, 17, 19, 21, 23 closed** as stated. Finding 7's fix restructures the whole
comparison section — the LRT is now computed *first*, the simulation second, and the identity printed
as its own line — and *"The simulation does not buy a second opinion; it buys the calibration of the
first one"* is the sentence. Finding 10's fix is now the best beat in that section: the 21.96 is
named as an underestimate of a real 89.17 *"so dropping thirteen rows understated an effect that is
real by about four-fold and still returned a decisive answer. You would never look twice"*, and the
140-row negative statistic arrives with **"That p-value is not a warning; it is the shape of the
bug."** Finding 12's fix ("Note the direction, because it is easy to get backwards") is better than
the clause I proposed.

**18 closed in a better place.** I asked for the closed form of the impossible-bird *tail
probability*; the chapter instead put the closed form of the *expectation* next to its simulated
counterpart with a Monte-Carlo SE, which teaches the same discipline and carries the Class 4 bridge
as well. Withdrawn.

## New findings

**N1 — blocking. Exercise 3 hands the reader back the naive null, in the chapter rewritten to kill
it.** Verbatim: *"Adapt this chapter's `n_outside` to your own quantile residuals and report the
count. Then **simulate 2000 standard normal samples of the same length** and report the median, mean
and ninety-fifth percentile of the same counter. Answer: what proportion of **correct-model draws**
are at least as bad as yours? Then say, in one sentence, **why the median is so far below the
mean**."* Every clause is the retired version. It instructs the student to build null (a); it calls
those draws "correct-model draws", the exact phrase the rewrite replaced; it asks them to score their
own **fitted** model's residuals against it, which is the error Itchy now says means *"most of the
worm plots I have squinted at were not fine"*; and its closing question has a false premise under the
null the chapter now teaches, where the median is 0 and the mean is 1.24, a gap of one point rather
than six. A student who does Exercise 3 as written will acquit the very model the chapter spends
three sections convicting — and will do it by 344 of 2000 rather than 48 of 2000.

   This is the third chapter running, and the third time it is **Exercise 3**: the Class 3 review
   blocked on *"Exercise 3 asks students to compute exactly these two differences … so it hands back
   the opposite of what was taught"*; the Class 4 review's finding 2 ended *"Exercise 3 sets this same
   comparison as homework."* The exercises are being written against the draft and not re-read against
   the rewrite. The fix here is three lines and the chapter has already written them: simulate from the
   fit, refit, recompute — and, if the naive null is kept, keep it the way the chapter now keeps it,
   as the wrong one, with the comparison as the point of the question.

**N2 — required. "That is the third different null on this page" is wrong, in the exchange that
teaches counting nulls.** Eddie says it, and Itchy answers *"It is, and you are right to count them,
because nobody ever does. One: the envelope null, which refits. Two: this one, which does not.
Three, at the end of the class: an AIC null which refits both models."* By the time that line is
spoken the page has run six simulation nulls of four distinct kinds, and the enumeration omits two of
them: the **naive normal-sample null**, which the chapter foregrounded a whole section earlier as the
wrong one, and the **refit X² null printed on the line immediately above**, which is what prompted
Eddie's question. The chapter's own summary has this right — *"This class simulates **four**, and they
differ by construction: normal samples with no model; simulate-and-refit for the envelope;
simulate-and-score-at-the-original-fitted-mean for the Pearson statistic …; simulate-and-refit-both-models
for ΔAIC"* — so the summary and the dialogue contradict each other, and the repair is to lift the
summary's own list into Itchy's mouth. Itchy's stated criterion, *"which parameters the null may
re-estimate"*, makes the naive null the most distinct of all four: it re-estimates nothing, because
there is no model in it.

**N3 — required. "to two decimal places" is false of both worms, and the gap it papers over is the
third term of the triple the chapter now quotes.** The summary: *"Both worms in this class have a
slope that matches their residual SD minus one **to two decimal places**."* They do not: `+0.2891`
against `+0.3067` is 0.29 against 0.31, and `+0.0726` against `+0.0844` is 0.07 against 0.08. Neither
pair agrees to two decimals; both agree to one. Reference 2's annotation carries the same
overstatement more softly — *"it is why the slope and the residual SD in this class keep printing the
same number"* — and Itchy says *"there they are, the same number twice"*. The relation is a very good
approximation, not an identity: the worm's slope is cov(sorted *r*, θ)/var(θ), which equals the SD
only when the quantile relation is exactly linear. I measured the discrepancy's own null — over 2000
iid normal samples of *n* = 163, slope − (SD − 1) has mean **−0.0030 and SD 0.0021** — so the observed
gaps of **−0.0176** and **−0.0119** are 7 and 5 null standard deviations, systematic rather than
noise. And the reason is on the page already: these residuals are skewed (−0.2095), and skewness is
*curvature*, the third of van Buuren and Fredriks' three features, which bends the worm and drags the
fitted line off the SD. Naming it costs one clause and completes the citation instead of rounding it
off. "Matches to one decimal place, and the small gap is the curvature" is both true and a better
lesson than "the same number twice".

**N4 — required. `fig-worm-repaired`'s caption states something about the executed output that the
executed output contradicts.** *"the surviving run below the band sits at the far left, at the lowest
theoretical quantiles, **and those points are females who fledged nothing**"*, with Itchy adding
*"The bottom of a count distribution is the zeros."* The run at ranks 7–15 has observed `Fledglings`
of **[0, 0, 1, 0, 0, 0, 0, 0, 3]** — seven zeros, a one and a **three**. Of the 13 points outside the
band the observed values are [0,0,0,0,1,0,0,0,0,0,3,5,6]: nine zeros, and one female who fledged
three, one who fledged five and one who fledged six (the last two are the *upper* pair). Only 21 of
the 30 lowest-ranked residuals are zeros. The reason is worth a clause rather than a correction: a
randomised quantile residual for a zero is drawn uniformly across the whole probability mass at zero,
so a zero can land anywhere below Φ⁻¹(F(0)) and a small non-zero count at a high fitted mean can land
below it. The inference is safe — the zeros check settles it independently — but this is a claim about
a picture written in prose and checked by nothing, in a chapter that computes `n_below` two lines
away and could as cheaply compute `count(females.Fledglings[ord[outside]] .== 0)`. It is the Class 4
review's finding 17 in a new place, and the honest version ("nine of the thirteen are females who
fledged nothing") is stronger than the absolute one.

**N5 — required. Exercise 9 cannot be run as written.** *"Then fit **the same model twice** on
different subsets of your rows, compare them, and paste the number it returns."* `lrtest` requires
`dof(full) > dof(reduced)` and throws otherwise, so two fits of the same formula trip the
argument-order guard the student met in the sentence before — which also makes the follow-up question
(*"why the engine can catch the first and cannot catch the second"*) unanswerable, because the engine
catches both, for the wrong reason. The chapter's own `guard-silence` cell does not do this: it fits a
**nested pair** with the reduced model on a subset, precisely because the same model twice would not
run. Lift that construction into the exercise.

**N6 — required. "All of them are Class 8's" misfiles one of the four refusals.** Itchy now names all
four — the REML guard, the marginal-approximation guard, the penalised-fit guard and the
variance-component warning — which closes finding 20, and then says *"All of those belong to models
with random effects in them, so all of them are Class 8's."* The first half is true. The second is not
for the penalised one: `_map_compare_guard`'s own docstring names `drm_phylo_penalty` as what triggers
it, and `docs/the-climb.md` puts relatedness and phylogeny at **rung 10**, not 8. A reader who follows
the pointer to find that refusal explained will meet REML and boundaries and not phylogeny. One clause
("the penalised one is Class 10's, where the penalty comes from").

**N7 — suggestion. "the most generous world it managed had `26` zeros" is a sample maximum.** It is the
one statistic on the page with no error bar available and the largest Monte-Carlo dependence of
anything printed: over 4000 draws mine reaches 29. The evidence is the `0 of 1000`; the maximum is
decoration that will move on the next reseed, in a chapter whose rule is to report the range.

**N8 — suggestion. The pass/fail bullet omits the model's third conviction.** Summary: *"The repaired
fit passes the impossible-bird check and passes Pearson chi-squared over its degrees of freedom
comfortably — and is convicted by the number of zeros."* It is also convicted by its own worm plot
(48 of 2000, and a run in 52 of 2000), which is the chapter's own headline three sections earlier and
the thing the rewrite was for. Two passes and **two** failures is the true inventory and the better
one, because the two failures were found by different instruments.

**N9 — suggestions carried over, both unchanged and both still small.** The Gaussian block's
`Pearson residual SD 1.0029` remains an algebraic identity — `sigma` is the ML estimate with divisor
*n*, `std` uses *n* − 1, so the ratio can only be √(171/170) = 1.002937, printed to seven digits — and
reads like a diagnostic passing. And `fig-simcheck`'s two panels still run to 200 and to about 560
with the right-hand axis label suppressed; both hold 1000 worlds, so the areas are comparable and the
bar heights are not.

## Re-derivations (all independent of DRM.jl)

- Refit nulls at 2000 draws in the chapter's design. Age-only: outside median 0, mean **1.25**, 95th
  **7**; run median 0, mean 0.93, 95th **5**; residual SD mean **0.9951**, SD **0.0534** against
  1/√(2n) = 0.0554. `0 of 2000` at ≥ 107 outside and `0 of 2000` at run ≥ 51. Repaired: median 0, mean
  **1.30**, 95th **7**; **45 of 2000** at ≥ 13 outside, **47 of 2000** at run ≥ 9; null SD spread
  0.0555, so the seed-averaged 1.1155 is **2.1** null SDs above one.
- Naive null, 2000 draws: median 1, mean **7.22**, 95th **37**, **346 of 2000** at ≥ 13. Pointwise
  prediction 2Φ(−2)·163 = **7.42**. Anticonservative by 7.22/1.25 = 5.8 in the mean and 37/7 = 5.3 at
  the 95th percentile — "about five".
- Worm slopes: **+0.2891** against SD − 1 = **+0.3067** (gap −0.0176); **+0.0726** against **+0.0844**
  (gap −0.0119). Null of that gap over 2000 iid normal samples: mean **−0.0030**, SD **0.0021** —
  so 7.0 and 5.2 null SDs. sd(θ) = 0.9989.
- Below/above: **49 / 58** (age-only, seed 1) and **11 / 2** (repaired, seed 2). Runs, repaired:
  (−) 2 at ranks 4–5, (−) **9** at ranks 7–15, (+) 1 at 114, (+) 1 at 118. Observed `Fledglings` in
  the run of 9: **[0, 0, 1, 0, 0, 0, 0, 0, 3]**; across all 13 outside: **[0,0,0,0,1,0,0,0,0,0,3,5,6]**;
  21 of the 30 lowest-ranked residuals are zeros.
- Zeros: observed **30**, expected Σexp(−μ̂ᵢ) = **15.4866**; simulated (4000) mean 15.49, SD 3.40,
  max 29, **0 of 4000** at ≥ 30, z = **4.26**. Observed against expected by count: 30/15.5, 15/26.3,
  19/29.7, 22/27.5, 31/22.3, 18/16.2, 15/10.8, 8/6.6, 3/3.8, ≥9: 2/4.3 — excess at both ends, deficit
  at one to three.
- X²: observed 1.1064; fixed-μ null mean must be n/(n − k) = **1.0188** exactly; refit null (4000)
  mean **1.0007**, P(≥ obs) **0.169**.
- Bootstrap (4000 resamples, both models refitted in each): difference **0.1474**, SE **0.0409**,
  z **3.60**, ratio-of-rate-ratios CI **[1.0754, 1.2622]**.
- ΔAIC = 2 − LR: −0.7923 = 2 − 2.7923 exactly; the chapter prints both. Asymptotic checks unchanged:
  median 1.5451, P(< 0) 0.1573, P(≤ −0.7923) 0.0947.
- Guard: 140-row reduced fit, statistic **−28.1070**, p **1.0000** via the `max(statistic, 0)` clamp;
  the honest comparison 89.1656 against the 150-row 21.9637, a factor of **4.06**.
- Files: `SparrowSurvival.csv` header is `ChickNo, Sex, Survival, Mass2, BroodSize, HatchingSuccess,
  EggNo, JulianDate, Dad, Mum, BroodNo, Year` (1950 rows) — `Mum` and `BroodNo` both present, as
  claimed. `BodySize.csv` is 460 rows of `BirdID, Sex, Tarsus, …`, the repeated-measures file.
  `FemaleSuccess.csv` names neither bird nor brood, as claimed.
- All four SVGs are byte-identical to `12f0f31`. The two rewritten worm captions now match what the
  pictures show — the age-only plot really does dip below on the left and rise above on the right,
  and the repaired plot's surviving run really does sit at the far left — with the one exception in N4.
  `fig-three-residuals` and `fig-simcheck` are unchanged and still teach their captions.

## One question for Shinichi

N1 is a process finding wearing a chapter finding's clothes, and it is now three for three: Class 3
blocked on Exercise 3, Class 4's finding 2 ended at Exercise 3, and Class 5's rewrite fixed four
blocking findings in the prose and left Exercise 3 pointing at the null it had just retired. The
mechanism is obvious once stated — the exercises are written last, against the draft, and are the one
part of a chapter that no reviewer's arithmetic touches, because they contain no executed output to
check.

So the question is whether the chapter template should say it. Something like: *the exercises are
part of the argument, and the last edit to any chapter is to re-read them against the prose that
changed.* Cheaper still, and mechanisable: an exercise that names a procedure the chapter demonstrates
should name the **cell label** it comes from — Exercise 3 would say "adapt `null-envelope`", and the
staleness would have been visible in the diff, because `null-envelope` is exactly the cell that was
rewritten.

The alternative reading is that Exercise 3 is fine and I am over-reading a teaching exercise as a
claim. I do not think so, on the evidence of the answer it produces: 344 of 2000 against 48 of 2000
is not a rounding difference between two ways of doing homework, it is an acquittal against a
conviction, on the chapter's own model, using the chapter's own counter. But it is your book, and the
call about how much a reader is expected to carry from the prose into the exercises is yours.

---

## Third pass (ea00337)

Short pass against the new freeze and the two worm SVGs (byte-identical to `cdf70d2` again — captions
changed, pictures did not). Every previously-verified number is unchanged and still reproduces:
`107`/`49`/`58`, `+0.2891`/`+0.3067`, the naive null `1 / 7.15 / 37`, the refit null
`0 / 1.24 / 7 ± 0.65`, `13`/`11`/`2`/run `9`, `+0.0726`/`+0.0844`, `48` and `52` of 2000,
`5`/`22.6`/`48` with `191 of 200`, `30`/`15.49`/`0 of 1000`, `0.1474` with SE `0.0399`.

**The one new number checks.** `of the 13 points outside, 9 fledged zero`. Independently:
the observed `Fledglings` at the 13 outside-band ranks are **[0,0,0,0,1,0,0,0,0,0,3,5,6]** — nine
zeros, and one female each at 1, 3, 5 and 6. The new helper is also constructed correctly:
`y[sortperm(r)]` reorders the response into the same order as `sort(r)`, which is the order
`worm_parts` builds `dev` in, so the mask lines up. **9 of 13.**

| item | status |
|---|---|
| N1 blocking — Exercise 3 built the naive null | **closed.** It now simulates from the fitted model, refits, recomputes, *and* asks for the naive null alongside so the student compares the two 95th percentiles and says why they differ. Better than restoring the correct null alone. |
| N2 required — "the third different null" | **closed in the count, reopened in one clause (see below)** |
| N3 required — "to two decimal places" | **closed in the summary and in reference 2; not in the dialogue (see below)** |
| N4 required — "those points are females who fledged nothing" | **closed.** Caption and dialogue both now read "mostly zeros: 9 of 13", from an executed inline count rather than prose. |
| N5 required — Exercise 9 could not run | **closed.** A reduced model on one subset and a nested full model on a different subset clears the `Δdof > 0` guard and returns a statistic, which is what the question needs. |
| N6 required — phylo refusal misfiled | **closed.** "three of them are Class 8's — the penalised one is Class 10's, where the penalty comes from". |
| N7, N8, and the two carried-over suggestions (16, 22) | **not closed**, all four still small. |

**Two required items remain, both one clause, neither touching a number — and both are the same
shape: the summary was corrected and the dialogue was not.**

**T1 — required. "The same number twice" survives in both places a reader meets it.** The summary now
reads *"a slope **close to** their residual SD minus one, **not equal to it** — the small gap left over
is the curvature term"*, and reference 2's annotation matches. But Itchy still says *"and there they
are, **the same number twice**"* of 0.289 against 0.307, and *"still **the same number twice**"* of
0.0726 against 0.0844 — with both pairs printed on the line above him. The false, checkable claim
("to two decimal places") is gone, which was the substance of N3; what is left is the dialogue
asserting an identity that the chapter's own summary spends a clause denying. Lift the summary's
wording into Itchy's mouth: it costs four words and the curvature point lands where the figure is,
rather than three pages later.

**T2 — required. The fixed enumeration re-blurs the distinction it exists to draw.** Eddie now says
*"the fourth different null"* and Itchy lists all four, which closes the count. But null three is
described as *"this one, the X²-over-df null, **just refitted the same way**"* — and the beat two
speeches earlier is that this null does **not** refit, which is precisely why its mean is
n/(n − k) = 1.0188 rather than one. The chapter's own summary keeps that straight
(*"simulate-and-score-at-the-original-fitted-mean for the Pearson statistic, whose null mean is
therefore n/(n − k) rather than one"*), so dialogue and summary now disagree about the defining
feature of the third null. Read charitably, "just refitted" means "which I have just refitted", since
the cell prints both flavours — but the stated criterion is *"which parameters the null may
re-estimate"*, and under that criterion a null three that refits like null two is not a fourth kind at
all and the count collapses back to three. One clause: "Three: this one, the X²-over-df null, scored
at the mean I fitted to the real data — which is why it is the one whose null mean is not one."

## Verdict

**Pass** — the blocking finding and all five required items from the re-review are closed, four of
them with executed arithmetic and two (Exercise 3, the zeros count) more thoroughly than I asked. Two
required wording items remain, both places where a corrected summary now contradicts an uncorrected
line of dialogue, and neither moves a number or a verdict.
