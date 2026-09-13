"""
    figures.jl

Figure-grammar helpers for "Stats Hours with Itchy". Every function takes
plain vectors / DataFrames — never DRM internals — so chapters keep working
if the fitting engine changes. Each applies the theme currently set with
`ItchyTheme.theme_itchy` (call `set_theme!(theme_itchy(mode))` before calling
these, as `save_svg_pair` does) and returns a `Figure`.
"""

include("theme_itchy.jl")
using .ItchyTheme

using CairoMakie
using Makie
using Statistics

# ── 1. data cloud ────────────────────────────────────────────────────────

"""
    fig_data_cloud(x, y; xlabel="x", ylabel="y", title="")

Raw scatter of the data — the first figure in the grammar.
"""
function fig_data_cloud(x, y; xlabel = "x", ylabel = "y", title = "")
    fig = Figure(size = (480, 360))
    ax = Axis(fig[1, 1]; xlabel, ylabel, title)
    scatter!(ax, x, y)
    fig
end

# ── 2a. fitted mean with sigma ribbon (location-scale chapters) ────────────

"""
    fig_fit_ribbon(x, y, μ, σ; xlabel="x", ylabel="y", title="")

Data cloud plus fitted mean `μ(x)` with a `±σ(x)` band. `x, μ, σ` must be
sorted/aligned so the ribbon draws cleanly; the band is labelled "±σ" — it is
a dispersion band, not a confidence interval.
"""
function fig_fit_ribbon(x, y, μ, σ; xlabel = "x", ylabel = "y", title = "")
    ord = sortperm(x)
    xs, μs, σs = x[ord], μ[ord], σ[ord]
    fig = Figure(size = (480, 360))
    ax = Axis(fig[1, 1]; xlabel, ylabel, title)
    # band and fitted line first, real data drawn LAST so no point is ever
    # painted over (a point at ~1σ from μ used to sit under the band itself)
    band!(ax, xs, μs .- σs, μs .+ σs; label = "±σ")
    lines!(ax, xs, μs; linewidth = 2, label = "fitted μ")
    scatter!(ax, x, y; markersize = 6)
    # legend outside the axis so it can never hide a group (reviewer: pond P05 sat under it)
    Legend(fig[1, 2], ax; framevisible = false)
    fig
end

# ── 2b. variance-component estimates, ML vs REML with CIs ──────────────────

"""
    fig_varcomp(labels, est_ml, ci_ml, est_reml, ci_reml; ylabel="variance component")

`ci_ml`/`ci_reml` are vectors of `(lo, hi)` tuples, aligned to `labels`.
Small multiples: one panel per component, each with its own y-scale, so a
component with a narrow CI (a small, real difference) is not squashed onto
the same axis as one with a wide CI — a shared axis makes the narrow one's
gap sub-pixel regardless of how real it is. ML and REML are plotted side by
side within each panel, with CI whiskers.
"""
function fig_varcomp(labels, est_ml, ci_ml, est_reml, ci_reml; ylabel = "variance component")
    n = length(labels)
    fig = Figure(size = (220 * n + 100, 360))
    for i in 1:n
        ax = Axis(fig[1, i];
            xticks = (1:2, ["ML", "REML"]),
            ylabel = i == 1 ? ylabel : "",
            title = string(labels[i]))
        xlims!(ax, 0.5, 2.5)
        lo_ml, hi_ml = ci_ml[i]
        lo_re, hi_re = ci_reml[i]
        # one colour per ESTIMATOR, not per label: ML is always palette 1, REML palette 2
        rangebars!(ax, [1], [lo_ml], [hi_ml]; whiskerwidth = 8, color = Cycled(1))
        rangebars!(ax, [2], [lo_re], [hi_re]; whiskerwidth = 8, color = Cycled(2))
        scatter!(ax, [1], [est_ml[i]]; markersize = 10, color = Cycled(1))
        scatter!(ax, [2], [est_reml[i]]; markersize = 10, marker = :diamond, color = Cycled(2))
    end
    elem_ml = MarkerElement(marker = :circle, markersize = 10, color = Cycled(1))
    elem_reml = MarkerElement(marker = :diamond, markersize = 10, color = Cycled(2))
    # legend outside the axes so it can never hide a group (reviewer: pond P05 sat under it)
    Legend(fig[1, n + 1], [elem_ml, elem_reml], ["ML", "REML"]; framevisible = false)
    fig
end

# ── 3. diagnostic: randomised-quantile worm/QQ plot ─────────────────────────

"""
    fig_diagnostic(resid_quantiles; title="Worm plot")

`resid_quantiles` are randomised-quantile residuals mapped to normal
quantiles (i.e. already transformed, e.g. via `qqnorm`-style theoretical
quantiles). Plots deviation from the identity line with a ±2SE envelope
approximated from order-statistic variance under normality.
"""
function fig_diagnostic(resid_quantiles; title = "Worm plot")
    n = length(resid_quantiles)
    obs = sort(resid_quantiles)
    p = ((1:n) .- 0.5) ./ n
    theo = sqrt(2) .* erfinv_approx.(2 .* p .- 1)
    dev = obs .- theo
    # order-statistic SE envelope under normality: se_i ≈ sqrt(p(1-p)/n)/φ(theo_i)
    φ = x -> exp(-x^2 / 2) / sqrt(2π)
    se = sqrt.(p .* (1 .- p) ./ n) ./ φ.(theo)
    fig = Figure(size = (480, 360))
    ax = Axis(fig[1, 1]; xlabel = "theoretical quantile", ylabel = "deviation", title)
    band!(ax, theo, -2 .* se, 2 .* se; label = "±2SE")
    hlines!(ax, [0.0]; linestyle = :dash, label = "0 = correct model")
    scatter!(ax, theo, dev; markersize = 6, label = "deviation")
    # legend outside the axis so it can never hide a group (reviewer: pond P05 sat under it)
    Legend(fig[1, 2], ax; framevisible = false)
    fig
end

# inverse error function approximation (Winitzki), avoids a SpecialFunctions dep
function erfinv_approx(x::Real)
    a = 0.147
    ln1mx2 = log(1 - x^2)
    t1 = 2 / (π * a) + ln1mx2 / 2
    sign(x) * sqrt(sqrt(t1^2 - ln1mx2 / a) - t1)
end

# ── 3b. worm-plot arithmetic, exposed so the picture can be counted ────────

"""
    worm_parts(r)

The same arithmetic `fig_diagnostic` draws with, returned rather than
plotted: sort `r`, compare each to the normal quantile it should sit at, and
report the deviation. Returns a NamedTuple `(; theo, dev, se)` — the
theoretical quantiles, the sorted residuals' deviation from them, and the
pointwise standard error of that deviation under normality (the ±2SE
envelope `fig_diagnostic` bands).
"""
function worm_parts(r)
    n = length(r)
    obs = sort(r)
    p = ((1:n) .- 0.5) ./ n
    theo = sqrt(2) .* erfinv_approx.(2 .* p .- 1)      # normal quantiles
    dens = x -> exp(-x^2 / 2) / sqrt(2π)
    se = sqrt.(p .* (1 .- p) ./ n) ./ dens.(theo)      # SE of the ith order statistic
    (; theo, dev = obs .- theo, se)
end

"""
    n_outside(r)

Count of `worm_parts(r)`'s deviations falling outside the pointwise ±2SE
envelope `fig_diagnostic` draws.
"""
n_outside(r) = (w = worm_parts(r); count(abs.(w.dev) .> 2 .* w.se))

"""
    n_below(r)

Count of `worm_parts(r)`'s deviations falling *below* the pointwise −2SE
envelope. (The count above the envelope is `n_outside(r) - n_below(r)`.)
"""
n_below(r) = (w = worm_parts(r); count(w.dev .< -2 .* w.se))

# ── 4b. shrinkage caterpillar: raw group means vs BLUPs ─────────────────────

"""
    fig_shrinkage(groups, raw_means, blups; boundary=false)

Caterpillar plot connecting each group's raw mean to its BLUP, ordered by
raw mean. `boundary=true` flags a zero-variance-component boundary fit
(annotated on the plot).
"""
function fig_shrinkage(groups, raw_means, blups; boundary = false)
    ord = sortperm(raw_means)
    g, raw, blup = groups[ord], raw_means[ord], blups[ord]
    n = length(g)
    fig = Figure(size = (520, 380))
    ax = Axis(fig[1, 1];
        xticks = (1:n, string.(g)), xticklabelrotation = π / 4,
        ylabel = "group effect",
        title = boundary ? "Shrinkage (zero-variance boundary)" : "Shrinkage")
    # raw mean and BLUP are the two things this plot exists to compare, so
    # neither may sit on top of the other: dodge them apart in x rather than
    # stacking both markers at the same point, where one hid the other
    # whenever shrinkage was mild.
    dodge = 0.15
    for i in 1:n
        lines!(ax, [i - dodge, i + dodge], [raw[i], blup[i]]; color = (:grey, 0.6))
    end
    scatter!(ax, (1:n) .- dodge, raw; markersize = 8, label = "raw mean")
    scatter!(ax, (1:n) .+ dodge, blup; markersize = 8, marker = :diamond, label = "BLUP")
    if boundary
        # explicit, non-cycled colour: hlines! cycles its own :color
        # independently of the scatters above and was landing on the same
        # palette slot as "raw mean"
        hlines!(ax, [0.0]; linestyle = :dot, color = (:grey, 0.6), label = "boundary")
    end
    # legend outside the axis so it can never hide a group (reviewer: pond P05 sat under it)
    Legend(fig[1, 2], ax; framevisible = false)
    fig
end

# ── 4a. disagreement overlay: two fits superposed ───────────────────────────

"""
    fig_disagreement(x, y, fits::Vector{<:NamedTuple}; xlabel="x", ylabel="y")

`fits` is a vector of `(; label, μ)` (or `(; label, x, μ)` if each fit has
its own x grid) NamedTuples, each drawn as a line over the shared data cloud.
"""
function fig_disagreement(x, y, fits::Vector{<:NamedTuple}; xlabel = "x", ylabel = "y")
    fig = Figure(size = (480, 360))
    ax = Axis(fig[1, 1]; xlabel, ylabel, title = "Disagreement")
    scatter!(ax, x, y; markersize = 6, color = (:grey, 0.5))
    for fit in fits
        fx = hasproperty(fit, :x) ? fit.x : x
        ord = sortperm(fx)
        lines!(ax, fx[ord], fit.μ[ord]; linewidth = 2, label = fit.label)
    end
    # legend outside the axis so it can never hide a group (reviewer: pond P05 sat under it)
    Legend(fig[1, 2], ax; framevisible = false)
    fig
end

# ── self-run smoke test ──────────────────────────────────────────────────

if abspath(PROGRAM_FILE) == @__FILE__
    using Random
    Random.seed!(1)
    set_theme!(theme_itchy(:light))

    n = 60
    x = sort(rand(n) .* 10)
    y = 2 .+ 0.5 .* x .+ randn(n)
    fig_data_cloud(x, y) |> display

    μ = 2 .+ 0.5 .* x
    σ = fill(1.0, n)
    fig_fit_ribbon(x, y, μ, σ) |> display

    labels = ["intercept", "slope"]
    est_ml = [0.8, 1.1]
    est_reml = [0.9, 1.05]
    ci_ml = [(0.5, 1.1), (0.8, 1.4)]
    ci_reml = [(0.6, 1.2), (0.75, 1.35)]
    fig_varcomp(labels, est_ml, ci_ml, est_reml, ci_reml) |> display

    resid_q = randn(80)
    fig_diagnostic(resid_q) |> display

    groups = string.("g", 1:8)
    raw_means = randn(8) .* 2
    blups = raw_means .* 0.6
    fig_shrinkage(groups, raw_means, blups; boundary = false) |> display

    fits = [
        (; label = "ML", μ = 2 .+ 0.5 .* x),
        (; label = "REML", μ = 2.1 .+ 0.48 .* x),
    ]
    fig_disagreement(x, y, fits) |> display

    set_theme!()
    println("figures.jl self-run OK")
end
