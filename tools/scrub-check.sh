#!/bin/sh
# Fail if any TRACKED blob, or any tracked symlink's target, matches the private-path pattern.
# The pattern lives in an untracked file (.scrub-pattern, git-ignored) so this script never names
# what it hunts for. git grep does not read symlink blobs, so those are checked separately.
PAT_FILE="${SCRUB_PATTERN_FILE:-.scrub-pattern}"
[ -s "$PAT_FILE" ] || { echo "scrub-check: no pattern file at $PAT_FILE (create it locally; it is git-ignored)"; exit 2; }
PAT=$(cat "$PAT_FILE")

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
bad=0
if git grep -qIE "$PAT" -- . ':!*.quarto_ipynb'; then git grep -lIE "$PAT" -- . ':!*.quarto_ipynb'; bad=1; fi
for f in $(git ls-files -s | awk '$1=="120000"{print $4}'); do
  t=$(git cat-file -p "$(git ls-files -s "$f" | awk '{print $2}')")
  echo "$t" | grep -qE "$PAT" && { echo "symlink $f -> $t"; bad=1; }
done
[ $bad = 0 ] && echo SCRUB-OK
exit $bad
