# Chapter 2 drafting note — archived elsewhere

The author's private first-person drafting note for chapter 2 (2026-09-06) is kept verbatim in the
author's own notes, outside this repository. The public version of the note, formerly the "Honest note from drafting this chapter" section at
the foot of the chapter, was moved here on 2026-09-07 during the reader pass: it is a drafting record,
not teaching, and it named an engine issue number and a superseded version of the chapter the reader
never saw.

---

## Honest note from drafting this chapter

**Did one engine help or hurt here? It helped more than expected, and it costs exactly three things, two of which are display bugs rather than architecture.**

**What genuinely worked.** The "μ and σ" framing turned the architecture's biggest liability into the chapter's spine. There was no need to apologise for the second table; it could open the chapter, because "where are the birds, and how spread out are they" is a *better* first sentence about a linear model than "the best-fitting line", and it is honest that `lm()` reports both quantities too. The final beat, where `Sex` moves into the σ formula, turned out to be a *better* payoff on the real Lundy birds than on the seeded data this chapter used to run on: the term does not earn its keep by AIC, and watching Itchy say so on stage — instead of the model conveniently confirming the lesson plan — is a demonstration no scripted example could match.

The comparison box got **better** under the one-engine rule, not worse. Going looking for "in R you would write `lm()`" turned up a real, verified, six-significant-figure disagreement instead: identical coefficients, identical log-likelihood, residual SDs differing by exactly √(n/(n−p)). Class 2 now plants the seed that Chapter 8 harvests.

**What had to be worked around, in order of cost.**

1. **The `NaN` in the σ row was the chapter's biggest tax, and it is gone.** When this chapter was first drafted the suppression was **blanket**: a real predictor in the σ formula printed `NaN NaN` too, even though "males and females vary equally" is a perfectly sensible null, so the flagship location-scale demonstration shipped with an untestable coefficient. DRM.jl #754 fixed it, and the chapter has been re-executed against the merged engine. The scene is *better* for the fix rather than merely unblocked: the σ table now prints its null above the columns, so the class can compare a unit-dependent null it should ignore with a dispersion null it should not, and the `Sex`-in-σ row now agrees with AIC out loud instead of going untested. The two passages that were marked as awaiting that merge are rewritten against the new output, not patched.
2. **No R², also gone.** `r2_constant_sigma` now exists, equals `lm()`'s R² exactly on a constant-σ Gaussian fit, and refuses with a named reason on a modelled σ. The chapter keeps the by-hand computation first, because the mixed-divisor mistake is the actual lesson and a button cannot teach it, and then uses the refusal on `fit3` as the payoff for the function's awkward name. The refusal is described as current behaviour, since DRM.jl classifies the function experimental in `docs/src/api-stability.md` and says the refusals are the part that may widen.
3. **The `bf` wrapper is a smaller problem than expected, and the error message is why.** Forgetting it produces a `MethodError` that names the wrong argument and lists what `drm` accepts. That turned a wart into one of the chapter's better teaching moments; error-message literacy arrives free in Class 2 instead of waiting for its own chapter.

**Two things a reviewer should push back on.** One comparison box was used where the convention says Weeks 1-2 should have "almost none"; it deletes cleanly if that is wrong. And the box's machine-readable tag lines contain em-dashes, which the house voice rule forbids in prose, kept only as format sigils, never in a line of actual writing.

**Verdict.** One engine works at this rung, on real data as well as the seeded stand-in it replaced, and it now costs one wrapper rather than one wrapper and two display bugs. The wrapper pays for itself in the last five minutes of the class. The two display problems that this chapter was written around have both been fixed in the engine and the chapter re-executed against the fix; what was a tax is now two of the better beats in the hour, which is the argument for writing the book and the engine in the same building.
