#!/bin/sh
# Publish an UPDATE to the already-public book.
#
# tools/recreate-public.sh exists for the FIRST publication: it renames the private repo out of the
# way and creates a public one holding a single squashed commit. It cannot be used again, and must
# not be — running it a second time would try to rename a repository that is already an archive.
#
# An update is a different shape. The public repository already holds a history of its own (one
# commit, at first), and readers, forks and links depend on it. So an update ADDS a commit rather
# than replacing anything: a new commit whose TREE is exactly the private main's tree, parented on
# whatever the public repository currently has. No force-push, ever. Nothing already published is
# rewritten, which is the property that makes this safe to run.
#
# The tree is taken with git plumbing rather than by copying files, so it is byte-identical to main
# by construction rather than by a comparison that could pass while wrong.
#
# Default is a DRY RUN. Nothing reaches GitHub without --publish.
set -eu

usage() {
  cat <<'EOF'
usage: tools/publish-update.sh [--publish] [-m "message"]

  (no flags)   DEFAULT. Dry run: every check, the new commit built locally, then a report.
               Touches nothing on GitHub.
  --publish    Also pushes the new commit to the public repository's main and waits for Pages.
  -m MESSAGE   Subject line for the published commit. Defaults to a dated one.

Overridable via environment: PUBLIC_REPO, SCRUB_PATTERN_FILE.
EOF
}

die() { echo "publish-update: $*" >&2; exit 1; }
say() { echo "--- $*"; }

mode=dry
msg=""
while [ $# -gt 0 ]; do
  case "$1" in
    --publish) mode=publish ;;
    --dry-run) mode=dry ;;
    -m) shift; [ $# -gt 0 ] || die "-m needs a message"; msg=$1 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" ;;
  esac
  shift
done

command -v git >/dev/null 2>&1 || die "git not found"
command -v gh  >/dev/null 2>&1 || die "gh not found"

root=$(git -C "$(dirname "$0")" rev-parse --show-toplevel) || die "cannot locate the repository from $0"
cd "$root"

repo="${PUBLIC_REPO:-itchyshin/stats-hours}"
release_url="git@github.com:$repo.git"
pattern_file="${SCRUB_PATTERN_FILE:-$root/.scrub-pattern}"

say "mode: $mode   public repo: $repo"

# --- the pattern file, and proof that it compiles -------------------------------------------------
# An invalid extended regular expression makes git grep exit 128, which a shell reads as "no match",
# so a leaking tree would report clean. Prove it compiles before trusting any answer it gives.
[ -s "$pattern_file" ] || die "no pattern file at $pattern_file (it is git-ignored; create it locally first)"
pat=$(cat "$pattern_file")
set +e
printf 'x\n' | grep -qE "$pat" >/dev/null 2>&1
pat_rc=$?
set -e
[ "$pat_rc" -gt 1 ] && die "the pattern in $pattern_file is not a valid extended regular expression — refusing, because an invalid pattern would report a leak as clean"

# --- the working tree must be clean, and main must match its own remote ----------------------------
[ -z "$(git status --porcelain --untracked-files=no)" ] || die "the working tree has uncommitted changes; commit or stash them first"
git fetch --prune origin >/dev/null 2>&1 || die "could not fetch origin"
[ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ] \
  || die "main and origin/main differ; push your work to the private archive before publishing an update"
say "OK: main == origin/main == $(git rev-parse main)"

# --- the tip of main must itself be clean ---------------------------------------------------------
# The published tree is main's tree, so the working-tree check is the one that matters here; the
# full-history check follows once the new commit exists.
sh "$root/tools/scrub-check.sh" >/dev/null || die "scrub-check failed on the working tree — refusing to publish it"
say "OK: the tree carries none of the private-path pattern"

# --- point a remote at the public repository, BY IDENTITY --------------------------------------------
# Never trust a name: after the first publication the archive answers to the old name via GitHub's
# rename redirect. Ask what the name resolves to and require it to be itself.
resolved=$(gh api "repos/$repo" --jq .full_name 2>/dev/null || true)
[ "$resolved" = "$repo" ] || die "$repo does not resolve to itself (got '${resolved:-nothing}'). Refusing to touch it."
vis=$(gh repo view "$repo" --json visibility --jq .visibility 2>/dev/null) || die "cannot read $repo"
[ "$vis" = "PUBLIC" ] || die "$repo is $vis, not PUBLIC — this script updates an already-published book; use tools/recreate-public.sh for a first publication"
git remote add release "$release_url" 2>/dev/null || git remote set-url release "$release_url"
say "OK: release -> $release_url, and $repo resolves to itself"

cleanup() { git remote remove release >/dev/null 2>&1 || true; }
trap cleanup EXIT

# --- what is published now, and what would be published --------------------------------------------
git fetch release main >/dev/null 2>&1 || die "could not fetch the public repository's main"
published=$(git rev-parse FETCH_HEAD)
pub_tree=$(git rev-parse "$published^{tree}")
new_tree=$(git rev-parse "main^{tree}")
say "published now: $published"

if [ "$pub_tree" = "$new_tree" ]; then
  say "NOTHING TO DO: the published tree is already identical to main's tree."
  exit 0
fi

[ -n "$msg" ] || msg="Stats Hours with Itchy - update, $(date +%Y-%m-%d)"

# --- build the new commit with plumbing -------------------------------------------------------------
# commit-tree takes main's tree verbatim and parents it on what is published. The result cannot
# differ from main's tree, because it IS main's tree; no file is copied and nothing can drift.
new=$(git commit-tree "$new_tree" -p "$published" -m "$msg")
say "built $new (tree = main's tree, parent = the published commit)"

# --- prove it, then gate on the full history --------------------------------------------------------
[ -z "$(git diff --stat main "$new")" ] || die "FATAL: the new commit's tree differs from main's. Refusing."
say "OK: tree identical to main"

if ! SCRUB_PATTERN_FILE="$pattern_file" sh "$root/tools/scrub-history-check.sh" "$new"; then
  die "HISTORY-NOT-CLEAN on the commit to be published, or on something it descends from. Nothing was pushed."
fi
say "GATE-OPEN: every commit this would publish is clean"

if [ "$mode" != publish ]; then
  cat <<EOF

DRY RUN complete: every check passed, nothing was pushed.
Would push $new to $repo main, on top of $published, then wait for the Pages build.
Run again with --publish to do it.
EOF
  exit 0
fi

# --- push, fast-forward only --------------------------------------------------------------------
# No --force, ever: the new commit descends from what is published, so an honest fast-forward is the
# only push that can succeed. A rejection here means someone else changed the public repo, and the
# right response is to look, not to force.
say "pushing $new to $repo main (fast-forward only)"
git push release "$new:main"

say "waiting for the Pages build (bounded to ~20 minutes)"
i=0
while [ $i -lt 60 ]; do
  st=$(gh api "repos/$repo/pages" --jq .status 2>/dev/null || echo unknown)
  [ "$st" = built ] && { say "OK: Pages built"; break; }
  i=$((i + 1))
  sleep 20
done
[ "$st" = built ] || say "WARNING: Pages did not report 'built' within the wait. Check the repository's Pages settings."

cat <<EOF

DONE. Published $new.
Next: sh tools/verify-public.sh   (expect the commit count to be one MORE than last time)
EOF
