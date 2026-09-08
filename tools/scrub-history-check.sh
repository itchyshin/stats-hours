#!/bin/sh
# Fail if ANY commit reachable from the given ref (default: HEAD) carries the private-path pattern in its tree.
# tools/scrub-check.sh looks at the tip only; publication pushes history, so history must be clean too.
# The pattern lives in the untracked, git-ignored .scrub-pattern so this script never names it.
REF="${1:-HEAD}"; PAT_FILE="${SCRUB_PATTERN_FILE:-.scrub-pattern}"
[ -s "$PAT_FILE" ] || { echo "scrub-history-check: no pattern file at $PAT_FILE"; exit 2; }
PAT=$(cat "$PAT_FILE"); n=0; hits=0

# The pattern is used as an extended regular expression. If it is not a VALID
# one -- an unbalanced parenthesis or bracket is the obvious way to get there
# while appending one more path fragment -- `git grep` exits 128, and 128 is
# exactly as false to the shell as "no match". A leaking history would then
# report clean, with the fatal message swallowed by the redirect. So prove the
# pattern compiles, against a string that must match nothing, and refuse if it
# does not. This check exists because an adversary found the silent version.
if printf 'x\n' | grep -qE "$PAT" 2>/dev/null; then :; else
  printf 'x\n' | grep -qE "$PAT" >/dev/null 2>&1
  if [ $? -gt 1 ]; then
    echo "SCRUB-PATTERN-INVALID: the pattern in $PAT_FILE is not a valid extended regular expression."
    echo "Refusing to run: an invalid pattern matches nothing and would report a leaking tree as clean."
    exit 2
  fi
fi
for c in $(git rev-list "$REF"); do
  n=$((n+1))
  if git grep -qIE "$PAT" "$c" -- . >/dev/null 2>&1; then hits=$((hits+1)); [ -n "$VERBOSE" ] && echo "hit $c"; fi
done
echo "history: $n commits reachable from $REF, $hits carry the pattern"
[ "$hits" = 0 ] && echo HISTORY-CLEAN || { echo HISTORY-NOT-CLEAN; exit 1; }
