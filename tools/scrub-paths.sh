#!/bin/sh
# Post-render step (see _quarto.yml `project.post-render`).
#
# DRM.jl is loaded via `Pkg.develop(path = "../DRM.jl")`, so Julia's stacktraces
# print the *local* dev checkout path (e.g. "<repos root>/DRM.jl/src/…")
# rather than a package-relative one. That is fine on this machine and wrong to
# publish. Rewrite it to the same "DRM.jl/src/…" shorthand docs/index.html uses.
set -eu

# Quarto exports the render's output directory to a post-render script. Honour
# it rather than assuming docs/: a render into a scratch directory (as
# tools/check-freeze.sh does, to compare a freeze-only render against the
# published output) must get exactly the same treatment, or the two disagree
# for a reason that has nothing to do with the freeze.
OUT="${QUARTO_PROJECT_OUTPUT_DIR:-docs/site}"
[ -d "$OUT" ] || OUT=docs/site
grep -rl --include=*.html "DRM\.jl/src/" "$OUT" 2>/dev/null | while IFS= read -r f; do
  sed -i '' -E 's#[^<>]*/DRM\.jl/src/#DRM.jl/src/#g' "$f"
done

# Quarto's jupyter engine stamps every executed cell's wrapper div with a
# random 8-hex-char id (`<div id="05346e1f" class="cell" ...>`), regenerated
# on every render. Nothing on the page links to it (no in-page anchors point
# at a cell id), so stripping it here makes two consecutive renders of the
# same chapter byte-identical, not just identical after normalisation (see
# tools/normalize-render.sh, which does the same thing for a render already
# on disk from before this script existed).
grep -rlE --include=*.html '<div id="[0-9a-f]{6,10}" class="cell"' "$OUT" 2>/dev/null | while IFS= read -r f; do
  sed -i '' -E 's#<div id="[0-9a-f]{6,10}" class="cell"#<div class="cell"#g' "$f"
done

# The landing page is index.qmd at the project root, so it renders straight to the site root.

# Authoring bookkeeping leaks into the shipped page. The chapters carry two
# kinds of note to their own authors -- `<!-- box: translate | id: ... -->`,
# which records which comparison box was checked against a real R run and
# when, and `<!-- eq: hand-typed; ... -->`, which marks an equation to be
# regenerated once the symbolic reader exists. Both belong in the .qmd and
# neither belongs in front of a reader who views source. Strip them here
# rather than deleting them from the chapters, so the authors keep their
# notes and the published page does not carry them.
grep -rlE --include=*.html '<!-- *(box|eq):' "$OUT" 2>/dev/null | while IFS= read -r f; do
  perl -0pi -e 's/<!--\s*(?:box|eq):.*?-->\n?//gs' "$f"
done
