"""
    diagnostics.jl

Simulation-based diagnostic helpers for "Stats Hours with Itchy" that take a
live DRM fit — unlike `figures.jl`'s figure-grammar helpers, which take only
plain vectors / DataFrames, these call `simulate` and `residuals` on a fit
directly, so they live in their own file rather than in `figures.jl`.
"""

include("figures.jl")

using DRM
using Statistics
import Distributions          # qualified: DRM exports its own Poisson, Binomial, …

"""
    coef_se(fit, block, name; level = 0.95)

The Wald standard error of one named coefficient in one parameter block
(e.g. `coef_se(fit, :sigma, "Sex: male")`). Reads it off the width of that
coefficient's own confidence interval — `se = (upper - estimate) / z`, the
same normal quantile `confint` used to build the interval — rather than
from the fit's internal coefficient layout.
"""
function coef_se(fit, block, name; level::Real = 0.95)
    rows = confint(fit; parm = block, level = level)
    row = rows[findfirst(r -> r.coef == name, rows)]
    z = Distributions.quantile(Distributions.Normal(), 1 - (1 - level) / 2)
    (row.upper - row.estimate) / z
end

using LinearAlgebra

"""
    binomial_group_modes(y, eta, group, sigma_b; penalised = true)

Per-group effects for a binomial random-intercept fit, logit(p_i) = eta_i + u_g(i),
computed one group at a time — the engine's `ranef` returns an empty `Dict` for
non-Gaussian fits (DRM.jl #759), so the chapter that needs them computes them here.

`y` is the 0/1 response, `eta` the fixed part of the linear predictor for every row
(the fit's coefficients applied to the covariates, with u = 0), `group` the grouping
label of every row and `sigma_b` the fitted group standard deviation on the link scale.

Each group's effect is the value of u that maximises

    sum_i [ y_i log p_i + (1 - y_i) log(1 - p_i) ]  -  u^2 / (2 sigma_b^2)

with p_i = logistic(eta_i + u): the group's own likelihood, plus the penalty for
sitting far from the population's zero. That is the conditional mode — the value
the fit considers most likely for that group. Newton's method on one number,
started at zero.

`penalised = false` drops the penalty and returns what the group says on its own
evidence, borrowing nothing from the population. For a group whose responses are
all 0 or all 1 that maximiser does not exist — the likelihood climbs for ever —
and the function returns `-Inf` or `+Inf` for it rather than the point where the
arithmetic gave up, with `NaN` in the matching gradient slot.

Returns `(; levels, u, grad)`: the sorted group labels, the effect for each, and
the gradient of the objective at the answer (near zero when Newton converged).
"""
function binomial_group_modes(y, eta, group, sigma_b; penalised = true)
    logistic_(z) = 1 / (1 + exp(-z))
    levels = sort(unique(group))
    rows = Dict(g => Int[] for g in levels)
    for (i, g) in enumerate(group); push!(rows[g], i); end
    u = zeros(length(levels)); grad = zeros(length(levels))
    for (j, g) in enumerate(levels)
        r = rows[g]
        if !penalised && all(==(y[r[1]]), y[r])          # unanimous: no finite maximiser
            u[j] = y[r[1]] == 1 ? Inf : -Inf; grad[j] = NaN
            continue
        end
        uj = 0.0
        for _ in 1:100
            gr = penalised ? -uj / sigma_b^2 : 0.0
            h  = penalised ? -1 / sigma_b^2  : 0.0
            for i in r
                p = logistic_(eta[i] + uj)
                gr += y[i] - p
                h  -= p * (1 - p)
            end
            step = gr / h
            uj -= step
            abs(step) < 1e-10 && break
        end
        gr = penalised ? -uj / sigma_b^2 : 0.0
        for i in r; gr += y[i] - logistic_(eta[i] + uj); end
        u[j] = uj; grad[j] = gr
    end
    (; levels, u, grad)
end

"""
    profile_ll(yrot, h, lambda, Xrot; reml = false)

Log-likelihood of a one-generation animal model at heritability `h`, on data
already rotated by the eigenvectors of the relatedness matrix `A`: with
`A = U diag(lambda) U'`, `yrot = U' * y` and `Xrot = U' * X`, the covariance
of `yrot` is diagonal, `h * lambda_i + (1 - h)` times the total variance, so
fitting collapses to closed-form generalised least squares at each `h` —
`profile_ll` is the piece `fit_h2` calls at every grid point.

`reml = true` divides by `n - p` instead of `n` and adds one term for the
cost of having estimated the fixed effects: that is the whole of REML, which
the engine does not implement for a structured random effect (see
`appendix-b-engine.qmd`). Written out for the sake of pricing that gap in a
simulation, not because this book teaches the linear algebra in it.
"""
function profile_ll(yrot, h, lambda, Xrot; reml = false)
    n, p = length(yrot), size(Xrot, 2)
    w  = h .* lambda .+ (1 - h)
    XW = Xrot ./ w
    M  = Xrot' * XW
    b  = M \ (XW' * yrot)
    r  = yrot - Xrot * b
    m  = reml ? n - p : n
    s2 = sum(abs2.(r) ./ w) / m
    ll = -0.5 * (m * log(s2) + sum(log, w) + m + m * log(2π))
    return reml ? ll - 0.5 * logdet(M) : ll
end

"""
    fit_h2(yrot, lambda, Xrot, grid; reml = false)

Grid-search heritability estimate for a one-generation animal model, via
`profile_ll` at every value in `grid`. Returns `(h2, lo, hi)`: the grid value
maximising the profile log-likelihood, and the widest interval of grid
values within `quantile(Chisq(1), 0.95) / 2` of that maximum — a 95%
profile-likelihood interval.

`lambda` and `Xrot` are the eigenvalues and rotated design matrix from the
same eigendecomposition of `A` used to build `yrot`; compute them once and
reuse them across many calls (as the recovery study in `wk10-relatedness.qmd`
does), since recomputing the eigendecomposition per call is what the
rotation trick exists to avoid.
"""
function fit_h2(yrot, lambda, Xrot, grid; reml = false)
    lls = [profile_ll(yrot, h, lambda, Xrot; reml = reml) for h in grid]
    inside = lls .>= maximum(lls) - Distributions.quantile(Distributions.Chisq(1), 0.95) / 2
    return (h2 = grid[argmax(lls)], lo = grid[findfirst(inside)], hi = grid[findlast(inside)])
end
