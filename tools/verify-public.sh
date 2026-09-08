#!/bin/sh
# Independent check that the public repository is what it should be. Run AFTER
# tools/recreate-public.sh --publish. This script only READS GitHub; it changes nothing.
set -eu

command -v git  >/dev/null 2>&1 || { echo "verify-public: git not found" >&2; exit 2; }
command -v gh   >/dev/null 2>&1 || { echo "verify-public: gh not found" >&2; exit 2; }
command -v curl >/dev/null 2>&1 || { echo "verify-public: curl not found" >&2; exit 2; }

# Locate the repository from THIS SCRIPT's own location — never from the caller's cwd (D6: the
# pattern file used to be read relative to cwd and silently misfired when run from elsewhere).
root=$(git -C "$(dirname "$0")" rev-parse --show-toplevel) || { echo "verify-public: cannot locate the repository from $0" >&2; exit 2; }

repo="${PUBLIC_REPO:-itchyshin/stats-hours}"
pattern_file="${SCRUB_PATTERN_FILE:-$root/.scrub-pattern}"
# tools/recreate-public.sh publishes exactly one squashed commit — that is the "what was published"
# this check holds the public repo to.
expected_commits="${PUBLIC_EXPECTED_COMMITS:-}"

# An empty or missing pattern file would match every line or none — either way it lies.
[ -s "$pattern_file" ] || { echo "verify-public: no pattern file at $pattern_file (it is git-ignored; create it locally first) — refusing to continue" >&2; exit 2; }
pat=$(cat "$pattern_file")

# An invalid extended regular expression makes git grep exit 128, which the shell
# reads as "no match" — so a leaking history would be reported clean. Prove the
# pattern compiles before trusting any answer it gives.
# set -e is on, and this grep is SUPPOSED to find nothing, so its exit 1 would
# kill the script before the status could be read. Disable the trap for the one
# line whose failure is the answer we want.
set +e
printf 'x\n' | grep -qE "$pat" >/dev/null 2>&1
pat_rc=$?
set -e
if [ "$pat_rc" -gt 1 ]; then
  echo "verify-public: the pattern in $pattern_file is not a valid extended regular expression — refusing to continue, because an invalid pattern would report a leak as clean" >&2
  exit 2
fi

ok=1

# 1. visibility
v=$(gh repo view "$repo" --json visibility --jq .visibility 2>/dev/null) || { echo "visibility: could not read (gh error)"; v=""; ok=0; }
echo "visibility: $v"
[ "$v" = "PUBLIC" ] || ok=0

# 2. the three previously-known pre-scrub SHAs must not be retrievable on the new repo. Defence in
# depth ONLY — see the SHA-reachability caveat below. It can catch only the SHAs it is told about.
for sha in 291f4ac 2335fa4 b6c03d3; do
  if gh api "repos/$repo/commits/$sha" >/dev/null 2>&1; then
    echo "LEAK: pre-scrub $sha is retrievable on $repo"; ok=0
  else
    echo "ok: $sha not retrievable on $repo"
  fi
done

# 3. full history of the public repo, by ref-reachable commit: zero hits, and the commit count must be
# exactly what was published — not zero (never pushed, or the push failed: a clone of an empty repo
# still exits 0, so "zero commits, zero hits" is not success, it is nothing having been checked at
# all), and not more than expected (the squash failed, or extra history leaked through).
t=$(mktemp -d)
if git clone -q --bare "https://github.com/$repo.git" "$t/r" 2>/dev/null; then
  n=0; hits=0
  for c in $(git -C "$t/r" rev-list --all); do
    n=$((n + 1))
    git -C "$t/r" grep -qIE "$pat" "$c" -- . >/dev/null 2>&1 && hits=$((hits + 1))
  done
  echo "history on the public repo: $n commits, $hits carry the pattern"
  [ "$hits" = 0 ] || ok=0
  if [ "$n" -eq 0 ]; then
    echo "FAIL: the public repo has no commits at all (never pushed, or the push failed) — this is not a clean bill of health, it is nothing having been checked"
    ok=0
  elif [ -n "${PUBLIC_EXPECTED_COMMITS:-}" ] && [ "$n" -ne "$expected_commits" ]; then
    echo "FAIL: expected exactly $expected_commits commit(s), found $n"
    ok=0
  fi
  # Why the count is no longer pinned to one. The first publication puts a single
  # squashed commit on the public repo, and asserting "exactly 1" was right that
  # day. Every later update ADDS a commit (see tools/publish-update.sh), so a
  # hard 1 would fail every honest update and teach a reader to ignore the check.
  # The property that actually matters is the line above this block: every commit
  # in the published history is free of the pattern, whatever the count. Zero
  # commits is still a failure, because that is nothing having been checked
  # rather than a clean result. Set PUBLIC_EXPECTED_COMMITS to assert an exact
  # number when you know what it should be.
else
  echo "could not clone the public repo to check its history"
  ok=0
fi
rm -rf "$t"

cat <<'EOF'
CAVEAT: the check above only sees commits reachable from a ref (a branch or tag). It cannot see a
CAVEAT: commit that exists only by SHA — the far side of a force-push, a deleted branch, a closed PR.
CAVEAT: That is a real blind spot this script cannot close from outside GitHub. Treat this as a sound
CAVEAT: day-one check on a repo that has received exactly one push, and as unsound the moment anyone
CAVEAT: force-pushes, deletes a branch, or closes a PR on the public repo.
EOF

# 4. Pages — wait (bounded) for the build so a slow build never reads as a broken publish.
tries=0
while :; do
  status=$(gh api "repos/$repo/pages" --jq .status 2>/dev/null || echo "no pages")
  [ "$status" = built ] && break
  tries=$((tries + 1))
  [ "$tries" -le 60 ] || { echo "pages: still '$status' after ~20 minutes — checking URLs anyway"; break; }
  sleep 20
done
p=$(gh api "repos/$repo/pages" --jq '"\(.source.branch) \(.source.path) \(.html_url)"' 2>/dev/null || echo "no pages")
echo "pages: $p"
case "$p" in
  "main /docs"*) ;;
  *) ok=0 ;;
esac

# 5. URLs — follow redirects and bound the wait, so neither a redirect nor a hang reads as broken.
for u in "https://itchyshin.github.io/stats-hours/" \
         "https://itchyshin.github.io/stats-hours/site/" \
         "https://colab.research.google.com/github/$repo/blob/main/notebooks/wk2-linear-models.ipynb"; do
  c=$(curl -sL --max-time 20 -o /dev/null -w "%{http_code}" "$u")
  echo "$c $u"
  [ "$c" = "200" ] || ok=0
done

[ "$ok" = 1 ] && echo "PUBLIC-OK" || { echo "PUBLIC-NOT-OK"; exit 1; }
