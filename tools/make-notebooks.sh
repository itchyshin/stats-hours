#!/bin/sh
# Regenerate notebooks/*.ipynb from the executed chapters and prepend the bootstrap cell.
# Run from the repo root. Needs quarto on PATH.
set -e
for q in book/*.qmd; do case "$q" in *_spike*) continue;; esac;
  n=$(basename "$q" .qmd); quarto convert "$q" --output "notebooks/$n.ipynb"
done
python3 tools/notebook-bootstrap.py
