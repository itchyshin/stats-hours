# Chapter 4 — adversarial statistical review (as executed)

## Review (bdf09e5)

Read against the frozen outputs and the four rendered SVGs, with a hand-written IRLS Poisson and a
hand-written NB2 maximum likelihood (Newton on a numerical Hessian, log-likelihoods from
`Distributions.logpdf`, no DRM.jl), plus an analytic Fisher information for the Gaussian
location-scale block. **Every executed number reproduces exactly**: the counts' moments, both count
fits to four decimals including the log-likelihoods, θ = 3.9864, the AIC drop of 20.8533, both rate-
ratio intervals, both Pearson statistics, both quantile-residual SDs at the chapter's own seeds, and
every sparrow number (σ 1.3757 / 1.4528 / 1.4132, AIC 611.5563 vs 613.3026, z 0.5034, p 0.6147). The
pre-rendered R block matches to all seven digits R prints, and its response-scale σ standard error
0.07613359 is exactly the delta-method 0.5008516 × 0.1520083. The `fit_ls` mean-model standard errors
match the analytic **X**ᵀdiag(1/σᵢ²)**X** inverse (2.6903, 0.1450, 0.2183) to rounding, so the engine's
location-scale information is right. The sparrow beat is consistent with Class 2 to every digit — same
file, same fit, same verdict. All five citations check on OpenAlex. Item 1 passes: the only bare
numerals in dialogue are "9:00 am", "Class 2 / 3 / 6 / 11" and word-form counts; all 29 inline quantities are
inline `{julia}`.

The arithmetic is clean. What is not clean is what the chapter says the arithmetic means, and — worse —
what it left in the CSV.

## Verdict

**Block** — two failures. Column 2 of the chapter's own data file is the exposure variable that makes
most of this chapter's overdispersion disappear, and the chapter neither uses it nor mentions it; and
the opening beat compares a marginal quantity with a conditional one and calls them "two estimates of
the same quantity".

## Findings

1. **blocking** — **`EggNo` is in the file, and the chapter's diagnosis does not survive it.**
`FemaleSuccess.csv` is `Fledglings, EggNo, Age`. `EggNo` is the number of eggs laid; **`Fledglings` ≤
`EggNo` in all 163 rows**, and `EggNo` runs from 1 to 23 (SD 4.33). The author's own working script for
this exact file, `data/2012/Notes.R`, fits it two ways and both use the exposure:
`glm(Fledglings ~ Age, family = quasipoisson, offset = log(EggNo))` (line 395) and
`glm(cbind(Fledglings, EggNo - Fledglings) ~ Age, binomial)` (line 384). Put the offset in and the
chapter collapses:

   | model | AIC | Pearson X²/df | θ | rate ratio on Age |
   |---|---|---|---|---|
   | Poisson, `Age` | 739.99 | 1.5679 | — | 1.2618 |
   | NB2, `Age` | 719.13 | 0.8831 | 3.99 | 1.2632 [1.1093, 1.4386] |
   | Poisson, `Age` + offset log(EggNo) | **651.02** | **1.1106** | — | 1.0812 |
   | NB2, `Age` + offset log(EggNo) | 652.20 | — | 27.58 | 1.0812 **[0.9767, 1.1968]** |

   The offset buys **88.96 AIC for zero parameters**, against the negative binomial's 20.85 for one.
   With it in, **the NB2 repair loses by 1.18 AIC** and θ goes to 27.6 — the chapter's whole subject
   evaporates. And the biology goes with it: the age rate ratio falls from 1.26 to 1.08 and its interval
   covers one, so "Both still exclude one, so the biology survives the repair" is an artefact of the
   omission, not a finding. Three sentences are false as a result: *"The mean structure is fine"*,
   *"The link is fine"*, and *"Every prediction is a legal number of chicks"* — **Itchy: "Correct."** The
   fitted NB2 puts about **10.9 rows' worth of probability mass above each bird's own `EggNo`**
   (Poisson: 8.9), i.e. more fledglings than eggs, which is exactly the class of impossibility Class 3
   convicted the Gaussian of. Itchy's hedge, *"age is unlikely to be the only thing that matters to a
   female"*, is not enough when the other thing is in the next column and the source script uses it.
   Note also that **Lindén & Mäntyniemi 2011 — the chapter's own reference 2 — is a paper about the
   mechanisms that generate overdispersion** (its abstract names sampling, flocking, aggregation and
   environmental variability), so the chapter cites the paper that would have caught this and annotates
   it with the one clause its abstract does not support ("what happens when the mean is small").

2. **blocking** — **the raw variance-to-mean ratio is not what the Poisson decrees, and 1.69 and 1.80
are not two estimates of the same quantity.** The setup cell prints `variance / mean : 1.6947 (Poisson
decrees 1)` and Momo says *"which is still not one"*. A Poisson **regression** decrees Var(y|x) = μ(x);
it says nothing about the marginal variance-to-mean ratio, which also carries Var(E[y|x]). Under the
chapter's own fitted Poisson that ratio is **1.148, not 1** — so the crude statistic's benchmark is
wrong on the page. Then Itchy: *"they are two estimates of the same quantity arrived at from different
directions … when the crude and the careful agree you have learned something rather than found an
artefact."* One is marginal, the other is conditional at μ = ȳ; they are different quantities and the
agreement **is** the artefact. Like for like, the fitted NB2 implies a marginal variance of
E[Var(y|x)] + Var(E[y|x]) = 5.9126 + 0.4806 = **6.3931**, a marginal ratio of **1.9925** against the
observed 1.6947 — the model over-predicts the raw spread by 18%, where the chapter's pairing (1.80 vs
1.69) shows a 6% agreement. Exercise 3 sets this same comparison as homework.

3. **blocking** — **"the dots live inside it" is contradicted by the chapter's own figure.** Of
`fig-counts`, Itchy says of the Poisson band *"Count the dots outside it"* and of the NB2 band *"the
dots live inside it, which is the entire point."* Counted: **67 of 163 outside the Poisson band, 61 of
163 outside the NB2 band** — a difference of six birds, and 37% of the data outside the band that
supposedly contains them. This is arithmetically unavoidable: a ±1 SD band is not supposed to contain
the data. The models' own expected coverage of their ±1 SD bands is **0.743 (Poisson) and 0.706 (NB2)**,
against observed 0.589 and 0.626. The honest and better beat is there for the taking: the Poisson band
holds 59% of the birds when its own model claims 74%, a 15-point shortfall; the NB2 band holds 63% when
it claims 71%, an 8-point shortfall — better, and still short.

4. **required** — **the sparrow "no" accepts the null.** Itchy: *"That is a real question about
sparrows and the answer is no."* Objective 5 makes it doctrine — *"accept the answer when it is no"* —
and the summary says *"The sparrows did not need it and told me so twice."* The chapter's own printed
SE says otherwise. From `sigma: Sex: male` = 0.0545 (0.1083), the male/female **σ ratio is 1.056 with a
95% interval of [0.854, 1.306]**, and the **variance** ratio is 1.115 [0.730, 1.705]: these 171 birds
are consistent with males scattering 15% less or 71% more in variance than females. At 80% power and
α = 0.05 the smallest σ ratio this design could have detected is **1.354**. The correct sentence is
"we cannot tell them apart, and we could only have seen a 35% difference", not "the answer is no".
Class 2 ships the same phrasing ("the honest answer was 'no'"), so this wants fixing in both.

5. **required** — **the worm plot is not as quiet as the dialogue says, and its caption describes a
different plot.** The caption reads *"Randomised quantile residuals … Normal when the model is right"*,
but `fig-diagnostic` is a **detrended** worm plot: the y-axis is `deviation` and a correct model gives a
flat line at **zero**, not a diagonal. A reader told "normal" will look for a 45° line. On the numbers,
**49 of 163 points (30%) fall outside the ±2SE envelope**, with a run of **29 consecutive points above
it** centred on theoretical quantile 0. Itchy convicts Class 3's Poisson plot for leaving the envelope
"for most of its length … in a systematic S"; by that standard this one leaves it systematically too.
"Tighter, flatter and still not perfect" is fair about *tighter*; it is not fair about *systematic*.
A central hump is a mean-structure signature, which is finding 1 showing up in a second place.

6. **required** — **"σ = 1 is unit-dependent" is false for the negative binomial.** The engine prints
`intercept ⇔ σ = 1 (unit-dependent); slope ⇔ equal dispersion` above **both** σ tables, and the summary
repeats it as a general rule. For the Gaussian sparrows, σ = 1 mm is indeed a unit-dependent curiosity.
For `NegBinomial2()`, σ is **dimensionless**: σ = 1 is θ = 1, i.e. Var = μ + μ², a real and
interpretable dispersion hypothesis, and the printed z = −4.5487 is a real test of it (θ = 1 is
rejected). The chapter praises the engine for printing its null and then mis-reads it. This is an
engine string as much as a chapter sentence — worth a DRM.jl issue to make the note family-aware.

7. **required** — **`Class 11` is a version-2 chapter.** *"**Class 11 is where σ stops being a nuisance
and becomes the response**"* points at a rung that `docs/the-climb.md` marks `v = 2`, while this
chapter's own `status_note` says version 1 is ten chapters plus a coda. A reader following the pointer
will not find it. Either say "held for version 2" or point at Class 5, which is in v1 and owns
diagnostics.

8. **required** — **the Class 6 promise cannot be run on either file.** The front box and the closing
line promise Class 6 will move the standard errors "on both of them". `FemaleSuccess.csv` has **no
female identifier at all** (three columns: Fledglings, EggNo, Age), and `MBodySize.csv` is the
**one-row-per-bird** file — 171 rows, 171 unique `BirdID` — so neither supports a random intercept.
The repeated-measures file is `BodySize.csv` (460 rows, 171 birds, 2–4 repeats each, 2.71 mean for
females and 2.67 for males), which `data/2012/README.md` says is what Class 6 needs. This is the same
defect the Class 3 review flagged for `ChickSurvival.csv`. One clause fixes it: the grouping is not
recorded in these files, so the repair is a different dataset, not a different formula.

9. **required** — **the box is tagged ⚠ DISAGREE and its own headline says the numbers are identical.**
"the same numbers to every digit, plus one row R prints that Julia does not" is a *translation* box, and
a good one — the σ-versus-θ trap is worth walking into. The conventions reserve ⚠ DISAGREE for two
implementations giving **different numbers**, with a named mechanism and a computable boundary. This has
neither and needs neither. Relabel it. This is verbatim the Class 3 review's finding 4, unfixed here.

10. **required** — **the θ refits are median-biased, not merely skewed.** The narration says θ's refits
are "skewed to the right". The executed output says more: the parametric bootstrap draws from a model
whose θ is 3.9864 and the **refits' median is 4.4820**, +12%. Skew alone moves the mean, not the median;
a median 12% above the generating value is small-sample bias in θ̂, which is a sharper and more useful
statement than skew and strengthens the chapter's own point about not quoting θ to three decimals. The
Monte-Carlo SE of a median over 200 draws is ≈ 1.25 × 1.4604/√200 = 0.129, so 4.482 sits 3.8 MCSE above
3.986 — this survives the reseed to `MersenneTwister(20260907)` passed through `simulate`. (That reseed
itself is right and closes the Class 3 review's finding 5.)

11. **required** — **the NB2 quantile-residual SD of 1.0026 is partly seed luck.** Over 200
randomisation seeds the NB2 RQR SD averages **1.0548 (SD 0.0278)**; seed 5 gives 1.0026, 1.9
randomisation-SDs low. The Poisson figure is stable (mean 1.3043, SD 0.0238 across seeds, against the
chapter's 1.2981). The conclusion holds either way — 1.05 is one sampling SE from 1 — but Momo's *"From
1.3 down to 1.0"* is a seed-specific digit, and the Julia-stuff bullet says only "**Pass the `rng`**, or
the page renders differently every time", which understates it: *which* rng you pass moves the second
decimal.

12. **suggestion** — **the two checks are not independent, and neither carries an error bar.** Objective
4 says "two **independent** overdispersion checks"; they are two functions of one fitted model on one
residual vector. "Two checks built on different arithmetic" (Itchy's own phrase) is right; "independent"
is not. On error bars, the numbers exist: simulating from the fitted models, the null distribution of
X²/df is mean 1.012, SD 0.118, 97.5th percentile **1.259** for the Poisson (observed 1.5679 — clearly
out) and mean 1.021, SD 0.155, 95% interval **[0.755, 1.362]** for the NB2 (observed 0.8831 — clearly
in). Note the NB2's SD of 0.155 is well above the √(2/df) = 0.112 a reader would guess, because the NB
tail is heavy — worth one sentence, since "do not go chasing that" currently rests on assertion. Same
for the RQR: MC SE = 1/√(2n) = **0.0554**, so the Poisson's 1.2981 is 5.4 SE from 1 and the NB2's is 0.

13. **suggestion** — **the quasi-Poisson is one line away and would demonstrate the cited paper.**
Reference 1 is Ver Hoef & Boveng, annotated (correctly, per its abstract) as being about different
weighting. The chapter never computes the alternative. It is arithmetic already on the page:
√(X²/df) = **1.2521** is the quasi-Poisson SE inflation against the NB2's **1.3879**, on the same
coefficient. Two numbers, and the citation stops being homework.

14. **suggestion** — **the mechanism behind "the estimate barely moves" is never named.** The beat is
stated as an observation and then generalised ("Overdispersion is a disease of standard errors"), but the
reason is a theorem: the Poisson score equations are unbiased estimating equations for β **whatever** the
true variance, so β̂ stays consistent and only its variance is wrong. Without that, a reader cannot tell
whether they were shown a property or a coincidence — and the residual 0.0012 difference between the two
slopes is exactly Ver Hoef & Boveng's re-weighting, which ties the beat to reference 1. Relatedly, "It
leaves the point estimates roughly where they were and **shrinks the intervals**" makes overdispersion the
agent; it is the Poisson model's failure to admit it that shrinks them.

15. **suggestion** — **dismiss the small bin with a number.** Simulating 7 counts from the fitted NB2 at
that bin's μ = 5.151, **P(sample variance ≤ 2.667) = 0.055**. So the point is not merely unstable, it is
at the 5th percentile — and the right dismissal is "one in twenty, and we looked at four bins", which is
stronger than "n = 7" and teaches multiplicity in passing.

16. **suggestion** — **"Binomial says it is p(1 − p)."** For n > 1 trials — the binomial the chapter's own
`EggNo` would give — the variance is **n**p(1 − p). For n = 1 it is p(1 − p) and is an identity that cannot
be false, which is the Class 3 review's finding 2 reappearing. One word fixes it.

17. **suggestion** — **"Three of the four bins sit near the curve and above the line"** is a claim about
executed output written in prose and checked by nothing. It happens to be exactly right (bins 1–3 sit
between the identity and the NB2 curve, all nearer the curve; bin 4 sits below both), but if θ or the data
move it goes stale silently. The chapter's own rule about numerals applies to counts of things in a figure.

18. **suggestion** — **an engine gap the chapter should own.** DRM.jl 0.7.1 exports no `offset`, and
`@formula(y ~ x + offset(z))` errors with `UndefVarError: offset`. If finding 1 is accepted, the taught
engine cannot currently express the model the source book used, which is a legitimate thing for the book
to say out loud rather than route around. `BetaBinomial()` **is** available and takes `cbind()`
(see the question below). Separately: a `BetaBinomial` fit prints its header as
`DrmFit (Gaussian location–scale, …)`, which is an engine display bug worth reporting.

**Verified.** All five citations are exact on OpenAlex — Ver Hoef & Boveng, *Ecology* 88(11):2766–2772;
Lindén & Mäntyniemi, *Ecology* 92(7):1414–1421; Harrison, *PeerJ* 2:e616; Rigby & Stasinopoulos, *JRSS C*
54(3):507–554; Hilbe, CUP 2011 — and four of the five annotations are supported by title or abstract, with
Ver Hoef & Boveng's ("they weight observations differently, so they can disagree about which coefficient
matters") near-verbatim from its abstract. The θ = 1/σ² arithmetic is right and the instruction
("exponentiate, square, take the reciprocal") produces 3.9864 as claimed. "Large θ, tidy counts" is right
and correctly flagged as the common confusion. The `sigma_m = s_hat[1] * s_hat[2]` line is correct
(exp(γ₀)exp(γ₁)), and `sigma(fit_ls)`'s printed range is exactly its two ends. The mean-variance figure is
the best page in the chapter: binning by the model's only covariate makes the plotted variances genuinely
conditional, marker area is the right encoding, and the claim "three near the curve, one below both" is
true point by point. The Class 2 cross-reference is exact. Keeping a failed comparison on the page is the
right instinct throughout — the objection in finding 4 is only to the word "no".

## Re-derivations

- Poisson (own IRLS): 0.70670 (0.10809), 0.23249 (0.04778); logLik −367.9932; AIC 739.9864.
  NB2 (own Newton ML): 0.70445 (0.14406), 0.23367 (0.06632), log σ −0.69145 (0.15201), θ 3.9864;
  logLik −356.5665; AIC 719.1331; ΔAIC **20.8533**. SE ratio **1.3879**.
- Marginal decomposition under the fitted NB2: E[Var(y|x)] = 5.9126, Var(E[y|x]) = 0.4806, implied
  marginal variance **6.3931** (observed 5.4377), implied marginal var/mean **1.9925**. A correct
  **Poisson** implies a marginal var/mean of **1.1482**, not 1.
- With `offset = log(EggNo)`: Poisson AIC 651.02 (X²/df 1.1106), NB2 AIC 652.20 (θ 27.58); age rate
  ratio 1.0812 [0.9767, 1.1968]. Binomial `cbind(Fledglings, EggNo − Fledglings) ~ Age`: X²/df 1.6417.
  Expected rows with y > EggNo under the chapter's NB2: **10.93**; under its Poisson: 8.88.
- ±1 SD band coverage: Poisson 96/163 inside (0.589) against its own expected 0.743; NB2 102/163 (0.626)
  against 0.706.
- Worm plot at seed 5: 49/163 outside the pointwise ±2SE envelope; longest same-sign run outside = 29.
- Null distribution of X²/df by simulation from each fitted model: Poisson mean 1.012, SD 0.118, 97.5%
  1.259; NB2 mean 1.021, SD 0.155, 95% [0.755, 1.362]. MC SE of an RQR SD = 1/√(2n) = 0.0554.
- RQR SD over 200 randomisation seeds: Poisson 1.3043 (0.0238), NB2 1.0548 (0.0278).
- Sparrows: σ ratio male/female 1.0560, 95% CI [0.8541, 1.3056]; variance ratio 1.1152 [0.7296, 1.7046];
  LRT χ² = 0.2536 on 1 df, p = 0.6145; minimum detectable σ ratio at 80% power **1.354**.
  `fit_ls` μ SEs from the analytic Fisher information: 2.6903, 0.1450, 0.2183.
- Bin at age 4 (n = 7, fitted μ = 5.151): P(sample variance ≤ 2.667) = **0.055** by simulation.

## One question for Shinichi

Finding 1 is not a sentence to patch. Three routes, and they are different books:

**(a) Own the estimand.** Keep `Fledglings ~ Age` and say in one clause that it estimates the *total*
effect of age on fledgling production, that a large part of the extra spread is variation in eggs laid,
and that Class 5 will show what happens when the exposure goes in. Cheapest, honest, and it keeps the
mean-variance figure — but the reader is then told the family lied when mostly the model did.

**(b) Change the file.** Move the count demonstration to a dataset with no unmodelled exposure sitting in
column 2. `SparrowSurvival.csv` (1950 rows) is the obvious candidate. Costs the Class 3 continuity —
Momo has been carrying this Poisson since last week.

**(c) Change the family, keep the file and the verb.** The source book's own construction runs today in
the pinned engine:

```
drm(bf(@formula(cbind(Fledglings, Failures) ~ Age)), Binomial(); data = d)             # AIC 670.2311
drm(bf(@formula(cbind(Fledglings, Failures) ~ Age), @formula(sigma ~ 1)),
    BetaBinomial(); data = d)                                                          # AIC 645.2604
```

An AIC drop of **24.97** for one parameter — larger than the 20.85 the chapter currently reports, on a
response that respects its own ceiling, with `X²/df = 1.64` under the binomial so the overdispersion is
real rather than manufactured. It is the same lesson, the same one verb and a second formula in the box,
and Class 3's binomial rung leads straight into it. The cost is that "the negative binomial" stops being
the chapter's centrepiece and becomes the *second* example — and that the mean-variance figure, which is
the best page here, would need rebuilding on p(1 − p).

Which of the three, and does the negative binomial keep top billing?

---

# Re-review (84ccdb4, branch `book/preview-machinery`)

Read against the new frozen outputs and all four rendered SVGs, with the whole chapter re-derived
from scratch: hand-written IRLS for the Poisson and the grouped binomial, hand-written Newton ML for
NB2 and for the **beta-binomial** (with the variance built independently as *n*p(1−p)(φ+*n*)/(φ+1)),
my own randomised-quantile-residual construction, and the worm-plot envelope recomputed both with the
chapter's `erfinv_approx` and with the exact normal quantile.

**Every executed number in the rewrite reproduces exactly.** Not one mismatch, to the last printed
digit: `1.1491`; `739.9864 → 652.8208` and the drop of `87.1656`; `logEgg 0.9503 [0.7343, 1.1664]`;
Pearson `1.5679 → 1.1064`; impossible mass `8.88 → 0.63`; the age rate ratio `1.2618 [1.1490, 1.3857]
→ 1.0889 [0.9859, 1.2027]`; Binomial logLik `−333.1155`, AIC `670.2311`, X²/df `1.6417`;
BetaBinomial φ `11.7329`, AIC `645.2604`, ΔAIC `24.9706`, X²/df `1.0160`; coverage `77`/`0.528`/`0.672`
and `56`/`0.656`/`0.670`; RQR SDs `1.2883` and `1.0722` at seeds 6 and 7; worm counts `84`/run `35`
and `4`/run `3`, span `−1.92` to `−1.62`, `49` of `54`; θ `3.9864 → 29.2025` and AIC `654.1004`;
sparrow σ ratio `1.0560 [0.8541, 1.3057]` and MDR `1.3544`. The pre-rendered R box is right too: the
offset model's logLik is **−323.5112** and its AIC **651.0224**, exactly as printed. The Winitzki
`erfinv_approx` makes no difference — the exact normal quantile gives the same 4 points outside, the
same run of 3, the same span. Item 1: 103 inline `{julia}` expressions, up from 29.

Two of the arithmetic choices deserve credit rather than comment. `ratio_implied` uses Julia's `var`
(divisor *n*−1) for Var(E[y|x]), which is the *same* divisor as the crude ratio it is being compared
with — the *n* divisor would give 1.1482, and picking the consistent one is the right call in a book
that has a whole box about divisors. And `claimed_coverage` uses `<=` for "inside" exactly as
`outside` uses `>`, so the claim and the count are measured with the same edge.

**I also ran the adversarial test the rewrite invites: does the chapter's own lesson survive being
turned on its second half?** It does. Adding `logEgg` to the *binomial's* linear predictor gives a
coefficient of −0.0743, leaves Pearson X²/df at 1.6424 (from 1.6417) and makes AIC **worse** (671.93
against 670.23). Per-egg success does not depend on clutch size in these birds, so the binomial's
overdispersion is not a second missing covariate. The beta-binomial is diagnosed correctly.

## Verdict

**Pass** — all three blocking findings are closed, and closed with executed arithmetic rather than
hedged prose. Three required items remain, each fixable in a sentence, and none of them touches a
number.

## The original findings, one by one

| # | was | now |
|---|---|---|
| 1 | blocking — `EggNo` unused | **closed** |
| 2 | blocking — wrong benchmark | **closed** |
| 3 | blocking — "the dots live inside it" | **closed** |
| 4 | required — sparrow "no" | **closed** (but see N3) |
| 5 | required — worm caption / systematic run | **closed** (but see N2) |
| 6 | required — σ = 1 "unit-dependent" | **closed** |
| 7 | required — Class 11 is v2 | **closed** |
| 8 | required — Class 6 promise unrunnable | **closed** |
| 9 | required — ⚠ DISAGREE mislabelled | **closed** |
| 10 | required — θ median bias | **changed — I was wrong; see below** |
| 11 | required — RQR seed luck | **closed for the SD, not for the counts (N2)** |
| 12 | suggestion — "independent", no error bars | **closed** |
| 13 | suggestion — quasi-Poisson never computed | **closed** |
| 14 | suggestion — mechanism unnamed | **closed** |
| 15 | suggestion — small bin needs a number | **not closed** |
| 16 | suggestion — "Binomial says p(1 − p)" | **closed** |
| 17 | suggestion — "three of the four bins" | **closed** |
| 18 | suggestion — engine gap | **closed** |

**1 closed.** Better than I proposed. The exposure is taught as a *free coefficient* first, the offset
is then derived as that coefficient pinned at one, and the interval [0.7343, 1.1664] is what licenses
the pin — which is the right order and teaches something my "use the offset" would not have. The
impossible mass (8.88 → 0.63) turns my prose objection into a printed statistic, and "I said *for now*
rather than *correct*" repairs the Class 3 parallel exactly where it broke.

**2 closed.** 1.1491 is exact, the three-line print (crude / implied / conditional) is the clearest
possible form of it, and Exercise 3 now sets the like-for-like comparison instead of the confused one.

**3 closed, and generalised.** "A band is not a promise that the dots are inside it" now has its own
section and its own arithmetic, and the beta-binomial's 0.656 against a claimed 0.670 is a much better
demonstration than my counter-example was.

**4 closed.** "Not detected" with the interval and the minimum detectable ratio is exactly right, and
naming Class 2 as wrong on the page is more honest than quietly diverging from it.

**5 closed.** The caption now says "**detrended**" and "a flat scatter about **zero** — not a
diagonal", and the counts are computed by re-using `erfinv_approx` so that what is counted is what is
drawn. That last move is the correct fix and I would not have thought of it.

**6, 7, 8, 9, 12, 13, 14, 16, 17, 18 closed** as stated. The `BetaBinomial` header display bug I
reported does not appear in the freeze — it prints `Distributional regression fit (BetaBinomial)`
correctly, so that half of finding 18 was mine to withdraw.

**10 — changed. The writer is right and I was wrong, and I was wrong in an instructive way.**
My number was a correct reading of the *old* frozen output (`bdf09e5` printed `median 4.4820, SD
1.4604`). My *inference* — that it would survive the reseed — was not. I settled it with 8000
independent parametric-bootstrap refits from the fitted NB2, forty times the chapter's 200:

- true median of θ̂ = **4.1250** against a generating 3.9864, i.e. a real median bias of **+3.48%**
  (MC SE 0.0211 at 8000 refits, so 6.6 MC SE — the bias exists);
- the block-to-block SD of a 200-refit median is **0.0860**;
- the old freeze's 4.4820 is **4.15 block-SDs** above the truth, and **0 of 40** blocks reached it;
- the new freeze's 4.0946 is **0.35 block-SDs below** it — an entirely ordinary draw.

So `4.4820` was an outlier run, `4.0946` is the trustworthy number, and my "3.8 MCSE, survives the
reseed" was exactly the one-run over-reading this chapter exists to warn against. Withdrawn.

Two small notes now that the arithmetic is settled, both **suggestions**. First, the chapter's
conclusion — "on two hundred refits that is not enough to call it bias" — is right about the evidence
in the cell and should not be readable as "there is no bias": there is, at about +3.5%, and 200 refits
simply cannot resolve it. "Two hundred refits cannot resolve it" is the sentence that stays true when
somebody runs 8000. Second, the cell's own error bar is unreliable for this statistic:
`1.2533 * SD / sqrt(200)` gives 0.1335, where the true block-to-block SD is 0.0860 — the asymptotic
median formula is **55% too wide** here, so the chapter is understating its own evidence with it. That
is a nice half-sentence for a chapter about judging a statistic against its error bar.

## New findings

**N1 — required. Two Pearson statistics on different responses are compared, four paragraphs before
the chapter forbids exactly that for AIC.** Toto: *"That is worse than the Poisson one was."* Itchy
accepts it and builds the beat on it: *"It is 1.64, and it is **real** rather than manufactured,
because this model already knows about the eggs. **This is the overdispersion the chapter is named
for.**"* But the jump from 1.1064 to 1.6417 is very largely arithmetic. The binomial claims a variance
of *n*p(1−p) where the Poisson claims *n*p, so at the same fitted mean the binomial's denominator is
smaller by a factor (1−p), and the same squared deviations must give a bigger statistic. The predicted
inflation from that alone is Σ*n*ᵢpᵢ / Σ*n*ᵢpᵢ(1−pᵢ) = **1.4920**; the observed ratio is
1.6417/1.1064 = **1.4838**. They agree to 0.6%. The chapter's substantive claim survives intact —
1.6417 is a genuine rejection of the binomial's own variance claim, and 1.6417 → 1.0160 with ΔAIC
24.97 is real — but the *comparison* Toto draws is not evidence, and the chapter itself says two beats
later that "AIC compares models of the *same* data". One clause: these are different responses, so do
not rank 1.11 against 1.64; what matters is that 1.64 is far from one on a model that already knows
the eggs.

**N2 — required. "49 of the lowest 54 deviations are negative" is a 1-in-20 randomisation draw,
quoted without the error bar the chapter taught.** This is the one statistic on the page carried by a
seed rather than a formula. Over 200 randomisation seeds on the same fit, that count has median **36**
(10th–90th percentile **27 to 45**) and the chapter's seed 7 gives **49 — the 94.5th percentile**,
with P(≥ 49) = 0.055. The *shape is real*: 36 of 54 is already well above the 27 you would expect
under symmetry, so the left tail genuinely is a little heavy and Toto is right to see the sag. But 49
overstates it by a wide margin, and it is quoted as bare evidence in the same chapter that says
"**Pass the `rng`** — and know that *which* rng you pass moves the second decimal". Here it moves a
headline count by thirteen. (The companion numbers are fine: "4 of 163 outside" is typical, P(≤ 4) =
0.48, and the binomial's 84 and run of 35 sit right on their seed-averaged means of 76.9 and 37.3.)
The fix is the chapter's own: report the count with its spread over seeds, or state the direction
without the number.

**N3 — required. Class 2 is now declared wrong in print, and Class 2 still says it.** *"Class 2 says
'no' about this same fit and Class 2 is wrong to."* That is the right sentence and I am glad it is
there, but `book/wk2-linear-models.qmd` still ships *"the honest answer was 'no'"* and *"the answer is
no different from the one AIC gave"* on the identical fit. Until Class 2 is amended the book
contradicts itself between two chapters, and the reader who does them in order meets the error before
the correction. Same fit, same numbers, so the repair is the Class 4 wording lifted across.

**N4 — suggestion. A live number typed by hand.** The TRANSLATE box's prose says *"Both AICs are
printed in the block below: **651.02** for the offset and **652.82** for the free coefficient."*
651.02 is legitimately a pre-rendered R number and cannot be computed in Julia; 652.82 is
`aic(poe) = 652.8208`, which the page has already executed, and it is typed as a literal. That is
precisely the class of numeral item 1 exists to catch.

**N5 — suggestion. `fig-ceiling` jitters counts below zero.** `fled_jit` adds Gaussian noise to the
response, so on a figure whose entire argument is that impossible values matter, several birds are
drawn at about −0.2 fledglings and the y-axis extends below zero. Jitter the eggs axis only, or clamp.

**N6 — suggestion. `fig-ceiling`'s band is a union, not a band.** `band_lo, band_hi = minimum(mu_p .-
sd_p), maximum(mu_p .+ sd_p)` spans [0.95, 7.42] — the envelope of every age's band, not any one
female's (a one-year-old gets [0.95, 4.15], a four-year-old [2.88, 7.42]). The caption says so
honestly — "over every female of every age" — and the quantified claim rests on the per-bird 8.88, so
this is a presentation note rather than an error: the drawn band crosses the ceiling further right
than any real bird's would.

**N7 — suggestion. The summary is looser than the front box about the grouping.** *"these files …
do not record which female or which bird a row belongs to"* — `MBodySize.csv` does record which bird
(`BirdID`, 171 unique in 171 rows); what it does not do is repeat any of them. The front box has this
exactly right; the bullet should borrow its wording.

**N8 — suggestion, carried over (finding 15). The small bin still has no number.** *"That point is not
counter-evidence"* still rests on n = 7 alone. Simulating 7 counts from the fitted NB2 at that bin's
μ = 5.151 gives P(sample variance ≤ 2.667) = **0.055** — so the honest dismissal is "one in twenty,
and we looked at four bins", which teaches multiplicity for free.

## Re-derivations (all independent of DRM.jl)

- Benchmark: crude 1.6947; implied with the *n*−1 divisor **1.1491** (with *n*, 1.1482).
- Exposure: AIC 739.9864 → **652.8208** (drop 87.1656); logLik −323.4104; logEgg 0.9503 (SE 0.1102),
  CI [0.7343, 1.1664]; Pearson 1.5679 → **1.1064**; impossible mass 8.88 → **0.63**; age rate ratio
  1.2618 [1.1490, 1.3857] → **1.0889 [0.9859, 1.2027]**. Offset version: logLik **−323.5112**, AIC
  **651.0224**, Age 0.0781 (0.0482) — the R box exactly.
- Binomial: logLik −333.1155, AIC 670.2311, X²/df **1.6417**. BetaBinomial (own ML, own variance
  formula): φ **11.7329**, logLik −319.6302, AIC **645.2604**, ΔAIC **24.9706**, X²/df **1.0160**.
- Mechanical part of 1.11 → 1.64: Σ*n*p / Σ*n*p(1−p) = **1.4920** against the observed 1.4838.
- Binomial with `logEgg` added: coefficient −0.0743, X²/df 1.6424, AIC 671.93 (worse by 1.70) — the
  binomial's dispersion is **not** a missing covariate.
- Coverage: 77 and 56 outside; 0.528 vs claimed 0.672, 0.656 vs claimed 0.670.
- Worm (own RQR, chapter seeds): Binomial SD 1.2883, 84 outside, run 35; BetaBinomial SD 1.0722,
  4 outside, run 3, span −1.92 to −1.62, 49 of 54 negative. Identical with the exact normal quantile.
  Over 200 seeds: outside median 5 (P(≤4) = 0.48); negatives-of-54 median **36**, 10–90% **27–45**,
  the printed 49 at the **94.5th percentile**; RQR SD mean 1.0385 (sd 0.0285).
- NB2: θ 3.9864, AIC drop 20.8533, SE factor 1.3880, quasi-Poisson 1.2521; with exposure θ **29.2025**,
  AIC **654.1004** (worse by 1.2796).
- θ bootstrap, 8000 refits: median **4.1250**, true median bias **+3.48%** (6.6 MC SE); block-median SD
  **0.0860** against the chapter's nominal 0.1335; old freeze 4.4820 at 4.15 block-SDs, new freeze
  4.0946 at −0.35.
- Sparrows: γ₁ 0.0545, analytic SE 0.1082, σ ratio 1.0560 [0.8542, 1.3056], MDR **1.3542**–1.3545
  depending on the SE's last digit.
- `fig-mean-variance` and `fig-sparrow-bands` are byte-identical to `bdf09e5`; both still teach their
  captions, and the mean-variance figure remains the best page in the chapter.

## One question for Shinichi

The rewrite makes Class 4 carry three families, two responses, an exposure, a coverage section and a
worm-plot section — and it is now roughly twice the length of Class 3, in a slot the climb calls an
introduction. Everything in it earns its place on the evidence. But Class 5 ("Is the model any good?")
is in draft in the working tree as I write this, and its first two sections are *three kinds of
residual* and *the picture, and what its envelope promises* — the generalisation of exactly the two
sections Class 4 has just built, on the same `FemaleSuccess.csv` and the same `logEgg` model.

So the question is not whether the material belongs in the book but who owns it. Either Class 4 keeps
the coverage arithmetic and the worm counting as *instances* and Class 5 is written to generalise them
explicitly ("you met this on the fledglings; here is the rule"), or Class 4 hands the machinery down a
rung and stays the chapter about the variance function. What must not happen is the two chapters
deriving the same envelope twice from scratch and quoting different seeds while doing it — which, on
the evidence of N2, is the failure mode nearest to hand.
