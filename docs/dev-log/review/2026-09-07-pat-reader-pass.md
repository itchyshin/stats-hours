# Pat's reader pass — 2026-09-07

**Reviewer:** Pat, biology graduate student. One statistics course. Has never opened Julia.
Reading the book on the web at `http://127.0.0.1:8934/` (rendered `docs/site/book/*.html`),
with the `book/*.qmd` sources alongside for exact quotes.

**Brief:** the author's complaint, verbatim — *"some of things are not understandable and do not
use internal code or something readers do not understand"*.

**What I did.** Read every page as a reader: landing page, preface, Classes 1–10, Appendix A,
coda. Where a phrase is quoted below it is quoted verbatim from the `.qmd` source, with the
line number, so a fixer can find it. **Every number stays exactly as it is** — the numbers are
computed at render and must not be retyped. Where a rewrite touches a sentence containing a
number I have written *keep the inline number* and left the expression alone.

**What I am not reviewing.** Whether the statistics are right. I cannot judge that. I am
reviewing whether a reader who has done one statistics course can follow the page.

---

## The three worst pages

| rank | page | distinct offending passages | verdict |
|---|---|---|---|
| 1 | **Class 10 — not even the groups are strangers** (`book/wk10-relatedness.qmd`) | 24 | **needs a real pass** |
| 2 | **Class 9 — both at once** (`book/wk9-glmms.qmd`) | 22 | **needs a real pass** |
| 3 | **Class 7 — not everyone shares a slope** (`book/wk7-random-slopes.qmd`) | 17 | **needs a real pass** |

**And one passage that outranks all three on severity, on a page that is otherwise fine:**
Class 2's closing section **"Honest note from drafting this chapter"** (`book/wk2-linear-models.qmd:682–698`)
is ~17 lines of the authors talking to each other, published on a reader-facing page. It is the
purest instance of the complaint in the whole book. See Class 2 below. Delete it or move it to
`docs/dev-log/`.

---

## Recurring words to ban from dialogue

These should not appear in anything Itchy, Toto, Momo, Eddie or Jaro says, nor in a
figure caption, nor in the masthead. Most have a plain equivalent that is *shorter*.

**Engine internals — a reader cannot open these files and would not know what to do if they could:**

| banned | where it appears | say instead |
|---|---|---|
| `gaussian_ranef.jl`, `src/gaussian_ranef.jl` | ch7:369, ch7:1028 | "inside the engine's own arithmetic" |
| `bias_correct.jl`, `heritability.jl` | ch10:1082 | drop the filename; the behaviour is the lesson |
| `_clamp01` | ch10:1075 | "the engine pushes it back to 0 or 1" |
| `binomial.jl`, `aghq_1d.jl` | ch9:922 | "the engine's own code" (once), then drop |
| `chibar.jl`, `drmTMB/R/profile.R` | ch8:776 | drop from Further reading |
| `docs/src/api-stability.md` | ch2:693 | drop |
| "the Cholesky diagonals are carried as logarithms" | ch7:369 | "the engine stores those numbers on a log scale" |
| `l11 = exp(a)`, `logdetM += log(dM)`, `dM = m11*m22 - m21^2` | ch7:369 | "one small determinant, computed as the difference of two big nearly-equal numbers" |
| `g_tol` | ch10:667 | "the convergence tolerance I set earlier" |

**Issue numbers.** `#727` (ch4 ×2, ch5 ×2, coda), `#753` (ch7, coda), `#761` (ch9 ×2),
`#762` (ch7 ×2), `#754` (ch2). The brief allows **at most one, in a Julia-stuff bullet,
phrased as "a known limitation, reported"**. Currently there are twelve, five of them
inside dialogue. Strip every dialogue mention; keep at most one per chapter in *Julia stuff*.

**Build / gate / provenance vocabulary — reader-facing, and none of it means anything to a reader:**

- "executed at build" / "executed by Quarto at render" / "produced when the site is built"
- "pre-rendered" (every chapter masthead and every R box)
- "pinned" / "pinned to the commit" / "the pinned engine commit"
- "provenance" (as a masthead heading)
- "merged" / "re-executed against the merged engine"
- "`error: true`" (ch1:13, ch2:13 — a Quarto option, printed in the masthead)
- "adversarial statistical review" (landing page)
- "the build enforces" (preface heading)

**Review vocabulary — the authors reviewing each other, on the page:**

- "a number somebody typed once" (ch9:863)
- "Two things a reviewer should push back on" (ch2:696)
- "the convention says Weeks 1-2 should have 'almost none'; it deletes cleanly if that is wrong" (ch2:696)
- "the house voice rule forbids in prose, kept only as format sigils" (ch2:696)
- "**[PARTLY UNVERIFIED]**" (ch10:1112)
- "checked against OpenAlex on …", "claims about what each argues are pitched no more narrowly
  than a title or abstract supports" (every Further reading preamble) — this is a note to a
  fact-checker, not to a reader.
- "This chapter's own code cites all three by name and had listed none of them" (ch10:1121)

**Lane / session words.** None found in dialogue. Clean.

---

## Terms that need a one-line definition on first use

Listed with the class where the first use happens. In every case the term is currently used
cold. A one-sentence gloss in the dialogue, the first time only, fixes it.

| term | first use | suggested one-liner |
|---|---|---|
| **worm plot** | **Class 2**, fig-cap `wk2:333` (then ch3:350 fig-cap, ch3 prose, ch4:117 — all before ch5 defines it at `wk5:236`) | "a quantile plot with the straight line flattened out, so a good model gives a flat scatter and a bad one wriggles" |
| **randomised quantile residual** | Class 2 fig-cap `wk2:333`; defined properly at ch3:346 | move the Class 3 sentence into the Class 2 caption, or drop "randomised quantile" from the ch2 caption and just say "residuals" |
| **Monte Carlo standard error / MC SE** | Class 3, printed output `wk3:433–434` then prose `wk3:439` | the ch3:439 prose *does* expand it — but the abbreviation `MC SE` reaches the reader first, inside the printf. Expand it in the printf label too, once. |
| **Wald** (interval) | Class 4:828, then ch6:301/317, ch8, ch9, Appendix A obj. 4 | **never defined anywhere in the book.** "a plain estimate-plus-or-minus-two-standard-errors interval" |
| **delta method** | Class 6:317 | "an approximation that turns the uncertainty in the two variances into uncertainty in their ratio" |
| **profile likelihood** | Class 6:311 (code comment), 317 (prose) | ch6:317 does explain it ("re-maximises the likelihood at each trial value"). Good — keep that sentence and reuse it in ch10. |
| **BLUP** | Class 6:358 fig-cap, then ch6:466, ch7, ch8, ch9 | expand once: "best linear unbiased predictor — the model's estimate of one group's own nudge" |
| **conditional mode** | Class 6:359 code comment, ch8:762, ch9:939 | say it is another name for the same thing as BLUP, once |
| **marginal vs conditional** (of a residual or a fitted value) | Class 6:646 | ch6 does explain it in place. Keep. Class 9:839 then reuses it in a *second, different* sense without warning — see Class 9 below. |
| **coverage** | Class 6:317 ("the coverage it advertises"), defined at Appendix A:234 | one line in ch6: "how often an interval of that kind actually contains the truth" |
| **boundary** (a variance tested at zero) | Class 5:25 (front-matter box), ch6, ch7 obj. 4, ch8 obj. 4 | ch8 defines it well. The three earlier uses need "a variance cannot be negative, so zero is the edge of the space it lives in" |
| **chi-bar-squared / χ̄² / chibar** | Class 8, Objective 4 | ch8:462 defines it. The *objective* uses it cold — reword objective 4 |
| **estimand** | Class 5:858, ch9:398, coda:43 | "the quantity you are actually trying to estimate" |
| **collapsible / non-collapsibility** | Class 9:307 | ch9:307 names it *after* explaining it. Good. Keep the order. |
| **coefficient of variation** | Class 9:391 | "the standard error divided by the estimate" |
| **design effect** | Class 9:398 | "a rule of thumb for how much a clustered sample is worth compared with an unclustered one" |
| **Laplace / AGHQ / GHQ-32 / abscissas** | Class 9:895–947 | the translate box explains Laplace and the two quadratures well. **"abscissas"** (ch9:946) is the one word to replace — say "nodes", which the same box already uses |
| **PIT** | Class 9:835 — **used once, never expanded** | delete the abbreviation: "the marginal reference is the right one to judge these against" |
| **latent scale** | Class 9:260 | ch9:256–260 explains it properly. Keep. |
| **eigenbasis** | Class 10:566, 781, 787, 795, 1088 | "*A* and the residual can be untangled by one change of coordinates, and the brood matrix cannot" |
| **bias-corrected** (of a ratio) | Class 6:309, ch10:323 | ch6:321 explains it. ch10 reuses the word without the sentence — repeat it. |
| **positive definite / condition number / shear** | Class 7:363–365, ch10:172 | keep the ideas, cut the words: "the matrix never actually falls apart" and "the numbers get very lopsided" |
| **Spearman–Brown** | Class 7:510 | "the same arithmetic as Class 6" is enough; drop the name or gloss it |
| **Mundlak** | Class 7:875 (cell label `#| label: mundlak` only, not visible in the rendered page) | rename the label to `within-between`; low priority |
| **exposure / offset** | Class 4:36, :158, :238 | ch4 defines both properly, in order. Keep. |
| **RQR** | Class 4:467, 469 (printed output only) | spell it out in the printf label |

---

# Page by page

## Landing page (`docs/site/index.html`) — needs a light pass

**Closing line.** "All ten classes planned for version 1, with Appendix A, the preface and the
coda — **every page executed at build and passed by an adversarial statistical review.**
Everything else so far is a plan; see the full outline."

> A reader does not know what "executed at build" is or who the adversarial reviewer was.
> **Rewrite:** "Ten classes, plus a preface, an appendix and a coda. Every number and figure on
> every page was produced by running the code you can see above it. Everything else is still a
> plan; see the full outline."

**Per-chapter badge.** "Executed draft" ×13.

> **Rewrite:** "Draft" — the "executed" half is machinery, and the mastheads already carry it.

---

## Preface — *why one engine* (`book/wk0-preface.qmd`) — needs a light pass

The prose is good and the voice is right. The problem is entirely the masthead and the last
section, which are written for a colleague.

**Masthead — status line.** "All ten classes of version 1 are executed (1–10), with Appendix A,
the preface and the coda. **Every number and figure on this page is produced when the site is
built**; the book itself is not written." (`:12`, repeated verbatim on all thirteen pages)

> **Rewrite:** "Ten of the thirteen classes are written, plus this preface, an appendix and a
> coda. Every number and figure on this page came from running the code on it. The book as a
> whole is not finished."

**Masthead — Provenance.** "This page carries one **executed cell**, run by **Quarto** when the
site is built. It reads the **pinned** engine commit out of `tools/engine-pin.txt` and asks the
loaded package for its own version number; neither the version nor the commit nor the date is
typed into this file." (`:14`)

> Four pieces of machinery in two sentences: "executed cell", "Quarto", "pinned", "commit".
> **Rewrite, and rename the heading from *Provenance* to *Where the numbers come from*:**
> "One block of code on this page runs every time the page is made. It asks the software for its
> own version number and reads the exact version of it this book was written against off disk.
> Nothing on this line was typed by hand."

**Masthead — Caveat.** Fine. It is plain and it is honest. Keep.

**Section heading.** "## The rule the build enforces" (`:181`)

> **Rewrite:** "## The rule this book cannot break"

**Under it.** "…a quantity spoken aloud in the dialogue is an **inline expression** that ran a
moment ago, not a numeral somebody remembered." (`:186`)

> **Rewrite:** "…a number spoken aloud in the dialogue was worked out by the code a moment
> earlier, not remembered."

**Itchy, in the demonstration.** "…**the commit every chapter in this book is pinned to** out of
`tools/engine-pin.txt`, and stamps the day this page was built" (`:193`)

> **Rewrite:** "…the exact version of the software every chapter in this book was written
> against, and today's date."

**Itchy.** "If you are reading a copy of this page built at some later time, it says so itself —
this one was built on `{julia} built_on`, running DRM.jl v`{julia} engine_version` at commit
`{julia} pinned_commit`." (`:215`)

> "commit" is the one word to lose. **Rewrite** (keep all three inline numbers):
> "…this one was made on `{julia} built_on`, running DRM.jl `{julia} engine_version`, version
> `{julia} pinned_commit`."

**Further reading preamble.** "Bibliographic details for all four were checked against OpenAlex
on 2026-09-07 (title, authors, journal, volume, pages, DOI); claims about what each argues are
pitched no more narrowly than a title or abstract supports." (`:239`)

> This is a note from one author to another about how the checking was done. A reader does not
> need it, and "pitched no more narrowly than a title or abstract supports" is not a sentence
> anybody can parse on first reading. **Rewrite:** delete, or reduce to one clause:
> "Details checked 2026-09-07."
> Same edit applies to the Further reading preamble on **every** chapter.

**Footer.** "· executed draft, 2026-09-07"

> **Rewrite:** "· draft, 2026-09-07"

---

## Class 1 — base camp (`book/wk1-base-camp.qmd`) — fine, one masthead fix

This is the best-pitched chapter in the book for my reading level. Toto's four deliberate errors
are exactly right, the pace is right, and nothing in the dialogue lost me.

**Masthead — Provenance.** "That includes the four errors: they are real failures, **kept in with
`error: true`**, not screenshots of failures." (`:13`)

> `error: true` is a setting in a file I will never see. **Rewrite:** "That includes the four
> errors: they really failed, here, on this page — they are not pictures of failures."

**Front-matter box.** "Its R output is **pre-rendered** — produced once with `Rscript` against the
same file the Julia cells read, and kept at `data/ch1/ch1-r-box.R` so you can run it yourself.
Quarto does not execute it." (`:31–33`)

> **Rewrite:** "The R output in it was run once, by hand, against the same file the Julia code
> reads, and the script is in the repository so you can run it yourself. It is the one block on
> this page that does not re-run each time."
> The same edit applies to every "**pre-rendered**" note in Classes 1–10.

---

## Class 2 — one line through a cloud of sparrows (`book/wk2-linear-models.qmd`) — needs a real pass (one section)

The class itself is good. Two problems, one of them severe.

### 1. The severe one: delete "Honest note from drafting this chapter" (`:682–698`)

Seventeen lines of authors talking to each other, at the bottom of a chapter a reader is
reading to learn regression. Everything in it is about writing the book, not about sparrows.
Sample of what a reader currently meets:

- "**Did one engine help or hurt here?** It helped more than expected, and it costs exactly
  three things, two of which are display bugs rather than architecture."
- "**DRM.jl #754 fixed it, and the chapter has been re-executed against the merged engine.**"
- "the flagship location-scale demonstration shipped with an untestable coefficient"
- "The refusal is described as current behaviour, since DRM.jl classifies the function
  experimental in `docs/src/api-stability.md`"
- "**Two things a reviewer should push back on.** One comparison box was used where **the
  convention says Weeks 1-2 should have 'almost none'**; **it deletes cleanly if that is wrong.**
  And the box's **machine-readable tag lines** contain em-dashes, which **the house voice rule
  forbids in prose, kept only as format sigils**, never in a line of actual writing."
- "**Verdict.** One engine works at this rung … which is the argument for writing the book and
  the engine in the same building."

> **Rewrite: delete the whole section from the chapter and move it to `docs/dev-log/`.**
> Nothing in it teaches a reader anything. If one idea is worth keeping for the reader — that the
> `Sex`-in-σ term *did not* earn its place, and the chapter kept it anyway — that idea is already
> in the class (`:714–718` in Class 4 makes the same point better).
>
> Check `docs/site/book/wk2-linear-models.html:1123` after the fix: it is currently rendered and
> live.

### 2. Front matter

**"A note on the transcripts."** "Local filesystem paths inside the pasted error messages have
been shortened to `DRM.jl/src/...`; nothing else in any transcript is altered." (`:20–21`)

> **Rewrite:** "The error messages below are real. The only thing changed in them is the long
> folder path at the front, shortened so it fits on the page."

**Masthead Provenance.** "The two error transcripts are real errors, kept in with `error: true`."

> Same fix as Class 1.

### 3. First use of "worm plot" and "randomised quantile residual"

**fig-cap `:333`.** "Randomised quantile residuals for fit2 against normal quantiles (worm plot)."

> Both terms arrive cold, three classes before Class 5 defines "worm plot" and one before Class 3
> defines "randomised quantile residuals". **Rewrite the caption:** "The residuals from `fit2`,
> plotted against what a normal distribution would predict. Class 3 explains what these residuals
> are and Class 5 explains how to read this picture; for now, a flat scatter is what you want."

### 4. Exercise 7

"Then answer in one sentence: **if a reviewer asked you** to report 'the residual standard
deviation', which of the two would you give them…" (`:667`)

> "reviewer" here means a journal referee, which is fine in-world — but it collides with the
> book's other, internal use of "reviewer". Prefer **"a referee"**, which the book already uses
> at ch5:52. Small, but consistent.

---

## Class 3 — the shape of the noise (`book/wk3-glms.qmd`) — needs a light pass

Genuinely well taught. The logistic/Poisson argument lands. Four small things.

**fig-cap `:350`.** "**Worm plot** of the two-predictor logistic fit's randomised quantile
residuals, at randomisation seed 3. The scatter sits close to the zero line **inside the ±2SE
band**…"

> "Worm plot" and "±2SE band" both arrive before Class 5. **Rewrite:** "The residuals of the
> two-predictor logistic fit, plotted the way Class 5 will teach you to read properly. The
> scatter sits close to the zero line and inside the grey band, which is the shape a diagnostic
> takes when there is nothing left to find."

**Printed output `:433–434`.** `"logistic fit, quantile residual SD : %.4f  (%.2f MC SE from 1)"`

> The abbreviation reaches the reader before the expansion in the next paragraph.
> **Rewrite the printf label** (not the number): `"(%.2f Monte Carlo standard errors from 1)"`.

**Itchy `:439`.** "The **Monte Carlo standard error** of one of these SDs is one over the square
root of twice the sample size"

> The expansion is here, but the term is used as though the reader has met it. **Rewrite:**
> "A spread computed from a random draw has its own wobble, and there is a formula for it: one
> over the square root of twice the sample size. That wobble has a name — the *Monte Carlo
> standard error* — and it is the ruler you judge the spread against."

**Julia stuff `:494`.** "`aic(fit)`: unchanged from Class 2, and still **the referee** when you add
a predictor."

> Mild, but a reader may not carry the metaphor. **Rewrite:** "…and still what decides whether a
> new predictor earned its place."

---

## Class 4 — when the family lies about the spread (`book/wk4-overdispersion.qmd`) — needs a light pass

Strong chapter. The exposure-before-family argument is the best beat in the first half of the
book. Five things.

**Itchy `:238`.** "Our engine cannot write it — DRM.jl 0.7.1 exports no `offset` (that is
[DRM.jl issue #727](https://github.com/itchyshin/DRM.jl/issues/727)) — so I am teaching the free
coefficient and showing you the pinned version in R"

> An issue number and a link, mid-dialogue. **Rewrite:** "Our engine cannot write it yet — a known
> limitation, reported — so I am teaching the free coefficient and showing you the pinned version
> in R." Keep the issue link in *Julia stuff* only (`:778` already has it; one is enough).

**Itchy `:680`.** "Males a little **more**, which is not what I would have guessed. **Now the
referees**, and I already know how this ends because we ran it in Class 2."

> A reader will read "the referees" as journal referees and be lost — the cell that follows is a
> *z* and a *p* and an AIC. **Rewrite:** "Now the verdicts, and I already know how this ends
> because we ran it in Class 2."

**Itchy `:554`.** "**The engine's note is not family-aware and should be; that is a bug report,
not a lesson.**"

> "not family-aware" and "a bug report" are both from the engineering seat. **Rewrite:** "The
> engine prints that warning without checking which family you asked for, so here it prints
> something untrue. That is a fault in the software rather than something for you to learn.
> Read the line, then decide whether it applies to your family."

**Julia stuff `:783`.** "…quote the SD against its **Monte Carlo standard error** of 1/√(2n)"

> Fine *if* Class 3 has already glossed it. It has not, quite — see Class 3 above.

**Simulation-thread paragraph `:828`.** "…and it is why a **likelihood-based interval beats a
Wald one** for this parameter, and why quoting a dispersion to three decimal places is theatre."

> **First use of "Wald" in the book, and it is never defined anywhere.** **Rewrite:** "…and it is
> why an interval read off the likelihood beats the plain estimate-plus-or-minus-two-standard-errors
> kind — the *Wald* interval — for this parameter."

**Printed output `:467, :469`.** `RQR` as a column label.

> Spell it out: `quantile residual SD`.

---

## Class 5 — is the model any good? (`book/wk5-diagnostics.qmd`) — needs a light pass

The worm-plot calibration section is the best teaching in the book. But the chapter opens with
its hardest paragraph.

**Front-matter box `:20–32`.** The "What this chapter pretends" box is 13 lines and contains, in
order: "a variance component tested at zero sits on a **boundary**", "the **chi-squared
reference**", "the **effective number of parameters** something other than *k* — which is exactly
what AIC's `2k` charges for", "**conditional AIC** exists because of it". Four unexplained terms
before the Objectives.

> This is the single hardest paragraph a reader meets in Classes 1–5, and it is a *warning about
> a chapter three weeks away*. **Rewrite, short:**
> "**What this chapter pretends.** Every model on this page has fixed effects only — the sparrows
> are measured once each here, and the females are not identified at all, so two broods by the
> same bird are treated as strangers. That is the same pretence Classes 2, 3 and 4 made, and the
> one **Class 6 stops making**. The residual and simulation machinery on this page survives the
> repair unchanged. The way you *compare two models* does not, and Class 8 is where that is put
> right — so treat the last section of this class as provisional. Note what the repair costs:
> `FemaleSuccess.csv` records neither the female nor the brood, so on that file the pretence
> cannot be ended by a cleverer formula; it needs a different file. `BodySize.csv` is where
> Class 6 goes and `SparrowSurvival.csv` is the file with `Mum` and `BroodNo` in it."

**Objectives 1–5.** "a **randomised quantile** residual", "**worm plot**", "the engine's
**comparison guard**".

> Objectives 1 and 2 are fine — the chapter defines both immediately.
> Objective 5's "the engine's **comparison guard**" is engine-internal wording.
> **Rewrite:** "…and say which comparisons the engine refuses outright, which it merely warns
> about, and which it cannot check at all."

**Itchy `:420`.** "The engine still exports no `offset` ([DRM.jl issue
#727](…)), so we still pay a degree of freedom to learn that the pin would have been safe."

> Second dialogue issue-number in the book, and "exports no `offset`" is API-speak.
> **Rewrite:** "The engine still cannot write an offset — a known limitation, reported — so we
> still pay a parameter to learn that pinning it would have been safe."
> (The same link recurs at `:785` in a Summary bullet; keep at most one, in *Julia stuff*.)

**Summary `:858`.** "**Marginal and conditional** … the **estimand**"

> **Rewrite "estimand":** "the quantity you are trying to estimate".

**Further reading preamble.** Same OpenAlex sentence as everywhere. Cut.

---

## Class 6 — rows are not strangers (`book/wk6-random-intercepts.qmd`) — needs a light pass

Eddie's question and the shrinkage caterpillar are excellent — the picture genuinely explains
what a random intercept is. The chapter's one weak spot is a single dense paragraph where five
new terms arrive at once.

**Itchy `:317`.** "`repeatability` gives you the **delta-method** interval unless you ask for
something else: a **Wald** interval built on the ratio and then **clamped** into the zero-to-one
range it has to live in. It is fast and it is the weaker of the two. `method = :profile`
re-maximises the likelihood at each trial value of R and **inverts the likelihood-ratio test**,
and that is the one documented as having **the coverage it advertises**."

> Five terms, none defined, in one Itchy speech: delta method, Wald, clamped, inverting a
> likelihood-ratio test, coverage. **Rewrite, splitting it across a Toto question:**
>
> **Itchy:** "`repeatability` hands you one of two intervals and does not say which. The default
> is the quick one: take the ratio, take a standard error for it, go two standard errors either
> way, and then push the ends back inside nought and one if they fall outside. Statisticians
> call that a *Wald* interval, and the approximation that gets a standard error for a ratio out
> of two variances is the *delta method*. It is fast and it is the weaker of the two."
>
> **Toto:** "And the other one?"
>
> **Itchy:** "`method = :profile` refits the model at each candidate value of R and keeps the
> values the data cannot rule out. That takes longer and it is the one documented to do what it
> says — if you ask for a 95% interval you get one that contains the truth 95 times in 100. They
> differ here in the third decimal place at both ends, which is small, and they will not always
> be small: near zero or near one the pushing-back-inside does real damage. Report the one you
> asked for, by name."

**fig-cap `:358`.** "diamonds are the fit's **BLUP** for the same bird"

> **First use of BLUP in the book, in a caption, unexpanded.** **Rewrite:** "diamonds are what
> the model predicts for the same bird — the *best linear unbiased predictor*, or BLUP, which is
> the name you will see in other people's output."

**fig-cap `:417`.** "the marginal residual with each bird's own **BLUP** subtracted out" — fine
once the above is in.

**Itchy `:466`.** "Shrinkage then pushes the number **back up**, not down, because a shrunk BLUP
removes slightly *less* than the bird's real effect"

> Fine once BLUP is glossed.

**Itchy `:321`.** "A ratio of estimates is not the estimate of the ratio, so the point estimate is
slightly off and the engine will tell you by how much if you look."

> Good sentence. Keep it, and **make Class 10 repeat it** rather than assume it (see below).

---

## Class 7 — not everyone shares a slope — **NEEDS A REAL PASS** (17 passages)

The teaching here is first-rate — the origin/correlation argument, the ledger of everything that
moved, the within/between split — and it is buried under more engine internals than any other
page. This is the chapter where the author's complaint is most literally true.

**1. Itchy `:369` — the worst paragraph in the book for a reader.**

> "Where is it, then? In the engine's own arithmetic, and you can read it, because the source is
> open. **`src/gaussian_ranef.jl` carries the Cholesky diagonals as logarithms and exponentiates
> them, `l11 = exp(a)`, `l22 = exp(b)`** — check it against the printed block: `L11` was
> `{julia} round(log(sd0), digits = 4)`, which is the logarithm of σ_0. **So a standard deviation
> is never handed to `log` anywhere in that objective. The only logarithm in it is
> `logdetM += log(dM)`, where `dM = m11*m22 - m21^2` is a two-by-two determinant computed once
> per bird.** With uncentred mass the cross term in it runs to order twenty-seven and the other
> term to order seven hundred and fifty, so `m11*m22` and `m21^2` are two big nearly-equal
> numbers, and in floating point their difference goes **negative**."
>
> **Rewrite** (keep both inline numbers):
> "Where is it, then? In the engine's own arithmetic, and you can go and look, because the code
> is open — but you do not have to, because the printed block already tells you. `L11` was
> `{julia} round(log(sd0), digits = 4)`, which is the *logarithm* of σ_0: the engine keeps those
> numbers on a log scale from the start, so no standard deviation is ever handed to `log`. There
> is exactly one logarithm left in the calculation, and it is of a small quantity worked out once
> per bird from four numbers multiplied and subtracted. With uncentred mass two of those numbers
> are huge and almost equal, so their difference — which ought to be a small positive number —
> comes out negative, and the computer hands *that* to `log`. Hence the error, and hence the
> number in it: `{julia} @sprintf("%.1e", -1.4757395258967641e20)`, which is nobody's standard
> deviation."

**2. Itchy `:373`.** "That is written down at [DRM.jl issue #762](…), **which now carries this
correction**."

> "which now carries this correction" is the authors telling each other they filed the fix.
> **Rewrite:** "That is a known limitation of this version of the engine, reported."
> Keep the link, if anywhere, in *Julia stuff*.

**3. Summary `:1000`.** "…and centring fixes it by driving the offending cross term to zero.
Centre a covariate whose zero is outside its range, every time (**DRM.jl #762**)."

> **Rewrite:** drop "(DRM.jl #762)" — the Julia-stuff bullet can carry it once.

**4. Itchy `:983`.** "You cannot ask it in this engine yet: `Binomial()` accepts `(1 | g)` and
refuses a random slope with the message 'supports `(1 | g)` on the mean', which is **[DRM.jl
issue #753]**(…), so the binary case **waits for Class 9 or for the issue, whichever arrives
first.**"

> **Rewrite:** "You cannot ask it in this engine yet: `Binomial()` takes a random intercept and
> refuses a random slope. That is a known limitation, reported, so the binary case waits. When it
> lands, everything on this page transfers except that you will read the two standard deviations
> on the log-odds scale."

**5. Itchy `:940` and cell label `:943`.** "Here is the **ledger**, said once and read straight
down." / `#| label: ledger` / `ledger = [ … ]`

> "ledger" is the acceptance-ledger word from the build machinery. In dialogue it reads as
> internal vocabulary. **Rewrite:** "Here is the **whole list**, said once and read straight
> down." Rename the label and the variable to `moved` or `changed`.

**6. Itchy `:363–365`.** "Σ at zero grams is **positive definite**. Its **determinant** is …
the same determinant as at every other origin" / "moving zero is a **shear**, and a shear has
determinant one, so it cannot change the determinant of Σ. Σ never becomes **singular** … Its
**condition number** gets ugly — `{julia} …` at zero grams against `{julia} …` at the mean — but
ugly is not singular"

> Four linear-algebra terms in two speeches. The *idea* — the matrix never actually breaks, the
> numbers just get lopsided — is simple and worth keeping. **Rewrite** (keep both inline numbers):
>
> **Momo:** "Σ at zero grams is a perfectly good covariance matrix. Its determinant — one summary
> number that would go to zero if it were collapsing — is `{julia} round(det(shifted(w_bar)), digits = 4)`,
> the same as at every other origin in the table."
>
> **Itchy:** "The same at every origin, and that is not luck: moving zero slides the matrix
> sideways without squashing it, and sliding cannot change that number. So Σ never collapses, at
> any origin, ever. What it *does* get is lopsided — the ratio of its largest to its smallest
> direction goes from `{julia} …` at the mean to `{julia} …` at zero grams — and lopsided is not
> collapsed. The correlation at zero is `{julia} …`, not minus one."

**7. Itchy `:261, :831, :1019`.** "printed as a **Cholesky factor**" / "its `recov` block is the
**Cholesky factor**" / "is the **Cholesky factor** of that covariance (`L11`, `L22`, `L21`)"

> Three uses, no gloss. This one is *load-bearing* — the reader must not read `L11` as σ_0 — so it
> needs a sentence rather than deletion. **Add at first use (`:261`):** "…printed as a *Cholesky
> factor*, which is a square-root-like rewriting of the covariance matrix. You cannot read σ_0,
> σ_1 or ρ straight off it, which is why the cell below takes them out properly."

**8. Itchy `:510`.** "…and weighting accordingly — the same **Spearman–Brown** arithmetic as
Class 6, applied to a slope instead of a mean."

> **Rewrite:** "…and weighting accordingly — the same arithmetic as Class 6, applied to a slope
> instead of a mean."

**9. Itchy `:514`.** "**Quoting the spread of the BLUPs as if it were σ_1 is a mistake with its
own literature.**"

> Needs the ch6 gloss to be in place; "a mistake with its own literature" is a wink to a
> colleague. **Rewrite:** "Quoting the spread of the predicted slopes as if it were σ_1 is a
> common enough mistake that people have written papers about it."

**10. Itchy `:578`.** "…so a **quantile residual** here compares each wing to a distribution that
has had the birds removed from its mean but not from its spread"

> Fine once Class 3/5 are glossed.

**11. Itchy `:637`.** "**The degrees of freedom are not what is happening. Shrinkage is**, and
Class 6 said so in the cell you all skipped"

> "the cell you all skipped" is a joke about the book's own drafting. Harmless but it reads as
> in-group. **Rewrite:** "…and Class 6 said so, in the cell most people skip."

**12. Itchy `:681`.** "Nor are the tails asymmetric in *count*: `{julia} …` residuals below minus
two and `{julia} …` above plus two."

> Fine.

**13. Itchy `:799–803`.** "**Same error, two mechanisms.** Diagnose, do not pattern-match."

> "pattern-match" is engineering vocabulary. **Rewrite:** "Same error, two causes. Work out
> which one you have; do not go by the look of the message."

**14. Itchy `:811`.** "That is **not** a clean **type-one-error rate**"

> **Rewrite:** "That is not a clean false-alarm rate — how often the test cries wolf when there
> is nothing there —"

**15. Itchy `:811`.** "…and if that disappoints you, that is what a **Monte Carlo standard
error** is for."

> Fine once Class 3 glosses it.

**16. Translate box `:830–833`.** "its `recov` block is the **Cholesky factor**, and `vc(fit)` is
a covariance matrix. That is an **absence** in the Julia engine, not a disagreement between the
two"

> "absence, not a disagreement" is a good distinction the book makes twice. Keep, once the
> Cholesky gloss is in.

**17. Objectives 3, 4, 6.** "name the **mixture** the test is referred to", "**boundary**".

> Objective 4 uses two undefined terms in eleven words. **Rewrite:** "Compare a random-slope
> model against a random-intercept model with AIC and with a likelihood-ratio test, and say why
> the usual reference distribution for that test is the wrong one when the thing you are testing
> is a variance."

---

## Class 8 — same model, two answers (`book/wk8-reml-vs-ml.qmd`) — needs a light pass

The best-taught hard chapter in the book. Jaro is the right device, and almost every term is
defined at the moment it is used. Six small things.

**Objective 4 `:36`.** "Use the **chi-bar-squared** reference for a variance component at the
**boundary**"

> The chapter defines both, beautifully, at `:462` and `:419`. The objective uses them cold, and
> objectives are the first thing a reader reads. **Rewrite:** "Say why the usual chi-squared
> reference is the wrong one when the thing being tested is a variance that cannot go below zero,
> and use the corrected test the engine provides."

**Objective 2 `:34`.** "Recognise the divisor argument from Class 2 in its grown-up form"

> Good. Keep.

**Itchy `:383`.** "They tell different stories and **reviewers routinely confuse them**."

> This reads as journal referees, which is fine — but the book uses "reviewer" elsewhere in its
> internal sense. **Rewrite:** "…and referees routinely confuse them."

**Further reading preamble `:776`.** "Items 2 and 3 are cited verbatim **in both engines' sources
(`DRM.jl/src/chibar.jl` and `drmTMB/R/profile.R`)**, so their details are checked against the
code this chapter runs."

> Two source-file paths in a reading list. **Rewrite:** "Items 2 and 3 are the papers both
> engines cite by name in their own code for exactly this test, so a reader chasing the method
> ends up in the same place the software does."

**Julia stuff `:767, :768`.** "the **χ̄²** p-value" / "`chibar_pvalue(stat, q)`: the **mixture**
p-value"

> Fine — the class has defined the mixture by then. Keep.

**Julia stuff `:769`.** "`repeatability(fit)`: R with a **delta-method** interval and a **bias
correction**"

> Fine once Class 6's rewrite is in.

**Masthead Caveat `:14`.** "No real pond file exists yet, so the data are simulated from a stated
seed inside the first cell"

> Excellent, plain, honest. This is the model for how every masthead caveat should read.

---

## Class 9 — both at once — **NEEDS A REAL PASS** (22 passages)

The most jargon-dense page in the book. The teaching in it is very good — the conditional/marginal
odds ratio, the unanimous broods, the two references for a residual — and a reader with one
statistics course will not survive the second half without help.

**1. Itchy `:922` — the engine-source leak.**

> "It says so in an error message, which is the only place it says so, and I had been calling
> ours adaptive quadrature right up until it corrected me in front of you. If you distrust error
> messages, **read the source: `binomial.jl` integrates each brood out with a fixed
> thirty-two-node Gauss–Hermite rule centred at zero, and `aghq_1d.jl` carries a comment telling
> the engine's own developers not to relabel that path as AGHQ.**"
>
> Two source files and a note left for the package's maintainers, in Itchy's dialogue.
> **Rewrite:** "It says so in an error message, which is the only place it says so, and I had
> been calling ours adaptive quadrature right up until it corrected me in front of you. If you
> distrust error messages you can go and read the code, and the code agrees: our engine spreads
> a fixed grid of thirty-two points around zero and adds up, and it never moves that grid to
> where the brood actually sits. So there are **three** rules in this room and not two, and the
> moral I was going to close on — name the approximation — I had not applied to my own engine."

**2. Itchy `:546`.** "**This is a limitation of the binomial path in the version of the engine
this page was built with, not a fact about GLMMs** (DRM.jl #761, **where the comment thread now
says so**)."

> "the comment thread now says so" is the authors reporting to each other that they filed it.
> **Rewrite:** "This is a limitation of the binomial route in this version of the engine, not a
> fact about GLMMs — a known limitation, reported."

**3. Summary `:1027`.** "…the same two groupings fitted Gaussian to mass are fine (**DRM.jl
#761**)."

> **Rewrite:** drop the issue number; the *Julia stuff* bullet can carry one.

**4. Itchy `:863`.** "**seed 909 is not a special seed, it is a number somebody typed once.**"

> Exactly the phrasing the brief flags. It is also confusing — a reader wonders *who* typed it and
> *when*. **Rewrite:** "…and there is nothing special about seed 909; it is one number out of a
> million that would have done."

**5. Itchy `:835`.** "The marginal reference is the correct **PIT** reference and the u = 0 one is
**miscalibrated** by `{julia} …`"

> "PIT" appears exactly once in the whole book and is never expanded. **Rewrite** (keep the inline
> number): "The reference averaged over broods is the right one, and the u = 0 one is off by
> `{julia} round(mean(null_cond) - mean(null_marg), digits = 4)`."

**6. Itchy `:839` — the sentence that will lose most readers.**

> "`fitted` on this fit is **marginal in the Class 6 sense and conditional in the Class 9 sense
> at the same time**, which is the sentence that makes people give up: it sets every brood effect
> to zero, and on a nonlinear link setting u to zero is *not* the same as averaging over u."
>
> Itchy says out loud that this sentence makes people give up, and then says it anyway.
> **Rewrite:** "Here is the thing that makes people give up, so I will say it slowly. `fitted`
> sets every brood's own effect to zero. In Class 6 that was the same as averaging over broods,
> because the model was a straight line and the average of a straight line is a straight line at
> the average. Here there is a link function in the way, and setting the brood to zero is *not*
> the same as averaging over broods. A chick is not, on average, a chick from an average brood —
> and the size of 'not', on this file, is `{julia} round(mean(null_cond) - mean(null_marg), digits = 4)`."

**7. Itchy `:398` — three unexplained terms in one speech.**

> "…the leftover favours **us**: our **coefficient of variation**, `{julia} …`, is smaller than
> the naive estimator's own, `{julia} …` … on a link where **the estimand does not move** when
> you add the grouping … a **design-effect heuristic** built from the chapter's own **ICCs**,
> 1 + (mean brood size − 1) × ICC, gives `{julia} …`"
>
> **Rewrite** (all inline numbers kept as they are): "…and the leftover favours us: measured
> against the size of what it is estimating, our standard error is the smaller of the two —
> `{julia} round(cv_glmm, digits = 4)` against `{julia} round(cv_naive, digits = 4)` — so the
> mixed model is genuinely more precise, not merely rescaled. Momo's prediction was not wrong
> about the mechanism it covers — it was answering Class 6's question, on a link where the thing
> being estimated does not change size when you add the grouping. Mass being
> `{julia} string(round(100 * (1 - icc_mass), digits = 0), "%")` within-brood is most of why the
> honest shortfall is only `{julia} string(round(100 * naive_short, digits = 1), "%")`. There is
> a rule of thumb for that, built from the two ratios this chapter has already computed — it says
> a clustered sample of this shape is worth about `{julia} round(design_effect, digits = 2)`
> ordinary observations for every one you have, which turns into a shortfall of
> `{julia} string(round(100 * design_shortfall, digits = 1), "%")` — the same ballpark, and not an
> identity."

**8. Translate box `:946`.** "the one they single out as inaccurate for a small number of
**abscissas** and inefficient for a large one. Thirty-two nodes is a large number of abscissas"

> The same box says "nodes" three lines earlier. **Rewrite:** use "nodes" both times.

**9. Itchy `:511`.** "**Its information matrix is meaningless before any question of estimability
arises.**"

> **Rewrite:** "So the standard errors it printed were never going to mean anything, whatever else
> is or is not estimable here."

**10. Itchy `:307` — non-collapsibility.**

> Jaro explains the idea fully *before* naming it, which is exactly right. Keep as written.

**11. Objective 3 `:36`.** "turn it into an intraclass correlation on the **latent** scale, naming
the scale out loud"

> "latent" arrives cold in the objectives; the class explains it well at `:256`.
> **Rewrite the objective:** "…and turn it into an intraclass correlation, saying out loud which
> scale that correlation lives on and why the scale had to be invented."

**12. Objective 4 `:37`.** "why a GLMM's coefficient is a **conditional** odds ratio, why
averaging over groups shrinks it towards zero"

> Fine — the class earns both.

**13. Itchy `:882`.** "…and do not lean on the count itself — over `{julia} B_band` genuinely
independent replicates the 95th percentile is `{julia} …`, so a count outside a **pointwise band**
is not a **well-behaved statistic**, whoever computes it."

> **Rewrite:** "…so counting points outside that band is not a reliable measurement, whoever does
> the counting."

**14. Itchy `:713`.** "It is right in the sense that it is the value with the most **posterior
support** given everything the model believes, and it is **regularised towards zero by
construction**"

> "posterior support" in a book that says, in the preface, that it contains no priors. And
> "regularised by construction" is not English a reader has met. **Rewrite:** "It is the value
> the model considers most likely for that nest, given everything the model believes, and it is
> pulled towards zero automatically — so a unanimous nest of one is pulled harder than a
> unanimous nest of five."

**15. Itchy `:625, :676, :678`.** "**blup**" / "**BLUPs**"

> Fine once Class 6 glosses it.

**16. Summary `:1023`.** One bullet, 220 words, seven numbers, containing "the **estimand**
changing size", "**coefficient of variation**", "a **design-effect heuristic**", "**ICCs**".

> This is the longest sentence-chain in the book and it is a *summary* bullet, where a reader goes
> to check they understood. **Rewrite: split into three bullets** — (a) the interval is narrower
> by X and most of that is the coefficient changing size, not the standard error; (b) measured
> against its own target the naive standard error is short by Y, and *that* is the number Class
> 6's rule is about; (c) on a nonlinear link, predict from both. Keep every number where it is.

**17. Summary `:1031`.** "Randomised **quantile residuals** are standard normal under a correct
model **only if each observation is compared with its own correct distribution**."

> Fine.

**18. Masthead Provenance `:13`.** "Every Julia cell in this chapter is **executed by Quarto at
render**, including the three errors. Nothing is pasted. The one R box is **pre-rendered**: all
four of its blocks were produced together by a single `Rscript` run…"

> Same fix as everywhere: "Every block of Julia code on this page ran when the page was made,
> including the three that fail. Nothing is pasted from a session you cannot see. The one R box
> was run once by hand against the same file, and its script is in the repository."

**19–22.** "**GHQ-32**" ×3, "**AGHQ**" ×6, "**Laplace**" ×4, "**conditional mode**" ×3 — all
inside the translate box, which defines all four properly. **Keep the box.** But the dialogue at
`:920` (*"It says our default is GHQ-32, and that GHQ-32 is not AGHQ"*) uses two acronyms *before*
the box defines them.

> **Rewrite `:920`:** **Momo:** "It says our default is a fixed grid of thirty-two points, and
> that a fixed grid is not the same thing as one that moves to where the group is."

---

## Class 10 — not even the groups are strangers — **NEEDS A REAL PASS** (24 passages)

The hardest chapter, and the one that most needs a reader's-seat edit. The argument — that a
heritability from a design like this cannot tell genes from nest — is the best thing in the book,
and I could follow it. What I could not follow was the machinery hung off it.

**1. Summary `:1075` — the worst single sentence for a reader.**

> "And a bound of exactly 0 or exactly 1 is not a computed bound: it is **`_clamp01`** acting on a
> value that fell outside, which is a thing to declare rather than to enjoy."
>
> `_clamp01` is a private function name from inside the engine. A reader cannot call it, find it,
> or use it. **Rewrite:** "And a bound of exactly 0 or exactly 1 is not something the model
> computed: it is the engine pushing a value that fell outside back to the edge. Say so when you
> report it, rather than enjoying the tidy number."

**2. Julia stuff `:1082`.** "**`ci` is `corrected ± z·se`, not `estimate ± z·se`** (**`bias_correct.jl`**),
then clamped into [0, 1] (**`heritability.jl`**)."

> Two more filenames. **Rewrite:** "…**`ci` is `corrected ± z·se`, not `estimate ± z·se`** — and it
> is then pushed back inside 0 and 1 if it falls outside."

**3. Itchy `:667`.** "It also settles the **`g_tol`** I chose out loud an hour ago: if that
tolerance had been too loose, this is the line where it would have shown."

> **Rewrite:** "It also settles the convergence tolerance I chose out loud an hour ago: if I had
> set it too loose, this is the line where it would have shown."

**4–7. "eigenbasis" ×5** — `:566` (code comment), `:781`, `:787`, `:795`, `:1088` (Julia stuff).

> Itchy `:781`: "…every refit of two structured components is a **dense *n* × *n* Cholesky**,
> because *A* and the brood-sharing matrix **share no eigenbasis** the way *A* and the residual do"
>
> Julia stuff `:1088`: "`eigen(Symmetric(A))`: with **one record per individual**, `A` and the
> residual covariance **share an eigenbasis**, so in the rotated coordinates `U'y` the whole model
> is diagonal and its profile likelihood costs O(*n*) per evaluation."
>
> Neither sentence is parseable by a reader who has done one statistics course, and the *point*
> of both is simple. **Rewrite `:781`** (keep the inline number): "…every refit with two
> structured components has to grind through the whole `{julia} n` × `{julia} n` matrix from
> scratch, because the pedigree matrix and the brood-sharing matrix cannot be untangled by a
> single change of coordinates the way the pedigree and the residual can — but a single real-data
> comparison is one such grind, twice, by the same code with one line changed."
>
> **Rewrite `:1088`:** "`eigen(Symmetric(A))`: when there is **one record per individual**, one
> change of coordinates untangles `A` from the residual completely, and in those coordinates the
> whole model comes apart into `{julia} n` independent one-number problems. That is what made two
> thousand refits fit inside a page. It is a special case — it needs the one-record design — and it
> is why the two-component model above could not be studied the same way."

**8. Julia stuff `:1083`.** "REML is the same **rotated-basis profile** with *n* replaced by
*n* − *p* and **`logdet(X'W⁻¹X)`** paid for — two lines, and it turns 'not available' into a
number."

> **Rewrite:** "…REML is the same calculation with *n* replaced by *n* − *p* and one extra term
> added for the cost of having estimated the fixed effects — two lines of code, and they turn 'not
> available' into a number."

**9. Further reading `:1121`.** "…and Patterson and Thompson for REML itself — the `n − p` divisor
and the **`logdet(X'W⁻¹X)`** term **this chapter's `profile_ll` adds** are theirs." Preceded by:
"**This chapter's own code cites all three by name and had listed none of them.**"

> The second half is a note from a reviewer to a writer. **Rewrite:** "…and Patterson and Thompson
> for REML itself, whose two ingredients — the *n* − *p* divisor and the extra term for the cost of
> the fixed effects — are exactly what the cells above added by hand."
> Delete "and had listed none of them".

**10. Further reading `:1112`.** "…item 5 is a book and item 7 is software documentation, neither
verified against a library in this session. Bibliographic details are verified where stated;
claims about what a paper argues are attributed as narrowly as the abstract supports."
**\[PARTLY UNVERIFIED\]**

> An `[PARTLY UNVERIFIED]` tag is a review artefact rendered live on the page. **Rewrite:** delete
> the tag and the whole preamble; keep at most "Details checked 2026-09-07."

**11. Itchy `:172–176` — the positive-definiteness digression.**

> "Now the eigenvalue, and I want you to notice that this check **cannot fail**. Write the matrix
> as a half of the identity, plus a quarter of the shared-sire blocks, plus a quarter of the
> shared-dam blocks. The two block terms are all-ones blocks, so **neither can contribute a
> negative eigenvalue**, and the half sits underneath everything as a floor."
>
> **Rewrite:** "Now the smallest eigenvalue, and I want you to notice that this check **cannot
> fail**. The matrix is a half of the identity plus two blocks of shared parents, and neither
> block can drag it below that half — so the check passes by construction. It is still worth
> printing, because it teaches you the reason it passes."

**12. Itchy `:323` — bias correction, assumed rather than re-explained.**

> "**The engine centres its interval on the bias-corrected estimate, not on the plug-in one.**"
>
> "plug-in" appears here for the first time in the book. **Rewrite:** "**The engine centres its
> interval on the corrected estimate, not on the one you get by just dividing the two variances.**"

**13. Itchy `:325`.** "The printed one is the **delta-method default**; the profile is a genuine
**re-maximisation** and on a fit this size it is minutes"

> **Rewrite** (assuming the Class 6 gloss is in): "The printed one is the quick kind Class 6
> showed you; the profile one refits the model at each candidate value, and on a fit this size
> that is minutes rather than seconds."

**14. Itchy `:534`.** "…because the **Wald** interval assumes a symmetry the likelihood does not
have there."

> Needs the Class 4 gloss. **Rewrite:** "…because the plain estimate-plus-or-minus kind of
> interval assumes a symmetry the likelihood does not have that close to zero."

**15. Itchy `:560` — the worm-plot paragraph, 250 words, six ideas.**

> One speech contains: a ∪ shape means right skew; the band is disqualified because it is drawn
> for independent draws; correlated draws need a wider band; you can read the verdict off the
> printed range instead; a right-skewed positive response wants a Gamma family; and no chapter
> teaches Gamma. **Rewrite: split into three speeches with Momo and Toto in between.** All six
> ideas are worth keeping and none of them survives being read in one breath. Keep every inline
> number where it is.

**16. Itchy `:781`.** "no brood term, **σ_A comfortably interior**"

> "interior" is used here without ever having been defined as the opposite of "on the boundary".
> **Rewrite:** "no brood term, and σ_A well away from zero."

**17. Itchy `:671`.** "…divide by *n* − *p* rather than *n*, and **pay for the determinant of the
information about the mean.**"

> **Rewrite:** "…divide by *n* − *p* rather than *n*, and add one extra term for the cost of having
> estimated the mean."

**18. Itchy `:675`.** "**The engine cannot compute this and a rotated basis with one changed line
can.** Name the limitation, then price it"

> **Rewrite:** "The engine cannot compute this and thirty lines of our own code can. Name the
> limitation, then measure what it costs you."

**19. Itchy `:930`.** One speech, 230 words, containing "**effective sample size**", a nested
parenthetical measurement, and three inline numbers.

> The finding is excellent — *the animal model separates genes from nest in proportion to how much
> of your relatedness comes from pairs who did not share one*. **Rewrite: put the parenthetical
> proof in its own speech**, and give the rule its own line, so a reader can find it.

**20. Summary `:1067`.** "The positive-definiteness check is worth printing but cannot fail:
`A = ½I + ¼S + ¼D` with `S` and `D` the shared-sire and shared-dam all-ones blocks, both positive
semi-definite, so **λ_min ≥ ½** for any one-generation sib pedigree."

> **Rewrite:** "The smallest-eigenvalue check is worth printing but cannot fail: the matrix is a
> half of the identity plus two blocks of shared parents, and neither block can drag it below that
> half. That half is the **Mendelian sampling** variance…"

**21. Summary `:1073`.** One bullet, 260 words, containing "**MC SE**", "**several Monte Carlo
standard errors from zero**", "**rotated basis**", "the wrong level".

> **Rewrite: split into two bullets** — one saying REML is unavailable here and why that matters
> for this literature; one saying what the gap was measured to be, and for which model. Keep all
> five numbers.

**22. Summary `:1074`.** "…whose **boundary-corrected** *p*, under the **50:50 χ̄² mixture** of
Self & Liang (1987) and Stram & Lee (1994), is `{julia} …`"

> Class 8 earns all of this. Class 10 assumes it. **Rewrite:** "…whose corrected *p*, using the
> reference Class 8 taught you for a variance tested at zero, is `{julia} round(bt.pvalue, digits = 3)`."

**23. Masthead Provenance `:13`.** Same "executed by Quarto at render" / "pre-rendered" fix.

**24. Objectives 3 and 6.** Objective 3 says "Compute a narrow-sense heritability as a **ratio of
variance components**, with an interval, and say what the denominator contains." — good, and the
chapter delivers it. Objective 6, "Recognise `relmat`, `phylo` and `spatial` as the same model
with a different matrix", uses three engine markers before the reader has met any of them.

> **Rewrite objective 6:** "Recognise that a pedigree, a phylogeny and a map of sites are the same
> model with a different matrix in it, and name the engine's marker for each."

---

## Appendix A — simulation as a way of thinking (`book/appendix-a-simulation.qmd`) — needs a light pass

Well pitched and the seed argument is genuinely clarifying. Three things.

**Objective 4 `:36`.** "…and say in one sentence when it and the **Wald** interval part company."

> Undefined here and everywhere. **Rewrite:** "…and say in one sentence when it and the ordinary
> estimate-plus-or-minus-two-standard-errors interval part company."

**Printed output `:250, :285`.** `"Wald interval covers slope"`, `"Wald interval      : …"`

> Keep the numbers; change the label to `plain (Wald) interval`, and have Itchy name it once:
> "The interval `confint` gives you is the plain kind — estimate, plus or minus about two standard
> errors. Statisticians call it a *Wald* interval, and that is the name you will meet in other
> people's methods sections."

**Itchy `:313`.** "…they pull apart hardest for a parameter that is skewed, or **pinned against a
wall it cannot cross**, and that is not a hypothetical case, it is the very next thing this book
asks you to estimate."

> Good. This is how "boundary" should be introduced everywhere. Consider using this phrasing in
> Class 5's front-matter box and Class 7's objective 4.

---

## Coda — where you go next (`book/wk13-coda.qmd`) — needs a light pass

The prose is the best in the book and I finished it wanting the second version. One section is
written to a colleague.

**"What version two adds" `:90–102`.**

> "Version two of the **engines** is a shorter and less romantic list… **Two of the three problems
> diagnosed while the early chapters were being written are fixed and merged, and every chapter
> here is pinned to the commit that carries the fix.** One is still open — the Julia engine refuses
> a random slope on a binomial fit that its R twin fits without complaint (**`DRM.jl` #753**),
> which is why Class 7 does not open on binary data. A second gap turned up in Class 4: `DRM.jl`
> has no `offset`, so the exposure is carried as a free covariate in Julia and the R box shows the
> offset (**#727**). Neither is a design decision; both are work."
>
> "diagnosed while the early chapters were being written", "fixed and merged", "pinned to the
> commit", two issue numbers, and "both are work" — this is a status update, not a coda.
> **Rewrite:** "Version two of the **software** is a shorter and less romantic list, and it is
> worth naming honestly, because this book's own chapters ran into it. Two of the three gaps that
> turned up while the early classes were being written have since been filled, and every chapter
> here uses the fixed version. One is still open: the Julia engine refuses a random slope on a
> yes-or-no response that its R twin fits without complaint, which is why Class 7 does not open on
> binary data. And there is no `offset` in the Julia engine, so Class 4 carries the exposure as an
> ordinary covariate and shows the offset in the R box. Neither is a design decision; both are
> work somebody has to do."

**Masthead Caveat `:15`.** "The engine gaps named are the ones **already filed and diagnosed in
`docs/state-of-play.md`, referred to by their issue numbers** rather than described from memory;
a reader wanting their current state should read the issues, not this page."

> **Rewrite:** "The software gaps named here are ones that have been written down and
> investigated, not recalled from memory. They may have been fixed since this page was made."

**`:43`.** "Then σ is not a nuisance to be repaired, it is the **estimand**"

> **Rewrite:** "…it is the thing you are trying to measure".

**`:100`.** "**A capability existing in a package's source is not the same as a capability that is
tested, documented and safe to teach.**"

> Good sentence, and the reader-facing lesson is real. Keep, but "in a package's source" →
> "somewhere in a package's code".

---

## What is already good, and should not be touched

So the pass does not sand off the things that work:

- **Class 1's four deliberate errors**, and the decision to teach error messages first.
- **Class 3's "for now"** — Itchy refusing to call the Poisson correct, and cashing it in Class 4.
- **Class 4's "check the exposure before you blame the family"**, and keeping the σ~Sex term that
  *did not* earn its place.
- **Class 5's two nulls** — showing that the reference everybody carries in their head is five
  times too generous. This is the single most useful thing I learned.
- **Class 6's shrinkage caterpillar** and Eddie's question. The picture does the work.
- **Class 7's within/between split at the end**, and Itchy saying plainly how much of his own
  earlier evidence it took away.
- **Class 8 entire.** Jaro is the right device and every term is defined where it is used.
- **Class 9's unanimous broods** — "on more than half of these nests the fixed-effect answer is
  undefined and the mixed answer is a number".
- **Class 10's three worlds**, and Momo's line about the nest. That is the argument of the
  chapter and it is perfectly clear.
- **Every masthead Caveat that just says what the data are.** Class 8's is the model.

---

## Summary table

| page | verdict | count |
|---|---|---|
| Landing page | needs a light pass | 2 |
| Preface | needs a light pass | 7 |
| Class 1 | fine (one masthead fix) | 2 |
| Class 2 | **needs a real pass** (one section to delete) | 5, one of them a whole section |
| Class 3 | needs a light pass | 4 |
| Class 4 | needs a light pass | 6 |
| Class 5 | needs a light pass | 6 |
| Class 6 | needs a light pass | 4 |
| **Class 7** | **needs a real pass** | **17** |
| Class 8 | needs a light pass | 6 |
| **Class 9** | **needs a real pass** | **22** |
| **Class 10** | **needs a real pass** | **24** |
| Appendix A | needs a light pass | 3 |
| Coda | needs a light pass | 4 |

**One structural note for whoever does the pass.** `docs/writing-conventions.md` already says a
correction has three homes — the dialogue, the Summary bullet and the Exercise. The same is true
of a banned word: every item above that appears in dialogue also appears in a Summary bullet, a
figure caption, an objective, or a masthead. `#727` is in four places, `#762` in two, `#753` in
two, "eigenbasis" in five, "pre-rendered" in all ten classes. Grep before re-rendering.

— Pat
