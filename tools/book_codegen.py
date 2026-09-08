#!/usr/bin/env python3
"""book_codegen.py — S1 probe: can the book's boxed "In R you'd write..."
snippet be MACHINE-GENERATED from DRM.jl's R-parity fixtures, instead of
hand-typed?

Proves the idea on exactly ONE model (the simplest fixture with a real
parity case on both sides): the Poisson mean-only count model,
`test/parity/fixtures/count-poisson/` in DRM.jl.

Provenance (all READ-ONLY; nothing here writes back to DRM.jl or drmTMB):
  - R block: `expected.meta.toml`'s `r_call` field. This is the literal R
    call string a DRM.jl maintainer typed into `gen_fixtures.R` next to the
    `drmTMB(...)` call that actually produced `expected.toml` (verified by
    reading `test/parity/gen_fixtures.R::generate_poisson()` — the `r_call`
    string is character-identical to the executed `fit <- drmTMB(...)` line
    one line above it). It is NOT captured programmatically (no `deparse`/
    `sys.call()` in the generator) — it is a maintained, hand-typed twin of
    the real call, sitting directly beside it.
  - Julia block: built from `expected.toml`'s `[fit] family` / `formula`
    fields, translated by the family-name and formula-wrapping rules
    documented in `docs/src/rosetta.md` ("The fit call" + "Families" table).
    Only the ONE mapping this fixture needs is transcribed below; this is a
    proof-of-concept translator, not a general R-formula parser (DRM.jl's
    own general translator, `_bridge_xlate` in `src/bridge.jl`, is a
    separate, much larger piece of machinery — see the evidence transcript).

Usage:
    python3 book_codegen.py
Run twice and diff stdout to check idempotence (no timestamps, no randomness).
"""

import tomllib
import os
from pathlib import Path

# Point this at a local DRM.jl checkout. Override with the DRM_JL environment variable:
#   DRM_JL=~/src/DRM.jl python3 tools/book_codegen.py
DRM_JL = Path(os.environ.get("DRM_JL", "../DRM.jl")).expanduser()
FIXTURE_DIR = DRM_JL / "test" / "parity" / "fixtures" / "count-poisson"

# Transcribed from docs/src/rosetta.md, "Families" table, poisson() row:
# | `poisson()` | `Poisson()` | — (mean only; `zi`, `hu`) |
# One entry only — this probe does not claim a general family map.
R_FAMILY_TO_JULIA = {
    "poisson": "Poisson()",
}


def julia_formula_block(formula_text: str) -> str:
    """Translate a single-part R formula string (e.g. "y ~ x") into DRM.jl's
    `bf(@formula(...))` bundle syntax, per rosetta.md's "The fit call" /
    "Formula grammar" tables. Handles exactly the shape this one fixture
    uses: one bare `lhs ~ rhs` part, no `;`-separated extra parameters, no
    R-only constructs (I(), scale(), factor(), poly(), ^, -term — those go
    through DRM.jl's separate `_bridge_xlate` rewriter, out of scope here).
    """
    parts = [p.strip() for p in formula_text.split(";") if p.strip()]
    if len(parts) != 1 or "~" not in parts[0] or "=" in parts[0]:
        raise ValueError(
            f"julia_formula_block: formula {formula_text!r} is not the single "
            "bare `lhs ~ rhs` shape this probe covers"
        )
    return f"bf(@formula({parts[0]}))"


def generate(fixture_dir: Path) -> tuple[str, str]:
    """Return (julia_block, r_block) for one parity fixture, as plain text
    ready to drop into the book's paired code-block template."""
    expected = tomllib.loads((fixture_dir / "expected.toml").read_text())
    meta = tomllib.loads((fixture_dir / "expected.meta.toml").read_text())

    family = expected["fit"]["family"]
    formula_text = expected["fit"]["formula"]
    r_call = meta["r_call"]

    if family not in R_FAMILY_TO_JULIA:
        raise ValueError(
            f"generate: family {family!r} has no entry in R_FAMILY_TO_JULIA "
            "(this probe covers exactly one family)"
        )
    julia_family = R_FAMILY_TO_JULIA[family]
    julia_bf = julia_formula_block(formula_text)
    julia_call = f"fit = drm({julia_bf}, {julia_family}; data = dat)"

    julia_block = "# Julia — DRM.jl\nusing DRM\n" + julia_call
    r_block = f"# R — drmTMB\nfit <- {r_call}"
    return julia_block, r_block


def main() -> None:
    julia_block, r_block = generate(FIXTURE_DIR)
    print("```julia")
    print(julia_block)
    print("```")
    print()
    print('> **In R you\'d write...**')
    print("```r")
    print(r_block)
    print("```")


if __name__ == "__main__":
    main()
