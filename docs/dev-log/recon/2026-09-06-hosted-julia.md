# Hosted Julia Notebook Options for Stats Hours

## Quick comparison

| Option | Julia available how | First-cell cost | Private repo ok? | Source |
|--------|-------------------|-----------------|------------------|--------|
| **Google Colab** | Native runtime selector (1.11 LTS) UNVERIFIED ([JuliaHub blog](https://juliahub.com/blog/julia-now-available-on-google-colab)) | Instant (no bootstrap) | Yes, via `Pkg.add(url="...")` | [Colab release notes](https://developers.google.com/colab/release-notes) |
| **Binder (mybinder.org)** | repo2docker + Project.toml + Manifest.toml UNVERIFIED ([repo2docker docs](https://repo2docker.readthedocs.io/en/2024.03.0/config_files.html)) | ~2–5 min initial build; cached launches <10s | No (public repos only) | [mybinder.readthedocs.io](https://mybinder.readthedocs.io/en/latest/) |
| **r-universe.dev** | N/A (for R twin drmTMB only): `options(repos = c(user = 'https://username.r-universe.dev', CRAN = 'https://cloud.r-project.org'))` then `install.packages("drmTMB")` UNVERIFIED ([rOpenSci blog](https://ropensci.org/blog/2023/08/01/r-universe-and-cran/)) | N/A | N/A | [docs.r-universe.dev](https://docs.r-universe.dev/) |
| **JuliaHub** | Pluto.jl cloud notebooks UNVERIFIED ([JuliaHub help](https://help.juliahub.com/juliahub/stable/tutorials/pluto_notebooks/)) | Instant (cloud-hosted) | Likely via cloud IDE | [juliahub.com/products](https://juliahub.com/products/juliahub) |
| **GitHub Codespaces** | Julia via .devcontainer/devcontainer.json (official [JuliaLang/devcontainer-templates](https://github.com/JuliaLang/devcontainer-templates)) UNVERIFIED ([Julia discourse](https://discourse.julialang.org/t/how-to-load-a-devcontainer-with-julia-into-github-codespaces-in-2025/126094)) | ~5–10 min first Codespace + Julia build | Yes (repo owner only) | [Codespaces docs](https://docs.github.com/en/codespaces) |
| **Kaggle** | Not officially supported (Python, R only); community workarounds exist UNVERIFIED ([Kaggle feedback #230935](https://www.kaggle.com/product-feedback/230935)) | N/A | N/A | [kaggle.com](https://kaggle.com) |

**Session limits:** Google Colab free tier = 12 hours max, ~90 min idle timeout UNVERIFIED ([Colab FAQ](https://research.google.com/colaboratory/faq.html)). Binder has no hard session limit but rebuilds expire after inactivity. r-universe and JuliaHub assume R/Julia installations on the reader's machine; Codespaces accrue billing after free monthly hours.

---

## What the probe should measure

To validate which platform is best for readers, run each notebook's **bootstrap + first two code cells** (the ones that instantiate the data) and time:

1. **Cell 1 startup**: Time from "execute cell" click to `Pkg.add(url="...")` completing and printing the first success message.
2. **Cell 2 data load**: Time from start to the two CSV downloads and `.jl` file reads finishing (look for the summary print at the end).
3. **Wall-clock total**: Boot + bootstrap + data load in seconds.
4. **Idempotence check**: Restart the kernel/session and re-run Cell 1 and 2. Does precompilation or caching make the second run faster? By how much?

For Binder + Codespaces, also measure cold-start (first launch of a new repo) vs. warm-start (returning to an existing environment).

---

## Recommendation

**Google Colab is the first choice for reader access.** UNVERIFIED Native Julia 1.11 runtime, zero bootstrap needed, GPUs available, and no installation friction. Session limits (12 hr) are adequate for a chapter. **Second option: self-hosted Binder** (if the repo can be public) or **GitHub Codespaces** (if the org pays for hours). **For R twin (drmTMB):** r-universe binaries solve the CRAN-install barrier; users set one repo option and `install.packages()` works. **Avoid Kaggle**—Julia is unsupported; workarounds are not user-friendly.

