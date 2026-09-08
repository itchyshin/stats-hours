# theme_itchy.R
#
# House ggplot2 theme for "Stats Hours with Itchy", matched to the site
# palette hardcoded in docs/index.html's :root blocks (light) and
# :root:not([data-theme="light"]) / :root[data-theme="dark"] blocks (dark).
#
# Font note: Newsreader, Fraunces and IBM Plex Mono (the site's web fonts)
# are not installed as system fonts on this Mac, so ggplot2/svglite fall back
# to the R graphics device defaults (sans) rather than downloading fonts.

suppressMessages(library(ggplot2))

if (!requireNamespace("svglite", quietly = TRUE)) {
  install.packages("svglite")
}

# ── palette (hardcoded from docs/index.html :root blocks) ──────────────────

.itchy_light <- list(
  paper = "#F2F4F4", raised = "#FFFFFF", ink = "#17211F", body = "#243230",
  muted = "#5C6866", accent = "#1F5F5B", accent_soft = "#DCEAE7", warn = "#A6522C"
)

.itchy_dark <- list(
  paper = "#0F1614", raised = "#151F1D", ink = "#E8EEEB", body = "#CFD9D6",
  muted = "#93A29E", accent = "#63C1B5", accent_soft = "#16302E", warn = "#DE9366"
)

#' House theme for ggplot2
#'
#' @param mode "light" or "dark"
#' @return a ggplot2 theme object
theme_itchy <- function(mode = "light") {
  c <- if (mode == "dark") .itchy_dark else .itchy_light

  theme_minimal(base_size = 13) +
    theme(
      plot.background = element_rect(fill = c$paper, colour = NA),
      panel.background = element_rect(fill = c$raised, colour = NA),
      panel.grid.major = element_line(colour = c$muted, linewidth = 0.15),
      panel.grid.minor = element_blank(),
      axis.text = element_text(colour = c$muted),
      axis.title = element_text(colour = c$body),
      plot.title = element_text(colour = c$ink, face = "bold"),
      plot.subtitle = element_text(colour = c$muted),
      legend.background = element_rect(fill = c$raised, colour = NA),
      legend.text = element_text(colour = c$ink),
      legend.title = element_text(colour = c$ink),
      text = element_text(colour = c$ink)
    )
}

#' Self-test: draw a tiny scatter+line and save as SVG via svglite
#'
#' @param path output SVG path
itchy_selftest <- function(path) {
  set.seed(1)
  x <- 1:10
  y <- x + 0.5 * sin(x)
  df <- data.frame(x = x, y = y)

  p <- ggplot(df, aes(x, y)) +
    geom_point(colour = .itchy_light$accent) +
    geom_line(colour = .itchy_light$accent) +
    labs(title = "Itchy theme self-test", x = "x", y = "y") +
    theme_itchy("light")

  svglite::svglite(path, width = 5, height = 3.5)
  print(p)
  dev.off()
  invisible(path)
}
