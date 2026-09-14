# Run a chapter

Each notebook is generated from its chapter (`quarto convert book/<chapter>.qmd`) with one bootstrap
cell prepended: it installs the engine from GitHub (no registry needed) and fetches the house theme and
the data. **The hosted path is not yet tested** — the reader-environment probe (minutes to first fit on
Colab's Julia runtime and on Binder) has not been run; the badges below are wired for the day the
repository is public.

| chapter | open |
|---|---|
| Preface — why one engine | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk0-preface.ipynb) |
| Class 1 — base camp | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk1-base-camp.ipynb) |
| Class 2 — the linear model | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk2-linear-models.ipynb) |
| Class 3 — the shape of the noise | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk3-glms.ipynb) |
| Class 4 — when the family lies about the spread | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk4-overdispersion.ipynb) |
| Class 5a — is the model any good? | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk5-diagnostics.ipynb) |
| Class 5b — which model? | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk5b-comparison.ipynb) |
| Class 6 — rows are not strangers | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk6-random-intercepts.ipynb) |
| Class 7 — not everyone shares a slope | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk7-random-slopes.ipynb) |
| Class 8 — same model, two answers | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk8-reml-vs-ml.ipynb) |
| Class 9 — both at once | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk9-glmms.ipynb) |
| Class 10 — not even the groups are strangers | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk10-relatedness.ipynb) |
| Appendix A — simulation as a way of thinking | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/appendix-a-simulation.ipynb) |
| Appendix B — where the engine stops | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/appendix-b-engine.ipynb) |
| Coda — where you go next | [Colab](https://colab.research.google.com/github/itchyshin/stats-hours/blob/main/notebooks/wk13-coda.ipynb) |

Regenerate after a chapter changes: `tools/make-notebooks.sh`.
