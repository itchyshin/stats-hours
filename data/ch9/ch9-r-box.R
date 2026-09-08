# data/ch9/ch9-r-box.R -- provenance for the one R block in book/wk9-glmms.qmd.
#
# Run once by hand, NOT by Quarto:
#   Rscript data/ch9/ch9-r-box.R
# R 4.6.0, drmTMB 0.7.0, lme4 2.0.1, reading data/2012/SparrowSurvival.csv (the
# same archived file the chapter's Julia cells read, dropped to rows complete on
# Survival, Mass2 and BroodNo). Its printed output is pasted verbatim into the
# chapter's `<-> TRANSLATE` box and is not executed at build time. Everything in
# that box -- all four blocks -- comes from this script and from nowhere else.

suppressMessages(library(drmTMB))
suppressMessages(library(lme4))
cat("R", as.character(getRversion()),
    "/ drmTMB", as.character(packageVersion("drmTMB")),
    "/ lme4", as.character(packageVersion("lme4")), "\n\n")

d <- read.csv("data/2012/SparrowSurvival.csv")
d <- d[!is.na(d$Survival) & !is.na(d$Mass2) & !is.na(d$BroodNo), ]
cat("rows", nrow(d), " broods", length(unique(d$BroodNo)), "\n\n")

## Block 1 -- drmTMB, whose marginal likelihood is TMB's Laplace approximation.
m <- drmTMB(bf(Survival ~ Mass2 + (1 | BroodNo)), family = binomial(), data = d)
s <- summary(m)
cat("--- drmTMB (Laplace) ---\n")
print(s$coefficients)
print(s$parameters[, c("estimate", "std_error")])
cat("logLik:", format(as.numeric(logLik(m)), digits = 4), "\n\n")

## Blocks 2-4 -- lme4, at three amounts of effort on the same integral.
## nAGQ = 1 is Laplace; nAGQ > 1 is ADAPTIVE Gauss-Hermite quadrature, centred
## on each group's conditional mode. Neither is DRM.jl's rule, which is
## non-adaptive 32-node Gauss-Hermite centred at zero.
glmer_block <- function(nagq, label) {
  g <- glmer(Survival ~ Mass2 + (1 | BroodNo), family = binomial, data = d,
             nAGQ = nagq)
  cat("--- lme4::glmer, nAGQ = ", nagq, " (", label, ") ---\n", sep = "")
  print(round(summary(g)$coefficients[, 1:3], 4))
  cat("  brood SD =", format(attr(VarCorr(g)$BroodNo, "stddev"), digits = 7),
      "  logLik =", format(as.numeric(logLik(g)), digits = 10),
      "  AIC =", format(AIC(g), digits = 10), "\n\n")
}

glmer_block(1,  "Laplace, the default")
glmer_block(9,  "adaptive GHQ")
glmer_block(25, "adaptive GHQ")
