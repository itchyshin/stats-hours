# ch7-r-box.R — produces the pre-rendered R block in book/wk7-random-slopes.qmd.
#
# Run once, by hand, from the repository root:
#     Rscript data/ch7/ch7-r-box.R
#
# It is NOT executed by Quarto, and nothing in the chapter depends on it at build
# time. It reads data/ch7/sparrows-weight.csv, which the chapter's first cell writes.

suppressPackageStartupMessages({
  library(drmTMB)
  library(lme4)
})

d <- read.csv("data/ch7/sparrows-weight.csv")

cat("R", as.character(getRversion()),
    "| drmTMB", as.character(packageVersion("drmTMB")),
    "| lme4", as.character(packageVersion("lme4")),
    "|", nrow(d), "rows,", length(unique(d$BirdID)), "birds\n\n")

## the same model, the same one term, in the R twin of the engine
m  <- drmTMB(bf(Wing ~ wc + (1 + wc | BirdID)), family = gaussian(), data = d)
sm <- summary(m)
cv <- sm$covariance
pr <- sm$parameters
se <- function(pat) pr$std_error[grepl(pat, rownames(pr), fixed = TRUE)]

cat("drmTMB (estimator: ", sm$estimator, ")\n", sep = "")
cat(sprintf("  sd(intercept) %.4f  (SE %.4f)\n", cv$from_sd, se("BirdID):(Intercept)")))
cat(sprintf("  sd(slope)     %.4f  (SE %.4f)\n", cv$to_sd,   se("BirdID):wc")))
cat(sprintf("  correlation   %+.4f  (SE %.4f)   <- printed, with a standard error\n",
            cv$correlation, se("cor((Intercept),wc | BirdID)")))
cat(sprintf("  sigma         %.4f\n", sigma(m)[1]))
cat(sprintf("  logLik        %.4f\n\n", as.numeric(logLik(m))))

## lme4, as comparison only: its default is REML, ours is ML (Class 8)
vc_line <- function(fit, label) {
  v <- VarCorr(fit)[["BirdID"]]
  cat(sprintf("%-20s sd0 %.4f  sd1 %.4f  cor %+.4f  sigma %.4f  logLik %.4f\n",
              label, sqrt(v[1, 1]), sqrt(v[2, 2]),
              v[1, 2] / sqrt(v[1, 1] * v[2, 2]), sigma(fit), as.numeric(logLik(fit))))
}
cat("lme4::lmer, same formula\n")
vc_line(lmer(Wing ~ wc + (1 + wc | BirdID), data = d), "  default (REML)")
vc_line(lmer(Wing ~ wc + (1 + wc | BirdID), data = d, REML = FALSE), "  REML = FALSE (ML)")
