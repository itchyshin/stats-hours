# Handover — the preview campaign, milestone M2 closed (updated later the same day)

**Date:** 2026-09-06 · **From:** the Claude session that ran the campaign · **To:** whoever continues,
on any platform · **Branch:** `book/preview-machinery`, **merged into `main` (final `86017f0`)** (2026-09-06, after DRM.jl #754 merged and
chapter 2 was re-executed on it); the site is live at the repository's Pages URL (still a private repo). Public-safe: no private paths or systems are named here.

## Read first, in order

`AGENTS.md` → `docs/state-of-play.md` → `docs/dev-log/after-task/2026-09-06-preview-machinery.md`
(Rose's close) → `docs/dev-log/plan-actual/2026-09-06-stats-hours.md` (Melissa's reconcile) →
`.unlazy/stats-hours/status.log` (the dated event log; incidents and lessons are there).

## What exists now

- **Four executed chapters** (see below; the first two are described here, chapter 6 and Appendix A were added later the same day — `book/wk6-random-intercepts.qmd`, reviewed and approved with changes, all closed; `book/appendix-a-simulation.qmd`). Every chapter is proven to render identically twice with the freeze cache moved aside (every `simulate` call is seeded; ledger gate `leaf-s12:G8`).
- **Two executed chapters (original text).** `book/wk2-linear-models.qmd` (real 2012 Lundy sparrows, 171 birds; every
  spoken number is inline executed code; four figures; two pre-rendered drmTMB boxes) and
  `book/wk8-reml-vs-ml.qmd` (REML vs ML, the boundary, the guard; reviewed, revised, approved).
- **One build.** `quarto render` from the repo root renders `index.qmd` + `book/*.qmd` into `docs/site/`,
  byte-identically twice. `docs/index.html` is a hand-written redirect. Julia cells execute (Jupyter +
  IJulia, kernel `julia-1.10`); R appears only in boxes, pre-rendered from a real run and labelled.
- **Machinery.** Team of eight under `.claude/agents/`; house theme `tools/theme_itchy.{jl,R}` and
  figure helpers `tools/figures.jl`; Lua filter `tools/stats_hours.lua`; path scrub post-render;
  acceptance ledger `.unlazy/stats-hours/` (git-ignored run state).
- **Data.** `data/2012/` — the eight original R-book files with provenance.
- **Licences.** CC BY 4.0 (text, figures, data), GPL-3 (code); `LICENSING.md`.
- **CI:** `.github/workflows/site-freeze-check.yml` + `tools/check-freeze.sh` — PR and dispatch only, no engines, hash-gated so it can never execute.
- **Hosted path, prepared and untested:** `notebooks/*.ipynb` (one per chapter, bootstrap cell pins DRM.jl to `tools/engine-pin.txt` and installs the plotting stack), `.binder/` (same pin, precompiled at image build). Both need the repository to be public before a student can click them.
- **Coverage table** `docs/design/capability-status.md` is the board's surface (Julia executed · R box pre-rendered · hosted run verified, per chapter).

## CARRIED-OVER

| item | state | resume |
|---|---|---|
| Two `NEEDS RUNNING` passages in chapter 2 | **done** — #754 merged; pinned to 4d9248f88; re-executed | when merged: `julia --project=. -e 'using Pkg; Pkg.add(url="https://github.com/itchyshin/DRM.jl", rev="<sha>")'`, re-execute, rewrite the two NaN passages, update the `engines:` pin, re-run `leaf-s4b` and `leaf-s12` |
| Hosted reader path (Colab / Binder) | never run — waits on the author's sign-in | slice S6 in the plan; gates `G-env` |
| Merge to `main` | **done** (a3d075d) | Pages serves `docs/` on `main`; merging makes the redirect and `docs/site/` live |
| Public preview (M3) | **Rose SIGNED** (`docs/dev-log/after-task/M3-public-signoff.md`) | the author runs the six steps `sh tools/recreate-public.sh` prints, one at a time; verify the three old SHAs 404 on the new repo |
| Reader probe (Colab, then Binder) | waits on the author's sign-in and a public repo | open `notebooks/wk2-linear-models.ipynb` on Colab's Julia runtime, time the first cell, record in `docs/reader-environment.md`, flip the coverage rows |
| Dev-log voice residue (people, agent and model names) | **decided: keep** — the dev-log is the public working record | nothing to do |
| DRM.jl #753 (Binomial random slopes) | open | blocks chapter 7 only |
| Root `Manifest.toml` | git-ignored; DRM.jl developed from a sibling checkout | after the #754 pin, un-ignore it so the build is reproducible from a URL |

## Rules that were paid for today

1. **Never point Quarto's `output-dir` at a directory that holds hand-authored files.** It cleans the
   whole directory first; there is no config to stop it. `docs/` was wiped three times.
2. **"Is X exported?" is answered by `:X in names(M)`, never by grep.** A wrong issue was filed on a
   negative grep and had to be closed.
3. **A negative check needs a positive control and the right working directory.** The ledger's
   explicit-file mode runs checks from the ledger's own directory; always pass `--cwd .`.
4. **Verify a `sed` took effect before running the command it was meant to guard.** BSD sed has no `\s`.
5. **Look at what you built over HTTP, not `file://`** — the snapshot viewer drops linked CSS.
6. **Every lane shares one git index in this checkout.** `git add` from one agent plus a bare `git commit` from another sweeps files into the wrong commit; always `git commit -o <paths>`.
7. **Freeze-on byte-stability tests the cache, not the code.** A gate re-render changed a printed number (unseeded `simulate`); reproducibility is proven only with the freeze moved aside.
8. **A CI check that can execute will, eventually.** `--use-freezer` silently falls back to real execution on a stale hash; gate on the hash first and strip the engine from PATH.

## Resume prompt

```text
Read AGENTS.md, docs/state-of-play.md and docs/dev-log/handover/2026-09-06-preview-machinery-handover.md
on branch book/preview-machinery. Run the lane pre-flight, then continue only the CARRIED-OVER table,
in order. Do not re-plan.
```
