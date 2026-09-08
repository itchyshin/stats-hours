# Stats Hours findings — project-lane handoff

## How this file came to be here

This note was written by the parity Stage 1 lane, not by the book lane, and it is filed here on
2026-09-08 as a record. It was pasted into a book-lane session that had no copy of it on disk, and a
note that lives only in a chat window is a note that will be lost.

Read it as evidence about the engines, gathered by reading the published book. It is **not** a claim the
book makes, **not** a task list for the book, and **not** a change to any chapter. Nothing in it has been
acted on here. The work it queues belongs to the `DRM.jl` and `drmTMB` repositories, and both were busy
with uncommitted work when this was filed.

One thing worth stating plainly, because it is the reason the note is safe to keep: Class 9 declares its
engines as DRM.jl 0.7.1 at `4d9248f88`, and `tools/engine-pin.txt` holds that same hash. Every failure
the chapter reports is therefore scoped to a named version. When one of these is repaired upstream, the
chapter does not become false; it becomes a record of what that version did. Do not edit a chapter to
remove a reported failure merely because a later engine no longer has it. Change the pin, re-run, and let
the build say what the new version does.

The original follows verbatim.

---

**Status:** living Stage 1 evidence note; not a release claim and not an edit
to the public book.  The observations below were read from the rendered book
on 2026-09-08.  Each source claim is tied to the version printed on that page,
not silently promoted to the current candidate.

**Source read:** Stats Hours with Itchy — Class 9, "Both at once"
(`site/book/wk9-glmms.html` on the published site), rendered page built
2026-09-07.  It identifies its Julia evidence as DRM.jl 0.7.1 at `4d9248f88`,
so its reported failures are leads for the current `91ef09e0` Stage 1
candidate until re-executed.

## Findings for project lanes

| ID | Finding in the book | Affected project | Current status | Required next action |
|---|---|---|---|---|
| SH-01 | An ordinary crossed Binomial workflow reached DRM.jl from R only after the bridge supplied a `resd` label for every grouping factor. The bridge had been omitting those synthetic labels (`resd_g`, `resd_h`) even though the native Julia formula supports `(1 \| g) + (1 \| h)`. | `drmTMB` + `DRM.jl` twin bridge | **Repaired and retained in the Stage 1 receipt.** The pure-R regression test asserts `resd = c("g", "h")`; one installed-package receipt verifies direct Julia, native TMB, and R-to-Julia output names, fitted dimensions, fixed-effect covariance, and usable uncertainty. | Keep the receipt narrow: it covers one healthy Binomial fixture, not all crossed bridge workflows. |
| SH-02 | Class 9 shows that a Binomial model with a second ordinary grouping can return infinite standard errors and a log likelihood lower than its nested one. Its Gaussian control supports treating this as an open engine-route question, rather than proof that the data design is impossible. | `DRM.jl` | **Open, separate Stage 2 candidate.** Stage 1 repairs SE forwarding only; it does not change the crossed Binomial likelihood or optimizer. | Reproduce against the named current candidate with the archived data and matched approximation. Partition: convergence, likelihood monotonicity, covariance/SE, and output extraction. Preserve the failing fixture if it reproduces. |
| SH-03 | `ranef(fit)` for the page's non-Gaussian Binomial fit returns an empty `Dict`, then indexing fails. The book identifies this as a missing output route rather than a statistical fact. | `DRM.jl`, then R bridge output mapping where practical | **Open, Stage 2 everyday-output gap.** | Add a public non-Gaussian random-effect extraction contract, with a healthy Binomial fixture and an explicit unavailable/error state for unsupported structures. Then assess R exposure under the one-way bridge rule. |
| SH-04 | The page distinguishes Laplace, fixed-node non-adaptive GHQ, and adaptive GHQ. It demonstrates that similarly named GLMM calls need not target the same approximate likelihood; a larger model's log likelihood cannot be compared across changed approximations. | `DRM.jl`, `drmTMB`, documentation | **Teaching correction completed for the Stage 1 Class 9 replacement.** This is not an algorithm change. | Keep approximation identity beside every cross-engine numerical comparison and prohibit a nested-model conclusion when the approximation changes. The Stage 1 bridge receipt must state its exact target and only compare like with like. |
| SH-05 | `fitted()` and randomized quantile residuals on a nonlinear mixed model are conditional (`u = 0`), not automatically population-averaged. The page demonstrates why an independence envelope or the wrong reference distribution can manufacture a diagnostic failure. | `DRM.jl` outputs/diagnostics and `drmTMB` documentation | **Open, Stage 2 semantic audit.** | Specify conditional versus marginal prediction/residual targets in the output contract, implement or refuse each deliberately, and add a generated-data diagnostic test before making a scientific claim. |

## What this note does *not* say

- The public book is a source of workflow requirements and observed failures;
  it is not a bridge test or proof that a current candidate still fails.
- SH-01 does not make Julia an R dependency: it preserves the approved
  one-way option, R → Julia.
- SH-02--SH-05 are not authorised implementation work in this Stage 1 arc.
  They are the bounded handoff queue for the relevant project lane.
- No issue, message, public page, or source book file has been changed.

## Claude-lane starter

```text
Read docs/dev-log/parity-stage1/stats-hours-findings.md first. Work only on
the selected SH item. Reproduce the rendered-book observation on an exact
current candidate before diagnosing it; compare matched mathematical targets,
retain failures, and do not widen the R→Julia bridge policy.
```

---

## Book-lane notes on the above, added when filing

Two cautions for whoever picks this up, both about scope rather than substance.

The starter above names a path. Until this file existed, that path resolved to nothing: it was searched
for in this repository, in both engine checkouts and across the surrounding workspace, and no
`parity-stage1` directory or file containing `SH-01` was found anywhere. So the starter was addressed to
a session in a repository where the Stage 1 work lives, and the copy filed here is a book-lane record of
what that lane reported. If the engine lane keeps its own copy, that one is authoritative and this is a
duplicate to be reconciled, not a second source of truth.

The starter also says to work only on the *selected* item, and no item is selected. The five are not
interchangeable: one is already repaired, one is a likelihood and optimiser investigation, one is a
missing output route, one is documentation, and one is a semantics audit. Whoever takes this needs the
item named before starting.

**SH-04 carries a collision risk worth flagging.** It refers to a "Stage 1 Class 9 replacement". Class 9
is a published chapter of this book. If another lane is rewriting it, that overlaps with the book lane,
and who owns the chapter is the author's call rather than something either lane should settle alone.
