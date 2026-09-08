"""
    ItchyTheme

House Makie theme for "Stats Hours with Itchy", matched to the site palette
hardcoded in `docs/index.html`'s `:root` blocks (light) and
`:root:not([data-theme="light"])` / `:root[data-theme="dark"]` blocks (dark).

Font note: Newsreader, Fraunces and IBM Plex Mono (the site's web fonts, pulled
from Google Fonts in docs/index.html) are NOT installed as system fonts on this
Mac (checked via `fc-list`), so Makie — which resolves fonts from the local
font system, not from the web — cannot use them. We fall back to Georgia
(serif/display) and Menlo (mono), both present on this machine
(`/System/Library/Fonts/Supplemental/Georgia*.ttf`, `/System/Library/Fonts/Menlo.ttc`).
"""
module ItchyTheme

using CairoMakie
using Makie
using Statistics

export theme_itchy, save_svg_pair, selftest, MAX_SVG_POINTS,
    LIGHT, DARK, mode_colors

# ── palette (hardcoded from docs/index.html :root blocks) ──────────────────

const LIGHT = (
    paper       = colorant"#F2F4F4",
    raised      = colorant"#FFFFFF",
    ink         = colorant"#17211F",
    body        = colorant"#243230",
    muted       = colorant"#5C6866",
    accent      = colorant"#1F5F5B",
    accent_soft = colorant"#DCEAE7",
    warn        = colorant"#A6522C",
)

const DARK = (
    paper       = colorant"#0F1614",
    raised      = colorant"#151F1D",
    ink         = colorant"#E8EEEB",
    body        = colorant"#CFD9D6",
    muted       = colorant"#93A29E",
    accent      = colorant"#63C1B5",
    accent_soft = colorant"#16302E",
    warn        = colorant"#DE9366",
)

mode_colors(mode::Symbol) = mode === :dark ? DARK : LIGHT

# ── fonts: Newsreader/Fraunces/IBM Plex Mono not installed locally; fall back ──

const SERIF_FONT = "Georgia"       # stand-in for Newsreader
const DISPLAY_FONT = "Georgia Bold" # stand-in for Fraunces
const MONO_FONT = "Menlo"          # stand-in for IBM Plex Mono

const MAX_SVG_POINTS = 5000

"""
    theme_itchy(mode=:light) -> Makie.Theme

House theme. `mode` is `:light` or `:dark`.
"""
function theme_itchy(mode::Symbol=:light)
    c = mode_colors(mode)
    Theme(
        backgroundcolor = c.paper,
        textcolor = c.ink,
        fontsize = 16,
        font = SERIF_FONT,
        palette = (color = [c.accent, c.warn, c.muted, c.ink],),
        Axis = (
            backgroundcolor = c.raised,
            xgridcolor = (c.muted, 0.15),
            ygridcolor = (c.muted, 0.15),
            xtickcolor = c.muted,
            ytickcolor = c.muted,
            leftspinecolor = c.muted,
            bottomspinecolor = c.muted,
            rightspinevisible = false,
            topspinevisible = false,
            titlecolor = c.ink,
            titlefont = DISPLAY_FONT,
            xlabelcolor = c.body,
            ylabelcolor = c.body,
            xticklabelcolor = c.muted,
            yticklabelcolor = c.muted,
            xticklabelfont = MONO_FONT,
            yticklabelfont = MONO_FONT,
        ),
        Legend = (
            backgroundcolor = c.raised,
            framecolor = c.muted,
            labelcolor = c.ink,
        ),
        Scatter = (color = c.accent, strokecolor = c.ink, strokewidth = 0.5),
        Lines = (color = c.accent,),
        Band = (color = (c.accent, 0.18),),
    )
end

"""
    save_svg_pair(fig_fn, path_stem)

Render `fig_fn(mode::Symbol) -> Figure` under both `:light` and `:dark`,
saving to `<path_stem>-light.svg` and `<path_stem>-dark.svg`. If the figure
plots more than `MAX_SVG_POINTS` points (as reported by `fig_fn`, via a
second return value, or assumed false when not provided), PNG @2x is saved
instead of SVG.
"""
function save_svg_pair(fig_fn, path_stem::AbstractString)
    for mode in (:light, :dark)
        set_theme!(theme_itchy(mode))
        result = fig_fn(mode)
        fig, big = result isa Tuple ? result : (result, false)
        suffix = mode === :light ? "light" : "dark"
        if big
            path = "$(path_stem)-$(suffix).png"
            save(path, fig; px_per_unit = 2)
        else
            path = "$(path_stem)-$(suffix).svg"
            save(path, fig)
        end
        set_theme!()
    end
    return nothing
end

"""
    selftest(stem)

Draw a tiny scatter+line figure and save it under both light and dark modes
via `save_svg_pair`, to `<stem>-light.svg` / `<stem>-dark.svg`.
"""
function selftest(stem::AbstractString)
    function draw(mode::Symbol)
        x = 1:10
        y = x .+ 0.5 .* sin.(x)
        fig = Figure(size = (480, 320))
        ax = Axis(fig[1, 1]; xlabel = "x", ylabel = "y", title = "Itchy theme self-test")
        scatter!(ax, x, y)
        lines!(ax, x, y)
        fig
    end
    save_svg_pair(draw, stem)
    return nothing
end

end # module
