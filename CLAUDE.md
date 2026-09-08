@AGENTS.md

## Notes for Claude Code

`AGENTS.md` is the source of truth.

- The manuscript is prose **and** executable evidence. Treat a number in a chapter the way you would
  treat a test assertion: it either ran, or it does not belong there.
- The chapters are `book/*.qmd`, executed at build; `docs/site/` is generated and committed; `docs/index.html`
  is a hand-written redirect. Never invent output — a number, figure, or equation that did not run is a defect.
- DRM.jl and drmTMB are separate repositories and are often busy. Check before editing either.
