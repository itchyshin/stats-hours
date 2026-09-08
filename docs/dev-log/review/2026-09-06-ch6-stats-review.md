# Chapter 6 — adversarial statistical review (as executed)

## Review (a692761)

Read against the frozen outputs, the rendered SVGs, `DRM.jl/src/heritability.jl` and OpenAlex, with
an independent refit from `data/2012/BodySize.csv` (own GLS profile, ML and REML, plus the Lessells &
Boag moment estimator). **Every executed number reproduces exactly** — σ_u 1.7541, σ 1.0969, R 0.7189,
unadjusted 0.7565, MSa 11.8260, MSw 1.2468, n0 2.682942, R_anova 0.759769. Item 1 passes: no numeral
is spoken bare; all twenty are inline `{julia}`.

## Verdict

**Block** — the arithmetic is clean, but the chapter's two payoff claims, the repeatability ceiling
and the divisor it hands to Class 8, are wrong.

## Findings

1. **blocking** — Itchy: *"if your measurement of wing length is only 72.0% repeatable, then no
correlation between wing length and anything else can do better than that."* The attenuation ceiling
is **√R = 0.848**, not R = 0.719: a correlation with a perfectly measured trait is bounded by
√(R_x R_y). The R-not-√R bound is the **heritability** result h² ≤ R — a different theorem, and
Class 10's. Exercise 8 asks students to compute this ceiling, so it propagates into marking, and
Nakagawa & Schielzeth (2010), cited twice here, has it right.

2. **blocking** — the DISAGREE box attributes the whole ANOVA-versus-likelihood gap to Class 2's
*n* against *n − p*. Measured: ANOVA/ML on σ_u² is **1.018922**, REML/ML **1.006614** — the divisor
accounts for about a third; the rest is that the moment estimator is not REML when *k* is unequal.
And *n* against *n − p* is the **residual**-level divisor, while Class 8 as now written teaches one
divisor **per level**, J/(J−1) = 1.005882 at the group level — so the seed contradicts the chapter it
is planted for. Fix: fit REML and show 0.7577 between ML 0.7565 and ANOVA 0.7598, naming both causes.

3. **required** — *"459 birds' worth of confidence out of 171 birds' worth of data"* and *"171
genuinely independent pieces of evidence, not 459"*. The executed SE ratio 1.2974 implies effective
n = 459/1.2974² = **273**; were it 171 the ratio would be √(459/171) = 1.638. The direction and
mechanism (tarsus is 92.9% between-bird) are right; the number is not, because tarsus is not
*purely* between-bird. "Closer to 171 than to 459" is true and better teaching.

4. **required** — the conditional-residual explanation is backwards. Itchy blames shrinkage for
SD 0.9039 < σ 1.0969; shrinkage pushes the **other** way (no shrinkage would give 0.869, the fitted
amount gives 0.903). The shortfall is dominated by σ²(1 − 1/k), the cost of estimating each bird's
own mean — this chapter's own divisor seed doing real work.

5. **required** — the diagnostic figure does not show what the text claims. `cond_resid ./ sigma_e`
divides by 1.0969 when the SD is 0.9039, so the worm plot is under-dispersed by construction: it
tilts monotonically and sits outside the ±2SE band along its whole length. "Judge the shape, not the
scale" cannot rescue it — a pure scale error **is** a shape here, of slope 0.824 − 1. Standardise by
`std(cond_resid)`.

6. **required** — the interval is unnamed and is the engine's weaker default. `repeatability` takes
`method = :delta` (Wald on the ratio, clamped to [0,1]) unless told otherwise; `method = :profile`
exists and is documented as the one with intended coverage. The chapter prints "95% CI 0.6556 to
0.7800" and never says which — its own sin, in a chapter about naming what the software chose. The
returned `bias` / `corrected` are advertised in "Julia stuff" and never shown.

7. **suggestion** — a stray `0.2292173498485901` reaches the rendered page (the cell's last
expression); add a `;`. The caterpillar cannot support "a bird with four measurements is pulled
less" — the printed `kept` range does (0.836 at k = 2, 0.911 at k = 4). And λ = kσ_u²/(kσ_u² + σ²)
is Spearman–Brown; naming it costs three words.

**Verified.** OpenAlex confirms both citations to title, journal, volume, pages and DOI — Nakagawa &
Schielzeth 2010, *Biol. Rev.* 85(4):935–956; Lessells & Boag 1987, *The Auk* 104(1):116–121 — each
cited for a claim it carries. The simulate cell does
subtract `fitted(fit)` before comparing spreads, and teaches the conditional-on-zero trap. "Every
diamond is closer to the middle" holds for all 171 birds, not just the 13 drawn. The error cell stays
in. The R box is earned but thin — the disagreement is shown entirely in Julia. Self-citation is fine;
the exposure is finding 1, stating the attenuation rule wrongly while citing, twice, the paper that
states it correctly.

## Re-derivations

- REML σ_u 1.97371 against ML 1.96721 (unadjusted). Class 8's identity holds: σ_u² ratio **1.006614**
  = (τ_R/τ_ML)² 1.006604 × σ² ratio 1.000011, against J/(J−1) = 1.005882. ANOVA/ML is **1.018922**.
- Effective n: 459/1.2974² = **272.7**; √(459/171) = 1.6384.
- Ceiling: √0.7189 = **0.8479**.
- Conditional residual: Σ_k n_k[σ²(1−1/k) + (1−λ_k)²(σ_u² + σ²/k)]/n → SD **0.9029** against 0.9039
  observed; at λ = 1, **0.869**.

## One question for Shinichi

Finding 1 has two honest repairs that teach different chapters: state the attenuation formula
properly here, which needs √ and the reliability of the *second* trait, or drop the correlation
framing and make the ceiling h² ≤ R — the version where the answer really is R, pointing straight at
Class 10. Which should Week 6 own?

---

## Re-review (e584f72)

Checked against the re-frozen outputs and the re-rendered SVGs, not the commit messages. The divisor
decomposition and the residual accounting were re-derived from my own refit; both citations re-queried
on OpenAlex.

| # | was | status |
|---|---|---|
| 1 | √R ceiling wrong | **resolved**, by redesign |
| 2 | divisor box blames one cause | **resolved** |
| 3 | "171 not 459" | **resolved** |
| 4 | residual explanation backwards | **resolved** |
| 5 | diagnostic under-dispersed | **resolved** |
| 6 | interval unnamed | **resolved** |
| 7 | stray value, caterpillar, Spearman–Brown | **resolved** (all three) |

**1.** The ceiling beat is now h² ≤ R, executed (V_between 3.0770, V_within 1.2032, total 4.2802,
R 0.7189) and argued correctly: both ratios share a denominator and V_A is a part of V_between, so the
inequality follows. The estimator and the conditioning are named in the cell output itself, and
Exercise 8 is rewritten to match. The √R point survives as a one-line warning and **is right** —
√R is a valid cap, since the tight bound √(R_x R_y) is smaller whenever the second trait is itself
imperfectly measured.

**2.** Three routes are now executed — ML 0.7565, REML 0.7577, ANOVA 0.7598 — and split on the
variance scale. My independent refit gives REML/ML **1.006614** (exact match), ANOVA/REML **1.012222**
against the printed 1.012226, and ANOVA/ML **1.018922** against 1.018921; the last digits are
optimiser tolerance, and the printed product 1.006614 × 1.012226 = 1.018921 is internally exact.
Consistent with Class 8: the box compares 1.006614 *against* J/(J−1) = 1.005882 rather than claiming
equality, and it now puts the divisor at the group level — "*J* birds in place of *n* rows … one
divisor per level" — which is the identity as Class 8 now teaches it. The second factor is correctly
named as moments-against-likelihood under unequal *k*, and the box says so itself: the divisor
"explains about a third of it".

**4.** The new `residual-accounting` cell reproduces my re-derivation to the digit: 0.8689 after
paying for each bird's own mean, 0.9029 with shrinkage added back, 0.9039 observed, and λ = 0.8365 /
0.8847 / 0.9109 at k = 2 / 3 / 4. Momo's wrong guess is now the teaching move rather than the
explanation.

**5.** `cond_resid ./ std(cond_resid)` — the tilt is gone. In the re-rendered figure the body sits
inside the ±2SE band and three genuine tail outliers stand clear of it, so the shape is now judgeable,
which is what the text asks the reader to do.

**6.** Both intervals are printed side by side (delta 0.6556–0.7800, profile 0.6520–0.7764), the
default is named, the profile is recommended, and Itchy calls the omission "the sin this whole book is
about, committed by me, in a cell, on purpose". That is the right repair.

### New, and still open

- **required** — the h² ≤ R claim is stated more broadly than the literature supports. The chapter
  calls it "the theorem" and "arithmetic rather than an approximation", and Eddie is told that a paper
  reporting h² above its R means "one of the two numbers is wrong". The arithmetic is sound *within
  this chapter's decomposition*, but Dohm (2002), "Repeatability estimates do not always set an upper
  limit to heritability", *Functional Ecology* 16:273–280 (382 citations, verified on OpenAlex), is a
  well-cited paper arguing the general claim fails — genotype-by-environment interaction, differing
  phenotypic bases, genetic variance inside the within-individual term. Cite it and scope the theorem
  to the decomposition, or soften Eddie's answer. As written, a student who finds h² > R is told the
  paper is wrong when the design may simply be one the bound does not cover.
- **open (carried)** — "Nakagawa and Schielzeth (2010) make exactly this argument" is a **content**
  claim. OpenAlex confirms the record and that the paper covers the ICC and the correlation-,
  ANOVA- and LMM-based routes — which independently supports the disagreement box — but the
  heritability-bound argument cannot be checked from metadata. The chapter's `[PARTLY UNVERIFIED]`
  marker covers bibliography, not content. Confirm before print.
- **suggestion** — "They differ here in the second decimal place of the lower bound": 0.6556 and
  0.6520 agree to the second decimal and first differ at the third.

## Verdict (re-review)

**Approve with changes** — all seven findings are resolved and re-verified from the executed cells,
with the divisor decomposition and residual accounting reproducing my own arithmetic; one new required
item remains, that h² ≤ R is asserted more broadly than the literature allows.
