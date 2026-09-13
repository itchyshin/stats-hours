# Pedagogy audit: is this a textbook or a manual?

Consolidation of two independent reviews of the whole book, 2026-09-12. Review A is by a course designer in applied statistics. Review B is by Priya, a biology graduate student in the intended audience, with one statistics course behind her, a little R and no Julia. Neither saw the other's work. Both read all fourteen pages in order: `index.qmd`, then `book/wk0-preface.qmd` through `book/wk13-coda.qmd` with `book/appendix-a-simulation.qmd` before the coda.

Every countable claim in either review was checked against the `.qmd` sources and, where it concerned what the reader sees, against the rendered pages under `docs/site/book/`. Where a claim did not survive checking it is listed in section 7 and excluded from the counts. Every other number quoted below was recomputed from the sources on 2026-09-12: word counts, executed-cell counts, exercise counts, cross-reference counts, and the occurrences of the phrases the reviewers cite.

Items are tagged at the end with a severity and a source. "Both, independently" means the two reviewers raised the same finding without seeing each other's work; that is the strongest evidence in this document. "A" or "B" alone means one reviewer raised it and the other did not.

---

## 1. The verdict

The two reviewers agree, and they agree in detail. This is a teaching book for its first three classes, for Class 6, for Class 8 and for Appendix A, and it becomes a manual from Class 4 onward, worst in Classes 5, 7, 9 and 10. Both name the same good chapters and the same bad ones without having conferred. Both say the same thing about what the manual consists of: it is not a manual of how to use the engine, which would at least be usable, but a record of where DRM.jl 0.7.1 stops, what it refuses, what it returns empty, which mixture its boundary test implements, which quadrature rule it uses, and thirty to a hundred and twenty lines of hand-written numerical code per chapter to route around each gap. Both say every one of those episodes is dressed as dialogue and ends in a real lesson, and both say the reader is not the person who needs that lesson four times.

They diagnose the same second failure independently and it is the one that turns the first from a nuisance into a wall. Julia is taught in Class 1 and never again. From Class 2's summary on, the code uses broadcasting, comprehensions, loops, `function ... end`, NamedTuples, Dicts, `push!`, try/catch, do-blocks, three-dimensional arrays, Cholesky factors and backslash solves without a sentence of introduction, and the "Julia stuff" summaries that should carry the language thread are lists of engine accessors and engine gotchas. The course designer found this by grep: the words "broadcast", "symbol", "macro", "comprehension" and "for loop" never appear in prose. The student found it by reading: by Class 7 she was copying code, not reading it, and by Class 10 she had stopped trying. The two failures compound. The engine forensics and the methodological hedging make the hard chapters two to three times the length of the easy ones (Class 1 is 8,200 words; Classes 7, 9 and 10 are 16,800, 16,700 and 17,100), and the reader cannot skim past the parts that are not for her because she cannot tell, from the code, which parts those are.

Where they differ, the difference is mostly of frame and remedy rather than of finding. The course designer sees a curriculum problem: too many ideas per hour, second-pass material in first-pass chapters, and no signal for which idea is load-bearing. The student sees an authority problem: the teacher is wrong on the page so often, from a rule retracted in Class 7 to a whole chapter's numbers replaced in a table to an engine misdescribed until an error message corrected him, that by Class 9 she was reading Itchy's assertions as provisional. Both are right and the second is the more serious, because a textbook whose voice the reader has learned to discount has stopped being a textbook whatever its pacing. On remedy, the designer wants the material subtracted to a fixed budget per class and Appendix A promoted to a class so that coverage and Monte Carlo error are taught before they are used; the student wants Appendix A left where it is as the template for the book's pacing, with the methodology moved into it and the chapters pointing back. The author must decide; section 3 says which way this document leans and why. The designer wants Classes 5 and 7 split; the student would split Class 4. Those are compatible.

One more thing both reviewers say and it should be read as the instruction for the whole revision: the statistical teaching, when the engine steps out of the way, is the best either had read at this level. The revision is a subtraction toward what already works, not a rewrite.

---

## 2. What must survive

Both reviewers listed what works. Where their lists overlap the item is marked; the overlap is large. The revision should cut toward these and not around them.

**The spine.** Each rung frees one thing the rung before held fixed, stated on the board in Class 2 ("μ is where the birds are. σ is how spread out they are.") and extended in Class 6 ("and no two rows know each other"). It is paid off in real callbacks: Class 7 opening on "They were all parallel", Class 9 opening on the note Class 3 promised, Class 10 opening on "Read me the promise". Both reviewers say a reader who finishes Class 10 knows what independence was buying in Class 2. Both.

**Class 1.** "Look at it four ways"; "add the pieces back up"; "a seed promises reproducibility, not correctness"; "that gap is not a finding yet"; the three-question error routine (what did I ask for, what exists, which argument), with the `filter` argument-order error as the payoff of the one translate box. The student says this section is the reason she did not bounce off Julia. Both.

**Class 2.** "A linear model is three claims"; "a sparrow with a tarsus of zero is a tragedy"; "the tarsus coefficient changed because the question changed" and "tarsus was quietly carrying sex's luggage"; R² done the long way before the button; the unit-dependent σ = 1 null; the divisor disagreement box with a named mechanism, √(n/(n − p)), which both reviewers call the model for what a disagreement box should be. Both.

**Class 3.** Two students bring responses that cannot be a length; fitting the wrong-shape Gaussian first and asking what it believes about an actual chick, shown from `extrema(fitted())`; odds multiplying without leaving the legal range; computing the inflection before saying "diminishing returns"; "a brood is big because a parent could afford it"; "the family picks two things, only one of them the shape of the curve". Both.

**Class 4.** "No." Open the file before you blame the family; the egg ceiling figure; "compare like with like or you convict an innocent model"; "θ is the price of the lie"; "overdispersion is a disease of standard errors"; "not detected is not no"; the binned mean-variance plot with marker area; the same move in three families unifying beta-binomial, negative binomial and σ ~ Sex. Both.

**Class 5.** Three residuals coinciding in the Gaussian ("why residual feels like one word"); Momo choosing a statistic she already knows the answer to; the impossible-birds simulation; "a check you pass is much weaker than a check you fail", shown on one model; "comparison ranks; it never validates"; the ΔAIC-when-the-parameter-is-useless simulation; "count your rows, it is one call to `nobs`" with the negative likelihood-ratio statistic. Both.

**Class 6, almost whole.** More rows than birds; the NA error as real data's first lesson; Momo naming the fourth hidden claim; the SE ratio turned back into an effective sample size between the two counts; the shrinkage caterpillar as the answer to "what is a random intercept"; the parallel-lines figure; "whichever one you name"; h² ≤ R with its Dohm caveat and the partition stated. Both.

**Class 7.** "Mass is condition, tarsus is architecture"; "pick a covariate whose within-group variation is a thing that happens, not a thing you did"; ρ as a statement about where zero is; and above all the within/between decomposition ("the cheapest thing on this page was never the random slope"), which both reviewers say should open the chapter. Both.

**Class 8, almost whole.** A student-driven opening ("I fitted the pond model twice"); one keyword, which rows move; "rows do not buy you a variance component, groups do"; test-rather-than-believe with n versus J; forty datasets to show "systematic"; the profile-likelihood picture of the puddle curve hitting the wall; the pile-up counted; the lmer both-ways box; "a variance component reported without its estimator is an unlabelled number"; the REML refusal explained as a category error. The student calls this the best-structured hard chapter and says its refusal is the one "read the refusal" episode the book should keep. Both.

**Class 9.** The unanimous-brood count against independent flips; the latent-threshold figure and π²/3; "a repeatability quoted without its scale is a rumour"; Jaro on conditional versus marginal odds ratios with the logit/log distinction; the two-curves figure; unanimous broods having no finite fixed estimate as "the strongest argument for random effects". Both.

**Class 10.** A built by hand and checked by name; "the model does not learn who is related to whom; you tell it"; Momo's "they share a nest" paragraph; "It is publishable. That is the problem."; the three-worlds figure, every curve over the real estimate, which the designer calls the single best teaching figure in the book; the four-faces table. Both.

**Appendix A.** Short, one idea per beat: a seed is a promise; the fitted-subtraction trap once; coverage as a property of a procedure; the ranked-interval caterpillar; the bootstrap-versus-Wald gap drawn at the scale of the disagreement. Both reviewers say this is the pacing the whole book should have. Both.

**The exercise design principle.** Your own organism, paste the code, explain every line to someone who has not opened Julia; and the specific exercises "predict, then check" (Class 8), "the third world" and "shuffle the matrix rows" (Class 10), "break it four ways" (Class 1). A.

**The cast's voices.** Toto's honest mistakes, Momo's scepticism, Eddie's "so what is a random intercept", Jaro arriving for the hard weeks. The student says these are what make the good pages read as teaching rather than lecture. B.

**The rule that no number is typed in**, and the honesty about what is not covered. A.

---

## 3. Book-level changes

Ordered by how much each would change the book.

### 3.1 The engine is the subject from Class 4 onward

**Problem.** Wherever the engine is missing a feature or misbehaves, the chapter stops teaching statistics and starts documenting software: diagnosing the failure, reimplementing the missing piece by hand, or explaining why the printed warning is wrong. It is concentrated in the hardest chapters, where the reader has the least spare capacity, and the lesson each episode ends in is always the same one: a defect in your software and a fact about your data print the same output.

**Evidence.** Ten occurrences of "reported to the engine's authors" or "reported to its authors" across Classes 4, 5, 7, 9 and the coda (checked: 2, 1, 2, 3, 2). Issue numbers on the page: "DRM.jl #753" in Class 7's summary, "DRM.jl #761" in Class 9's summary, and an error message quoting "(1-D Liu–Pierce, #448)" in Class 9. Class 4: "The engine prints that warning without checking which family you asked for, so here it prints something untrue. That is a fault in the software rather than something for you to learn." Class 5's translate box is about what `residuals` refuses in DRM.jl 0.7.1 and what `anova` refuses in drmTMB. Class 7: about 150 lines tracing a `DomainError` to a two-by-two determinant, plus a 400-replicate crash-rate study concluding "on this engine and this version, a random-slope fit that throws is data". Class 9: about 120 lines on a second grouping returning infinite standard errors ("a limitation of the binomial route in this version of the engine"), a hand-written Newton solver because `ranef` returns an empty Dict for a non-Gaussian fit, and a deliberately provoked `ArgumentError` used to discover that the engine's default is a fixed 32-node grid. Class 10: about 120 lines of eigen-rotated profile likelihood, golden-section search, bisection and a dense coordinate-ascent solver because "REML is not implemented for a model with a structured random effect". The `simulate()` draws-with-random-effects-at-zero trap is re-explained in Classes 6, 7, 8, 9 and 10 (twelve occurrences of the sentence).

**Change.** Create one short appendix, "Where the engine stops, at version 0.7.1", holding every known limitation, quirk and issue number as a plain table: feature, status, workaround, issue. In the chapters, state the model, fit it, and where the engine cannot, say so in one sentence with a pointer to that appendix, then continue with the statistics. Delete the forensic sections (Class 7's origins tables and `slope_study`; Class 9's Year/Mum infinite-SE investigation, Newton solver and AGHQ discovery loop; Class 10's hand-rolled REML) or move their code to the appendix and keep only the one number each produces. Keep at most one "read the refusal" episode in the whole book: Class 8's REML refusal, because there the refusal is the lesson. Delete version strings and issue numbers from chapter prose entirely. Separately, fix the engine where it is cheap before version 1 so the chapters stop teaching around it; section 6 lists those items. The book edits do not wait on the engine work.

Severity: structural. Raised by: both, independently.

### 3.2 Julia is taught for one chapter and then assumed

**Problem.** The preface promises "basic Julia is not an appendix and not a prerequisite, it is Class 1", but Class 1 covers CSV, DataFrames verbs, errors, seeds and `@formula`, and every chapter after it silently assumes constructs never introduced. The "Julia stuff" summaries are catalogues of engine accessors, not of language. A reader who is meant to learn Julia here cannot read the cells she is asked to run.

**Evidence.** Grep across all chapters: the words "broadcast", "symbol", "macro", "comprehension", "for loop" and "define a function" never appear in prose. Class 1 uses `by_sex.mean_wing[by_sex.Sex .== "F"][1]` (the dot), `groupby(sparrows, :Sex)` and `:Wing => mean => :mean_wing` (the colon) and `@printf` (the @) without a word on any of them. Class 2's simulation thread: `wing_sim = [rand(rng_sim, Normal(m, sigma_hat)) for m in mu_hat]` and `mean(std.(eachcol(sims .- fitted(fit1))))`. Class 3: `grid = (; Mass2 = [2.0, 3.5, 5.0])`, `function refit_slope(y) ... end`, `for (m, p) in zip(...)`, `ysim[:, k]`, with the only note being the manual line "newdata is a NamedTuple or column table, not a DataFrame". Class 4: generator expressions, ternaries, NamedTuple returns, `findfirst(==("mu: logEgg"), ct_e.rownms)`. Class 5: `Float64[]`, `push!`, closures, semicolon-sequenced one-liners, `sortperm`. Class 6: `idx = Dict(b => i for (i, b) in enumerate(bird_ids))`, `keep = trues(n)`. Class 7: `Dict{Symbol,Float64}()`, `leftjoin`, try/catch with `e isa DomainError`, `with_logger(NullLogger()) do`, `randn(rng_sim, 2, birds, nrep)`. Class 8: `open(path, "w") do io`, `b = (X' * Hi * X) \ (X' * Hi * y)`. Class 9: `sprint(showerror, e)`, `clamp.`, `Int.(rand(rng, n) .< p)`. Class 10: `half_sib(i, j) = j != i && ((sire[j] == sire[i]) ⊻ (dam[j] == dam[i]))`, `cholesky`, `diagind`, golden-section search. Class 2's Julia summary is `coef`, `coeftable`, `confint`, `loglik`, `aic`, `bic`, `nobs`, `dof_residual`, `lrtest`: engine API, not Julia.

**Change.** Run a Julia thread with the same discipline as the statistics thread. Each class introduces at most two or three language constructs, in prose, at the moment the code first needs them, shown once on the sparrow data with one sentence of what it means, and one exercise practises each. A concrete allocation both reviewers converge on: Class 1, the dot (broadcasting), the colon (Symbol), the @ (macro), the trailing semicolon, keyword arguments; Class 2, symbols in `select`, comprehensions, `exp.()`, shown as a loop first and then as the one-liner; Class 3, `function ... end`, `for`, `zip`, the NamedTuple and why `predict` takes one; Class 5, `push!` and typed empty vectors, `rand(rng, 1:n, n)` and `df[rows, :]` for resampling; Class 6, Dict as a lookup table; Class 7, try/catch. Split every "Julia stuff" summary into "Julia you used" (language constructs, one line each, naming the cell they first appeared in) and "Engine calls" (the two or three `drm`-family functions the chapter needed). Move every accessor caveat and gotcha to the engine appendix. Anything beyond that list (matrix algebra, `cholesky`, golden section, `eigen`) belongs in an appendix the reader is told she may skip.

Severity: structural. Raised by: both, independently.

### 3.3 Chapter size and cognitive load double from Class 4 on

**Problem.** Chapters 4 to 10 each ask the reader to hold twenty to forty new ideas and read twenty to forty executed cells in what the fiction calls one hour. The dialogue form makes it worse: nothing signals which idea is load-bearing, so a novice weights the Monte Carlo standard error of an order statistic the same as "overdispersion is a disease of standard errors". The pattern in each hard chapter is: fit the model, run a diagnostic, discover the diagnostic's reference is wrong, simulate a null for the diagnostic, sweep the seed of the null, compare that null with a second null.

**Evidence.** Word counts (recomputed): Class 1 8,194; Class 2 7,879; Class 3 8,500; Class 4 11,123; Class 5 13,643; Class 6 10,694; Class 7 16,831; Class 8 9,664; Class 9 16,746; Class 10 17,103. Executed cells: Class 2 36, Class 4 31, Class 5 28, Class 7 25, Class 9 39, Class 10 29. Class 5's own character counts the nulls: "Eddie: That is the fourth different null on this page." Class 5's stage direction says Eddie "has come for the last twenty minutes and will ask the question the first forty are for", in a 13,600-word chapter. Class 4's objectives run to six items and the chapter additionally contains a 200-seed sweep to decide whether a sag in a worm plot is real. Class 9's residual section runs from a u = 0 reference to a marginal reference to a 500-draw null of both to a 500-seed sweep to a 500-replicate iid band null. Class 10 adds four hand-written optimisers after the statistical point has already landed. The student reports skipping roughly a third of each of Classes 4, 5, 7, 9 and 10 while reading for an exam.

**Change.** Cap each class: one rung freed, one model fitted and read, one diagnostic, one simulation. The designer's numbers: roughly 6,000 words, 12 executed cells, five new ideas, with the one idea the class is for named at the top and three or four objectives, none of which needs a 30-line function to demonstrate. Split Class 5 (residuals and simulation checks / model comparison) and Class 7 (within-between decomposition / random slopes), and cut Class 4 to its spine (exposure before family; the same second formula in three families; not detected is not no). Move every second-pass idea (MCSE, seed sweeps, four nulls, boundary mixtures beyond q = 1, REML by hand, coordinate ascent) into clearly labelled and visibly collapsible "Going further" boxes or into Appendix A, so that a first-time reader can skip them without losing the thread.

Severity: structural. Raised by: both, independently.

### 3.4 The simulation thread has become the subject

**Problem.** Appendix A calls simulation "a habit, not a subject" and the coda repeats it, but from Class 4 on the majority of pages are Monte Carlo methodology: thousands of refits, coverage studies, MCSEs on medians, rejection rates with and without failures, and nulls compared against nulls.

**Evidence.** Class 4: a 2,000-resample bootstrap of the MCSE of the median of 200 refitted θ values, compared against "the textbook 1.2533 × SD/√n". Class 5 runs 2,000 simulate-refit worlds twice, 2,000 normal samples, 1,000 impossible-bird worlds twice, 1,000 ΔAIC worlds and 2,000 bootstrap resamples with two refits each. Class 7 runs 400 null and 400 alternative refits and reports "four hundred replicates cannot distinguish either bound from nominal". Class 8 runs 2,000 boundary replicates. Class 9 runs 1,000 marginal worlds, 500 residual-null draws, a 500-seed sweep, 500 iid band replicates and a 100-refit coverage study with its own interval-on-coverage. Class 10 runs 3 × 500 recovery worlds plus paired REML. "Monte Carlo" appears 54 times in the sources.

**Change.** In each class, one simulation, at most about 200 refits, one printed number, one sentence. The methodology (coverage, MCSE, the parametric bootstrap, why refits belong in the null, why a simulated rate carries an error bar) lives in Appendix A and the chapters refer to it. Where the two reviewers differ is whether Appendix A should then be promoted to a class between Classes 2 and 3 or 5 and 6 so it is taught before it is used (A), or left as the appendix whose pacing is the template and simply pointed at (B). This document leans to B: promotion adds a methodology chapter in the first third of a book the author already fears is a manual, and once MCSE is stripped from Classes 3 and 4 (item 4.4.2) the first real user of coverage is Class 5, which can point forward. If, after the cuts, Class 5 still cannot be read without the appendix, promote it then. Author to decide.

Severity: major. Raised by: both, independently.

### 3.5 The teacher being wrong on the page has gone from a device to a tic

**Problem.** Toto's mistakes are the promised ones and they teach. Itchy's serial self-corrections do not: a rule from Class 6 retracted in Class 7, a boundary story retracted two cells later, a whole chapter's numbers replaced in an "an hour ago / now" table, a demonstration that "fell apart in front of us" in Class 9, an engine misdescribed until an error message corrected him. The reader stops knowing which sentence to put in her notes, and by Class 9 reads Itchy's assertions as provisional. Several passages read as the book arguing with an earlier draft of itself.

**Evidence.** Class 7: "Now watch me get caught by my own rule"; "That is the story I would have told you, and it is wrong"; "Every one of them moved."; "Toto: Should we have started here? Itchy: Probably". Class 9: "So your demonstration just fell apart in front of us."; "I had been calling ours adaptive quadrature ... right up until it corrected me in front of you." Class 4: "Now the check I have been putting off, because it is the one this book has been sloppy about." and "Class 2 reports this identical fit in exactly those terms, and it is worth turning back to check that it does, because a book that says "no" in one chapter and "not detected" in another has not decided what it believes." Class 5: "turned on the verdict I most wanted to be true". Class 3: "So it is the low end, not both, that got nowhere near a wall". Class 6: "Which is the sin this whole book is about, committed by me, in a cell, on purpose."

**Change.** Keep Toto's and Momo's mistakes. Allow Itchy at most one visible self-correction per chapter and make it the one that carries the chapter's lesson. Everywhere else, teach the corrected version first and drop the retracted draft. Delete every sentence in which the author audits the book's own consistency in a character's mouth. Where a passage reads as the book arguing with an earlier version of itself, rewrite it from scratch.

Severity: major. Raised by: both, independently (A in the Class 4 and Class 7 items; B as a book-level finding).

### 3.6 Graduate ideas arrive early, as em-dash definitions, and are then relied on

**Problem.** Statistical concepts arrive as eight-word definitions in the middle of a sentence and are then used as tools for the rest of the book. Some are the hardest ideas in the course. The book reaches for a research-methodology idea where a plain sentence would teach.

**Evidence.** Class 2: "the smallest ratio this sample would have caught four times out of five, that is what "80% power" means" (minimum detectable effect, in the second class). Class 3: "That piece of arithmetic is called the delta method"; "A spread computed from a random draw has its own wobble, and that wobble has a name, the Monte Carlo standard error", with 1/√(2n) used as the yardstick in the third class. Class 4: "Deviations in a worm plot are order statistics ... and therefore heavily autocorrelated"; "the statisticians' phrase is that the score equations are unbiased estimating equations"; a bootstrap MCSE of a median against an asymptotic formula. Class 5: the ΔAIC = 2 − LR identity, AICc, "pointwise envelope", "closed form", "parametric-bootstrap p-value". Class 6: "Hessian names the curvature of the likelihood at its peak". Class 7: "printed as a Cholesky factor", condition numbers, MAD, Stram and Lee versus a q = 2 mixture. Class 9: "the coefficient of variation", "design effect", "non-collapsibility". The student counted at least a dozen such definitions: Wald interval, delta method, Monte Carlo standard error, order statistics, pointwise envelope, profile likelihood, Hessian, method of moments, contrasts, exchangeable, coefficient of variation, design effect, non-collapsibility, closed form, parametric bootstrap p-value, Cholesky factor, condition number.

**Change.** Defer minimum detectable effects to Class 5 or Appendix A and have Classes 2 and 4 say "not detected, and this sample was small". Introduce the Monte Carlo standard error once, in Appendix A, and have Classes 3 and 4 say "well above one" without an error bar. For the six concepts the book leans on repeatedly (Wald interval, delta method, Monte Carlo SE, profile likelihood, the boundary, the parametric bootstrap) give each a short standalone demonstration the first time, on the Appendix A model. Add a glossary page. Concepts used once (condition number, method of moments, coefficient of variation, order-statistic autocorrelation, unbiased estimating equations, AICc, the 1.2533 comparison) should be cut with the passage that needs them.

Severity: major. Raised by: both, independently.

### 3.7 The book narrates its own structure on every page

**Problem.** Hundreds of "Class N" cross-references ask the reader to hold the whole syllabus in mind; the same debts are announced repeatedly before they are paid; Classes 3, 4 and 5 open with a "What this chapter pretends" block that restates one paragraph; every chapter's front-matter says "the book itself is not written"; several passages audit the book's consistency in dialogue. The student stopped reading the pointers by Class 5, and the boilerplate made every page feel provisional.

**Evidence.** Occurrences of "Class N" per file (recomputed): Class 3 38, Class 4 35, Class 5 28, Class 6 47, Class 7 57, Class 9 86, Class 10 70. Class 3 makes the brood-identifier point four times: header note, Itchy's speech, summary bullet, Exercise 9. Class 6 forward-references Class 8 for the boundary and the divisor six times. Class 7: "Class 6 said so, in the cell most people skip". Class 9: "Class 8 is still where it gets its hour", after Class 8 has been read. Every chapter carries a `status_note` saying the prose "is still being written" or "the book itself is not written".

**Change.** Each chapter says once, at the top, what it inherits and once, at the end, what it defers. One forward pointer per section, none in summaries. Cut cross-references by two thirds and trust the climb figure to carry the structure. Delete the "What this chapter pretends" header once the pretence has been stated in Class 3; move each chapter's pretence to one closing sentence. Remove the book-auditing-itself sentences. Replace the per-page status, provenance and caveat boilerplate with one line and a link. Keep the genuine callbacks that make the arc ("They were all parallel"; "Read me the promise"; "the note Class 3 promised").

Severity: major. Raised by: both, independently.

### 3.8 The "Julia stuff" summaries are API reference lists and gotcha lists

**Problem.** The section that should carry the language thread is instead a list of engine accessors and, increasingly, of the engine's failures, documented per version.

**Evidence.** Class 1's summary documents `aic`, `residuals` and `simulate` under "Three calls you will meet, and cannot use today." Class 2 lists `bic`, which is never used, and notes "there is no `logLik` or `AIC`". Class 4: "There is no `offset` in DRM.jl 0.7.1"; "Neither engine prints θ or φ for you"; "Columns 5 and 6 are the confidence limits". Class 5: "There is no `:pearson`"; `update(fit, newformula; data)` "Not used above". Class 6: "It defaults to `method = :delta`"; `vc`, `Cycled(i)` and `Makie.wong_colors()` listed and not used. Class 7: "`re_sd(fit)`: returns an empty `Dict` for a fit with a correlated block"; "(DRM.jl #753)". Class 8: "The `:resd` and `:sigma` rows come back on the log scale". Class 9: "`ranef(fit)`: returns an empty `Dict` for a non-Gaussian fit in DRM.jl 0.7.1 ... (DRM.jl #761)". Class 10: "`ci` is `corrected ± z·se`, not `estimate ± z·se`".

**Change.** As in 3.2: split into "Julia you used" and "Engine calls"; list only what the chapter used; move every gotcha to the engine appendix; put the engine accessors on a one-page reference card at the back.

Severity: major. Raised by: both, independently.

### 3.9 Exercises: nowhere to check yourself, no data for the named organisms, and constructs never taught

**Problem.** The exercise principle is right, but there are no worked solutions or model answers anywhere in the book; the three named organisms have no data files, so every organism-named exercise cannot be done; several exercises require the chapter's research-grade code, a loop before any loop has been taught, or R; and nothing walks a reader from her own CSV to a reported result.

**Evidence.** No chapter has an answer key. `data/` holds the 2012 sparrow files and Class 8's simulated ponds and nothing else (checked: no water-flea, Daphnia or dunnock file exists). Exercises naming Toto's water fleas, Momo's tadpoles or Eddie's dunnocks: Class 1 Ex 5; Class 2 Ex 4, 5, 6; Class 3 Ex 4, 5; Class 4 Ex 8, 9; Class 6 Ex 6; Class 10 Ex 5. Class 2 Ex 8 needs a 200-iteration refit loop before any loop has been taught. Class 4 has 13 exercises; Class 9 has 10, one requiring `glmer` at three `nAGQ` values in R. Class 5 Ex 3 asks for a 2,000-replicate simulate-refit-count loop, twice, on the reader's own data. Class 7 Ex 7 asks the reader to run the chapter's 800-refit `slope_study` on her own design and Ex 8 to read two papers. Class 1 Ex 9: "in one sentence, guessing is fine".

**Change.** Ship three small datasets (real if available, otherwise simulated from a stated seed and labelled as Class 8 labels its ponds) for Toto, Momo and Eddie, and point every organism-named exercise at them. Two worked exercises with model answers per chapter, on the book's own data, with Toto's answer and Itchy's marking in Class 1 as the template for "explain each line". Cap at seven exercises per chapter, ordered easy to hard, the first three doable in ten minutes. Move R-dependent exercises into an optional "if you have R" block. Cut exercises that require the chapter's research-grade code, or provide the function in `tools/` and ask the reader to call and interpret it. Add to each class a ten-line "recipe" box (read, look, fit, read the table, one check, one sentence for the paper) written against a generic `df`, `y`, `x`, `g`, and one worked "your first model on your own data" page after Class 2.

Severity: major. Raised by: both, independently (A on answer keys, R dependence and research-grade code; B on missing data files and the absent recipe).

### 3.10 Motivation is inconsistent; the weak chapters open with a caveat or with the engine

**Problem.** The best chapters open with a person and a problem. The others open with a block about what the chapter "pretends", with the engine, or with objectives that are about software behaviour.

**Evidence.** Preface first sentence: "This is a statistics book with one engine in it." Classes 3, 4 and 5 open, before the class begins, with "**What this chapter pretends.**" Class 5 objective 5: "say which comparisons the engine refuses outright, which it only warns you about, and which it cannot check at all." Class 9 objective 5: "tell a limitation of your engine apart from a fact about your data." By contrast Class 8 opens "Momo: I fitted the pond model twice." and Class 6 opens with "it has more rows in it than it has birds".

**Change.** Every class opens with the question in the room (a student's data, a number that looks wrong) and states its one idea within the first 200 words. Move the "what this chapter pretends" text to a closing "what we swept under the rug" paragraph. Rewrite every objective that names engine behaviour as an objective about data or models.

Severity: major. Raised by: A (B raised the "pretends" header under 3.7).

### 3.11 The same fit, helper, trap and warning are re-taught across chapters

**Problem.** Material is repeated rather than referenced.

**Evidence.** The σ ~ Sex sparrow fit with its 80%-power minimum detectable ratio appears in Class 2, Class 4 and the coda (three fits of one model). The worm-plot envelope arithmetic is re-implemented from `erfinv_approx` in Class 4 (`worm_outside`), Class 5 (`worm_parts`, `n_outside`, `n_below`, `n_zeros_outside`, `worm_slope`, `longest_run`), Class 6 (inline), Class 7 (`worm_band`, `n_outside`) and Class 9 (`outside_band`). The `simulate()` zero-random-effect trap is explained in Classes 6, 7, 8, 9 and 10. "If a line at the bottom of the warning names a file inside the engine, that line is for the engine's authors, not for you" appears in Class 6 and Class 8. The offset limitation is stated in Class 4 (three times: dialogue, translate box, summary), Class 5 (twice) and the coda.

**Change.** Teach each once. Put the worm-plot counters in `tools/figures.jl` with one documented `worm_counts(r)` and call it. Fix `simulate()` or document its behaviour once in Appendix A. Keep the σ ~ Sex fit in Class 4 only; Class 2 ends after R², the coda references Class 4's figure. Keep the offset limitation in the engine appendix and the coda only.

Severity: major. Raised by: both, independently (A as a book-level finding; B in the Class 5, 6 and 7 items).

### 3.12 The audience is contradictory

**Problem.** The brief says undergraduates or graduates learning Julia and statistics together; the preface says something else; the cast says a third thing; the R boxes assume a fourth.

**Evidence.** Preface: "It is Julia for the working statistician coming from R. It is not Julia for data science". Cast table: "Momo, the sceptic, arriving from SPSS". Class 1: "Momo: In SPSS I opened a file by opening a file." Class 2: "Momo: (typing quietly) I ran it in R while you were talking. R says my residual standard error is 1.426". Class 1's translate box maps `dplyr` verbs; Class 7's box discusses `lmer` REML defaults; Class 9's box compares `glmer` at `nAGQ = 1, 9, 25`. The student did not know whether she was the reader.

**Change.** Decide. If the reader is a student meeting both for the first time, say so in the preface's first paragraph, give Momo one consistent background, cut the R boxes to the three that genuinely prevent a misreading (Class 2's divisor, Class 8's REML default, Class 9's quadrature), and move the "cost, stated plainly" paragraph about lme4 and MixedModels.jl to the coda. If the reader is an R-fluent statistician, say so on the cover and drop the claim that basic Julia is taught. The rest of both reviews assumes the first answer.

Severity: major. Raised by: both, independently.

### 3.13 The dialogue collapses under long Itchy monologues

**Problem.** When a speech runs 300 words the students stop being interlocutors and the page becomes a lecture with names on it.

**Evidence.** Measured: Class 9's speech beginning "Two numbers, both correct, measuring different things" is 380 words; the speech beginning "With the right reference the spread sits" is 301 words; Class 7's speech on the rejection rate caveat is 212 words. Class 4's summary bullets are themselves paragraphs.

**Change.** Cap speeches at about 120 words; break a long explanation with a student question a real student would ask. Summary bullets: one sentence each.

Severity: minor. Raised by: A.

### 3.14 Notation arrives ad hoc, with build notes left in the source

**Problem.** β0, β1, u_j, σ_u, Σ and A are each introduced where first needed rather than once, and every equation block carries an internal build comment.

**Evidence.** Ten `<!-- eq: hand-typed; replace with equations(fit) when Symbolizer.jl lands -->` comments across Classes 4, 6, 7, 8, 9, 10 and Appendix A. Class 4 introduces y_i ~ Poisson(μ_i), log μ_i = β0 + β1 x_i without having introduced β; Class 6 says "these six symbols are the ones you keep"; Class 7 adds Σ; Class 10 adds y = Xβ + a + ε.

**Change.** A half-page notation box in Class 2 (β, μ, σ, i, j), extended once in Class 6 (u_j, σ_u) and once in Class 10 (A). Remove build comments from what the reader can see in the source.

Severity: minor. Raised by: A.

### 3.15 Review notes have leaked into code the reader sees, and summaries hand-type numbers

**Problem.** Revision history sits in code comments on the page, and some summary bullets contain literal numbers, which undercuts the promise the preface makes and the reader is asked to trust.

**Evidence.** Class 3 code comment: "(this legend used to sit inside the axis at top-left, over four real markers ... moved out after that was caught in review)". Class 6: "Counting z past a fixed +-2, as this cell used to, answers a different question than the one on the page." "(reviewer: pond P05 sat under it)" appears three times in Class 9 and once in the coda (checked); there is no pond in either. Class 7's summary contains literal numbers: "58% between-bird", "from 2.13 mm to 1.13", "0.062 ± 0.015 and 0.040 ± 0.010", "+0.583 (SE 0.093) between birds and +0.049 (SE 0.056) within", "cut σ_1 from 0.431 to 0.254".

**Change.** Strip review-history comments from every code cell. Replace every literal number in a summary bullet with an inline `{julia}` expression, or delete the number.

Severity: minor. Raised by: B.

### 3.16 The seed rule contradicts itself

**Problem.** Class 1 makes "never `Random.seed!`" a house rule; Appendix A opens with three cells of `Random.seed!`, and only the summary admits the discrepancy.

**Evidence.** Class 1 summary: "Never `Random.seed!`, which sets a hidden switch for the whole session". Appendix A: "The first line, `Random.seed!(316)`, is the one to keep your eye on." (seven occurrences in the file), and its summary: "The book's own code, in every class, does not touch the global generator at all".

**Change.** Use `MersenneTwister(316)` in the generator cells and keep one sentence on why the global seed exists; or keep `Random.seed!` and have Itchy say in dialogue why the appendix breaks the house rule for one demonstration.

Severity: minor. Raised by: both, independently.

---

## 4. Chapter-by-chapter changes

In book order. Each item: problem, evidence, change, source.

### 4.0 Preface

**4.0.1 Wrong audience in the first section.** "It is Julia for the working statistician coming from R. It is not Julia for data science; there are good books for that". The preface tells the student the book was said to be for that it is not for her, and the rest of the section talks about referees, co-authors, lme4 and ecosystem cost; one page later the cast table introduces a student from SPSS. Change: state the intended reader in the first paragraph and make Momo, the R boxes and the preface agree with it (see 3.12); move the lme4 cost paragraph to the coda. Severity: major. Raised by: both, independently.

**4.0.2 No motivation on page one.** "This is a statistics book with one engine in it." The first sentence a learner reads is about software architecture, and nothing in the first two pages gives a reader a reason to want to fit a model. Change: open with the sparrows and a question (why do some chicks die?), then the cast; put "Why one engine" after "How to read it" or in a box. Severity: major. Raised by: A.

**4.0.3 A parenthetical glossary before Class 1.** The preface defines random intercept, standard error, estimator, offset, dispersion, structured random effect, heritability, frequentist, confidence interval, REML, coverage and parametric bootstrap in parentheses. A novice retains none of it and is intimidated by all of it. Change: cut the parenthetical glossary; say "you will meet each of these words at the moment you need it". Severity: minor. Raised by: A.

**4.0.4 The first code in the book prints an engine version and a git snapshot.** "asks the engine which version is loaded, reads the exact engine snapshot every chapter in this book uses from a file kept with the book, and prints today's date". Before any sparrow; it sets the tone that the engine is the thing being documented. Change: keep the one-paragraph "never invent output" rule; move the build stamp to a colophon or the page footer. Severity: minor. Raised by: both, independently.

### 4.1 Class 1

**4.1.1 The summary documents three engine calls the chapter did not use.** "Three calls you will meet, and cannot use today. Nothing fitted a model today, so nothing today can call `aic(fit)` ..." with keyword conventions. This is an API reference, not a summary of what was learned. Change: delete the bullet; teach the `rng` keyword for `residuals` and `simulate` when those functions first appear. Severity: major. Raised by: both, independently.

**4.1.2 The `bf` box and its third slot are explained before the reader has fitted anything.** "Class 4 is the week you put something in that second slot, and the box has been quietly holding it open since your first hour. The nothing at the end is a third slot, for a second response column". Class 2 already defends `bf` properly when Momo objects. The reviewers differ on how much to cut: A would cut the `bf` section from Class 1 and keep only the `@formula` "unknown" beat; B would keep the box but mention only `mu` and `sigma`, and explain the third slot in Class 4 when `cbind` arrives. Lean to B: Class 2's "the box has been holding it open" line depends on the reader having seen the σ slot once. Severity: major. Raised by: both, independently.

**4.1.3 The first broadcast dot, the first Symbol and the first macro appear without a word.** `wing_f = by_sex.mean_wing[by_sex.Sex .== "F"][1]` (the dotted `.==`, indexing by a vector of trues and falses, the trailing `[1]`), `:Wing => mean => :mean_wing` (the colon), `@printf("rows: %d ...")` (the `@`, the format string, `\n`), all in the first cells, none explained here or anywhere in the book; broadcasting is used on every page after this. Change: add a "five Julia habits" passage: the dot means "do it to every element"; the colon makes a name into a Symbol, Julia's way of writing a name as a value, which DataFrames uses to refer to a column without reading it; the @ marks a macro; the trailing semicolon hides output; keyword arguments come after `;`. One sentence on what indexing with a true/false vector returns, or compute `wing_f` from the `combine` output by row, which the reader has just been taught. Consider `println` in Class 1 and `@printf` when a decimal place actually needs controlling. Then use each construct in an exercise. Severity: major. Raised by: both, independently.

**4.1.4 `subset(sparrows, :Sex => ByRow(==("F")))` is presented as the verb that "reads closer to dplyr".** `==("F")` as a function is a Julia idiom that needs a sentence and does not read like anything an R user knows. Change: drop `subset` from Class 1 (`filter` is enough) or explain that `==("F")` is a function asking "is this equal to F" and `ByRow` applies it to each row. Severity: minor. Raised by: B.

**4.1.5 The first user-defined function is introduced only in a code comment.** `flip(n; rng) = rand(rng, Bool, n)`: the first function definition and the first keyword without a default. Change: one paragraph in prose: this line defines a function; the part after the semicolon is a keyword you must supply. Severity: minor. Raised by: A.

**4.1.6 Four errors plus a meta-rule overload the first morning.** The `+ "0.5"` `MethodError` with ChainRulesCore candidates teaches a rule ("when the function is enormous and general, read the first line") a novice cannot apply. Change: keep the column typo, the package typo and the `filter` argument order; move the `+ "0.5"` error to an exercise. Severity: minor. Raised by: A.

**4.1.7 Momo's background changes with what the chapter needs.** SPSS here (four times), an R user with an `lm` printout in Class 2, SPSS again in Classes 3 and 5. Change: one background, kept (see 3.12). Severity: minor. Raised by: A.

**4.1.8 No model of a good "explain each line" answer.** The instruction "paste your code and then explain in your own words what each line does" is excellent and there is no example of a good answer in this or any chapter. Change: one worked exercise with Toto's answer and Itchy's marking, here, as the template for the whole book. Severity: minor. Raised by: A.

**4.1.9 The water-flea exercise has no file.** "Toto's water fleas. Draw a data cloud with `fig_data_cloud` for two of Toto's measurements." No Daphnia file exists anywhere in the repository. Change: ship a Daphnia file (or a labelled simulated one) with carapace length, body length and a clone column, and point every Toto exercise at it (see 3.9). Severity: major. Raised by: B.

### 4.2 Class 2

**4.2.1 The σ ~ Sex peek, minimum detectable ratio and power arrive in the second class.** "the smallest ratio this sample would have caught four times out of five, that is what "80% power" means, is `sex_sigma_mdr`-fold". About 100 lines after a chapter that has already taught twenty ideas, with `exp((1.96 + 0.84) * se)` hidden in an echo-false cell; the student had never met power and did not know where 0.84 came from. Class 4 repeats the identical fit. Change: end Class 2 after the disagreement box and R². Move σ ~ Sex, the ratio figure and any mention of power to Class 4, and if power is kept there, show and name 1.96 and 0.84. The interval straddling one already makes the "not detected" point without a power calculation. Severity: major. Raised by: both, independently.

**4.2.2 A diagnostic figure the reader is told she cannot yet read.** `fig-diagnostic` caption: "Class 3 explains what these residuals are and Class 5 explains how to read this picture; for now, a flat scatter is what you want." A figure with no way to read it teaches nothing and costs attention. Change: cut the figure from Class 2; introduce the worm plot once, in Class 3, with the explanation. Severity: major. Raised by: both, independently.

**4.2.3 Documentation status of a package function on a teaching page.** "The package's own documentation marks `r2_constant_sigma` as experimental, and is precise about which half is which". Change: delete the sentence; the refusal message already teaches the point. Severity: minor. Raised by: both, independently.

**4.2.4 Export semantics in the first simulation.** "`simulate(fit; nsim = n)` (exported, meaning DRM makes it public, so you can call it directly after `using DRM`, `nsim` matching R's own keyword)". Change: delete the parenthesis. Severity: minor. Raised by: both, independently.

**4.2.5 `bic` is listed and never used; the spelling note is an R-migration footnote.** "`loglik(fit)`, `aic(fit)`, `bic(fit)`, `nobs(fit)`, `dof_residual(fit)` ... Note the Julia spellings; there is no `logLik` or `AIC`." Change: list only what the chapter used. Severity: minor. Raised by: A.

**4.2.6 The simulation thread is dense Julia with the explanation aimed only at the statistics.** `wing_sim = [rand(rng_sim, Normal(m, sigma_hat)) for m in mu_hat]` (first comprehension, first `Normal()` from Distributions), `mean(std.(eachcol(sims .- fitted(fit1))))` (matrix-minus-vector broadcast, `eachcol`, two levels of dots). This is the first simulation the reader is expected to adapt and she could not have written it. Change: show the loop version first (`for k in 1:200 ... end`, `push!`), explain it, then show the one-liner as the compact form; practise the comprehension in an exercise. Severity: major. Raised by: both, independently.

**4.2.7 Exercise 8 needs a loop before any loop has been taught.** "refit fit3's σ~Sex model to each, and record the AIC difference each time." It needs a loop over columns of a matrix, a DataFrame rebuilt per iteration, two fits per iteration and a vector accumulated; the σ ~ Sex model belongs in Class 4 anyway. Change: move to Class 4 or 5 with a loop skeleton supplied, or supply the skeleton and ask the reader to fill in two lines. Severity: minor. Raised by: both, independently.

**4.2.8 Two residual-degrees-of-freedom conventions in one chapter.** The chapter has the reader compute `dof_residual` by hand as birds minus intercept, slope and σ, then the disagreement box uses n − p with p excluding σ and says "not the 167 in fit2's own header above, which also charges for σ". One of the two is the engine's own quirk. Change: pick one convention for the chapter's arithmetic (n − p with p the mean coefficients, which is what R uses and what the box needs) and mention the header's convention in one footnote, or not at all. Severity: major. Raised by: B.

**4.2.9 The collapsible drmTMB twin-output boxes are unglossed.** "Same fit in drmTMB, the same engine in R" prints raw output with `dpar`, `distributional-scale`, `convergence: 0` and no line saying which row to compare with which; the preface said R boxes would be rare and earned. Change: drop the twin-output boxes (the disagreement box does the real work) or add one line saying which row to compare. Severity: minor. Raised by: B.

### 4.3 Class 3

**4.3.1 The fit object's internal `blocks` field is printed as evidence.** `println("\nblocks the fit carries: ", first.(logit_fit.blocks))`, and the summary: "`fit.blocks` carries only `mu` for these families ... Do not go looking for `sigma(fit)` here." The statistics is the decree; the engine's data structure is not evidence for it, and the absent σ table already made the point. Change: delete the line and the bullet. Severity: major. Raised by: both, independently.

**4.3.2 The Monte Carlo standard error becomes the yardstick in Class 3.** "A spread computed from a random draw has its own wobble, and that wobble has a name, the Monte Carlo standard error, so judge the spread against it rather than against your eye", with 1/√(2n) used twice and carried into Classes 4 and 5 as assumed. Change: in Class 3 say "the count residuals are much wider than one; the survival residuals are not". Introduce MCSE once, in Appendix A (see 3.6). Severity: major. Raised by: A.

**4.3.3 The first multi-line function, loop, column slice and NamedTuple appear unexplained.** `function refit_slope(y) ... end`, `for (m, p) in zip(...)`, `ysim[:, k]`, `size(ysim, 2)`, `grid = (; Mass2 = [2.0, 3.5, 5.0])`, three of them in the summary, and the only note is the manual line "newdata is a NamedTuple or column table, not a DataFrame". Change: make the simulate-refit cell a taught beat inside the class; introduce `function`, the loop, `zip` and the column slice with one sentence each; say what a NamedTuple is when the grid is built and why `predict` takes one (better still, let `predict` also take a DataFrame so the reader's instinct is not wrong); have Exercise 8 practise writing the function. Severity: major. Raised by: both, independently.

**4.3.4 The chapter opens with its own caveat and makes the brood point four times.** "**What this chapter pretends.** These chicks come out of nests, and chicks from one nest are not independent draws" in the header, then in Itchy's speech ("Today we pretend, and on this file we would have to"), the summary and Exercise 9, each with the same `BroodSize`-but-no-identifier detail. Change: open with Toto's spreadsheet of dead chicks; say the pretence once, in Itchy's mouth, and let Exercise 9 ask about it. Severity: minor. Raised by: both, independently.

**4.3.5 The variance-decree passage reads as the book correcting an earlier draft.** "So it is the low end, not both, that got nowhere near a wall; nothing in this file was promised literally zero noise, but the heaviest-surviving chicks come close." and a 120-word caption. The student could not tell what the shaded strip was for other than that a previous version had got it wrong. Change: rewrite from scratch with one claim: the variance is decreed, it peaks at p = 1/2, and here is where this fit's probabilities sit on that curve. Cut the caption to two sentences. Severity: major. Raised by: B.

**4.3.6 Randomised quantile residuals get one long sentence and then carry every later chapter.** "you draw uniformly inside it, that is the randomised part, and push the result through the inverse normal". "Push through the inverse normal" meant nothing to the student; the picture is called a worm plot in the caption and the term is explained two chapters later. Change: a short worked beat: take one chick, its fitted p, show the interval of probability it occupies, draw a point inside it, look it up on the normal curve; one figure; name the worm plot when the figure is first drawn. Severity: major. Raised by: B.

**4.3.7 A review note in a code cell the reader sees.** "(this legend used to sit inside the axis at top-left, over four real markers ... moved out after that was caught in review)". Change: delete (see 3.15). Severity: minor. Raised by: B.

### 4.4 Class 4

**4.4.1 The 30-line `worm_outside` function, the 200-seed sag sweep and the order-statistics argument are graduate diagnostics in a chapter whose one idea is exposure before family.** `worm_outside` (erfinv, run-length counting, a ternary, a NamedTuple return) shown in full; "Now the sag itself ... a count of signs is a randomisation draw exactly as an SD is"; "Deviations in a worm plot are order statistics ... and therefore heavily autocorrelated". The student skipped from "Now the sag itself" to "So this model is right?" and lost nothing she could name. Class 5 does all of it again. Change: cut `worm_outside`, `worm-seed-sweep` and the sag discussion; show the beta-binomial worm plot and say "flat enough; a scattered handful outside a pointwise envelope is what an envelope is for; a long one-sided run is a diagnosis; Class 5 says how to count". Put the worm arithmetic in `tools/figures.jl`. Severity: major. Raised by: both, independently.

**4.4.2 A bootstrap Monte Carlo SE of a median compared against an asymptotic formula.** "The textbook 1.2533 * SD / sqrt(n) is a LARGE-SAMPLE formula and runs wide for a statistic this skewed, so resample the refits themselves"; "which is a nice inversion of the usual complaint". This is a methods-paper footnote written for someone with the usual complaint already in her head. Change: keep the histogram of θ and the sentence "the refits are asymmetric, so quote θ to one decimal". Delete the bootstrap, the 1.2533 comparison and the inversion sentence. Severity: major. Raised by: both, independently.

**4.4.3 Two paragraphs explaining that the engine's σ = 1 header is wrong for NegBinomial2.** "The engine prints that warning without checking which family you asked for, so here it prints something untrue. That is a fault in the software rather than something for you to learn." Then why is it on the page? Change: fix the header in the engine (a family-aware header), or hide the header line in this chapter's output; cut the passage to one line. Severity: major. Raised by: both, independently.

**4.4.4 The offset limitation is stated three times with an apology.** "Our engine cannot write it yet, a known limitation, reported to the engine's authors, so I am teaching the free coefficient". The pedagogical route (fit the coefficient free, see that it covers one) is the better lesson and needs no apology; the reader still ends up unable to fit the model the chapter recommends in Julia. Change: one sentence: "we fit it free, which is what you should do first anyway"; the limitation goes to the engine appendix; if the engine gains offsets before publication, fit it in Julia. Severity: major. Raised by: both, independently.

**4.4.5 The Julia summary is a list of accessor caveats.** "`sigma(fit)`: ... On `BetaBinomial()` it returns the σ and the trial counts, so read θ or φ off `coef(fit, :sigma)` instead"; "Neither engine prints θ or φ for you"; "`dof_residual(fit)`: exported and needed ... which the engine does not compute for you"; "`import Distributions`: needed here because DRM exports its own `Poisson`". Change: keep the three calls used; caveats to the reference card. Severity: minor. Raised by: A.

**4.4.6 The author audits the book's cross-chapter consistency in the character's mouth.** "Class 2 reports this identical fit in exactly those terms, and it is worth turning back to check that it does, because a book that says "no" in one chapter and "not detected" in another has not decided what it believes." Attached to a fit that is a verbatim repeat of Class 2's ending. Change: keep the σ ~ Sex fit here only; delete the sentence. Severity: major. Raised by: both, independently.

**4.4.7 "The statisticians' phrase is that the score equations are unbiased estimating equations."** The plain sentence before it is the lesson; the phrase adds two undefined terms that cannot be looked up from what the book has given. Change: delete the phrase. Severity: minor. Raised by: both, independently.

**4.4.8 The mechanical Pearson inflation computation.** "Predict the inflation from that alone and you get `mech_inflation`; the ratio you actually saw is `disp_bin / disp_poe`. They agree, so the jump ... is not evidence of anything." A subtle point a novice will not follow. Change: one sentence: "do not compare Pearson statistics across different responses". Drop the computation. Severity: minor. Raised by: A.

**4.4.9 Thirteen exercises, several needing the chapter's heaviest code.** Ex 12 (simulate and report the MCSE of the median) and Ex 10 (sum a fitted pmf over a band). Change: seven exercises; keep 1, 4, 5, 6, 7, 9 and 11 ("the two faces" paragraph is the best exercise in the chapter). Severity: minor. Raised by: A.

**4.4.10 The chapter changes subject too many times.** Marginal-versus-conditional ratios, Pearson X², exposure, offsets, grouped binomial, beta-binomial with φ, band coverage, a detrended worm plot, a seed sweep, NB2 and θ, quasi-Poisson, a mean-variance plot, a location-scale Gaussian, minimum detectable ratios and a bootstrap MCSE. "Now the check I have been putting off, because it is the one this book has been sloppy about." is where the chapter changes subject for the fourth time. Change: split, or cut to the spine (exposure before family; the same second formula in three families; not detected is not no); move band coverage, the worm-sag sweep and the θ bootstrap to Appendix A or exercises. Severity: major. Raised by: B (A covers it in 3.3).

**4.4.11 Confidence limits are pulled out of a `coeftable` by integer column.** `egg_lo_ci, egg_hi_ci = ct_e.cols[5][r_egg], ct_e.cols[6][r_egg]` with `findfirst(==("mu: logEgg"), ct_e.rownms)` to find the row; the summary then documents "Columns 5 and 6 are the confidence limits". `confint` exists and was used in Class 2. Change: use `confint(fit)` and name the row; never index a table by integer column in a textbook. Severity: major. Raised by: B.

**4.4.12 `phi = exp(-2 * coef(bbin, :sigma)[1])`: why −2 is stated, not taught.** The prose says "the σ slot carries φ = 1/σ²" and moves on. Change: one line of algebra on the board: the engine stores log σ, φ = 1/σ², so φ = exp(−2 log σ); the same for θ. Severity: major. Raised by: B.

### 4.5 Class 5

**4.5.1 Four nulls on one page; the chapter should be split.** "Eddie: That is the fourth different null on this page." The chapter builds a naive envelope null, a refit envelope null, a plug-in Pearson null, a refit Pearson null and a ΔAIC null, plus two seed sweeps, a bootstrapped 95th percentile, n/(n − k) bookkeeping, ΔAIC = 2 − LR, AICc and a 2,000 × 2 bootstrap of a difference. The one idea, simulate from the fit and count, was taught by the impossible-birds cell. Change: split into two classes. 5a: three residuals, the worm plot, one simulated null (simulate, refit, count), one chosen statistic (zeros). 5b: AIC, LRT, one ΔAIC simulation, marginal versus conditional, `nobs`. Cut the envelope-null calibration to one comparison (naive versus refit), cut the plug-in/refit Pearson split entirely, and move seed sweeps and the bootstrapped difference to Appendix A. Severity: major. Raised by: both, independently.

**4.5.2 A catalogue of the engine's `lrtest` guards for concepts three chapters away, made a learning objective.** "The engine refuses to compare two restricted-likelihood fits ... or two fits that used different approximations for the random effects, or a penalised fit ... And it warns you if the extra parameter you are testing is a variance component", each with a dash-definition of REML, penalised fits and variance components; objective 5 makes this a goal. Change: show the argument-order refusal and the silent row-count hole, which are the lessons; delete the paragraph and objective 5's engine clause; each refusal is taught where its concept is (Class 8). Severity: major. Raised by: both, independently.

**4.5.3 The translate box is about API absences on both sides.** "`residuals(fit; type = ...)` in DRM.jl 0.7.1 accepts `:response` and `:quantile` and throws on anything else" and "`drmTMB`'s `anova()` refuses every likelihood-ratio comparison ... That is an absence in the R package". Neither absence teaches the residual. Change: delete the box. Keep one clause: write the Pearson residual yourself, (y − μ̂)/√V(μ̂), which forces you to name the variance function, and say it is written by hand on purpose. Severity: major. Raised by: both, independently.

**4.5.4 The summary documents a function the chapter did not use.** "`update(fit, newformula; data)`: refit with the same family and a new formula box. Not used above". Change: delete. Severity: minor. Raised by: both, independently.

**4.5.5 Thirty-five lines of worm-plot helper code the reader must parse to follow the counts.** `n_zeros_outside(r, y) = (w = worm_parts(r); count(y[sortperm(r)][abs.(w.dev) .> 2 .* w.se] .== 0))` and its neighbours: compound expressions, `sortperm`, `sign.`, ternary chains, NamedTuple returns, none taught, re-written in Classes 4, 7 and 9, and Exercise 3 asks the reader to "adapt this chapter's `n_outside`". Change: move `worm_parts` and its counters into `tools/figures.jl` with one documented `worm_counts(r)`; in the chapter, show a five-line loop if counting must be shown. Severity: major. Raised by: both, independently.

**4.5.6 A 2,000-resample bootstrap of the difference between marginal and conditional rate ratios.** "What you want is an error bar on the difference, and the way to get one when no formula is to hand is to resample the birds." Two refits per resample, plus a figure, to make a point ("two different questions") the previous paragraph already made. Change: cut the bootstrap and its figure; keep "an interval that excludes another estimate's point value is not a test" as one sentence. Severity: major. Raised by: A.

**4.5.7 The bootstrap resampling idiom is never explained.** `d = females[rand(rng_boot, 1:n_fem, n_fem), :]`. The statistical idea is stated; the code that does it is not. Change: one sentence: `rand(rng, 1:n, n)` draws n row numbers with replacement, and `df[rows, :]` picks those rows. (If 4.5.6 is cut, teach the idiom in Appendix A instead.) Severity: major. Raised by: B.

**4.5.8 AICc is printed and defined without being used.** "`aicc` is the small-sample correction, `aic + 2k(k+1)/(n − k − 1)`; prefer it when n/k is small." Change: delete AICc from the chapter. Severity: minor. Raised by: A.

**4.5.9 The plug-in-versus-refit Pearson null bookkeeping.** "so its expectation is not one but n/(n − k), which for this model is". Bookkeeping about a null the chapter then replaces; the verdict did not change. Change: cut; score the invented worlds by refitting, once, and move on. Severity: major. Raised by: B.

**4.5.10 A character refers to the chapter's exercise numbering mid-dialogue.** "No, but the recipe will, and Exercise 5 is going to ask you for exactly this." Change: delete the clause. Severity: minor. Raised by: A.

**4.5.11 Exercise 3 asks for a 2,000-replicate simulate-refit-count loop, twice, on the reader's own data.** The book has not taught her to write a loop. Change: provide the loop as a function in `tools/` and ask the reader to call and interpret it, or cut to 200 replicates with the skeleton given. Severity: minor. Raised by: B.

### 4.6 Class 6

**4.6.1 The residual accounting ladder.** "Shrinkage then pushes the number back up, not down, because a shrunk BLUP removes slightly less than the bird's real effect and leaves a little of it behind in the residual." Thirty lines of code and a page of prose (√(1 − 1/k) shortfall plus shrinkage adding back) on a second-order effect in a diagnostic, in the chapter that introduces random intercepts; Class 7 repeats it with √(1 − 2/k). The student skipped the cell and the paragraph. Change: cut the ladder. One sentence: "these residuals are a little narrower than σ for reasons Appendix A explains; standardise by their own spread and read the shape". Put the ladder in Appendix A if anywhere. Severity: major. Raised by: both, independently.

**4.6.2 The ML / REML / ANOVA decomposition is Class 8's lesson delivered early, with a third estimator added.** "So: the ordering ML < REML < ANOVA is not luck, and the divisor explains about a third of it." with J/(J − 1), Lessells and Boag's n0, and a split of the gap on the variance scale. Change: keep the Lessells and Boag box as "the classical route gives a slightly different number; Class 8 says why"; show ML and the ANOVA number only; move the decomposition and REML to Class 8. Severity: major. Raised by: both, independently.

**4.6.3 Two paragraphs on the engine's default interval method and its fields.** "`repeatability` hands you one of two intervals and does not say which. The default is the quick one"; `bias` and `corrected` fields; "the one documented to do what it says". The concept (delta versus profile) matters; the engine's default does not. Change: teach delta versus profile in one exchange; report the profile interval by name; set the engine's default to the one the book recommends; drop the field-by-field description here. Severity: major. Raised by: both, independently.

**4.6.4 The Julia summary lists things the chapter did not use.** `vc(fit)`, `Cycled(i)` and `Makie.wong_colors()`, and `ranef`'s alternative documentation name. Change: list what was used. Severity: minor. Raised by: A.

**4.6.5 The simulation-thread cell exists to demonstrate the `simulate` trap and then explains a Hessian warning and a stack-trace line.** "If a line at the bottom of the warning names a file inside the engine, that line is for the engine's authors, not for you." The cell shows the model failing to reproduce the spread of the data, which is the opposite of what a reader expects a simulation cell to show, and the book re-teaches the same trap in Classes 7, 8, 9 and 10. Change: give `simulate` a keyword to draw the random effects (or document the behaviour once in Appendix A); make this cell show the model reproducing the spread of the data; suppress or fix the warning's file path. Severity: major. Raised by: both, independently.

**4.6.6 An outlier is found, refitted without, and deferred to Class 7, which finds it again and defers it to an exercise.** "This bird, and a second one like it, get the full treatment next week: Class 7 names them both and sends them to an exercise." Change: deal with it once, here, in three sentences. Severity: minor. Raised by: A.

**4.6.7 Dict, `enumerate`, a lookup comprehension and a boolean mask appear unexplained.** `idx = Dict(b => i for (i, b) in enumerate(bird_ids))`, `cond_resid = residuals(ri_fit) .- [blups[idx[b]] for b in sparrows.BirdID]`, `keep = trues(n); keep[worst] = false`. Change: introduce Dict with one sentence ("a lookup table from bird name to row number") before this cell, or use a join, which Class 7 uses anyway. Severity: major. Raised by: B.

**4.6.8 Revision history in a code comment.** "Counting z past a fixed +-2, as this cell used to, answers a different question than the one on the page." Change: delete (see 3.15). Severity: minor. Raised by: B.

**4.6.9 The board and the printout use different symbols.** "The engine calls the bird spread σ_b, for "between"; it is the σ_u on the board, and I will keep calling it σ_u." Every later chapter inherits the mismatch. Change: use σ_b on the board, or rename the engine's heading. Severity: minor. Raised by: B.

### 4.7 Class 7

**4.7.1 The chapter should be written in the order the author now knows is right.** "Toto: Should we have started here? Itchy: Probably". The chapter concedes that the within/between split should have come first and that every number in the preceding two hours was inflated by a misspecified fixed part, then narrates the retraction with an "an hour ago / now" table ("Every one of them moved."). Three self-corrections in one class: Class 6's rule retracted, the boundary explanation retracted, the whole blended model's numbers replaced. Change: restructure. (1) Check within-group variation. (2) Split mass into `wbar` and `wdev`: one fixed parameter, the biggest AIC gain, the cheapest lesson. (3) Random slope on `wdev`. (4) Shrinkage for slopes. (5) The boundary test. Delete the "moved" table and the blended-model detour. If one visible self-correction is kept per chapter (3.5), make it the Class 6 rule correction, not the whole-chapter one. Severity: major. Raised by: both, independently.

**4.7.2 A numerical-analysis investigation of the engine's optimiser.** "There is exactly one logarithm left in the calculation, and it is of a small quantity worked out once per bird from four numbers multiplied and subtracted, a two-by-two determinant." The origins cell prints three tables (four fits; six shifted covariance matrices with det, eigenvalues, condition number and `isposdef`; six engine attempts with try/catch), and the exact floating-point value from the error is on the page. Itchy says "Read them." The student did not, and the later figure ("One curve, not four fits") made the point on its own. Change: show the crash, say "this engine's optimiser fails on far-away origins; lme4 fits the same model; centre the covariate and the problem is gone", show the fit. Keep the ρ-versus-origin figure and the four-origin table of ρ; delete the eigenvalue and try/catch tables; move the determinant post-mortem to the engine appendix. Severity: major. Raised by: both, independently.

**4.7.3 Jaro is brought in to explain that the engine's boundary function is built for a different case.** "Because `lrt_boundary` with q equal to two implements a different mixture, and its documentation says which: a quarter, a half and a quarter, on zero, one and two degrees of freedom." The reader is told to compute the Stram and Lee mixture by hand and leaves distrusting the function and unsure which mixture is which. Change: give the engine a `q = :slope` (or equivalent) that implements the correct mixture, or detect a correlation among the added parameters; then teach only the idea: a variance tested at zero needs a mixture, and one corrected p-value. Severity: major. Raised by: both, independently.

**4.7.4 The `slope_study` simulation is a research note on the optimiser's crash behaviour.** 400 null plus 400 alternative refits, `DomainError` counting by exception type, rejection rates with and without failures, Monte Carlo SEs on each, and a conclusion about "this engine and this version". The harness uses a docstring, a Cholesky factor with a jitter, a three-dimensional random array, `with_logger` and try/catch with `e isa DomainError`; Exercise 7 asks the reader to run it on her design and she cannot read it. Change: delete the study from the chapter. If a parametric bootstrap of the boundary test is wanted, do it once in Class 8, where it already exists. If any of it is kept, provide `slope_study` in `tools/` with a documented signature and show only the call and the printed table; teach "draw correlated group effects" in Appendix A with a two-line example. Severity: major. Raised by: both, independently.

**4.7.5 Three engine facts to read one covariance block.** "`re_sd` came back empty, and that is a fact about this version of the engine rather than about your model." An empty Dict, a Cholesky factor printed as `L11, L22, L21`, and `vc` as the correct accessor, in three paragraphs and two summary bullets. Change: have the engine print σ0, σ1 and ρ (or make `re_sd` return the two SDs and the correlation for a correlated block); delete the passage. Severity: major. Raised by: both, independently.

**4.7.6 Class 6's standard-error rule is retracted here and found wrong again in Class 9.** "Class 6's rule is a special case advertised as a general one, which is the commonest way for a true sentence to be wrong." Each retraction costs the reader the confidence the rule was meant to give. Change: state the two-mechanism version in Class 6 ("two things happen when you add a grouping; which wins depends on how much noise the group term removes") so Classes 7 and 9 confirm rather than correct. Severity: major. Raised by: both, independently (A here; B under 3.5).

**4.7.7 The MAD detour on an outlier Class 6 already found.** The worm section standardises by `std(cond)`, finds 25 points outside, discovers two outliers inflated the standardiser, introduces the MAD, drops the rows, and gets 0 outside; the problem was created by the chapter's own choice of divisor and the MAD arrives as a rescue rather than a taught idea; two named rows are carried into Exercise 9. Change: name the two outlying rows from the raw file first (they are in the data), draw the worm plot once with them flagged, two sentences and a footnote naming the rows. Drop the MAD detour, or teach robust scale in Class 5 where diagnostics live. Severity: major. Raised by: both, independently.

**4.7.8 The binary random-slope limitation is stated in dialogue, in the summary with an issue number, and in the coda.** "`Binomial()` takes a random intercept and refuses a random slope. That is a known limitation of the current engine, reported to its authors"; "(DRM.jl #753)". Change: one line in the engine appendix. Severity: minor. Raised by: both, independently.

**4.7.9 The exercises are ordered wrong and two are research-grade.** Exercise 3 (the within/between split, the one that teaches) is buried third; Exercise 7 asks for 800 refits with the chapter's 30-line function; Exercise 8 asks the reader to read two papers. Change: make the split Exercise 1; cut 7 and 8. Severity: minor. Raised by: A.

**4.7.10 Twenty lines of design rationale inside the spaghetti-plot cell.** "the palette's "warn" and "muted" swatches are only about 4/255 apart in greyscale luminance" and the marker-cycling explanation. Change: move to `tools/figures.jl` as a helper with the rationale in its docstring. Severity: minor. Raised by: B.

**4.7.11 A further-reading item reviews the quality of two engine documentation pages.** "The package's separate "capabilities" page is less careful on this point; use the families page." Change: delete the item. Severity: minor. Raised by: B.

### 4.8 Class 8

**4.8.1 Generalised least squares in matrix form to print an identity between two divisors.** `qform` (design matrix, `Z = Float64[df.pond[i] == g[j] for ...]`, `H = I + tau^2 * (Z * Z')`, backslash solve, `r' * Hi * r`) and the printed identity "sigma^2 ratio = n/(n-p) * q(tau_R)/q(tau_ML)"; τ and q(τ) arrive in one code comment; the reader has never seen a design matrix in this book, and the side-by-side table and the n-versus-J experiment already make the point. Change: cut `qform` and the identity block. Keep the table, "one divisor per level", Jaro's sentence, and the n-versus-J experiment. If the closed form is wanted, put it in an appendix. Severity: major. Raised by: both, independently.

**4.8.2 A 20-line closed-form profile likelihood with `logdet` to draw the wall figure.** `push!(ll, -m / 2 * log(2pi * s2) - 0.5 * logdet(H) - m / 2)`. The figure is the best thing in the chapter; the code behind it is not something the reader should be asked to read. Change: compute the profile with an engine call or a helper in `tools/` and show only the figure. Severity: major. Raised by: A.

**4.8.3 A second-order asymptotic subtlety after the pile-up has been shown.** "at five ponds the statistics that are not zero are lighter in the tail than chi-squared with one degree of freedom as well. Crainiceanu and Ruppert (2004) is where that is worked out properly." A learner leaves with "the correction is not a rescue either", which undercuts the chapter's own lesson. Change: one sentence in Further reading; in the text, "the correction is a large improvement and the design is still five ponds". Severity: minor. Raised by: A.

**4.8.4 An absence catalogue for the R twin.** "`drmTMB` has neither of the two tools you learned this hour: it has no boundary-corrected test, and its `anova` refuses every comparison, not only the invalid ones." plus `reml_loglik` / `ml_loglik` / `chibar_pvalue` accessor notes and a further-reading item pointing at "the REML rows and the REML scope warning box" of the engine docs. Change: one line, or the engine appendix. Severity: minor. Raised by: both, independently.

**4.8.5 A hand-rolled CSV writer with a do-block in the setup cell.** `open(path, "w") do io; println(io, join(names(df), ","))`, when `CSV.write` was used in Classes 2 and 6 and the do-block is never explained. Change: use `CSV.write`. Severity: minor. Raised by: both, independently.

**4.8.6 Momo's tadpoles turn out to be invented.** "No real pond file exists yet, so the data are simulated from a stated seed inside the first cell". The chapter is honest about it, but after a preface that promises real data and a cast who each own an organism it registered with the student as the book running out of birds. Change: find a real grouped dataset for this class, or say up front in the preface that Momo's data are simulated throughout. Author to decide; the honesty is already there. Severity: minor. Raised by: B.

**4.8.7 `===`, `only` and a filter over named tuples to read two rows out of `confint`.** `pick(sym, nm) = only(filter(r -> r.param === sym && r.coef == nm, rows))`, because the `:resd` rows come back on the log scale. Another engine wrinkle solved with unexplained Julia. Change: have `confint` return SDs on the natural scale (or a keyword to do so), and delete `sd_intervals`. Severity: minor. Raised by: B.

### 4.9 Class 9

**4.9.1 The second-grouping section is a bug report with a design lesson buried under it.** "So the thing that breaks is not how many levels a grouping has. It is having a second grouping at all, on this family, in this version of this engine"; "This is a limitation of the binomial route in this version of the engine, not a fact about GLMMs". About 120 lines and five fits (Year alone, Year + brood, Mum alone, Mum + brood, a Gaussian control), built around a fit Itchy expected to fail that did not, framed as "my demonstration fell apart in front of you"; Bolker's floor is asserted and then not shown. Change: cut the section. Teach the design check (no brood spans two years; four levels; Mum is partially crossed) and Bolker's floor in a page; fit Year as a fixed effect; set the Mum design question as the exercise it already is; cut the two-grouping fits until the engine can do them. Severity: major. Raised by: both, independently.

**4.9.2 Because `ranef` returns an empty Dict, the chapter writes a Newton solver.** "This is a known limitation of the version of the engine this page was built with, not a fact about GLMMs: the per-group estimates are wired up for Gaussian models, and not yet for this one." Then `brood_effects`: a Newton iteration with gradient and Hessian accumulators, an underflow guard (`h > -1e-12 && break`), a penalised/unpenalised switch, verified against the Gaussian `ranef`. The shrinkage picture and the point that unanimous broods have no finite own estimate are the best statistics in the chapter and need no solver. Change: fix `ranef` for non-Gaussian fits and draw the picture in three lines. Keep the shrinkage figure and the "more than half the broods have no finite own estimate" beat; delete the solver or hide it in `tools/`. Severity: major. Raised by: both, independently.

**4.9.3 The AGHQ refusal is provoked, word-wrapped and used to discover the engine's quadrature rule.** "It says so in an error message, which is the only place it says so, and I had been calling ours adaptive quadrature ... right up until it corrected me in front of you." The message itself contains "(1-D Liu–Pierce, #448)" and "associate_pairs QuadGK"; a `split`/string-building loop wraps it; then a box explains Laplace versus non-adaptive versus adaptive Gauss-Hermite with Pinheiro and Bates calling the engine's rule the weak member. The learner takes away that her engine uses the weak rule and that even the teacher did not know. Change: one sentence in the box: "packages approximate this integral differently; name the approximation; ours is GHQ-32, glmer's default is Laplace". Delete the discovery cell and the wrapping loop. Make the engine state its rule in `summary`, and consider adaptive quadrature in the engine. Severity: major. Raised by: both, independently.

**4.9.4 The standard-error decomposition speech.** "Rescaling by the coefficient is still most of the story: on a log scale it accounts for `log_share`% of the full gap ... And the leftover favours us." A 380-word speech (measured) decomposing the SE gap into coefficient rescaling, a coefficient of variation and a design-effect heuristic, paying a "debt" with arithmetic no learner can check. The student read it three times and could not say what the two shortfalls measured. Change: two sentences ("the standard error went up; part of that is the coefficient changing size because the odds ratio is conditional; part is clustering, and the naive SE is short by X% against its own target, measured by simulation") and cut the `se-decomposition` cell. Severity: major. Raised by: both, independently.

**4.9.5 Four layers of diagnosing a diagnostic.** Quantile residuals against u = 0, then against the marginal probability, then a 500-draw null for each, then a 500-seed sweep, then a 500-replicate iid band null, each correcting the previous one ("I do not get to keep the reference I have just condemned and use one as its target"; "if you read that as "the model is wrong" you have made the same mistake twice on one page"). The real point (`fitted()` is not the average over groups on a nonlinear link) is made in the second layer. Change: one worm plot judged against the marginal reference, with the two-reference comparison and its figure, and one sentence on why `fitted()` is not the average over broods. Cut the residual-null, seed-sweep and band-null cells; Appendix A owns the methodology. Severity: major. Raised by: both, independently.

**4.9.6 A 100-refit coverage study with an interval on the coverage and a caterpillar of all 100 intervals, at the end of the GLMM chapter.** "with `R` replicates the interval on that coverage runs from ...% to ...%, so this run cannot tell 95 per cent apart from anything down to about ...%". This duplicates Appendix A. Change: cut; one sentence pointing to Appendix A. Severity: major. Raised by: A.

**4.9.7 Ten exercises, one needing R at three quadrature settings.** "Fit the same model in R with `glmer` at `nAGQ = 1`, `nAGQ = 9` and `nAGQ = 25`". Exercise 6 interpolates the chapter's own counts as the target. Change: seven exercises; keep 2, 3, 4, 5, 7 (the unanimous broods) and a shortened 6; move 10 to an "if you have R" block. Severity: minor. Raised by: A.

**4.9.8 A magic index into the standard-error vector.** `push!(log_se, stderror(f)[3])`: the third element is the SE for log σ_b and nothing on the page says so; a reader cannot reproduce it on a model with a different number of coefficients. Change: use a named accessor (`stderror(f, :resd)` or equivalent) or explain the ordering once. Severity: minor. Raised by: B.

**4.9.9 A review note about a pond, copied into a chapter with no ponds.** "# legend outside the axis so it can never hide a group (reviewer: pond P05 sat under it)" appears three times in Class 9 and once in the coda (checked). Change: delete all four. Severity: minor. Raised by: B.

### 4.10 Class 10

**4.10.1 The chapter's second half is organised around pricing an engine limitation, and reimplements the engine to do it.** "The engine cannot compute this and thirty lines of our own code can. Name the limitation, then measure what it costs you". Because REML is refused for `animal`, the chapter writes an eigen-rotated profile likelihood, golden-section search, bisection for interval crossings, then a dense two-component likelihood with `cholesky`, `diagind` and coordinate ascent: over a hundred lines, not thirty, and none of it statistics the reader was meant to learn. The three-worlds simulation that follows is the real lesson and does not need the REML detour to land. Change: implement REML for the animal model in the engine before version 1, or put the machinery in `tools/` with a two-line call. In the chapter, report the two h² values with "ML sits low by about X%, measured by simulation; REML raises it from x to y; here is why" in one paragraph, and lead with the three worlds. Severity: major. Raised by: both, independently.

**4.10.2 A paragraph, a printed UNCORRECTED/CORRECTED check and a summary bullet about which number the engine's interval is centred on.** "The engine centres its interval on the corrected estimate, not on the one you get by just dividing the two variances." An API quirk presented as a lesson, explained twice. Change: make the engine print estimate, corrected and the interval it is centred on, coherently, in one line; one sentence in the chapter. Severity: major. Raised by: both, independently.

**4.10.3 Three engine-interface details for one fit.** `relmat(1 | BroodNo)` with an identity `K` ("with two structured components in one model, the engine wants both spelled the same way"), `algorithm = :sparse` ("time both once on your own file rather than trusting either default"), and `g_tol = 1e-3` chosen "out loud". Change: let `(1 | BroodNo)` work beside `animal`; use defaults, and if a default is wrong fix the engine's default; delete the workaround and the tolerance paragraph. Severity: minor. Raised by: both, independently.

**4.10.4 A detour refitting Class 6's file twice to conclude that a different trait's R caps nothing here.** "Notice that the cell fetched two numbers, and that Class 6 printed both too. Momo, which one is Class 6's ceiling, and why does it matter which?" The chapter is already 17,000 words. Change: two sentences: "one weighing per chick, so no R; and Class 6's wing R is a different trait and caps nothing". Keep the √R remark. Severity: major. Raised by: A.

**4.10.5 The translate box calls an internal R function and then tells the reader not to.** "The check itself reaches past the public interface: `drmTMB:::drm_pedigree_additive_relationship` is an internal function". Change: verify with the public `pedigree =` route, or drop the box to two sentences. Severity: minor. Raised by: both, independently.

**4.10.6 Eigenvalues, positive definiteness and Mendelian sampling in the matrix-building section, before the model is fitted.** "Mendelian sampling. Two full sibs each get half their father's genes, but not the same half, and the contrast between them carries exactly half the additive variance." Elegant, and one idea too many at that point. Change: keep "check three entries by name"; move the eigenvalue check and its interpretation to a box. Severity: minor. Raised by: A.

**4.10.7 The Gamma admission and the residual section that leads to it.** "A right-skewed positive response is what a `Gamma` family is for; the engine ships one, and no class in this book teaches it, which is a gap in the book rather than in the engine." Honest, and fine to say once, but the residual section before it (marginal quantile residuals, the band disqualified, the ∪ shape) is another page in a chapter that cannot afford it, and the reader does not know what to do with the information. Change: keep the admission as one sentence (or teach Gamma in one paragraph in Class 3 or 4); cut the residual section to the worm plot and "right-skewed; Gamma is the repair; not today". Severity: minor. Raised by: both, independently.

**4.10.8 The residual REML/ML ratio aside.** "Notice which side of one that sits on, below, where n/(n−p) sits above. That is not a contradiction: the naive divisor is n over n − p times a small factor". The student could not follow why the ratio sits below one when Class 8 said above, and the explanation depends on the Class 8 identity she also could not follow (4.8.1). Change: cut the residual-ratio aside; report only the V_A ratio, which is the one that matters. Severity: major. Raised by: B.

**4.10.9 The pair-counting section after the point has landed.** "Count it properly, in pairs, not in families and broods, because the information lives in the pairs." A five-branch loop counting related pairs by brood-sharing, then an explanation of why that count does not explain the interval width. Change: cut to one sentence: "X% of related pairs never shared a nest, which is why the two components can be separated here." Severity: major. Raised by: B.

**4.10.10 The xor operator appears once, unexplained.** `half_sib(i, j) = j != i && ((sire[j] == sire[i]) ⊻ (dam[j] == dam[i]))`. Change: write it as "shares exactly one parent" with two comparisons, or add a comment. Severity: minor. Raised by: B.

### 4.A Appendix A

**4.A.1 The appendix breaks Class 1's seed rule three times and admits it only in the summary.** See 3.16. Change: `MersenneTwister(316)` in the generator cells, or Itchy says in dialogue why the house rule is broken here for one demonstration. Severity: major. Raised by: both, independently.

**4.A.2 Where the appendix sits.** This is the clearest, shortest, best-paced page in the book, and it is where MCSE, coverage, the fitted-subtraction trap and the bootstrap should be taught, but the chapters use all of them from Class 3 onward, so it arrives after the reader needed it. A: promote it to a class between 2 and 3 (or 5 and 6), strip its content from Classes 3 and 4, and have Classes 5, 8, 9 and 10 refer back. B: keep it as the appendix whose pacing is the template, move the methodology from the chapters into it, and make the chapters point at it. See 3.4 for the lean. Severity: major. Raised by: A (B's position differs and is recorded).

**4.A.3 The do-block appears in the appendix's first loop with the explanation only in the summary.** `refits = with_logger(NullLogger()) do ... end`. A reader arriving here from Class 2, as the preface invites, has not met it. Change: drop the logger wrapper (fix the engine's convergence chatter) or explain it inline. Severity: minor. Raised by: B.

### 4.13 Coda

**4.13.1 Engine limitations as part of the closing argument.** "Two things the Julia engine cannot yet do that its R twin can: fit a random slope ... when the outcome is yes/no ... and take an offset". Acceptable in a coda as the one place they are stated, but it is currently the fourth statement of each, and the coda should end on the models, not the software. Change: keep here or in the engine appendix, and delete the earlier repeats (3.11). Severity: minor. Raised by: both, independently.

**4.13.2 The σ ~ Sex model is fitted for the third time to draw one figure on a page that says it runs no code.** "One figure below refits a model Class 2 already ran, to show what rung eleven means". Change: reference Class 4's figure; the coda needs no cell. Severity: minor. Raised by: A.

**4.13.3 The minuted answer is that Toto learned to read error messages.** "Toto: I mostly learned to read the error messages. Itchy: (to the room) That is the correct answer and I want it minuted." For the novice reader this is uncomfortably accurate: the thing she can most confidently do after fourteen pages is read a Julia error. She wanted the correct answer to be that she can fit a model to her own data. Change: give Toto a second sentence, the model he can now fit and the sentence he can now write about it, and make that the minuted answer. Severity: major. Raised by: B.

---

## 5. What to cut

Cutting is the change a manual most needs and the one an author least wants to hear. Everything here is already covered above; this is the list on one page.

1. Class 7: the origins cell's eigenvalue and try/catch tables, the determinant post-mortem, the `slope_study` harness and its 800 refits, the "an hour ago / now" table, the MAD detour, Exercises 7 and 8.
2. Class 9: the Year/Mum infinite-SE investigation (five fits), the `brood_effects` Newton solver and its Gaussian check, the AGHQ discovery cell and wrapping loop, the `se-decomposition` cell and its 380-word speech, the residual-null, seed-sweep and band-null cells, the 100-refit coverage study and its caterpillar.
3. Class 10: the eigen-rotated profile likelihood, golden section, bisection and dense coordinate-ascent solver (keep the two numbers), the Class 6 repeatability detour, the residual REML/ML aside, the pair-counting loop, the UNCORRECTED/CORRECTED check.
4. Class 5: two of the four nulls (the naive envelope null beyond one comparison, the plug-in Pearson null), the second seed sweep, the 2,000-resample bootstrap of the difference and its figure, the `lrtest` guard catalogue, the translate box, AICc, `update` in the summary.
5. Class 4: `worm_outside`, the 200-seed sag sweep, the order-statistics paragraph, the bootstrap MCSE of the median and the 1.2533 comparison, the σ = 1 header paragraph, the mechanical-inflation computation, the "book that says no" sentence, six of the thirteen exercises.
6. Class 6: the residual accounting ladder, the ML/REML/ANOVA decomposition (to Class 8), the `repeatability` field-by-field description, the outlier deferral.
7. Class 8: `qform` and the identity, the closed-form profile code (keep the figure), the Crainiceanu sentence in the text, the drmTMB absence paragraph, the hand-rolled `write_csv`.
8. Class 2: the σ ~ Sex peek and everything after R², `fig-diagnostic`, the `r2_constant_sigma` documentation sentence, the "exported" parenthesis, `bic`.
9. Class 3: the `blocks` line and bullet, the MCSE yardstick, three of the four brood-identifier statements.
10. Class 1: the "three calls you cannot use today" bullet, the third slot of `bf`, the `+ "0.5"` error (to an exercise).
11. Everywhere: issue numbers, version strings, "reported to the engine's authors" (ten occurrences), the `simulate` trap after its first statement, the second and later worm-plot helper implementations, `<!-- eq: hand-typed -->` comments, review-history comments in code cells, "(reviewer: pond P05 sat under it)" four times, literal numbers in summary bullets, the per-page "the book itself is not written" boilerplate, and two thirds of the "Class N" cross-references.
12. The coda's third fit of the σ ~ Sex model.

---

## 6. Engine work both reviewers assumed

Both reviewers propose engine changes, and several chapter fixes are cheaper if the engine changes first. None of the book edits above waits on any of these; where the engine cannot be changed before version 1, the passage is cut and the limitation goes in the engine appendix. In rough order of how many pages each would shorten:

- `simulate` with a keyword to draw the random effects (Classes 6, 7, 8, 9, 10).
- `ranef` for non-Gaussian fits (Class 9).
- REML for `animal` and other structured effects (Class 10).
- A correct boundary mixture for a random slope, `q = :slope` or detection of a correlation among the added parameters (Class 7).
- `re_sd` or the printed block reporting σ0, σ1 and ρ for a correlated block instead of a Cholesky factor (Class 7).
- A family-aware σ = 1 header, or none, for `NegBinomial2` and `BetaBinomial` (Class 4).
- An `offset` term (Classes 4 and 5).
- `heritability` and `repeatability` printing estimate, corrected and the interval's centre coherently, and defaulting to the profile interval (Classes 6 and 10).
- `(1 | g)` working beside `animal` without the `relmat(1 | g)` with identity `K` workaround (Class 10).
- `confint` returning SDs on the natural scale (Class 8).
- The engine stating its quadrature rule in `summary`, and adaptive quadrature on the binomial path (Class 9).
- `predict` accepting a DataFrame (Class 3).
- A second grouping on the binomial route (Class 9).
- Warnings that do not print an engine file path (Classes 6 and 8).

---

## 7. Reviewer claims that did not survive checking

One claim is excluded from the counts.

Review A, Class 1: "The rendered page shows neither red nor `!Matched`; the reader is told to 'find the red' on a page where there is none." Measured, not seen: `docs/site/book/wk1-base-camp.html` contains `<span class="ansi-bright-red-fg">` around the mismatched arguments in the `err-type` and `err-order` blocks, and the site stylesheet under `docs/site/site_libs/quarto-html/` styles that class with a red (`#b22b31`). The red is rendered. The prose is right to say `!Matched` appears only where there is no colour. No change needed on that point; the item about the meta-rule (4.1.6) stands independently.

Everything else that was countable was recounted and holds: the ten "reported to" occurrences, the issue numbers, the four "pond P05" comments, the per-chapter "Class N" counts (A's figures for Classes 3, 4, 6, 7, 9 and 10 match exactly), the word counts, the absence of any Daphnia or dunnock file, the twelve statements of the `simulate` trap, the three "What this chapter pretends" headers, the seven `Random.seed!` calls in Appendix A, the literal numbers in Class 7's summary, and the 380-word and 301-word speeches in Class 9.

---

## 8. Counts

Book-level items: 16. Structural 3, major 9, minor 4. Found by both reviewers independently: 12 of 16. Found by A alone: 3. Found by B alone: 1.

Chapter-level items: 104. Major 58, minor 46. Found by both reviewers independently: 52 of 104. Found by A alone: 25. Found by B alone: 27.

All items: 120. Structural 3, major 67, minor 50. Found by both reviewers independently: 64 of 120. Found by A alone: 28. Found by B alone: 28.

One further claim (Review A, the Class 1 red marker) was checked against the rendered page and excluded.
