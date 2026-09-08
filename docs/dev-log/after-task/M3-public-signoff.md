# M3 — public sign-off

Closer's verdict on going public by recreating from clean history (`tools/recreate-public.sh`).
Checked at `main` = `a3d075d` against the live preview.

## Verdict

**NOT SIGNED.** Four blocking items — three text-only, one needing chapter 2 re-executed. Nothing
structural: hours, not days. The recreate procedure itself is sound.

**B1 — private paths in four tracked symlinks (privacy).** `.claude/skills/` holds four symlinks
whose *blob content is an absolute home path carrying the account name and the private vault
directory*. `git grep` cannot read symlink blobs — which is why every scrub sweep, this one
included, returned clean. Same class as P1/P2 in the M2 close: the gate could not see the string.
They also dangle for any cloner. **Delete all four** (`git rm .claude/skills/*`).

**B2 — a private path in the freeze cache.** `_freeze/book/_spike/execute-results/html.json`
embeds a local dev-checkout path twice, in a stored Julia stack trace. `tools/scrub-paths.sh`
searches `docs/` only, so `_freeze/` was out of scope. Unpublished (Quarto excludes `_spike`) but readable. Fix the class: scrub the file, then widen the scrubber past `docs/`.

**B3 — the README understates the book.** It claims "**two chapters of ten**… chapter 6 is a
notation stub". Four documents are written, executed and live; chapter 6 is reviewed too. It also
pins "DRM.jl 0.7.0" where `tools/engine-pin.txt`, both manifests and all four chapter mastheads say
**0.7.1 at 4d9248f88**. First thing a reader meets, and both claims are false.

**B4 — chapter 2 contradicts itself on the live page.** Masthead: "DRM.jl 0.7.1 at 4d9248f88".
Provenance footer, same page: "DRM.jl 0.7.0". Its banner still reads "This is one chapter of ten…
Everything else so far is a plan" while the landing lists four. For a book whose rule is never to
invent output, a wrong version stamp is the worst error available. Editing the `.qmd` invalidates
its freeze hash, so this one costs a re-execute plus render.

## Evidence

1. `curl` — root `301 → /stats-hours/`, `/site/` **200**; the four chapters 200 (19–156 KB).
2. Landing links **all four**: `wk2`, `wk6`, `wk8`, `appendix-a`.
3. `grep -ilE "NEEDS RUNNING|PLACEHOLDER|TODO|FIXME"` over five fetched pages — **no hits**.
4. Private-path grep over the fetched HTML — **no hits**. The live pages are clean.
5. Browser pane: the landing renders the thirteen-rung climb correctly; chapter 2 renders with
   masthead, engines line and caveats intact — and shows the B4 contradiction.
6. The campaign's private-path grep over `main` (home prefix, vault name, account name) → **one
   hit** (B2). `git ls-tree -r main | awk '$1==120000'` → **four hits** (B1), invisible to that grep.
7. `gh api repos/itchyshin/stats-hours/commits/<sha>` — **291f4ac, 2335fa4, b6c03d3 all retrievable
   today**; `git merge-base --is-ancestor <sha> main` → **false** for all three, and no local ref
   contains them. Recreation is warranted, and the history it would push is clean of them.
8. `notebooks/README.md` still says "hosted path is **not yet tested**" — true, keep it.
9. `docs/design/capability-status.md`: two stale rows — "public preview live | planned" (it is live)
   and the engine row citing `NEEDS RUNNING` markers cleared in `0f4bef6`.

## Author's steps

1. Fix B1–B4 on `main`; re-run `tools/check-freeze.sh`; confirm `git ls-tree -r main | awk '$1==120000'`
   is empty and the private-path grep is empty.
2. `gh repo view itchyshin/stats-hours --json visibility` → confirm private.
3. `gh repo rename stats-hours-prescrub -R itchyshin/stats-hours`.
4. From a checkout **on `main`** (the tree is currently on `book/preview-machinery`; check out
   `main` first or this pushes the wrong branch): `gh repo create itchyshin/stats-hours --public
   --source=. --remote=public --push`.
5. `gh api -X POST repos/itchyshin/stats-hours/pages -f 'source[branch]=main' -f 'source[path]=/docs'`.

## Post-flip verification

- All three old SHAs **404** on the new repo (step 6 of the script prints `ok`).
- Pages serves `/docs` on `main`; root `301`s to `/site/`; four chapters 200.
- Re-run the symlink and private-path greps against a fresh public clone, not the local tree.
- Binder and the Colab badges now resolve — the first real test of the hosted path.

## Not blocking, owed

`docs/state-of-play.md` "Next" items 1 and 3 are done (#754 merged; chapter 6 is not a stub).
`capability-status.md` — the two stale rows above. `notebooks/README.md` — the Appendix A row sits
*below* the table and renders as an orphan. `AGENTS.md:45` still says Quarto is not used.

---

## Re-check (7437c50)

**NOT SIGNED.** B2, B3, B4 and B5 are genuinely fixed and live. **B1 is not fixed**, and the tool
built to catch it introduced a leak of its own. Both are one-commit fixes.

**B1 — still open, and the new checker proves it.** The four `.claude/skills/` symlinks are *still
tracked* at `main`. `.gitignore:28` gained `.claude/skills/`, but gitignore does not untrack an
already-tracked path — the `git rm --cached` never landed. `git ls-tree -r main | awk '$1==120000'`
returns all four, and their blobs still read as an absolute home path with the account name and the
vault directory. `sh tools/scrub-check.sh` **exits 1 and names all four**. The checker is correct;
it was written and then not run against the merge. Fix: `git rm --cached -r .claude/skills` and
commit, then re-run the checker to a `SCRUB-OK`.

**B6 — new. The scrub tool publishes the secret it exists to find.** `tools/scrub-check.sh:4`
hard-codes the account name and the vault name in `PAT`, and line 6 excludes that same file from its
own grep (`':!tools/scrub-check.sh'`), so it can never report itself. Replicating its grep against
`main` without that exclusion returns exactly one hit: the checker. On a public repo a reader can
read the account name straight out of the anti-leak tool. Fix: derive the pattern at runtime
(`$(id -un)`, `$HOME`) or read it from an ignored file — no literal name in a tracked blob — and
drop the self-exclusion so the tool stays auditable.

Third, minor: the checker walks `git ls-files`, i.e. whatever branch is checked out, not `main`. Run
it from `main` (or point it at a ref) before the flip; the tree is currently on
`book/preview-machinery`.

### Verified fixed

1. **B2** — no `_spike` path is tracked at `main`; the freeze cache is clean.
2. **B3** — README now reads "Status — four executed chapters of ten", "**4** — chapters 2, 6, 8 and
   Appendix A", and "0.7.1 (pinned to commit `4d9248f88`)". "Hosted path is not yet tested" survives.
3. **B4** — all four chapters carry `engines: DRM.jl 0.7.1 at 4d9248f88` and the same status_note,
   "One of four executed chapters (2, 6, 8 and Appendix A) of ten planned". Chapter 2's provenance
   footer now says 0.7.1. Every remaining `0.7.0` string is drmTMB's version — correct.
4. **B5** — `recreate-public.sh` step 4 begins `git switch main &&`.
5. **Live site** — root and `/site/` 200, four chapters 200; no `NEEDS RUNNING`/`PLACEHOLDER`; no
   private path in any served page; `DRM.jl 0.7.1` on all four mastheads and in chapter 2's footer;
   the new status_note appears on all four pages. Pages has built the fix.
6. **Executed-since-last-edit** — md5 of each `.qmd` equals its committed freeze `hash` for all four
   chapters (render-free check (b) of `check-freeze.sh`). The re-execution is real, not asserted.

The author's steps and post-flip verification above stand unchanged, with one addition: **step 1 is
now `git rm --cached -r .claude/skills`, de-name `scrub-check.sh`, then `sh tools/scrub-check.sh`
from `main` until it prints `SCRUB-OK`.** That single green line is the gate for signing.

---

## Re-check (006a3d8)

**SIGNED — the repository may go public via recreate-from-clean.** B1 and B6 are fixed, every
earlier item still holds, and the live site is clean. No blocking items remain.

**B1 — closed.** `git ls-tree -r main | awk '$1==120000'` returns **nothing**; `.claude/` now tracks
only the eight agent files. `.gitignore:28` keeps the skills directory out. The re-staging was real
and is gone from the tree, not merely ignored.

**B6 — closed, and closed properly.** `tools/scrub-check.sh` reads its pattern from
`$SCRUB_PATTERN_FILE`, default `.scrub-pattern` (`.gitignore:29`), exits 2 with a message when
absent, names nothing itself, and no longer excludes itself from its own grep. Replicating its two
sweeps against the `main` ref returns **no text-blob hit and no symlink**. `sh tools/scrub-check.sh`
prints **SCRUB-OK**, exit 0.

### Everything re-verified at 006a3d8

1. **Repo sweep** — no private path in any tracked blob; no tracked symlink at all; no `_spike`
   path; `recreate-public.sh` step 4 begins `git switch main &&`.
2. **README** — "four executed chapters of ten", "**4** — chapters 2, 6, 8 and Appendix A",
   "0.7.1 (pinned to commit `4d9248f88`)"; `notebooks/README.md:5` still says the hosted path is
   **not yet tested**, which is still true.
3. **Live site** — root 200 (meta-refresh to `site/` intact), `/site/` 200, four chapters 200. The
   landing links all four. No `NEEDS RUNNING`/`PLACEHOLDER`, no private path in any served page.
   `DRM.jl 0.7.1` on all four mastheads and in chapter 2's provenance footer; every remaining
   `0.7.0` is drmTMB's own version. All four pages carry the "One of four executed chapters"
   status_note. Pages has built 006a3d8.
4. **Executed-since-last-edit** — md5 of each chapter `.qmd` equals its committed freeze `hash`,
   all four **FRESH**. The prose and the evidence are in step.

### Two notes for the flip, neither blocking

- `.scrub-pattern` is git-ignored by design, so the checker **exits 2 on a fresh clone and in CI** —
  it is an author-local gate, not a CI one. Recreate the file before running the post-flip sweep on
  the public clone, or the check will look like it passed when it never ran.
- The checker walks `git ls-files`, i.e. the checked-out branch, not a ref. Run it from `main`.
  Step 4's `git switch main` now guarantees the push is from `main` regardless.

The **Author's steps** and **Post-flip verification** sections above stand. Step 1 is now satisfied:
go straight to `gh repo view` and the rename. The residual list under **Not blocking, owed** is
unchanged and can be worked in the open.
