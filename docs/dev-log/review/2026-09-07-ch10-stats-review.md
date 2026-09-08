# Chapter 10 — adversarial statistical review (as executed)

## Review (fd7d8ce)

Read from the commit — the chapter source, the frozen execute-results, all four rendered SVGs (as
images, at 2×), and `data/ch10/ch10-r-box.R` — with the whole chapter re-derived independently of
DRM.jl: my own `numpy` build of `A`, my own ML and **REML** profile likelihoods in the eigenbasis,
my own dense three-component Gaussian likelihood (Cholesky, no eigen trick) for the two-component
fit, my own numerical observed information and delta method, and my own recovery study at 2000
replicates per world with my own generator. The R box was **re-run** against the installed
drmTMB 0.7.0.

**Every executed number in the chapter reproduces.** The counts (1950 → 1675 chicks, 126 sires,
127 dams, 208 pairs, 503 broods, four cohorts, mass mean 3.62191 SD 1.19100 min 1.2 max 9.6);
the sibships (208 families, largest 48, median 5, 12 singletons, 59/126 and 55/127 multiply-mated);
the crossing (195 mixed broods, 195 with both parents differing, 140 of 208 pairs spread, brood
sizes 1–6); `A` (11 423 at ½, 9 911 at ¼, 1 380 641 at 0, λ_min 0.500000); the animal-only fit
(σ_A 0.515456, σ_e 1.067728, **logLik −2631.857496** against the engine's −2631.8575, V_A 0.265694,
V_P 1.405738, h² 0.189007, and the five mean coefficients to four decimals); the delta SE **0.0452**
from my own Hessian (whose SE(log σ_A) 0.1274 and SE(log σ_e) 0.0273 are the engine's printed
standard errors exactly); the two-component fit (σ_A 0.274511, σ_B 0.744589, σ_e 0.884355,
**logLik −2513.543713**, shares 0.0534/0.3927/0.5539, √V_P 1.1882, delta SEs 0.0333 and 0.0293);
the whole AIC ladder (5324.398 / 5277.715 / 5044.927 / 5043.087, ΔAIC −234.63 and −1.84); the
quantile residuals (mean −0.0456, SD 1.3365, range −2.859 to 6.776, ratio 0.9948); the eigenbasis
profile (0.1900 with CI 0.1150–0.2900 on the chapter's own grid); the recovery triple at my own
seeds (medians 0.1850/0.2100/0.1500, SDs 0.0419/0.0562/0.0522, coverage 0.943/0.032/0.009,
exclusion 0.991); the observed SD about the fixed part 1.1820; the Class 6 file (459 rows,
171 birds); and all four lines of the R box **verbatim**, including `max |A_drmTMB − A_by_hand| = 0`.
All five journal citations are exact on OpenAlex — authors in order, titles, journals, volumes,
pages, DOIs, and the "(online 2009)" note on Wilson et al. Item 1 passes: 24 inline `{julia}`
expressions, and every bare numeral in dialogue is a Class pointer, "9:00 am", an equation symbol,
a citation year or a list number.

The arithmetic is immaculate and the chapter's central argument is right and is proved rather
than asserted: this design genuinely cannot separate the pedigree from the nest, the third world
genuinely returns a heritability out of a world with no genetics, and the engine's own printed
numbers say so. What is wrong is two Class pointers, a benchmark that is not the chapter it cites,
an interval that is not the estimate ± the standard error it is printed beside, and a "recovers it
honestly" that the same cell measures as biased.

## Verdict

**Block** — five failures. Two Class pointers send the reader to chapters that do not contain what
they promise (Class 9 is binomial, not Poisson; no chapter in this book teaches `Gamma`). The
Class 6 repeatability the chapter fetches is the *unadjusted* one, not the ceiling Class 6 hands the
reader, so "the same formula" is false and the fetch commits the sibling error Class 6 warns about
in the same paragraph. The chapter quotes the ML penalty as `n/(n−p) = 1.003` — the residual
divisor, which Chapter 8 says is the smaller half — and then reads its own world-1 simulation, which
measures the real penalty on h² at about 2%, as "recovers h² honestly". And the printed heritability
triple does not cohere: DRM.jl centres the interval on the **bias-corrected** estimate, which the
chapter never prints, so 0.1890 ± 1.96 × 0.0452 is not 0.1046–0.2817, and the implied bias is 18% of
the 0.0534 the chapter reports as the honest answer — exactly what Class 6 predicted would happen
here, in writing.

## Findings

1. **blocking** — **"Class 9 let them live inside a Poisson." Class 9 is binomial.** Opening
paragraph. `book/wk9-glmms.qmd` fits `Binomial()` six times and `Poisson()` **zero** times
(`grep -c "Poisson()"` returns 0); its response is `Survival`, its link is logit, its ratios are
odds ratios and its ICC is π²/3. Worse, the one place Class 9 mentions Poisson is the beat that
this sentence erases — Jaro, `wk9-glmms.qmd:311`: *"The **log** link, the one this book taught you
in Classes 3 to 5, is collapsible for the rate ratio… So 'nonlinear' is not the criterion. Logit
is."* Class 9 exists to distinguish the two, and Class 10's first paragraph merges them. No chapter
in this book puts a random effect inside a Poisson, so the sentence has no correct referent; the
honest version is "Class 9 let them live inside a coin flip" or "…inside a Bernoulli". The Summary's
version — *"Classes 6, 7 and 9 let groups differ"* — is correct and needs no change.

2. **blocking** — **"Class 3's `Gamma` family" — the book has no Gamma family.** After the worm plot:
*"A right-skewed positive response is what Class 3's `Gamma` family is for."* `grep -rn "Gamma"
book/*.qmd` returns hits in **wk10 only**. Class 3 teaches `Gaussian()`, `Binomial()` and
`Poisson()`, and its closing beat is "pick the family" among those three. DRM.jl does ship
`src/gamma.jl`, so the *engine* claim is true and the fix is a word — "what a `Gamma` family is for,
and DRM.jl has one" — but as written the sentence sends a reader to a class that will not have it,
in the chapter that spends a page insisting a reader check the file rather than take the lecturer's
word.

3. **blocking** — **the Class 6 repeatability is not the number Class 6 hands you, and "the same
formula" is false.** Chapter 10 fits `Wing ~ 1 + (1 | BirdID)` and gets **R = 0.7565**, then says:
*"That number **is** Class 6's number — the same file, the same 459 measurements, **the same
formula**, the same maximum likelihood — so nothing has gone wrong in fetching it."* Class 6's
ceiling is `Wing ~ Tarsus + (1 | BirdID)`, and its executed output is:

   | Class 6 cell | formula | R |
   |---|---|---|
   | `repeatability` / `ceiling` — **the bound Class 6 hands the reader** | `Wing ~ Tarsus + (1\|BirdID)` | **0.7189** |
   | `adjusted-vs-not` — the comparison | `Wing ~ 1 + (1\|BirdID)` | **0.7565** |

   Class 6 prints both side by side and then says, in terms (`wk6-random-intercepts.qmd:502`):
   *"Ours is 0.719, estimated by maximum likelihood and **adjusted for tarsus**… **Match the
   conditioning when you quote it: an adjusted R bounds an adjusted h².**"* Chapter 10 fetches the
   other one and calls the formula the same. So the beat whose whole point is *"carrying it across
   traits is the commonest way people get it wrong"* itself drops the conditioning Class 6 named as
   the second commonest way — in the same paragraph, from the same file. The row set is not the
   problem: `dropmissing` on `[:Tarsus, :Wing]` and on `[:Wing, :BirdID]` both give 459 rows on 171
   birds, which I checked. Fixing the number is one word in the formula; fixing the argument means
   saying that a bound must match its conditioning *and* its trait. **Three homes** (conventions,
   "when a review corrects a beat"): the dialogue, the Summary bullet — *"a repeatability of a
   different trait, at a different age, from a different file caps nothing"*, which names trait, age
   and file but not conditioning — and **Exercise 6**, which tells the student to "compute the
   repeatability of your trait from Class 6 and state the bound it puts on your h²" with no
   instruction to match the conditioning.

4. **blocking** — **the chapter quotes the wrong divisor for the ML penalty, and then reads its own
measurement of the right one as agreement.** Two sentences carry this:

   > *"at the residual level the divisor is n against n − p: our mean costs 5 parameters out of 1675
   > chicks, a factor of 1.003."* — and the Summary: *"The downward bias in an ML variance component
   > is roughly the price of the fixed effects, which was **small on this file** — but 'small' is a
   > thing you check."*

   It is never checked, and the check is already in the chapter. **World 1 is that check.** Truth
   h² = 0.1890; the chapter's own printed median is **0.1800**, and at R = 200 the Monte Carlo
   standard error of a median is ≈ 1.253 × 0.0387/√200 = **0.0037**, so the printed gap is 2.4 MC SE
   — a detected bias, read as *"this pedigree recovers h² honestly"*. I ran the same estimator at
   R = 2000 with my own generator and added a REML profile (three lines: swap `n` for `n − p` and
   add `logdet(Xᵀ W⁻¹ X)`):

   | R = 2000, world 1 (truth h² = 0.1890) | mean | MC SE | median | relative bias |
   |---|---|---|---|---|
   | ML — the chapter's estimator | 0.1847 | 0.0010 | 0.1850 | **−2.3%** |
   | REML — the same code, one line changed | 0.1891 | 0.0010 | 0.1875 | +0.1% |

   Paired, REML − ML = **+0.00440** (SE 0.00004). And on the real data the same machinery gives
   **h²_ML = 0.18901, h²_REML = 0.19414**, from V_A 0.265694 against 0.274153 — a ratio of
   **1.032** on the structured component against **0.998** on the residual. The chapter quotes
   1.003. That is the residual half, and Chapter 8 is the chapter that says which half matters:
   *"the correction lands almost entirely on whichever level has **fewer units**"*
   (`wk8-reml-vs-ml.qmd`, "The divisor, grown up"). The chapter's own reference 2 compounds it —
   Kruuk (2004)'s abstract describes the literature as *"**restricted maximum-likelihood** 'animal
   models'"*, so the chapter fits by ML, points at a REML literature, and prices ML at 0.3%.

   The fix is not a hedge, it is the best half-page available here: the engine refuses REML, the
   chapter has already written the rotated-basis profile that can compute it, and one extra line
   turns a refusal into a measurement — *this is what REML would have said, and here is the
   simulation that shows why it is the one to believe*. That also repairs the Summary bullet, which
   currently promises a check that did not happen.

5. **blocking** — **the printed estimate, SE and CI do not cohere, the chapter calls the interval a
Wald interval, and the bias term Class 6 promised would matter here is never printed.** The naive
fit prints `h2 = 0.1890  SE 0.0452  95% CI 0.1046 to 0.2817`. A reader doing the arithmetic this
book teaches gets `0.1890 ± 1.959964 × 0.0452 = 0.1005 to 0.2775` — which is what my independent
delta method returns. The engine's source explains it (`DRM/src/bias_correct.jl:142–144`):

   ```julia
   corrected = estimate + bias                       # bias = ½·tr(H_g·V)
   z  = quantile(Normal(), 1 - (1 - level) / 2)
   ci = (lower = corrected - z * se, upper = corrected + z * se)
   ```

   The interval is centred on `corrected`, not on `estimate`. Inverting the printed intervals:

   | quantity | printed estimate | implied `corrected` | implied `bias` | as % of the estimate |
   |---|---|---|---|---|
   | h², pedigree only | 0.1890 | 0.19315 | **+0.0041** | +2.2% |
   | h², pedigree + brood | 0.0534 | 0.06313 | **+0.0098** | **+18.3%** |
   | brood share | 0.3927 | 0.38887 | −0.0039 | −1.0% |

   Class 6 wrote the forecast (`wk6-random-intercepts.qmd`, `repeatability` cell): *"A ratio of
   estimates is not the estimate of the ratio, so the point estimate is slightly off and the engine
   will tell you by how much if you look. It is tiny here. **It will not be tiny in Class 10.**"*
   Class 6 prints `bias` and `corrected`. Class 10 prints neither, and 18% of the headline number is
   not tiny. The `repeatability`/`heritability` return already carries both fields; printing them is
   one `@printf`.

   Two consequences ride on the same object. **(a)** The clamp is never declared: the full model's
   CI prints `0.0000 to 0.1284`, and 0.0000 is not a computed bound — it is `_clamp01` acting on
   `corrected − z·se = −0.0021` (`heritability.jl:107–109`). A CI floored at zero has to say it was
   floored, in a chapter whose third simulated world lives on that boundary. **(b)** The explanation
   given for why the delta and profile intervals differ — *"a Wald interval on a ratio, **clamped
   into [0, 1]**, is the weaker of the two"* — is not what happened in the naive fit, where nothing
   was clamped and both endpoints are interior. On a fine grid the real comparison is
   profile 0.1124–0.2909 against plain Wald 0.1005–0.2775: the profile sits **higher at both ends**
   because the profile of a variance ratio near the low end is right-asymmetric, and that is a
   mechanism the chapter can name instead of a verdict it can assert.

6. **required** — **the decisive AIC comparison is a boundary comparison and is never named as one.**
`pedigree + brood` against `brood only` differs by exactly one parameter, σ_A, tested at zero. The
chapter reads ΔAIC = −1.84 as *"how little separates the last two rows"* and stops. The likelihood
ratio is **χ² = 3.8396 on 1 df**; the naive p is **0.0501** and the boundary p, under the
50:50 χ̄² mixture, is **0.0250** — the whole "is it significant" reading flips on the correction, and
the chapter reports neither. DRM.jl **exports** `chibar_pvalue` and `lrt_boundary`, and
`src/chibar.jl:1–14` states the rule; Class 9 already used the exactly-halved boundary p on its own
LRT, so this is the book's own convention, departed from. The engine also prints
*"NOT the σ_b = 0 boundary"* above the very z table in this chapter's output — a warning the page
reproduces and does not act on. AIC's 2k penalty is derived under the regularity conditions that
fail here; saying so, and giving the boundary p, is two lines and is the honest reading of a
1.84-point gap.

7. **required** — **the partition figure's dialogue reads the wrong bar, and the right reading is the
better lesson.** Momo: *"The genetic block just shrank and a new block appeared in its place."*
Itchy endorses it. The figure and the printed numbers say otherwise:

   | component | pedigree only (g²) | pedigree + brood (g²) | change |
   |---|---|---|---|
   | genetic | 0.265694 | 0.075356 | **−0.190338** |
   | brood | 0 | 0.554413 | +0.554413 |
   | residual | 1.140044 | 0.782084 | **−0.357959** |
   | total | 1.405738 | 1.411854 | +0.006116 |

   The brood block took **34.3%** of itself from the genetic block and **64.6%** from the residual.
   It did not appear "in its place". The mechanism is one line and it is the chapter's own
   two-partitions argument, finished: the pedigree-only model must assign **every** full-sib pair the
   same covariance, 0.5 × 0.2657 = **0.133**, whether or not they shared a nest; the two-component
   model assigns **0.592** to same-brood full sibs and **0.038** to different-brood full sibs. A
   16-fold split the first model had to average over is what the residual was absorbing, and that is
   why 195 mixed broods and 140 spread pairs — counted two pages earlier — are what make the second
   model possible at all.

8. **required** — **two attributions are narrower than the abstracts support, and the front matter
promises otherwise.** *"Kruuk (2004) and Wilson et al. (2010) both put this near the front"* — the
"this" being the shared-nest confound. Kruuk's abstract presents environmental variation as the
thing the animal model **solves**, not as a warning: *"offer a powerful means of tackling the
potentially confounding effects of environmental variation"*. Wilson et al.'s abstract puts
*"key pitfalls and dangers"* in its **concluding** numbered item, not near the front. Reference 2's
annotation — *"Its treatment of what else can inflate an estimate of additive genetic variance is
the source of this chapter's second half"* — is a claim about the paper's interior that the abstract
does not support, in a list whose header promises *"claims about what a paper argues are attributed
as narrowly as the abstract supports"*. Reference 3 is the one that carries this weight and it
carries it well; pointing the in-text sentence at Kruuk & Hadfield alone would be both true and
stronger.

9. **required** — **reference 3's abstract states the general rule behind this chapter's own result,
and the chapter never uses it.** Kruuk & Hadfield (2007): *"we demonstrate the ability of the animal
model to reduce bias due to shared environment effects such as maternal or brood effects,
**especially where pedigrees contain multiple generations and immigration rates are low**"*. This
pedigree is **one generation**. That is not a decoration — it is the reason the simulation comes out
the way it does, stated by the paper the chapter calls "today's confound", and it turns a fact about
one sparrow file into a rule the reader can apply to their own. The chapter says *"this design
cannot tell them apart"*; the citation says *which* designs can.

10. **required** — **"a hundred draws" against `nsim = 50`.** The closing line of the simulation
thread: *"Read what a function promises before you build an argument on a hundred draws from it."*
The cell above it is `simulate(full_model; nsim = 50, ...)`. A hundred is Class 6's number
(`ysim = simulate(ri_fit; nsim = 100)`), carried across. Either raise `nsim` or write "fifty".

11. **required** — **Class 6 promises twice that Class 10 comes back to the √R bound, and it does
not.** `wk6-random-intercepts.qmd:516`: *"**A correlation between two traits is capped by the square
root of the repeatability, not by R itself**… Do not carry today's bound across to that problem;
**Class 10 comes back to it**."* Repeated in Class 6's summary bullet. Chapter 10 contains zero
mentions of `sqrt(R)` or a correlation bound. Either Class 10 spends two sentences on it — it sits
naturally beside "the gap between R and h² is the permanent environment" — or Class 6's forward
pointer comes out. It cannot stay unhonoured in the book's last taught rung.

12. **suggestion** — **the positive-definiteness check cannot fail, and the number it prints is the
one worth teaching.** *"a smallest eigenvalue safely above zero, so the matrix is a legal covariance
shape and not a rounding accident."* Write the construction as `A = ½I + ¼S + ¼D`, where `S` and `D`
are the sire and dam all-ones block matrices; both are positive semi-definite, so **λ_min ≥ ½ by
construction** for any one-generation sib pedigree. I confirmed it: `λ_min(¼S + ¼D) = −6.9e−15`, and
**1471 of the 1675 eigenvalues of A are exactly 0.5000**. The check passes because it cannot fail.
The ½ is not an arbitrary floor either — it is the **Mendelian sampling** variance: a contrast
between two full sibs carries exactly ½σ_A², which is the one number in this chapter a
quantitative geneticist would recognise on sight, and it arrives free in a cell that currently
teaches "safely above zero". The by-name check two cells later is the check that can fail, and the
chapter is right to say so.

13. **suggestion** — **the eigenbasis cross-check is weaker than the one already in hand.** The
chapter compares point estimates, 0.1900 against 0.1890, on a grid of step 0.005 — so the agreement
is guaranteed to within half a grid step and can resolve nothing finer than 0.0025. The
log-likelihood is free and decisive: my profile at its own maximum is **−2631.857496** against the
engine's **−2631.8575**, and dropping the grid for a bounded 1-D optimiser gives
**h² = 0.189007** against the engine's 0.1890 — five digits, not one. One extra `@printf` of
`profile_ll(yrot, ĥ)` beside `loglik(naive)` turns "to within the spacing of the grid" into
"to seven digits". The same line would also discharge the promise made in the `fit-animal` comment
(*"check the answer against the model's own likelihood later in this chapter"*), which the grid
comparison does not keep.

14. **suggestion** — **`g_tol = 1e-3` is chosen out loud and never verified.** *"Tighten it on your
own data and confirm the printed digits do not move."* I tightened it: an unconstrained optimum at
machine precision gives σ_A 0.5154556 and σ_e 1.0677282 against the printed 0.5155 and 1.0677. The
digits do not move, and saying so costs one clause.

15. **suggestion** — **V_P is conditional on Sex and Cohort and the chapter never says so.**
Objective 3 is *"say what the denominator contains"*; Itchy defines V_P = V_A + V_B + V_R and stops
there. Sex and Cohort are fixed, so the variance they explain — **0.0236 g² of a full-variance total
of 1.4355** — is outside the denominator. On a full-variance denominator h² would be **0.0525**
rather than 0.0534, so nothing turns on it here, which is exactly why one clause can say it cheaply:
this h² is conditional on sex and year, and a reader whose fixed effects explain more than 2% of the
variance will find it does turn on it.

16. **suggestion** — **0.955 in the table, "96%" in the sentence.** The inline expression rounds
correctly, but a reader looking from the prose to the table two paragraphs up sees two numbers. The
chapter's own habit elsewhere is to quote the printed figure.

17. **suggestion** — **the medians carry no Monte Carlo standard error while the coverage does.**
The chapter gives MC SEs for the coverages and for the 99.0%, then quotes medians 0.1550, 0.2050,
0.1800 and the derived *"82% of the number Eddie was ready to publish"* bare. At R = 200 the MC SE
of a median is ≈ 1.253 × SD/√200, i.e. **0.0037–0.0051**, so 82% is ±2.5 points. In the chapter that
insists a single-seed count carries its spread, and whose finding 4 turns on a 0.009 difference
between a median and a truth, the medians are the numbers that most need it.

18. **suggestion** — **the worm plot's ±2SE band is not the right band for these residuals.** The
chapter establishes, correctly and with the arithmetic, that these are **marginal** residuals still
carrying the breeding value and the brood effect (SD 1.3365 against a predicted 1.3436). The band is
computed for *n* independent standard normal draws; with 503 brood clusters at a 39% brood share
these are strongly correlated, so the band is too narrow and "leaves the band" is over-confident.
The verdict survives easily — −2.86 against +6.78 is not a close call — and one clause saying the
band is optimistic for the same reason the spread is inflated closes the loop the chapter opened
three sentences earlier.

19. **suggestion** — **three annotation notes.** Wilson et al.: *"Written for people who know mixed
models and not quantitative genetics"* is the chapter's inference; the abstract addresses
*"ecologists"* and offers *"three detailed example tutorials"*. Dohm: the abstract lists **five**
conditions under which the bound fails, and the chapter names one (*"let genes and permanent
environment covary"*), which is closest to the abstract's (b); condition (e), **maternal effects**,
is the one this chapter's own brood confound actually is, and naming it would tie the reference to
the page. Hadfield 2010: *"the Bayesian route that most of this literature actually took"* and the
claim about posteriors versus likelihood intervals near a boundary are both the chapter's own — good
claims, but presented in a list whose header says otherwise.

20. **suggestion** — **the four-faces table is accurate and drops one warning.** I checked all four
call sites against the DRM.jl 0.7.1 tutorials: `K =` (`relmat-known-matrices.md:29`), `tree =`
(`phylogenetic-models.md:24`), `coords =` with `K(ρ) = exp(−d/ρ)` and ρ estimated jointly
(`spatial-models.md:6–13`) — all exact, including the chapter's `exp(-d/ρ)`. The refusal to fit a
tree with no tree in the repository is the right call, correctly reasoned. The one omission: the
spatial tutorial's own caveat, *"The spatial range is recovered only weakly from a single
realization"*, which is the same "can your design see it?" question this chapter spends its second
half on, sitting unclaimed in the file the chapter points at.

21. **suggestion** — **`fig-relatedness` axes are indices.** The by-name check two cells earlier
picks out `CC0188` against `CC0189`, `CC0352` and `CC0182`; the heatmap's axes run 1–18. I measured
the rendered pixels to check the claim the caption rests on: the wash is `#3B528B` (viridis at
**0.25**) and the blocks are `#21908D` (viridis at **0.5**), so *"there is no zero anywhere in it"*
is true and visible, and the figure teaches exactly what Itchy says. Chick codes on the ticks would
let a reader carry the check into the picture.

**Verified.** The chapter's hardest claim is right and is proved, not asserted. All four AIC rows
are ML on the same 1675 rows with consistent parameter counts (6/7/7/8), so the ladder is legitimate
— I reproduced every log-likelihood from scratch, including the sparse-assembled two-component fit,
whose maximum my dense Cholesky likelihood matches to six decimals, so `algorithm = :sparse` is
giving the right answer and the chapter's claim about it holds. The recovery study is
well-constructed: three worlds simulated from the fitted models with explicit `MersenneTwister`
seeds, breeding values drawn correctly through `cholesky(Symmetric(A)).L`, the *same* estimator
applied to all three, and the coverage in world 1 reported as the licence for the other two. My own
2000-replicate rerun reproduces every column. *"All three curves are over it"* is right and stronger
than the chapter claims: the probability of landing within ±0.005 of 0.1890 is 0.089, 0.074 and
0.068 in the three worlds — a likelihood ratio of about 1.3 to 1 across a world with 19% heritability
and a world with none. The `simulate` trap is real and correctly diagnosed (simulated SD 0.8857
against σ_e 0.8844 and √V_P 1.1882), and the chapter is right that it would have destroyed the
recovery study had it been used. The refusal to compute a repeatability from a file with one
weighing per chick — *"not badly, not approximately, not at all"* — is exactly right, and the counts
prove it. The `heritability` versus `repeatability` denominator distinction in the Julia summary is
correct against the source (`heritability.jl`: numerator one component, denominator **all**
components plus residual; `icc`/`repeatability`: focal plus residual only). The R box is exact:
I re-ran `ch10-r-box.R` against drmTMB 0.7.0 and all four printed lines reproduce verbatim,
`max |A_drmTMB − A_by_hand| = 0`, and the box's claim about DRM.jl is quoted correctly from
`docs/src/tutorials/animal-models.md:105` — *"Building `A` from a pedigree and a sparse
large-pedigree path are planned."* The worm plot's reading is textbook-correct: ∪ means right skew,
and the printed range −2.859 to +6.776 says the same thing without the picture. The REML refusal is
read exactly as it should be. Item 1 passes. Every number on the page ran.

## Re-derivations

- **Data and pedigree** (own `pandas`, no Julia): 1950 → 1675 rows on `Mass2`; 126 sires, 127 dams,
  208 pairs, 503 broods, cohorts 2003–2006; mass 3.62191 ± 1.19100, 1.2–9.6; 208 families,
  max 48, median 5, 12 singletons; 59/126 sires and 55/127 dams multiply mated; 195 mixed broods
  (195 with both parents differing), 140/208 pairs spread across broods, brood sizes 1–6; one
  weighing per chick (min = max = 1).
- **A**: 11 423 pairs at ½, 9 911 at ¼, 1 380 641 at 0; distinct off-diagonals {0, 0.25, 0.5};
  **λ_min = 0.500000 exactly, with multiplicity 1471**, and λ_min(¼S + ¼D) = −6.9e−15, so
  `A = ½I + ¼S + ¼D` forces λ_min ≥ ½ for any one-generation sib pedigree.
- **Animal-only ML** (own eigenbasis profile + own 2-parameter Nelder–Mead, agreeing):
  h² **0.189007**, σ_A **0.5154556**, σ_e **1.0677282**, V_A 0.265694, V_P 1.405738,
  **logLik −2631.857496**, AIC 5277.7150; β = (4.0023, −0.0104, −0.3449, −0.4034, −0.5133).
  Own numerical observed information: SE(log σ_A) **0.1274**, SE(log σ_e) **0.0273**, corr −0.681 —
  the engine's printed standard errors. Delta SE on h² **0.0452**; plain Wald **0.1005–0.2775**
  against the printed 0.1046–0.2817.
- **Animal-only REML** (same code, `n → n − p` plus `logdet(XᵀW⁻¹X)`): h² **0.194140**,
  σ_A **0.523596**, σ_e **1.066764**, profile CI 0.1161–0.2978. V_A REML/ML = **1.03184**;
  V_R REML/ML = **0.99820**; n/(n−p) = 1.00299.
- **Profile CIs**: fine grid **0.1124–0.2909**; the chapter's 200-point grid reproduces its printed
  **0.1150–0.2900** and its **0.1900** exactly.
- **Two-component fit** (own dense Cholesky likelihood over σ_A, σ_B, σ_e — no eigen shortcut):
  0.274511 / 0.744589 / 0.884355, **logLik −2513.543713**, AIC 5043.0874, shares
  0.0534/0.3927/0.5539, √V_P 1.1882; log-scale SEs 0.3147 / 0.0509 / 0.0282 (the engine's);
  delta SEs 0.0333 (h²) and 0.0293 (brood).
- **Ladder**: fixed-only logLik −2656.199016 / AIC 5324.3980; brood-only −2515.463527 / 5044.9271;
  ΔAIC −234.6276 and **−1.8396**. LRT for σ_A = 0 given brood: **χ² = 3.8396**, naive p **0.0501**,
  boundary (½χ²₀ + ½χ²₁) p **0.0250**.
- **Partition moves (g²)**: V_A 0.265694 → 0.075356 (−0.190338); V_R 1.140044 → 0.782084
  (−0.357959); V_B 0 → 0.554413; total 1.405738 → 1.411854. Brood block sourced **34.3%** from the
  genetic block, **64.6%** from the residual. Implied full-sib covariances: naive 0.1328 for every
  pair; two-component **0.5921** same brood, **0.0377** different brood.
- **Marginal residuals** (own GLS at the fitted components): mean −0.0456, SD 1.3365,
  range −2.859 to 6.776, √V_P/σ 1.3436, ratio 0.9948; SD about the fixed part 1.1820. All printed.
- **Recovery, own generator, R = 2000 per world** (chapter: 200):

  | world | truth | median | mean | SD | coverage | excludes 0 |
  |---|---|---|---|---|---|---|
  | genes only | 0.1890 | 0.1850 | 0.1856 | 0.0419 | 0.943 | 1.000 |
  | genes and brood | 0.0534 | 0.2100 | 0.2137 | 0.0562 | 0.032 | 1.000 |
  | brood only | 0.0000 | 0.1500 | 0.1546 | 0.0522 | 0.009 | **0.991** |

  P(estimate within ±0.005 of 0.1890) = 0.089 / 0.074 / 0.068. Only 1 of 6000 estimates exceeds the
  histogram's top edge of 0.45, so the hand-built bins lose nothing.
- **World 1, ML against REML, R = 2000**: ML mean 0.1847 (MC SE 0.0010), REML mean 0.1891
  (MC SE 0.0010), paired difference **+0.00440** (SE 0.00004).
- **Engine source**: `bias_correct.jl:142–144` (`ci = corrected ± z·se`),
  `heritability.jl:107–109` (`_clamp01_ci`), `heritability.jl` docstrings (heritability = focal /
  all components + residual; `icc` = focal / focal + residual), `chibar.jl:1–14` and the
  `chibar_pvalue`, `lrt_boundary` exports in `DRM.jl:173`, `src/gamma.jl` (a Gamma family exists),
  `docs/src/tutorials/animal-models.md:105`, `relmat-known-matrices.md:29`,
  `phylogenetic-models.md:24`, `spatial-models.md:6–13,43`.
- **Chapter 6** (from its own freeze): 459 rows on 171 birds; adjusted R **0.7189**
  (`Wing ~ Tarsus + (1|BirdID)`), unadjusted R **0.7565** (`Wing ~ 1 + (1|BirdID)`); V_between
  3.0770, V_within 1.2032, total 4.2802.
- **Chapter 9**: `Binomial()` × 6, `Poisson()` × 0. **Book-wide**: `Gamma` appears in wk10 only.
- **R box**: re-run with `Rscript data/ch10/ch10-r-box.R` against drmTMB 0.7.0 — 1928 pedigree rows,
  1675 × 1675 chick block, off-diagonals {0, 0.25, 0.5}, max absolute difference **0**. Verbatim.
- **Citations, OpenAlex**: Wilson et al. *J. Anim. Ecol.* 79(1):13–26, doi:10.1111/j.1365-2656.2009.01639.x
  (OpenAlex year 2009 — the chapter's "(online 2009)" note is right); Kruuk *Phil. Trans. R. Soc. B*
  359(1446):873–890, doi:10.1098/rstb.2003.1437; Kruuk & Hadfield *J. Evol. Biol.* 20(5):1890–1903,
  doi:10.1111/j.1420-9101.2007.01377.x; Dohm *Funct. Ecol.* 16(2):273–280,
  doi:10.1046/j.1365-2435.2002.00621.x; Hadfield *JSS* 33(2), doi:10.18637/jss.v033.i02. Authors in
  order, titles and pages exact. Item 5 (Lynch & Walsh) is declared unverified in the front matter
  and I did not verify the chapter numbers either.
- **Figures**, rendered at 2× and read as images: `fig-relatedness` (wash `#3B528B` = 0.25, blocks
  `#21908D` = 0.5, four full-sib blocks of 5/2/9/2 among 18 chicks of one sire — the caption's claim
  is visible and true); `fig-partition` (bar heights indistinguishable, genetic block shrinks, brood
  block appears — but see finding 7 for what the dialogue says about it); `fig-recovery` (three
  overlapping curves all with mass at the black 0.1890 line, world 1's dashed truth correctly
  described as hidden beneath it, world 2's orange dash at 0.053 and world 3's green dash at 0.0 both
  visible); `fig-diagnostic` (a clean ∪ — left end +1.3, middle sagging to −0.15, right end +1.65,
  both ends outside the band, which is right skew and matches the printed −2.86/+6.78).

## One question for Shinichi

The engine refuses REML on this route, and the chapter has already written the machinery that can
supply it — the rotated-basis profile is three lines from a REML profile, and it says
**h² = 0.194 rather than 0.190**, with a 2000-replicate simulation showing ML biased −2.3% on this
design and REML unbiased. Should Class 10 compute that and put it on the page, turning the engine's
"not yet" into a measurement of what the "not yet" costs? It is the strongest half-page available
here and it discharges Class 8's debt. But it means the book's last taught rung reports a number the
taught engine cannot produce, which cuts against "one engine teaches every rung" harder than any
comparison box does. The alternative is to keep ML, drop the 1.003, and say plainly that the price
is measured in world 1 at about 2% — honest, cheaper, and a smaller chapter.

---

## Re-review (e98c111, branch `book/preview-machinery`)

### Review

Read from the new commit — the rewritten source, the new frozen execute-results, both regenerated SVGs
(`fig-relatedness`, `fig-recovery`) as images at 2×, and the unchanged `data/ch10/ch10-r-box.R` — with
every number that is new or moved re-derived independently of DRM.jl: my own eigenbasis **REML**
profile with golden-section maximisation and bisected likelihood-ratio limits, my own 2000-replicate
paired ML/REML recovery with my own generator, my own dense-Cholesky **REML** fit of the
*two-component* model, my own delta method and bias inversion, my own boundary likelihood-ratio test,
and my own pairwise crossing counts from `A` and the brood vector. Chapter 6's freeze was read for
the ceiling triple; Self & Liang, Stram & Lee and Patterson & Thompson were checked on OpenAlex.

**Every new executed number reproduces, several of them to six or seven digits.** The eigenvalue count
(**1471 of 1675 exactly ½**); the bias triple on the naive fit (**corrected 0.19315, bias +0.00414,
+2.2%**, and `corrected ± 1.96 SE` = 0.1046–0.2817 against `plug-in ± 1.96 SE` = 0.1005–0.2775 — both
rows exactly as printed); the two-component bias (**corrected 0.06313, +18.2%, unclamped lower
−0.0021**) and the brood share (0.38887, −1.0%); the fixed-effect variance 0.0237 g² and the
full-variance h² 0.0525; the partition sourcing (**0.1903 g², 34.3% from the genetic block; 0.3580 g²,
64.6% from the residual**) and the sib covariances (**0.1328 / 0.5921 / 0.0377, 16-fold**); the
boundary test (**χ² 3.8396, naive p 0.0501, χ̄² p 0.0250**); and the entire REML row —
**h² 0.194140, logLik −2640.594179, CI 0.1161 to 0.2979, σ_A 0.52360, σ 1.06676, V_A REML/ML 1.03184,
V_R REML/ML 0.99819, n/(n−p) 1.00299** — reproduce digit for digit from my own code. My own
2000-replicate paired rerun of world 1 gives ML bias −2.6% and REML −0.3%, with **paired REML − ML =
+0.00436 (MC SE 0.00001)** against the chapter's **+0.00433**, and the real-data gap +0.00513 is exact.
Class 6's ceiling triple — **R = 0.7189, 95% CI 0.6556 to 0.7800** — is Class 6's printed line verbatim,
on the same 459 rows and 171 birds, and 0.7565 is Class 6's printed unadjusted comparison. Item 1
still passes: the residue is equation symbols, citation metadata, "95% CI" labels, the 50:50 mixture
and the 1.25 × SD/√R formula.

**All five blocking and all six required findings are closed, and all ten suggestions with them.** The
fixes are not patches: the eigenvalue line now teaches Mendelian sampling, the ML price is refused as
a lazy answer and then *computed and simulated*, the interval's centre is derived on the page, the
boundary test is run, and "recovers h² honestly" survives only as a sentence Itchy retracts out loud.
Five new findings, none of them a wrong number.

### Verdict

**Accept with required corrections** — no blocking findings. Five required: an REML log-likelihood
printed in the same column as two ML ones with no comparability caveat, in the chapter whose own
summary says that comparison is meaningless; a 3% ML price measured for the animal-only estimator in
a brood-free world and written into a methods sentence about the two-component number the chapter
actually reports (for that model the real-data ML-to-REML gap is **4.2%** against 2.7%, and my own
paired recovery in the matching world puts the estimator gap at **+3.7%** against +2.3%); a residual
REML/ML ratio below one set beside a prediction above one as though they agreed; "exactly one source
of leverage" counted in families and broods where the information lives in **19 736 related pairs that
do not share a brood**; and a phrase that puts Kruuk's "restricted maximum likelihood" in the title
rather than the abstract.

### Closed / not closed, per v1 finding

| # | v1 finding | status |
|---|---|---|
| 1 | blocking — "Class 9 … inside a Poisson" | **closed.** Now "a coin flip". The only two `Poisson` strings left are a namespace comment and the engine's own quoted error. |
| 2 | blocking — "Class 3's `Gamma` family" | **closed.** Now *"what a `Gamma` family is for; the engine ships one, and no class in this book teaches it, which is a gap in the book rather than in the engine"* — which is exactly what I verified (`DRM/src/gamma.jl` exists; `Gamma` appears in no other chapter). |
| 3 | blocking — the wrong Class 6 repeatability | **closed and exceeded.** Refit on `dropmissing([:Tarsus, :Wing])` with `Wing ~ Tarsus + (1 \| BirdID)` → **0.7189 (0.6556–0.7800)**, Class 6's printed triple exactly; the unadjusted **0.7565** is kept and named as the wrong fetch, with the gap quantified at **3.8 points**; Momo now identifies which is the ceiling and why. Fixed in all three homes — dialogue, Summary bullet ("**Conditioning counts as part of the trait**"), and Exercise 6 ("with the same fixed effects your animal model has"). |
| 4 | blocking — ML's price mis-quoted, then measured and misread | **closed.** `n/(n−p)` is now Itchy's *"lazy answer I want you to refuse"*, Momo names the wrong level, Class 8's rule is quoted, Kruuk's REML framing is used against the fit, a promise is made and kept, and world 1 is refit **paired** by both estimators. *"I nearly wrote 'recovers h² honestly' and it does not"* is the best available fix. |
| 5 | blocking — estimate / SE / CI incoherence, undeclared clamp | **closed.** The cell now prints `corrected`, `bias`, both candidate intervals labelled *"where it comes from"* and *"NOT what it printed"*, and the unclamped lower bound **−0.0022**; Momo raises it, Class 6's forecast is quoted, and the Julia summary cites `bias_correct.jl` and `heritability.jl` by name. The v1 mis-explanation ("clamped … the weaker of the two") is explicitly retracted in a new paragraph that gets the mechanism right. |
| 6 | required — the boundary comparison | **closed.** `lrt_boundary(full_model, brood_only; q = 1)`, with Eddie naming the parameter, the engine's own "NOT the σ_b = 0 boundary" cited, Toto reading the two sides of a twentieth, and a Summary bullet with Self & Liang and Stram & Lee. |
| 7 | required — the partition dialogue | **closed.** "in its place" is now the thing Itchy forbids; the shares (34% / 65%) and the covariance split (0.133 vs 0.592 / 0.038, 16-fold) are computed, spoken by Momo, and carried into the Summary. |
| 8 | required — Kruuk / Wilson attribution | **closed.** In-text: *"Kruuk and Hadfield (2007) is a whole paper on exactly this, and it is the one to cite; Kruuk (2004) and Wilson et al. (2010) are the introductions … but they are not where this argument lives."* References 1, 2, 4 and 6 all rewritten with the abstract/inference boundary marked. |
| 9 | required — reference 3's multi-generation mechanism | **closed, and it became the best new page.** Jaro asks, Itchy quotes the abstract, Eddie supplies the mechanism, and the rule generalises: *"the animal model separates genes from nest in proportion to how much of your relatedness comes from pairs who did not share one."* See N4 for the one thing wrong with the arithmetic under it. |
| 10 | required — "a hundred draws" against `nsim = 50` | **closed.** "fifty draws". |
| 11 | required — Class 6's twice-promised √R bound | **closed.** Eddie asks, two sentences deliver it, √0.7189 = **0.848** is computed inline, and it lands in the Summary and Exercise 6. |
| 12 | suggestion — the check that cannot fail | **closed.** The construction is in the comment, Jaro names Mendelian sampling, `n_half_eig` prints **1471 of 1675**, and Exercise 1 now asks whether the check could ever have failed. |
| 13 | suggestion — a weak cross-check | **closed.** Golden-section refinement off the grid plus bisected profile limits; the table prints log-likelihoods and Eddie says "seven digits". |
| 14 | suggestion — `g_tol` unverified | **closed.** *"It also settles the `g_tol` I chose out loud an hour ago."* |
| 15 | suggestion — V_P conditional on the fixed effects | **closed.** 0.0237 g² printed, 0.0525 against 0.0534, with the right warning about a covariate that matters. |
| 16 | suggestion — 0.955 quoted as 96% | **closed.** Now `round(…, digits = 3)` = **0.946**, matching the table. |
| 17 | suggestion — medians without MC SE | **closed.** `mcse_median` for all three worlds, plus ±1.5 points on the 83%, plus Exercise 4 asking for both. |
| 18 | suggestion — the worm-plot band | **closed.** The band is disqualified in the text, with the 39% brood share and 503 nests named, and "leaves the band" called over-confident. |
| 19 | suggestion — annotation notes | **closed** for references 1, 2, 4 and 6. |
| 20 | suggestion — the spatial tutorial's own warning | **closed**, in the Summary and in reference 7. |
| 21 | suggestion — `fig-relatedness` axes | **closed.** Chick codes on both axes; I re-rendered and looked. Legible at 8 pt, and the four full-sib blocks (5 / 2 / 9 / 2 among 18 chicks of one sire) are now readable by name. |

### New findings

N1. **required** — **an REML log-likelihood is printed in the same `logLik` column as two ML ones,
with no word that they are not comparable.** The `sim-machinery` table reads:

   ```
                                     h2         logLik     CI lo     CI hi
   the engine, by ML              0.1890     -2631.8575         -         -
   the same, read directly      0.189007   -2631.857496    0.1124    0.2909
   REML, one line changed       0.194140   -2640.594179    0.1161    0.2979
   ```

   All three reproduce exactly in my own code. But a reader who has just been taught that a
   log-likelihood is how you compare fits will read down that column, get
   2 × (−2631.857 − (−2640.594)) = **17.47 on 1 df**, and conclude REML is decisively rejected. The
   chapter states the guard two sections later, in the Julia summary, and about a *different* table:
   *"comparable across these fits because all four are maximum likelihood on the same rows. **Had one
   been REML, the comparison would have been meaningless** and Class 8 explains why."* Eddie's line —
   *"The two log-likelihoods agree to seven digits"* — shows the writer knows there are three. One
   clause on the REML row (a different objective, not a worse fit; ML and REML likelihoods are not on
   one scale) closes it, and it is the same lesson the chapter already owns.

N2. **required** — **the 3% ML price is measured for the animal-only estimator and written into a
methods sentence about the two-component number the chapter reports.** Momo: *"So **the number we are
going to report** is low by about 3%."* Itchy: *"That is exactly the sentence, and it is the right one
to put in a methods section: estimated by maximum likelihood … a simulation from the fitted model puts
the resulting downward bias at about 3% **of h²**."* Twenty lines later: *"the honest report from this
file is the second fit and not the first: h² = 0.053."* Those are two different estimators in two
different situations. World 1 has **no brood variance at all** and fits the animal-only model, whose
σ_A is comfortably interior; the reported model carries a brood term and a σ_A whose own interval the
engine had to floor at zero, and whose bias correction the chapter prints as **18.2%** against the
naive fit's **2.2%**. Nothing in the recovery study measures the ML bias of the estimator whose number
goes in the abstract.

   I ran the analogue the chapter already has the machinery for — REML on the **two-component** model,
   on the real data, by my own dense-Cholesky likelihood:

   | two-component fit, real data | σ_A | σ_B | σ_e | h² |
   |---|---|---|---|---|
   | ML (reproduces the chapter) | 0.274511 | 0.744589 | 0.884355 | **0.053374** |
   | REML | 0.281018 | 0.748536 | 0.883451 | **0.055623** |

   REML/ML on V_A is **1.048** and on h² is **1.042** — **+4.2%**, against the +2.7% the chapter
   measured for the animal-only model. I then ran the matching recovery study the chapter does not:
   world 2 (genes **and** brood, the world its reported model came from), refitting the
   **two-component** model to each replicate by both estimators, paired, with my own dense-Cholesky
   likelihood — 80 replicates, which is all a 2.4-second fit affords on a loaded machine:

   | world 2, two-component estimator, truth h² = 0.053374, R = 80 | mean | MC SE | bias | rel. |
   |---|---|---|---|---|
   | ML | 0.05318 | 0.00371 | −0.00019 | **−0.4%** (0.1 MC SE) |
   | REML | 0.05513 | 0.00375 | +0.00176 | +3.3% (0.5 MC SE) |
   | paired REML − ML | | | **+0.00195** (MC SE 0.00006) | **+3.7% of the truth** |

   Read that carefully, because it cuts two ways. At 80 replicates the MC SE on the mean is 7
   percentage points of the truth, so this run can neither confirm nor refute a 3% bias in the
   reported estimator — what it does establish is that **3% was not measured for it**, and that the
   two quantities I *can* measure precisely both come out larger for the reported model than for the
   one the chapter simulated: the paired estimator gap is **+3.7%** here against **+2.3%**
   (0.00433/0.1890) in world 1, and the real-data gap is **+4.2%** against **+2.7%**. It also shows
   the two estimators bracketing the truth rather than one of them being right — REML's own bias here
   is +3.3%, of the same size and the opposite sign.

   The fix is *not* "add `reml_too` to world 2": the chapter's fast route is the shared eigenbasis of
   `A` and the residual, and `A` and `Z_broodZ_brood'` do not share one, so there is no cheap
   two-component refit and the chapter is right not to attempt 500 of them. The fix is a clause —
   *"measured for the animal-only estimator; the ML-to-REML gap on the two-component fit these data
   actually got is 4.2%"* — which costs nothing, is computable from a model the chapter has already
   fitted, and keeps the methods sentence honest about which number it describes.

N3. **required** — **the residual REML/ML ratio is below one and is set beside a prediction above one
as though they agreed.** Itchy: *"On the **residual** the two estimators differ by a factor of 0.9982,
sitting next to the 1.00299 I nearly fobbed you off with."* REML's residual variance came out
**smaller** than ML's; `n/(n − p)` predicts **larger**. The argument being made is about *magnitude*
(0.2% against 3.2% on V_A) and that argument is correct and well made — but the page's whole new
subject is reading these ratios properly, and it prints a ratio on the wrong side of one without a
word. Class 8 supplies the sentence: *"the residual ratio is n over n − p multiplied by a small factor,
and that factor is only there because the two fits sit at slightly different values of τ"* — here at
different h², 0.189007 against 0.194140, which is enough to push 1.003 below one. One clause, and the
juxtaposition becomes the lesson it is meant to be.

N4. **required** — **"exactly one source of that leverage" is counted in families and broods, where
the information lives in pairs.** The new deep-pedigree exchange ends: *"Our file has exactly one
source of that leverage — the 140 pairs whose chicks are spread across broods and the 195 broods
holding more than one pair — and that is why the second model can be fitted at all and why its
interval is as wide as it is."* The quantity that carries the information is *related pairs that do
not share a brood*, and it is one line from `A` and the brood vector, both already in memory:

   | pair type | total | same brood | **different brood** |
   |---|---|---|---|
   | full sibs (A = ½) | 11 423 | 1 598 | **9 825 (86.0%)** |
   | half sibs (A = ¼) | 9 911 | 0 | **9 911 (100%)** |
   | any relatives | 21 334 | 1 598 | **19 736 (92.5%)** |

   plus **680 unrelated pairs that do share a brood** — the other half of the crossing. Full-sib
   families here run to 48 chicks while broods stop at 6, so the great majority of relatedness in this
   file comes with no shared nest attached. That is a much stronger statement of the chapter's own
   thesis than 140 and 195, it is the number Eddie's "anything two steps away" argument is actually
   about, and it makes the design's success comprehensible rather than lucky. The clause it does not
   support is *"and why its interval is as wide as it is"*: with 92.5% of the relatedness carrying no
   common environment, the width is better explained by σ_A being small and near a boundary — which
   the chapter has already established two ways — than by scarce crossing. (Effective sample size for
   σ_A is nearer the 208 families than the 21 334 pairs, so I am not claiming the interval *should* be
   narrow; I am saying the sentence attributes it to the wrong thing.)

N5. **required** — **"Kruuk 2004 says so in its title sentence" — it says so in the abstract.** The
Summary's REML bullet: *"this literature is a REML literature (Kruuk 2004 says so in its title
sentence)"*. The title is *"Estimating genetic parameters in natural populations using the 'animal
model'"* — it contains neither "restricted" nor "maximum likelihood". The phrase is the abstract's
opening: *"I review the recent application of restricted maximum-likelihood 'animal models' to
multigenerational data from natural populations."* Reference 2's annotation gets it right (*"its
abstract … describes the literature as **restricted** maximum-likelihood animal models"*) and so does
Itchy in the dialogue (*"Kruuk's paper describes this entire literature as…"*, naming no venue). Only
the Summary slips, and only by two words — but it is a citation claim in the revision whose subject is
citation discipline.

N6. **suggestion** — **the `class6-r` cell prints an estimate beside an interval it did not centre.**
`R of adult wing, ADJUSTED for tarsus : 0.7189 (95% CI 0.6556 to 0.7800)`. That interval is centred on
**0.7178**, not 0.7189 — Class 6 prints the missing pieces in its own cell (`bias estimate -0.00109,
bias-corrected point estimate 0.7178`). It is the configuration the chapter forbade forty lines
earlier: *"Report `corrected` and `bias` beside every ratio, or report the interval and say what it is
centred on."* The bias is small and the beat does not turn on it, which is exactly why the chapter's
own rule should apply to it.

N7. **suggestion** — **the Wald interval and the boundary LRT disagree, and the disagreement is the
lesson.** The two-component fit's interval on h² reaches **−0.0022** before the clamp — it covers zero
— while the boundary likelihood-ratio test on the same fit rejects σ_A = 0 at **p = 0.0250**. Itchy
half-notices (*"what the corrected p-value does not buy you"*), but does not name it: a Wald-type
interval and a likelihood-ratio test routinely disagree near a variance boundary, in this direction,
because the Wald interval assumes a symmetry the likelihood does not have there. The chapter has both
objects on the page, has just explained profile asymmetry for a variance ratio, and could close the
loop in a sentence.

N8. **suggestion** — **the Summary rounds 0.0501 to 0.05 and erases Toto's beat.** *"whose naive p is
0.05 and whose boundary-corrected p is 0.025. The reading flips on the correction."* At three digits
the naive p reads as exactly the threshold; Toto's line in the dialogue — *"just the wrong side of a
twentieth"* — needs the fourth digit the cell prints.

N9. **suggestion** — **three named citations appear in no reading list.** Self & Liang (1987) and
Stram & Lee (1994) are cited by name and year in the Summary and the cell comment, and Patterson and
Thompson in the `profile_ll` docstring. All three check out on OpenAlex — Self & Liang, *JASA* 1987,
"Asymptotic Properties of Maximum Likelihood Estimators and Likelihood Ratio Tests under Nonstandard
Conditions"; Stram & Lee, *Biometrics* 1994, "Variance Components Testing in the Longitudinal Mixed
Effects Model"; Patterson & Thompson, *Biometrika* 1971, "Recovery of inter-block information when
block sizes are unequal" — but the further reading has seven items and none of them is these. The
chapter is quoting the engine's own source comments, which is fine; the list should say so or carry
them.

N10. **suggestion** — **"about 3%" is a 500-replicate point estimate quoted bare where it matters
most.** The table prints its MC SE (0.0018 on the mean, so roughly ±1 percentage point on the relative
bias), and the Summary says "several Monte Carlo standard errors from zero". But the methods sentence
Itchy tells the reader to write carries the bare 3%. My 2000-replicate rerun puts it at **−2.6%**
(MC SE 0.5 points). The chapter's own new discipline — a median has a standard error like everything
else — applies to the number it is handing the reader to publish.

**Verified.** Every check the chapter added is a check I could reproduce, and several are stronger than
they need to be. The eigenbasis REML is correct Patterson–Thompson REML, not an approximation: it
recovers 0.194140 and −2640.594179 from an independent implementation, and its profile limits agree
with mine to the fourth digit after bisection. The paired design is the right design — the paired
REML − ML difference has an MC SE of 0.00001 against a 500-replicate spread of 0.0018, which is why
0.00433 lands within 0.00003 of my 2000-replicate 0.00436. `lrt_boundary` returns exactly the
statistic and both p-values I compute by hand, and the halving is the Self–Liang q = 1 rule applied
correctly. The bias-correction beat is right in every particular: `ci = corrected ± z·se`
(`bias_correct.jl:142–144`), `corrected = estimate + ½ tr(H_g V)`, the clamp is `_clamp01`
(`heritability.jl:107–109`), and all three inverted centres — 0.19315, 0.06313, 0.38887 — match the
printed intervals. The partition arithmetic, the sib covariances and the fixed-effect variance all
reproduce to four decimals. The Class 6 ceiling is now Class 6's exact printed triple on Class 6's
exact rows. Both regenerated figures teach their captions: the heatmap is now readable by chick code
and the wash is still `#3B528B` = 0.25, and the 500-replicate recovery curves are smoother, all three
with real mass over the black 0.1890 line, with world 1's dashed truth hidden beneath it as the text
says and the largest estimate (0.4025) safely inside the top bin edge — a guard the chapter now prints.
All five journal citations remain exact. Item 1 passes. Every retired claim is gone from the Summary
and the Exercises, and the one surviving instance of "recovers h² honestly" is Itchy taking it back.

### Re-derivations (new or moved in v2)

- **REML, animal-only, own eigenbasis profile with golden-section maximisation and bisected limits**:
  h² **0.194140**, logLik **−2640.594179**, CI **0.1161–0.2979**, σ_A **0.52360**, σ **1.06676**;
  V_A REML/ML **1.03184**, V_R REML/ML **0.99819**, n/(n−p) **1.00299**; real-data gap **+0.00513**.
  ML row unchanged and exact: 0.189007, −2631.857496, 0.1124–0.2909.
- **Paired world-1 recovery, own generator, R = 2000, grid step 5e−4**: ML mean 0.1840 (MC SE 0.0009,
  bias −2.6%, 5.4 MC SE); REML mean 0.1884 (MC SE 0.0009, bias −0.3%, 0.7 MC SE);
  **paired REML − ML +0.00436 (MC SE 0.00001)** against the chapter's +0.00433 at R = 500.
- **Two-component model, own dense-Cholesky ML and REML, real data**: ML 0.274511 / 0.744589 /
  0.884355, h² 0.053374; REML 0.281018 / 0.748536 / 0.883451, h² **0.055623**; REML/ML on V_A 1.048,
  on h² **1.042**.
- **Two-component recovery in world 2, paired, R = 80**: ML mean 0.05318 (MC SE 0.00371, bias −0.4%);
  REML mean 0.05513 (MC SE 0.00375, bias +3.3%); paired **+0.00195 (MC SE 0.00006) = +3.7%**.
- **Bias inversion from the printed intervals**: naive corrected **0.19315** (bias +0.00414, +2.2%);
  two-component corrected **0.06313** (+18.3%), unclamped lower **−0.00213**; brood share corrected
  **0.38887** (−1.0%). All three match the cell's printed values and `bias_correct.jl:142–144`.
- **Boundary test, by hand**: χ² **3.8396** on 1 df; naive p **0.0501**; ½χ²₀ + ½χ²₁ p **0.0250**.
- **Crossing, counted in pairs** (one line from `A` and the brood vector): full sibs 11 423 total,
  1 598 same brood, **9 825 different brood (86.0%)**; half sibs 9 911, **all in different broods**;
  all relatives 21 334, **19 736 (92.5%) in different broods**; **680 unrelated pairs share a brood**.
- **Partition, fixed effects, covariances**: brood block 0.554413 g² sourced 0.190338 (34.3%) from
  V_A and 0.357959 (64.6%) from V_R; var(fitted) 0.02365 g²; h² on a full-variance denominator
  0.0525; full-sib covariance 0.1328 (pedigree only) against 0.5921 / 0.0377 (16.0-fold).
- **Chapter 6's freeze**: `by hand R = 0.7189`; `delta R = 0.7189 SE 0.0317 95% CI 0.6556 to 0.7800`;
  `bias estimate -0.00109, bias-corrected point estimate 0.7178`; unadjusted 0.7565; 459 rows,
  171 birds. The chapter's ceiling line reprints this exactly.
- **OpenAlex**: Self & Liang, *JASA* 1987; Stram & Lee, *Biometrics* 1994; Patterson & Thompson,
  *Biometrika* 1971 — all three real, correctly attributed, none in the reading list.
- **Figures** (both regenerated ones re-rendered at 2× and read as images): `fig-relatedness` now
  carries chick codes on both axes, wash still `#3B528B` (0.25) and blocks `#21908D` (0.5);
  `fig-recovery` at 500 replicates shows all three curves with real mass over the black 0.1890 line,
  world 1's dashed truth hidden beneath it, and every curve back to zero inside the 0.45 top edge.

---

## Third pass (3e2817e)

Read the source and freeze at the new commit; re-derived both new cells against the code I already
had. Short pass — no new re-rendering, no new simulation.

### Per item

| item | status |
|---|---|
| **N1** — REML logLik comparability | **closed.** A printed line under the table: *"(REML's logLik is not comparable to the ML rows above it -- a different objective, not a worse fit)"*. |
| **N2** — the 3% attached to the wrong estimator | **closed, and better than the fix I proposed.** The bare "3%" is gone: it is now **3.3% with its MC SE (1.0 points)**, explicitly *"for the animal-only model — world 1 carries no brood term at all"*. A new `reml-two-component` cell does the one thing I said was affordable — one dense two-component fit, twice — and the methods sentence is now two sentences naming both estimators and both numbers. The cell also explains *why* there is no cheap recovery study (A and the brood matrix share no eigenbasis), which is the constraint I had to work out for myself. |
| **N3** — residual ratio below one | **closed.** *"Notice which side of one that sits on — below, where n/(n−p) sits above. That is not a contradiction: … the two fits sit at slightly different heritabilities, 0.189007 against 0.194140, which is enough to push it under one."* That is Class 8's mechanism, stated. |
| **N4** — leverage counted in groups | **closed.** A new `leverage-pairs` cell counts pairs, and the width clause is reattributed exactly where the evidence puts it: *"scarce crossing is not the bottleneck. σ_A is small and sits near the boundary the last cell tested … its effective sample size is nearer the 208 families than the 21334 pairs."* |
| **N5** — "in its title sentence" | **closed.** Now "in its abstract"; the string "title sentence" is gone from the file. |
| **N6** — Class 6's interval centre | **closed.** `bias -0.00109, bias-corrected point estimate 0.7178 <- what that CI is actually centred on` — Class 6's own printed values, to the digit. |
| **N7** — Wald vs LRT at the boundary | **closed.** *"a Wald interval and a likelihood-ratio test routinely disagree this close to a variance boundary, because the Wald interval assumes a symmetry the likelihood does not have there."* |
| **N8** — 0.0501 rounded to 0.05 | **closed.** Summary now at `digits = 4`. |
| **N9** — three uncited names | **closed.** New reference 8 carries all three, and the front-matter note extends the OpenAlex check to item 8. I verified the details: Self & Liang, *JASA* **82(398):605–610**, doi:10.1080/01621459.1987.10478472; Stram & Lee, *Biometrics* **50(4):1171**, doi:10.2307/2533455; Patterson & Thompson, *Biometrika* **58(3):545–554**, doi:10.1093/biomet/58.3.545 — all exact, authors in order. |
| **N10** — "about 3%" quoted bare | **closed** by the same edit as N2: the figure now carries its MC SE everywhere it appears, dialogue and Summary alike. |

### The two new cells, checked against my own code

**`reml-two-component`** — reproduces my independent dense-Cholesky Nelder–Mead fits **to every printed
digit**, from a different optimiser and a different starting point:

| | h² | brood | σ_A | criterion |
|---|---|---|---|---|
| chapter, ML | 0.053374 | 0.392685 | 0.27451 | −2513.5437 |
| mine, ML | 0.053374 | 0.392685 | 0.274511 | −2513.54371 |
| chapter, REML | 0.055623 | 0.394647 | 0.28102 | −2521.5368 |
| mine, REML | 0.055623 | 0.394647 | 0.281018 | −2521.53678 |

REML/ML on h²: chapter **1.04215**, mine **1.04214** (a 1e−5 coordinate-ascent tolerance). Eddie's
cross-check holds: the ML row is `full_model`'s 0.053374 to six digits.

**`leverage-pairs`** — every cell of the table is mine exactly: full sibs 11 423 / 1 598 / **9 825
(86.0%)**; half sibs 9 911 / 0 / **9 911 (100%)**; all relatives 21 334 / 1 598 / **19 736 (92.5%)**;
**680** unrelated pairs sharing a brood.

### One new suggestion

**suggestion** — **"every half sib, because none of them are nest-mates by definition" is not a
definition, it is this file's fieldwork, and the chapter already printed the reason.** Two paternal
half sibs *would* share a brood if a brood held chicks of two pairs sharing a sire; that never happens
here because — as the `crossing` cell printed two pages earlier — all **195 of 195** mixed broods have
**both** sire and dam differing. `half_same = 0` is a measurement, and the better sentence is already
on the page: *no brood in this file holds two chicks with one parent in common*. One clause, and the
strongest number in the new cell stops resting on a word that would be wrong in most pedigrees.

*(Noted, not raised: `fit_two` is a warm-started coordinate ascent inside ±0.03 / ±0.05 of the engine's
estimate, so it is a local search presented as a fit. It lands on the right point here — my
Nelder–Mead from `log([0.2745, 0.7446, 0.8844])` with a free search finds the same optimum to six
digits — but the brackets are an assumption the cell does not state.)*

### Verdict

**Accept.** All ten items from the second pass are closed, both new cells reproduce digit for digit
against independent code, reference 8's three entries are exact on OpenAlex, and no retired wording
survives ("title sentence", "exactly one source", the bare "about 3%" are all gone). One suggestion
remains, worth a clause: "by definition" should be "in this file", with the 195-of-195 count that
already proves it.
