# Reader environment — measured

The book's promise is that a reader runs a chapter without installing anything. The cost of that
promise is the first cell: installing the engine from GitHub and precompiling the plotting stack.

## Clean-machine proxy (measured 2026-09-06)

A fresh Julia depot on the author's Mac (Apple silicon, Julia 1.10.0), running exactly the bootstrap
cell the notebooks ship, pinned to `tools/engine-pin.txt`:

| step | seconds |
|---|---|
| install from GitHub + precompile (DRM.jl, DataFrames, CSV, Distributions, Makie, CairoMakie, AlgebraOfGraphics, StatsBase, StatsModels) | 519.5 |
| `using DRM, DataFrames, CSV, CairoMakie` | 9.2 |
| first fit (`Wing ~ Tarsus` on the 2012 sparrows) | 8.1 |
| first figure | 0.8 |
| **total to first fit and figure** | **537.7 (≈ 9 min)** |

This is **above the five-minute ceiling** the plan set, and a hosted CPU will be slower, not faster.
The cost is almost entirely the plotting stack's precompilation, not the engine.

## What this implies for the two hosted paths

- **Binder** precompiles at *image build* (`.binder/postBuild`), so a reader's first cell is seconds;
  the cost is paid once per image, not per reader. Binder is therefore the path that meets the ceiling —
  once the repository is public.
- **Colab** starts from a bare runtime every session, so the full cost lands on the reader every time
  unless the bootstrap is split: install the engine and data first (a fit within a minute or two),
  and load the plotting stack in a second cell. **Measured, same clean depot: engine + data only — install
  and precompile 172.0 s, load 3.9 s, first fit 7.8 s, total 183.8 s (≈ 3 min).** So a Colab reader
  reaches a real fit in about three minutes, under the ceiling; the figures then cost the remaining
  minutes once. The notebooks ship this two-cell bootstrap.

## Summary

| path | first fit | first figure | meets the 5-min ceiling? |
|---|---|---|---|
| bare machine, one-cell bootstrap | 9.0 min | 9.0 min | no |
| bare machine, two-cell bootstrap (Colab shape) | ≈ 3 min | ≈ 9 min | fit yes; figure no |
| Binder (precompiled image) | seconds | seconds | yes, after a one-off image build |

## Still unmeasured

The actual Colab Julia runtime (needs the author's sign-in) and an actual Binder launch (needs a public
repository). Both are one afternoon's work once those two doors open.
