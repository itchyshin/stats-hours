#!/bin/sh
# normalize-render.sh <file> -- print an HTML render with the non-deterministic
# bits stripped, so two renders of the same source are byte-identical after
# normalisation even if they are not identical on disk.
#
# Quarto's jupyter engine gives every executed cell's wrapper div a random
# 8-hex-char id, regenerated on each render (`<div id="05346e1f" class="cell"
# ...>`); tools/scrub-paths.sh already strips this from the file on disk as a
# post-render step, so in the normal case this script's output equals the
# file's own content verbatim. It stays here, and still strips the same
# pattern, so a comparison never depends on scrub-paths.sh having run, and so
# any other hash-only id Quarto/pandoc introduces later has one place to add
# a rule.
#
# Usage: tools/normalize-render.sh path/to/rendered.html
set -eu

file=$1
sed -E 's#<div id="[0-9a-f]{6,10}" class="cell"#<div class="cell"#g' "$file"
