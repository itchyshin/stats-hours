# Chapter 8 — adversarial statistical review (as executed)

Read against the frozen `execute-results/html.json`, the rendered SVGs, and the two engines' sources.
I refitted both estimators independently from `data/ch8/tadpoles.csv` (own GLS profile, no Julia).

## Verdict

**Block** — every executed number checks out, but three prose claims do not, and the central beat is wrong on the merits.

## Findings

1. **blocking** — qmd:125, Jaro: *"On ten thousand rows the two answers agree to four decimal places."* Not executed, and false. With J = 12 and n from 120 to 12,000 the σ_u REML/ML ratio goes 1.0497 → 1.0445, not to 1; only **J** shrinks it (J = 600 → 1.0009). Contradicts qmd:228 and Exercise 2. Fix: "ten thousand **ponds**", or cut.
2. **blocking** — divisors cell, qmd:208–222. J/(J−1) is not a "naive guess": it is the **exact n → ∞ limit** of the σ_u² ratio here (measured 1.09098 at n = 12,000 vs 1.09091), and n/(n−p) is exact for σ² at fixed τ. So "neither guess is right" dismisses two correct asymptotic answers, and "there is no clean n − p to write down" is false: there is one divisor **per level** and the observed numbers are their product (below). Nobody proposes J/(J−1) in dialogue either. Fix: print the decomposition.
3. **required** — qmd:253: *"Do it on forty datasets and ML is low on all forty."* Unexecuted; `boundary_study` is three lines from checking it.
4. **required** — `chibar` cell. The demo lands on `statistic = 0.0`, where 0.5 is the strict tail P(T > 0); the p-value P(T ≥ 0) is 1, as `src/chibar.jl` notes. Toto and Jaro generalise ("always exactly half") from the one point where the formula is not a p-value, and where 1.0 → 0.5 buys nothing. Fix: a second puddle seed with stat > 0.
5. **required** — `fig-shrinkage`: twelve tick labels, **eleven** visible pairs. P05 (raw mean 2.603, the largest) sits under the legend at `:rt` (`tools/figures.jl:144`). Toto's "the small ponds moved more" (qmd:275) holds for the printed *factors*, not the *picture*: P05 (n = 11) moves 0.231 mm, P01 (n = 8) moves 0.004 mm. Move the legend; split the claims.
6. **required** — qmd:438. 0.603 vs 0.5 is real but explains less than it is asked to: pile-up alone predicts a χ̄² rejection rate of 0.397 × 0.10 = 0.040, against 0.020 observed. The non-zero statistics are lighter-tailed than χ²(1) too at J = 5. One sentence, or cite Crainiceanu & Ruppert (2004, JRSS-B 66:165–185).
7. **required** — qmd:277 promises "every one of those diamonds sits on exactly the same line". Never drawn; `fig_shrinkage(...; boundary = true)` exists for it.
8. **required** — qmd:455–457 cites Bolker et al. (2009) for "the optimiser and convergence-criterion defaults"; that is a GLMM guide whose software table covers PQL/Laplace/GHQ. Verify, or move the claim to Bates et al. (2015, JSS). Conversely, Self & Liang and Stram & Lee **are** verifiable in-repo (`drmTMB:R/profile.R:365–372`) — narrow the blanket `[UNVERIFIED]`.
9. **required** — `the-climb.md:49–58` wants a `simulate` cell from chapter 2 on; chapter 8 has none, though `simulate(fit; nsim)` is exported (`ranef` is used directly — good). And `boundary_study` redraws group sizes per replicate, so 0.603 averages over *designs*, while Exercise 5 tells students to hold sizes fixed.
10. **suggestion** — R moves 0.4823 → 0.5037, **crossing one half**, unremarked: the sharpest form of the chapter's thesis.

**Verified in source.** The guard's *why* matches `src/comparison.jl:127–141` (it fires on `_mean_structure` mismatch only). qmd:535 on drmTMB is right, and is an absence: `anova.drmTMB` refuses everything (`R/methods.R:2703–2710`), and no χ̄² test exists there. The lme4 block reproduces our fits to every printed digit, and my own REML refit returns σ_u = 1.01660, σ = 1.00913, ℓ_R = −183.98271 — exactly the executed values. No σ-ribbon. The closed-form profile check defuses most of the "engine as ground truth" charge, but covers ML only.

## Re-derivations

From the CSV: σ_u 1.01660/0.96943 = 1.048656, squared **1.099680** (printed 1.0997); σ 1.00913/1.00430 = 1.004813, squared **1.009648** (printed 1.0096); J/(J−1) = 1.090909; 117/115 = 1.017391. All match. The missing decomposition (τ̂_ML = 0.965283, τ̂_REML = 1.007402):

- σ² ratio = [n/(n−p)] × [q(τ̂_R)/q(τ̂_ML)] = 1.017391 × 0.992389 = **1.009648**
- σ_u² ratio = (τ̂_R/τ̂_ML)² × σ² ratio = 1.089172 × 1.009648 = **1.099680**, with 1.089172 → J/(J−1) as n → ∞.

Each guess is exactly right about its own level; the finite-sample numbers are their product.

Monte Carlo SE at 300 reps: pile-up 0.603, SE √(0.603·0.397/300) = **0.0283**, i.e. 3.65 SE above 0.5 — that claim holds. Naive 0.007 (2/300), SE **0.0047**; χ̄² 0.020 (6/300), SE **0.0081**, upper 2-SE 0.036 < 0.05. So 300 suffices for every claim made. But "the naive one is worse" needs no evidence: the rejection regions are nested (naive p < 0.05 ⟺ χ̄² p < 0.025), so the ordering is deterministic and rests on 4 discordant replicates. Print the MCSEs, or raise to 2000 (seconds).

## What survives #754

Almost everything. The chapter never calls `summary(fit)`, so the z/p change cannot reach it — and by the same accident it already dodges the scale-block `NaN`. One exposure: the `println(fit)` blocks get re-frozen, so a natural-scale σ line would land beside the log-scale `sigma:`/`resd:` lines right under Itchy's "that is log σ_u" (qmd:313). The sentence survives, the screen turns ambiguous — name the scale. Re-check the `confint` log-scale note (qmd:232, 564) only if #754 moves interval scales too.

## One question for Shinichi

Finding 2 turns the divisor beat into "one divisor per level, and the answer is their product" — truer, but it puts a two-factor identity in front of a reader two chapters after meeting a random intercept. Full decomposition in the class, or a footnote with Jaro keeping the plain-language version?

---

## Re-review (60b7de7)

Checked against the re-frozen `execute-results/html.json` and the re-rendered SVGs, not the writer's
report. Both identities re-derived from the frozen output; both engine claims re-checked in source.

| # | was | status |
|---|---|---|
| 1 | "ten thousand rows" | **resolved** |
| 2 | "naive guess" / "no clean n − p" | **resolved** |
| 3 | "40 of 40" unexecuted | **resolved** |
| 4 | χ̄² demo at statistic = 0 | **resolved** |
| 5 | `fig-shrinkage` hides P05 | **partly** — chapter fixed, helper not |
| 6 | pile-up over-explains | **resolved** |
| 7 | boundary picture promised | **resolved** |
| 8 | Bolker citation | **resolved** |
| 9 | no `simulate` cell | **resolved** |
| 10 | R crossing one half | **resolved** |

**1.** The `n-vs-j` cell executes the right experiment: rows grown with J = 12 give σ_u² 1.09968 → 1.09178 → 1.09100 at n = 11,758, stopping on J/(J−1) = 1.09091, while ponds grown to J = 300 give 1.00361. That reproduces my independent run (1.09100 at n = 9,600). "Rows do not buy you a variance component. Groups buy you a variance component" is the correct mechanism, stated better than I asked for.

**2.** The divisors cell now prints "its divisor" and the identity. Re-derived from the frozen output: 1.017391 × 0.992389 = **1.009648** and 1.089172 × 1.009648 = **1.099680**, with (τ_R/τ_ML)² = 1.089172 against J/(J−1) = 1.090909 — all to 6 dp against my own refit. Jaro's "it generalised **per level**" replaces the false claim.

**4.** Better than the fix I proposed. Jaro now states the catch outright — at stat = 0, 0.5 is P(T > 0) while P(T ≥ 0) is 1 — and seed 55 supplies a positive draw (stat 3.335598, χ̄² 0.0338979, naive 0.0677957; the halving checks). The added note that the corrected test makes the Type I error on that draw, because σ_u is truly zero, is the honest reading and I did not ask for it.

**5. Partly.** All twelve ponds are visible in the re-rendered figure, P05 included, and the `n_j` / `kept` / `moved` table plus Itchy's speech now keep the fraction and the distance apart — the exact confusion I flagged. But the fix is a per-call workaround (`fig.content[2].halign = :left`); `tools/figures.jl:144` still carries `position = :rt`, so the next chapter to call `fig_shrinkage` inherits the bug.

**6.** Now a proper parametric bootstrap: design held fixed, response redrawn from the reduced fit, 2000 reps, MCSEs printed. Pile 0.5535 ± 0.0111 — 4.8 MCSE above 0.5. Pile-implied 0.0447 against measured 0.0160 ± 0.0028, about 10 MCSE apart, so the "second effect" claim is earned; Crainiceanu & Ruppert cited. **Note for the coordinator:** the report quoted "0.0428 vs 0.0230"; the executed cell says **0.0447 vs 0.0160**. The chapter is right and the report is wrong — do not quote the report.

**9.** `simulate(fit_red; nsim)` now generates the null, the design is held fixed (matching Exercise 5), and the spread-check cell teaches the-climb's own trap. Both engine claims verified in source, not inferred: `simulate` is "conditional on the random effects being zero (population level)" (`DRM.jl/src/gaussian_core.jl:1720`) and `fitted` is "the population/marginal mean `Xβ̂`" (`:1279–1282`), which is why `raw` is the fixed-part mean.

### Remaining marker

`[PARTLY UNVERIFIED]` (qmd:766) is now scoped honestly: items 2 and 3 are verified verbatim against both engines' sources. It still covers items 1, 4, 5, 6 and 7 — including **both citations this revision added** (Bates et al. 2015 for finding 8, Crainiceanu & Ruppert 2004 for finding 6). The fixes are sound; their bibliography is unchecked. Close it before print.

### New, minor

- **suggestion** — `tools/figures.jl:68–75`: `fig_varcomp` still renders the σ pair grey/black against a teal/orange legend, because the colour cycler advances inside the loop. Pin `Cycled(1)`/`Cycled(2)`.
- **suggestion** — DRM.jl's `fitted` and `residuals` are marginal (Xβ̂); lme4's are conditional on the BLUPs. The chapter builds `raw` from `fitted(fit_ml)` and never says so. In a chapter about unlabelled defaults, written for R users, that is one sentence worth spending.

## Verdict (re-review)

**Approve** — all ten findings addressed, both identities and the boundary study re-verified from the executed cells; what remains is two shared-helper suggestions and an unchecked bibliography.
