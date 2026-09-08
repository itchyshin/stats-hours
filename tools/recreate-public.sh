#!/bin/sh
# M3 — make the book public by RECREATING the GitHub repository from ONE squashed commit (never by
# flipping main's visibility: dozens of pre-scrub commits carry local filesystem paths and, once
# anything reaches a public remote, stay fetchable by SHA forever — a force-push cannot take them back).
#
# Default mode is a DRY RUN: every local, reversible check runs — the pattern-file guard, main ==
# origin/main, the orphan single-commit build in a THROWAWAY WORKTREE, and the full-history scrub gate
# — and the script prints exactly what the irreversible steps would do. Nothing on GitHub is touched
# without --publish. Cheap checks always run before anything irreversible; the rename/create/push/Pages
# sequence only starts once all of them have passed.
#
# Safe to run twice: instead of trusting a local marker file, it asks git/GitHub how far a previous run
# got (has origin already been repointed at the archive? does the public repo already exist?) and skips
# what is already done rather than repeating or compounding it.
set -eu

usage() {
  cat <<'EOF'
usage: tools/recreate-public.sh [--publish]

  (no flags)   DEFAULT. Dry run: local checks + orphan-commit build + history gate, then prints
               the irreversible recipe. Touches nothing on GitHub.
  --publish    Also performs the irreversible steps: rename the private repo to an archive,
               repoint origin at that archive, create the new public repo, push the squashed
               commit, enable Pages, and wait for the Pages build. Requires the closer's signed
               recommendation to already exist (see $signoff below).

Overridable via environment: PUBLIC_REPO, PUBLIC_ARCHIVE, RECREATE_PUBLIC_SIGNOFF,
SCRUB_PATTERN_FILE, RECREATE_PUBLIC_BRANCH.
EOF
}

die() { echo "recreate-public: $*" >&2; exit 1; }
say() { echo "--- $*"; }

mode=dry
for arg in "$@"; do
  case "$arg" in
    --publish) mode=publish ;;
    --dry-run) mode=dry ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $arg" ;;
  esac
done

command -v git >/dev/null 2>&1 || die "git not found"
command -v gh  >/dev/null 2>&1 || die "gh not found"

# --- locate the repository from THIS SCRIPT's own location; no path is hardcoded here ---
root=$(git -C "$(dirname "$0")" rev-parse --show-toplevel) || die "cannot locate the repository from $0"
cd "$root"

repo="${PUBLIC_REPO:-itchyshin/stats-hours}"
owner=${repo%%/*}
name=${repo#*/}
archive="${PUBLIC_ARCHIVE:-$owner/$name-prescrub}"
archive_newname=${archive#*/}
archive_url="git@github.com:$archive.git"
signoff="${RECREATE_PUBLIC_SIGNOFF:-$root/docs/dev-log/after-task/M3-public-signoff.md}"
pattern_file="${SCRUB_PATTERN_FILE:-$root/.scrub-pattern}"
release_branch="${RECREATE_PUBLIC_BRANCH:-release-squash}"
commit_msg="Stats Hours with Itchy - version 1 (history squashed for publication; the full history stays in the private archive)"

say "mode: $mode   repo: $repo   archive: $archive"

# Fail fast: publishing for real requires the closer's signed recommendation. Checked before doing any
# work at all, so a missing signoff never wastes a fetch + orphan build first.
if [ "$mode" = publish ]; then
  [ -s "$signoff" ] || die "refusing to publish — no signed recommendation at $signoff"
fi

# ============================================================================
# 1. cheap local guards. Every one of these must pass before anything else runs.
# ============================================================================

# An empty or missing pattern file would match every line or none — either way it lies.
[ -s "$pattern_file" ] || die "no pattern file at $pattern_file (it is git-ignored; create it locally first) — refusing to continue"

say "fetching origin and checking main is exactly what origin has"
git fetch --prune origin >/dev/null 2>&1 || die "git fetch failed — check network/auth before doing anything irreversible"
local_main=$(git rev-parse main) || die "no local branch 'main'"
remote_main=$(git rev-parse origin/main 2>/dev/null) || die "no origin/main — is origin still pointing where you think it does?"
[ "$local_main" = "$remote_main" ] || die "local main ($local_main) != origin/main ($remote_main) — push or pull before publishing"
say "OK: main == origin/main == $local_main"

# ============================================================================
# 2. how far did a PREVIOUS run get? Ask git/GitHub, not a marker file, so this can't go stale.
# ============================================================================

origin_url=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$origin_url" = "$archive_url" ]; then
  resuming=yes
  say "STATE: origin already points at the archive ($archive) — a previous run already renamed and repointed origin. Resuming from there."
else
  resuming=no
  vis=$(gh repo view "$repo" --json visibility --jq .visibility 2>/dev/null) || die "could not read $repo's visibility via gh — check 'gh auth status' before doing anything irreversible"
  [ "$vis" = "PRIVATE" ] || die "$repo is not PRIVATE (gh reports '$vis') — stop and look by hand; this script will not guess whether that is expected"
  say "STATE: $repo confirmed PRIVATE, origin -> $origin_url"
fi

# ============================================================================
# 3. build the single squashed commit in a THROWAWAY WORKTREE — never in this clone.
#    A dirty or mid-render working tree here is never at risk, because this never touches it.
# ============================================================================

wt=$(mktemp -d)/release
cleanup() {
  if [ -n "${wt:-}" ] && [ -d "$wt" ]; then
    git worktree remove --force "$wt" >/dev/null 2>&1 || true
  fi
  git branch -D "$release_branch" >/dev/null 2>&1 || true
  # Leave no remote in this clone that points at the PUBLIC repository. The push
  # above needs one for a moment; a permanent one is a loaded gun in the author's
  # daily working copy, because this clone's main still holds the unsquashed
  # history. Git's non-fast-forward rule would refuse an ordinary push, but not a
  # forced one, and not a future squash. So the remote does not outlive the run.
  git remote remove release >/dev/null 2>&1 || true
}
trap cleanup EXIT

say "building the orphan commit in a throwaway worktree: $wt"
git worktree add --detach "$wt" main >/dev/null
git -C "$wt" switch --orphan "$release_branch" >/dev/null
git -C "$wt" checkout main -- :/
git -C "$wt" commit -q -m "$commit_msg"

say "checking the squashed commit's tree is byte-identical to main's"
diff_out=$(git diff --stat main "$release_branch")
[ -z "$diff_out" ] || die "the squashed commit's tree differs from main's tree — aborting. diff --stat said:
$diff_out"
say "OK: tree identical to main"

# ============================================================================
# 4. the history gate — CHAINED. A failure here stops everything below and exits non-zero.
# ============================================================================

say "running the full-history scrub check against the squashed commit"
if ! SCRUB_PATTERN_FILE="$pattern_file" sh "$root/tools/scrub-history-check.sh" "$release_branch"; then
  die "HISTORY-NOT-CLEAN on the squashed commit itself — the pattern is in main's current tip, not just its old history. Fix that first. Nothing else in this script will run."
fi
say "GATE-OPEN: history is clean"

squashed_sha=$(git rev-parse "$release_branch")

# ============================================================================
# 5. dry run stops here — nothing below this line has executed yet.
# ============================================================================

if [ "$mode" = dry ]; then
  cat <<EOF

DRY RUN complete: every local check passed, nothing outward-facing was touched.
Squashed commit ready at $squashed_sha (tree identical to main, history clean).

With --publish this script would then, in order:
  1. gh repo rename $archive_newname -R $repo -y
  2. git remote set-url origin $archive_url          (origin repointed to the archive immediately — never left resolving to the public repo)
  3. gh repo create $repo --public --source=$wt --remote=release   (skipped if $repo already exists from an earlier interrupted run)
  4. git push release $release_branch:main
  5. gh api -X POST repos/$repo/pages -f 'source[branch]=main' -f 'source[path]=/docs'
  6. wait (bounded, ~20 min) for repos/$repo/pages .status == built
  7. sh tools/verify-public.sh

Run again with --publish to execute these. (The signed recommendation at
$signoff must exist first.)
EOF
  exit 0
fi

# ============================================================================
# 6. IRREVERSIBLE FROM HERE. Rename, then repoint origin IMMEDIATELY — before create/push exist to
#    be misdirected at — then create, push, enable Pages.
# ============================================================================

if [ "$resuming" = no ]; then
  say "RENAMING $repo -> $archive (point of no return for the name itself)"
  gh repo rename "$archive_newname" -R "$repo" -y
else
  say "skipping rename: already done in a previous run"
fi

# Runs unconditionally, immediately after the rename (or immediately, if resuming) and before
# anything else touches GitHub. origin must never be left resolving to the public repo.
git remote set-url origin "$archive_url"
now_url=$(git remote get-url origin)
[ "$now_url" = "$archive_url" ] || die "FATAL: origin did not repoint to the archive (got '$now_url'). Fix by hand before doing anything else: git remote set-url origin $archive_url"
say "OK: origin -> $archive_url (a habitual 'git push origin main' can no longer reach the public repo)"

# Does the public repository already exist? Ask by IDENTITY, never by name.
# The rename above leaves GitHub redirecting the old name to the archive, so a
# bare "gh repo view $repo" answers yes and names the ARCHIVE. Believing it
# skips the create and pushes the squashed commit straight at the private
# repository holding the unsquashed history. That happened; only git's
# non-fast-forward rule stopped it. So compare the full name that comes back
# against the one asked for, and treat anything else as "does not exist yet".
resolved=$(gh api "repos/$repo" --jq .full_name 2>/dev/null || true)
if [ "$resolved" = "$repo" ]; then
  say "STATE: $repo already exists on GitHub — reusing it (a previous run must have created it)"
  git remote add release "git@github.com:$repo.git" 2>/dev/null || git remote set-url release "git@github.com:$repo.git"
else
  if [ -n "$resolved" ]; then
    say "NOTE: the name $repo currently redirects to $resolved (the rename's redirect). Creating the real public repository now, which ends the redirect."
  fi
  say "CREATING the public repository $repo (the name is now public)"
  # Create it empty, then wire the remote here. NOT --source="$wt": a linked
  # worktree keeps its .git as a FILE rather than a directory, and gh rejects
  # it as "not a git repository". The squashed commit lives in the shared
  # object store either way, so it pushes fine from this clone.
  gh repo create "$repo" --public \
    --description "Stats Hours with Itchy - an open-access statistics book, taught in Julia, every number and figure produced by a real run" \
    || die "could not create $repo"
  git remote add release "git@github.com:$repo.git" 2>/dev/null \
    || git remote set-url release "git@github.com:$repo.git"
fi

# Whatever route we took, refuse to push until the release remote resolves to
# the public repository and not to the archive. A push is the irreversible act.
rel=$(git remote get-url release)
case "$rel" in
  *"$archive_newname"*) die "FATAL: the release remote points at the archive ($rel). Refusing to push." ;;
esac
rel_full=$(gh api "repos/$repo" --jq .full_name 2>/dev/null || true)
[ "$rel_full" = "$repo" ] || die "FATAL: $repo still does not resolve to itself (got '${rel_full:-nothing}'). Refusing to push."
say "OK: release -> $rel, and $repo resolves to itself"

say "pushing the squashed commit"
git push release "$release_branch:main"

say "enabling Pages on docs/"
gh api -X POST "repos/$repo/pages" -f 'source[branch]=main' -f 'source[path]=/docs' --jq .status || die "Pages API call failed — check by hand: gh api repos/$repo/pages"

say "waiting for the Pages build (bounded to ~20 minutes)"
tries=0
while :; do
  status=$(gh api "repos/$repo/pages" --jq .status 2>/dev/null || echo unknown)
  [ "$status" = built ] && { say "OK: Pages built"; break; }
  tries=$((tries + 1))
  [ "$tries" -le 60 ] || { echo "recreate-public: WARNING — Pages status still '$status' after ~20 minutes; check by hand: gh api repos/$repo/pages" >&2; break; }
  sleep 20
done

cat <<EOF

DONE. Next: sh tools/verify-public.sh
EOF
