#!/bin/sh
# tools/check-freeze.sh
#
# Freeze-consistency check. MUST NEVER execute Julia/R/Jupyter — CI has no
# engine installed on purpose, and this script must fail loudly rather than
# silently execute even when run on a machine (a laptop) that does have one.
# It verifies, from the committed _freeze/ cache alone:
#   (a) every rendered chapter with a julia code cell has a committed
#       _freeze/<path>/execute-results/html.json;
#   (b) that freeze's stored "hash" still equals md5(the chapter's current
#       source) — i.e. the freeze reflects the qmd as it stands, not a
#       stale prior version. This is checked BEFORE any render is attempted,
#       and independently proves no execution can be needed for step (c):
#       Quarto's freeze staleness check (`execute: freeze: auto`) uses this
#       exact hash (verified by hand: `hashlib.md5(open(qmd,'rb').read())`
#       equals the freeze json's top-level "hash" field for every chapter on
#       this tree) — a match means Quarto's own freezer will find the same
#       match and never invoke a kernel;
#   (c) rendering from that frozen cache reproduces docs/site/ (the
#       committed, published output) exactly.
#
# WORKING INCANTATION (Quarto 1.6.42, verified against `quarto render --help`
# and by hand against this repo — see .unlazy/stats-hours/gates/leaf-ci.md):
#
#   quarto render <file>.qmd --use-freezer --output-dir <tmp>
#
# run ONE FILE AT A TIME (never `quarto render` on the whole project), and
# never `--no-execute`. Both departures from the first-guess incantation are
# load-bearing, found by rendering into a scratch dir and reading the result:
#
#   * `--no-execute` was tried first and rejected: it skips code cells
#     outright — no output at all, not even the frozen output, and inline
#     `{julia} expr}` spans are left uninterpolated. It always disagrees
#     with docs/site regardless of whether the freeze is actually
#     consistent, so it cannot do this check's job. `-M execute-enabled:false`
#     was also tried and rejected for the opposite reason: it does NOT
#     suppress execution for a single-file render at all (confirmed: a real
#     julia-1.10 kernel still started). `--use-freezer` ("force use of frozen
#     computations for an incremental file render") is the one flag that
#     actually substitutes the committed _freeze/ results — but only when
#     the freeze is fresh (hence the (b) hash check that must pass first: on
#     a stale freeze, `--use-freezer` was observed to fall back to real
#     execution rather than erroring — the (b) check exists specifically so
#     this script never reaches that flag in a state where it could).
#
#   * Rendering file-by-file, not as a project, is required because
#     `_quarto.yml`'s `project.post-render: tools/scrub-paths.sh` only runs
#     on a *project* render, never a single-file one — and scrub-paths.sh
#     hardcodes the literal path "docs" rather than reading
#     $QUARTO_PROJECT_OUTPUT_DIR. A project-level render here, even with
#     --output-dir pointed elsewhere, would still run scrub-paths.sh with
#     cwd = repo root: it would find nothing to scrub in the throwaway
#     output dir, but its grep also matches the real, already-scrubbed
#     docs/site/**/*.html (the "DRM.jl/src/" shorthand substring survives
#     its own scrub) and would rewrite those committed files in place.
#     That is exactly the "touch other people's outputs" failure this
#     script must not risk — avoided structurally, not papered over, since
#     scrub-paths.sh is not this script's file to change (see
#     .unlazy/stats-hours/gates/leaf-ci.md: OWNS is this script and the
#     workflow only).
#
# BELT AND BRACES: even though (b) proves the freeze is fresh, the render in
# (c) below is still run with juliaup's bin directory removed from PATH.
# If Quarto ever tried to start a kernel anyway (a Quarto bug, a hash
# collision, whatever), "julia" would resolve to nothing and the render
# would fail loudly with a command-not-found error — exactly like it will
# fail in CI, which has no Julia at all — rather than silently executing and
# mutating the local, possibly shared, _freeze/ cache. This was not a
# hypothetical: an earlier draft of this check ran `--use-freezer` on a
# chapter without checking (b) first, its freeze was mid-edit and stale, and
# it silently re-executed Julia and rewrote the committed _freeze/ file.
# Hence both (b) and this PATH guard.
#
# WHY THE DIFF NEEDS ITS OWN NORMALIZATION PASS
#
# tools/scrub-paths.sh does two things to docs/**/*.html after a real
# project render:
#   1. rewrites the local dev-checkout DRM.jl path down to the
#      "DRM.jl/src/..." shorthand (stack traces print the developer's
#      absolute path);
#   2. strips the random 8-hex-char id Quarto's jupyter engine stamps on
#      every executed cell's wrapper <div> (regenerated on every render,
#      frozen or not — two honest renders of identical content are never
#      byte-identical without this).
# Because this script deliberately renders file-by-file (above) and cannot
# call scrub-paths.sh itself, it reproduces both transforms here, against
# its own --output-dir only, before diffing. Verified by hand: with both
# normalizations applied to a fresh --use-freezer render, `diff -rq` against
# docs/site/ is empty; without them, the only differences on the current
# tree are exactly these two (confirmed by re-rendering twice and diffing
# the two renders against each other: identical except the cell-id, which
# regenerates every time).
#
# The diff also ignores site_libs/ (Quarto's own asset bundle — rebuilt
# identically by every render, irrelevant to freeze content). No volatile
# timestamp text was found anywhere in the rendered output while verifying
# this script (checked by hand: no "generated on" / build-time string
# anywhere; the one date-shaped text is the fixed `content="quarto-1.6.42"`
# generator meta tag, byte-identical every render), so none is excluded.

set -eu

cd "$(dirname "$0")/.."

# Override only for local verification in a sandbox that blocks /tmp; CI and
# ordinary local use get the plain /tmp path.
OUT="${FREEZE_CHECK_OUT:-/tmp/freeze-check-site}"

# Render list: index.qmd plus book/*.qmd, minus Quarto's own "leading
# underscore = excluded from render" convention (book/_spike.qmd is a real
# file with real freeze results, kept around as a spike, but it is not part
# of _quarto.yml's rendered `book/*.qmd` output — confirmed with
# `quarto inspect .`, whose "input" list omits it).
render_list_file=$(mktemp)
diff_out=$(mktemp)
trap 'rm -f "$render_list_file" "$diff_out"' EXIT

echo "index.qmd" >> "$render_list_file"
for f in book/*.qmd; do
  base=$(basename "$f")
  case "$base" in
    _*) continue ;;
  esac
  echo "$f" >> "$render_list_file"
done

# (a) freeze existence — only for files that actually have a julia cell.
missing=0
while IFS= read -r f; do
  if ! grep -q '^```{julia}' "$f"; then
    continue
  fi
  stem=${f%.qmd}
  freeze_json="_freeze/${stem}/execute-results/html.json"
  if [ ! -f "$freeze_json" ]; then
    echo "MISSING FREEZE: $f has julia cells but no $freeze_json" >&2
    missing=1
  fi
done < "$render_list_file"
if [ "$missing" -ne 0 ]; then
  echo "freeze check FAILED: one or more chapters missing a committed freeze" >&2
  exit 1
fi

# (b) freshness — the freeze's stored source hash must match the current
# source, checked without ever invoking Quarto/an engine.
stale=0
while IFS= read -r f; do
  if ! grep -q '^```{julia}' "$f"; then
    continue
  fi
  stem=${f%.qmd}
  freeze_json="_freeze/${stem}/execute-results/html.json"
  if ! python3 - "$f" "$freeze_json" <<'PYEOF'
import hashlib
import json
import sys

qmd_path, freeze_path = sys.argv[1], sys.argv[2]
stored = json.load(open(freeze_path))["hash"]
actual = hashlib.md5(open(qmd_path, "rb").read()).hexdigest()
if stored != actual:
    print(f"STALE FREEZE: {qmd_path} hash {actual} != frozen hash {stored}", file=sys.stderr)
    sys.exit(1)
PYEOF
  then
    stale=1
  fi
done < "$render_list_file"
if [ "$stale" -ne 0 ]; then
  echo "freeze check FAILED: one or more chapters were edited without re-running/re-freezing" >&2
  exit 1
fi

# (c) render from the (now proven-fresh) frozen cache only, file by file,
# into $OUT — with juliaup removed from PATH as a structural guarantee
# against ever executing (see header).
mkdir -p "$OUT"
SAFE_PATH=$(printf '%s' "$PATH" | tr ':' '\n' | grep -v juliaup | tr '\n' ':')
while IFS= read -r f; do
  PATH="$SAFE_PATH" quarto render "$f" --use-freezer --output-dir "$OUT"
done < "$render_list_file"

# Reproduce tools/scrub-paths.sh's two transforms against $OUT only (see
# header for why this script cannot just call scrub-paths.sh itself).
find "$OUT" -name '*.html' -print | while IFS= read -r html; do
  if grep -q "DRM\.jl/src/" "$html"; then
    sed -E 's#[^<>]*/DRM\.jl/src/#DRM.jl/src/#g' "$html" > "$html.tmp" && mv "$html.tmp" "$html"
  fi
done
find "$OUT" -name '*.html' -print | while IFS= read -r html; do
  if grep -qE '<div id="[0-9a-f]{6,10}" class="cell"' "$html"; then
    sed -E 's#<div id="[0-9a-f]{6,10}" class="cell"#<div class="cell"#g' "$html" > "$html.tmp" && mv "$html.tmp" "$html"
  fi
done

# (d) diff the normalized render against the committed site.
if ! diff -rq -x site_libs "$OUT" docs/site > "$diff_out" 2>&1; then
  echo "freeze check FAILED: rendering from the committed _freeze/ cache differs from docs/site/" >&2
  cat "$diff_out" >&2
  exit 1
fi

echo "freeze consistent"
