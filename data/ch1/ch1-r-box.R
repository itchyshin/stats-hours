# Class 1 translate box -- the R half, PRE-RENDERED.
#
# Run once by hand, from the repository root, with:
#   Rscript data/ch1/ch1-r-box.R
# Quarto does not execute this file; its captured output is pasted into the
# translate box in book/wk1-base-camp.qmd and labelled as pre-rendered.
#
# It reads the same archived file the Julia cells read: data/2012/MBodySize.csv
# (171 house sparrows, Lundy Island; provenance in data/2012/README.md).

suppressMessages(library(dplyr))

sp <- read.csv("data/2012/MBodySize.csv")

cat("nrow:", nrow(sp), "  ncol:", ncol(sp), "\n\n")

print(head(sp, 3))
cat("\n")

print(summary(sp[, c("Tarsus", "Wing")]))
cat("\n")

cat("mean wing:", mean(sp$Wing), "\n\n")

males <- subset(sp, Sex == "M")
cat("males:", nrow(males), "\n\n")

print(sp %>% group_by(Sex) %>% summarise(mean_wing = mean(Wing), n = n()))

cat("\nR version:", R.version.string, " dplyr:", as.character(packageVersion("dplyr")), "\n")
