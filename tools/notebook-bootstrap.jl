# ── Run this chapter on a clean machine (Colab "Julia" runtime, Binder, or any Jupyter with a Julia kernel) ──
# Cell 1 of 2 — the engine and the data. Measured on a clean machine: about three minutes to a first fit.
# Both engines are public on GitHub, so nothing needs a registry.
import Pkg
Pkg.add(url = "https://github.com/itchyshin/DRM.jl", rev = "{{DRM_REV}}")   # the commit the chapters were executed against
Pkg.add(["DataFrames", "CSV", "Distributions", "StatsBase", "StatsModels"])
REPO_RAW = "https://raw.githubusercontent.com/itchyshin/stats-hours/main"   # works once the repository is public
for f in ("tools/theme_itchy.jl", "tools/figures.jl", "tools/engine-pin.txt", "data/2012/MBodySize.csv", "data/2012/BodySize.csv", "data/2012/ChickSurvival.csv", "data/2012/FemaleSuccess.csv", "data/2012/SparrowSurvival.csv")
    mkpath(dirname(f)); isfile(f) || download("$REPO_RAW/$f", f)
end
println("engine and data ready — run the next cell for the plotting stack (several minutes; read on meanwhile)")
##CELL##
# Cell 2 of 2 — the plotting stack. This is the slow part on a bare machine (about eight minutes measured;
# Binder pays it once at image build, so there it is seconds). Every figure in the chapter needs it.
import Pkg
Pkg.add(["Makie", "CairoMakie", "AlgebraOfGraphics"])
using CairoMakie
println("plotting ready")
