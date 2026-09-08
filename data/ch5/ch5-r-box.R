# data/ch5/ch5-r-box.R -- provenance for the one R block in book/wk5-diagnostics.qmd.
#
# Run once by hand, NOT by Quarto:
#   Rscript data/ch5/ch5-r-box.R
# R 4.6.0, drmTMB 0.7.0, reading data/2012/FemaleSuccess.csv (the same archived
# file the chapter's Julia cells read). Its printed output is pasted verbatim
# into the chapter's `↔ TRANSLATE` box and is not executed at build time.

suppressMessages(library(drmTMB))
cat("R", as.character(getRversion()), "/ drmTMB",
    as.character(packageVersion("drmTMB")), "\n\n")

d <- read.csv("data/2012/FemaleSuccess.csv")
d$logEgg <- log(d$EggNo)

m1 <- drmTMB(bf(Fledglings ~ Age),          family = poisson(), data = d)
m2 <- drmTMB(bf(Fledglings ~ Age + logEgg), family = poisson(), data = d)

cat("AIC(m1) =", format(AIC(m1), digits = 10), "\n")
cat("AIC(m2) =", format(AIC(m2), digits = 10), "\n\n")

rp <- residuals(m1, type = "pearson")
cat("residuals(m1, type = \"pearson\") -- first three and SD:\n")
cat(format(head(rp, 3), digits = 7), "\n")
cat("sd =", format(sd(rp), digits = 7), "\n\n")

cat("anova(m1, m2):\n")
tryCatch(print(anova(m1, m2)),
         error = function(e) cat("Error in `anova()`:\n!", conditionMessage(e), "\n"))
