# Chapter 3 — adversarial statistical review (as executed)

## Review (4275a16)

Read against the frozen outputs and rendered SVGs, with an independent IRLS refit of all four models.
**Every executed number reproduces exactly** — the Gaussian extrema and its 4 illegal fits, the logit
slope and OR, all three predicted probabilities, the delta SE, both two-predictor fits, ΔAIC, the
Poisson coefficients and the count moments. The pre-rendered R block matches to every digit, including
residual deviance 1930.0, AIC 1936 and null deviance 2159.9 (mine 2159.86). Item 1 passes: the only
bare numerals in dialogue are "Class 2 / 6", "Week 4" and a citation year; all 36 quantities are
inline `{julia}`.

## Verdict

**Block** — one sentence, repeated in the summary and set as an exercise, is contradicted by the
chapter's own `predict` output three cells earlier.

## Findings

1. **blocking** — *"a gram matters enormously to a small chick and hardly at all to a big one"*, and
the summary's *"diminishing returns"*. The executed predictions say the opposite here: 2.0 → 3.5 g
buys **+0.2142** of probability, 3.5 → 5.0 g buys **+0.2551**. A logistic curve is symmetric about
p = ½, here at 4.02 g — *above* the mean mass of 3.63 — so across the bulk of these data it is
**accelerating**. Toto's "the curve flattens out at both ends" is the correct reading and Itchy
overwrites it. Exercise 3 asks students to compute exactly these two differences and explain why they
differ, so it hands back the opposite of what was taught.

2. **required** — the binomial "decree" is misfiled. For a 0/1 response Var = p(1−p) is an
**identity**, not an assumption: there is no overdispersed Bernoulli. Dispersion in binary data enters
only through **clustering** — the broods this chapter pretends away — so "if the decree is wrong …
Week 4" points at the wrong chapter; here it is Class 6. And "the spread is about one, which is the
model's claim about the noise being met" asks more than binary data can give: an RQR SD near 1 is
close to automatic for 0/1 responses.

3. **required** — `ChickSurvival.csv` carries no brood identifier (Survival, Sex, Mass2, BroodSize,
JulianDate). The front box promises Class 6 ends the pretence and Exercise 9 asks the reader to name
the grouping, but the repair cannot be run on this file. One clause fixes it: the brood is not
recorded here, so the fix is a different dataset, not a different formula.

4. **required** — the box is tagged **⚠ DISAGREE** and its own headline says "no disagreement in the
numbers". The conventions want a named mechanism and a computable boundary; this has neither, and
needs neither. It is a translation box, and a good one. Relabel it.

5. **required** — the simulation cell seeds the **global** RNG (`Random.seed!`), while the chapter's
own bullets say "Pass the `rng`" and "Every random draw in this chapter … is made from an explicit
`MersenneTwister`". The page is reproducible; that provenance sentence is false for the one cell.

6. **suggestion** — what *else* is wrong with the Gaussian fit is never said: its constant-σ
assumption is violated by construction, so its standard errors are wrong even where its predictions
are legal. That is this chapter's own theme, never turned on the wrong model — and as it stands the
impossibility rests on 4 of 1576 fitted values.

7. **suggestion** — neither quantile-residual SD carries an error bar, and that is the judgement being
made. MC SE of an RQR SD is 1/√(2n): **0.0178** for the logistic, so 1.0201 is 1.13 SE from 1;
**0.0554** for the Poisson, so 1.2981 is **5.4 SE** from 1. Also "AIC went −5.57" reads as a value
rather than a change.

**Verified.** All five citations check on OpenAlex — Warton & Hui, *Ecology* 92:3–10 (the note that
OpenAlex records the online-first year as 2010 is exactly right); Bolker 2008; Zuur et al. 2009;
Dunn & Smyth, *JCGS* 5:236–244; McCullagh & Nelder 1989 — and attributing claims "no more narrowly
than a title or abstract supports" is better discipline than Classes 6 and 8 manage. The odds language
is correct throughout: 2.01 is a multiplication, per gram, never a probability. Quantile residuals are
the right object, the Poisson worm plot shows the tilt the text claims, the simulate cell refits
rather than comparing spreads, the brood-size reversal is handled honestly, and the two-shapes figure
earns its place.

## Re-derivations

- p(2.0) 0.1954, p(3.5) 0.4096, p(5.0) 0.6647 → **+0.2142** then **+0.2551**. Inflection at
  −b₀/b₁ = 2.8152/0.6999 = **4.02 g**; mean mass 3.63.
- ΔAIC: −968.7711 → 1941.5423; with BroodSize −964.9841 → 1935.9682; difference **−5.5741**, an
  implied LRT of 7.574 on 1 df against the Wald z² = 7.509.
- MC SE of an RQR SD = 1/√(2n): logistic **0.0178**, Poisson **0.0554**. Refit slopes: MCSE of the
  mean 0.0494/√200 = **0.0035**, so 0.7077 − 0.6999 is 2.2 SE.

## One question for Shinichi

Finding 1 is a choice, not just a fix. These chicks sit mostly *below* the inflection, so the honest
story is "a gram matters most to a middling chick and least at both ends", which makes the inflection
a nameable quantity. The diminishing-returns line needs data lying above p = ½. Keep the sigmoid's
real symmetry as the Week 3 lesson, or move that beat to a response where it is true?

## Confirmation (HEAD, 2026-09-07)

Checked against `book/wk3-glms.qmd` and `_freeze/book/wk3-glms/execute-results/html.json` as they
are on disk now (not the reviewed SHA 4275a16; landed in commit `fc222ce`, "chapter 3's brood promise
points at Class 9 in all three homes"). The frozen `fit-logistic` block prints coefficients
`(Intercept) -2.8152`, `Mass2 0.6999`. Independent re-derivation, plain Python:

```
b0, b1 = -2.8152, 0.6999
sigmoid(x) = 1 / (1 + exp(-(b0 + b1*x)))
p(2.0) = 0.1954, p(3.5) = 0.4096, p(5.0) = 0.6647
gain_low  = p(3.5) - p(2.0) = 0.2142
gain_high = p(5.0) - p(3.5) = 0.2551
inflection = -b0/b1 = 4.0223
```

Matches the frozen output (`2.0 g -> 3.5 g buys : 0.2142`, `3.5 g -> 5.0 g buys : 0.2551`,
`steepest point (p = 1/2) at : 4.0224 g`) and the review's own re-derivation, to the digit.

**Blocking finding — diminishing returns vs. the chapter's own predictions.** Closed. The dialogue
no longer states diminishing returns as the reading: Toto's "The second step buys *more* than the
first" (line 230) is answered with "Across the range where these chicks actually live, the curve is
**accelerating**. Had I told you a gram matters most to the smallest chick, you would now be holding
a sentence your own output contradicts" (line 232), and Momo's "I have read 'diminishing returns' in
a dozen papers about exactly this" is met with "it is true wherever the data sit above the inflection
and false wherever they sit below it, which is why it is something you compute rather than something
you say" (line 240) — the symmetric, data-dependent reading the review asked for. The Summary bullet
agrees: "Whether your own data show diminishing or *increasing* returns depends on which side of that
point they lie: most of these chicks sit below it, the mean among them, so over the bulk of the data
an extra gram buys more as a chick gets heavier, not less" (line 475). Exercise 3 no longer asserts a
direction; it asks the reader to compute both gains and the inflection and say which is larger "without
using the word 'nonlinear'" (line 541) — consistent with the corrected beat. Dialogue, Summary and
Exercise 3 agree with each other and with the re-derived numbers.

**Finding 2 (required) — binary dispersion is clustering, not Week 4.** Closed. Line 296: "There is no
overdispersed Bernoulli to go looking for. What *can* be wrong with binary data is the other thing —
that the rows are not independent draws, because chicks from one nest share a pair of parents and a
territory — and that is clustering, which is **Class 6**, not Week 4." The Summary bullet carries the
same correction (line 476): "for a 0/1 response, p(1 − p) is an **identity** and there is no
overdispersed Bernoulli to find, so what can go wrong in binary data is the independence of the rows
(Class 6), not the variance function."

**Finding 3 (required) — no brood id in `ChickSurvival.csv`.** Closed. `data/2012/ChickSurvival.csv`
still carries only `Survival,Sex,Mass2,BroodSize,JulianDate` — no brood identifier — confirmed by
reading the file header directly. The brood pointer now names Class 9 in all three homes: dialogue at
line 264 ("This is also exactly the point where Class 9 will tell you that the chicks in one brood
are not independent... Class 9 stops pretending, on a file that can"), the Summary bullet at line 479
("Class 6 frees the correlation between rows on repeated measures of one bird, and Class 9 is where
this pretence ends, on a file that records the brood"), and Exercise 9 at line 553 ("Finish with one
sentence saying which number on your output you expect Class 9 to change"). `book/wk9-glmms.qmd`
does fit survival with a brood random intercept, on the brood-identified file: it reads
`data/2012/SparrowSurvival.csv` (line 61, described in its own caveat as "the brood-identified version
of the file Class 3 used") and fits `drm(bf(@formula(Survival ~ Mass2 + (1|BroodNo))), Binomial();
data = raw)` (line 74) and again at line 193. The one-clause fix the review asked for is also in
place: the epigraph (lines 25–27) now reads "this file records how *big* each brood was and never
*which* brood a chick came from, so ending the pretence here needs a dataset that carries the brood
identifier, not a different formula on this one." (The epigraph's earlier clause, "the same pretence...
Class 6 stops making," is not one of the three named homes and reads defensibly as the general
fixed-effects-vs-random-effects concept Class 6 introduces, rather than a promise that Class 6 fixes
this dataset — worth a glance if the epigraph is touched again, but not a blocker.)

**Finding 4 (required) — the ⚠ DISAGREE box relabelled.** Closed. The box at line 300 is now tagged
`<!-- box: translate | id: glm-dispersion-line | ch: 03 | checked: 2026-09-07 -->` and headed
"**↔ TRANSLATE: a sentence in R's output that ours does not print**" — no `DISAGREE` label remains on
it, matching the writing-conventions.md distinction between a translation box and a disagreement box.

**Finding 5 (required) — explicit rng, no `Random.seed!`.** Closed. `grep -n "Random.seed" book/wk3-glms.qmd`
returns no matches. Every random draw is passed an explicit `MersenneTwister`: the jitter cells
(`rng = MersenneTwister(20260907)`, `rng2 = MersenneTwister(99)`), the quantile-residual cells
(`rng = MersenneTwister(3)`, `rng = MersenneTwister(4)`), and the simulation cell
(`rng_sim = MersenneTwister(20260907)`), consistent with the chapter's own claim that "Every random
draw in this chapter... is made from an explicit `MersenneTwister`."

Also checked and unaffected by this fix: no bare numerals in dialogue beyond the class/week/citation
pattern the original review already passed (`Class 2/4/6/9`, `Week 4`, `Dunn & Smyth 1996`) — every
computed quantity, including the new sigmoid-beat numbers, is an inline `{julia}` expression; 35 such
expressions remain in the file. One unrelated, out-of-scope change is present on disk: an uncommitted
one-line `status_note` frontmatter edit (chapter-count wording), which does not touch any reviewed
content and is not part of this confirmation.

**Verdict: CONFIRMED — all five findings closed (the one blocking finding and the four required
findings); no new defects found. The chapter is unblocked.**
