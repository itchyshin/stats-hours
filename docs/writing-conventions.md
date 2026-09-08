# Writing conventions

## Chapter template — the 2012 skeleton, in this order

1. **Objectives** — a short numbered list.
2. **The class** — a scene-setting stage direction, then the lesson as *dialogue*.
3. **Code as a REPL transcript** — `julia>` prompt, output printed, then explained line by line.
   **Errors stay in.**
4. **Summary, split two ways** — "Stats stuff" (concepts) and "Julia stuff" (functions, packages).
5. **Further reading** — three to six, annotated, graded by depth; up to eight in the hard weeks, where
   a reader needs the counterweight paper as well as the source (chapters 6 and 8 do).
6. **Exercises** — applied, dataset-driven, "explain your code in your own words".

## The cast

| | | |
|---|---|---|
| **Itchy** | the lecturer | house sparrows |
| **Toto** | the novice, who types the mistakes everyone makes | water fleas |
| **Momo** | the sceptic, arriving from SPSS, who asks what the syntax is buying | tadpoles |
| **Eddie** | the advanced peer | dunnocks |
| **Jaro** | a statistician friend, who arrives for the hard weeks | — |

Each character owns a running dataset, so a reader can follow one organism through the whole climb.

## Never invent output

Every printed table, every figure and every number in a chapter is produced when the site is
built: chapters are Quarto documents whose Julia cells execute at render, spoken numbers are inline
`{julia}` expressions, and every random draw is made from an explicit `MersenneTwister` passed as
`rng`. The one exception is the R box, pre-rendered once from a real `Rscript` run and labelled
with its date and versions. Nothing is pasted from memory, and nothing is marked `[NEEDS RUNNING]`
any more: a chapter that has not run does not build.

A chapter with plausible-looking invented output is a **failed deliverable, not a draft** — worse
than an obviously unfinished one, because nobody catches it. Where the real data are unavailable,
the chapter says so and simulates from a stated seed. Chapter 2 does exactly this, and says so twice.

**When a review corrects a beat, the correction has three homes.** The dialogue, the Summary
bullet, and the Exercise that sets the same question. Three chapters running (3, 4, 5) were
blocked a second time because the prose was fixed and Exercise 3 still handed the reader the
retired claim. After any correction, grep the Summary and Exercises for the old wording and the
old number before re-rendering.

## What a reader must never meet

The reader is a biology student with one statistics course and no Julia. Nothing from the
machinery that builds the book belongs on the page: no engine source files or line numbers, no
issue numbers in dialogue (at most one, in a Julia-stuff bullet, as "a known limitation, reported"),
no gate, ledger, freeze, scrub, lane, writer, fixer or reviewer, no "this page's seed" or "a number
somebody typed once", no Quarto cell options. Every statistical term is defined in one line the first
time the book uses it, and abbreviations are expanded on first use. A beat that only makes sense if you
know the chapter was once wrong is rewritten as teaching, not as a retraction. Pat's reader pass
(`docs/dev-log/review/2026-09-07-pat-reader-pass.md`) is the checklist; it exists because the
statistical reviews pushed exactly this vocabulary into the dialogue.

## Comparison boxes — rare and earned

The book teaches one engine. Other packages appear only in boxes, and a box must earn its place:

- **A translation box** — "in R you would write…" — only where an R-trained reader would otherwise
  be actively misled. At most one or two per chapter; almost none in the early weeks.
- **A disagreement box** — where two implementations of the same model give different numbers, with
  a named mechanism and a computable boundary. These are the best pages in the book.
- **Never** a box that merely restates the same call in another language.

The evidence behind that restraint: dual-coding every chapter costs more teaching time than it
returns, while a genuine *disagreement* teaches something no single implementation can show.
