# ch10-r-box.R -- produces the pre-rendered R block in book/wk10-relatedness.qmd.
# Run once, by hand:  Rscript data/ch10/ch10-r-box.R
# drmTMB 0.7.0 / R 4.6.0, reading data/2012/SparrowSurvival.csv.
#
# What it checks: drmTMB can build the additive relationship matrix A from a
# pedigree (id / dam / sire), which DRM.jl cannot do today. So we ask it to, and
# compare its answer with the one-line rule the chapter builds A from.

suppressMessages(library(drmTMB))

d <- read.csv("data/2012/SparrowSurvival.csv", na.strings = c("NA", ""),
              stringsAsFactors = FALSE)
d <- d[!is.na(d$Mass2), ]

founders <- unique(c(d$Dad, d$Mum))
ped <- rbind(
  data.frame(id = founders, dam = NA_character_, sire = NA_character_),
  data.frame(id = d$ChickNo, dam = d$Mum, sire = d$Dad)
)

A_r <- drmTMB:::drm_pedigree_additive_relationship(ped)
A_r <- A_r[d$ChickNo, d$ChickNo]              # the chick block, in file order

# The chapter's rule: 1/4 per shared parent off the diagonal, 1 on it.
same_sire <- outer(d$Dad, d$Dad, "==")
same_dam  <- outer(d$Mum, d$Mum, "==")
A_hand <- 0.25 * same_sire + 0.25 * same_dam
diag(A_hand) <- 1

off <- A_r[upper.tri(A_r)]

cat(sprintf("pedigree rows (chicks + founders): %d\n", nrow(ped)))
cat(sprintf("chick block of A: %d x %d\n", nrow(A_r), ncol(A_r)))
cat(sprintf("distinct off-diagonal values: %s\n",
            paste(sort(unique(off)), collapse = " ")))
cat(sprintf("max |A_drmTMB - A_by_hand| over all %d^2 entries: %g\n",
            nrow(A_r), max(abs(A_r - A_hand))))
