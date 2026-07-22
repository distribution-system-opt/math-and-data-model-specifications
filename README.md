# Distribution System Model & Data Specification

[![Docs: stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://distribution-system-opt.github.io/math-and-data-model-specifications/stable/)
[![Docs: dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://distribution-system-opt.github.io/math-and-data-model-specifications/dev/)
[![Documentation](https://github.com/distribution-system-opt/math-and-data-model-specifications/actions/workflows/documentation.yml/badge.svg)](https://github.com/distribution-system-opt/math-and-data-model-specifications/actions/workflows/documentation.yml)

> [!WARNING]
> **Work in progress — not yet validated.** This repository is currently being
> staged: its content has not yet been validated for consistency with the source
> specification, and may change without notice. Do not rely on it yet. Once the
> content has been reviewed and validated, a version will be tagged — until then
> there is no released version.

The mathematical and data-model specification for four-wire distribution-system
optimal power flow (OPF), developed by the IEEE PES Task Force on Benchmarking
Multiconductor OPF for Distribution Systems and published as a
[Documenter.jl](https://documenter.juliadocs.org) site.

📖 **Rendered docs:** <https://distribution-system-opt.github.io/math-and-data-model-specifications>

The specification source lives as plain Markdown under [`docs/src/spec/`](docs/src/spec)
and evolves through pull requests rather than by editing a PDF.

## IEEE PES Task Force

This specification is developed by the IEEE PES Task Force on **Benchmarking
Multiconductor OPF (BMOPF) for Distribution Systems**.

| Role | Name | Affiliation |
|------|------|-------------|
| Chair | Matthew Deakin | Newcastle University, UK |
| Co-chair | Frederik Geth | University of Queensland, Australia |
| Secretary | Amritanshu Pandey | University of Vermont, USA |

## Motivation

Reliable benchmarks are essential for validating and comparing power-system
algorithms, yet unbalanced distribution networks have historically lacked a common,
open benchmark format. Transmission-oriented libraries such as
[PGLib](https://power-grid-lib.github.io/) are positive-sequence only and do not
carry over to unbalanced distribution networks, while the established IEEE
distribution test feeders are not distributed under open licences.

This Task Force fills that gap by defining a shared **mathematical model** and
**data model** for four-wire distribution-system OPF, so that benchmark problems
can be exchanged, compared, and reproduced across tools. This repository is the
canonical, version-controlled home of that specification and its JSON Schema — the
successor to the earlier LaTeX/PDF *Mathematical Model and Data Model* document.

The models deliberately target the features universally required for distribution
OPF — 1-to-4-wire lines with explicit neutral and earth (no Kron reduction), meshed
and electrically parallel branches, and perfect or impedance grounding — expressed
in SI units and serialised as JSON against an accompanying schema.

## Contributing

Contributions of all kinds are welcome — corrections, clarifications, new content,
and modelling proposals. Anyone can open issues and pull requests; project
maintainers from the Task Force review and merge. See the
[Contributing guide](docs/src/contributing.md) for the review tiers, modelling
principles, governance, and release policy.

## Licensing

This repository — all specification text, equations, figures, data-model
definitions, and the accompanying JSON Schema — is licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/); see [LICENSE](LICENSE).

**By submitting a pull request, you agree to license your contribution under the
same CC BY 4.0 terms.**

(Benchmark **datasets** built against this specification are a separate concern and
are licensed independently — each inherits the licence of its upstream source,
recorded in its `meta.license` field.)

## Citation

The specification is versioned and not static; please cite the specific version
(git tag) you used. Benchmark cases carry original-source attribution in their
metadata — cite those sources when using specific networks.

## Building locally

Requires [Julia](https://julialang.org) 1.10 or newer.

```bash
# Install the documentation dependencies (first time only)
julia --project=docs -e 'using Pkg; Pkg.instantiate()'

# Build the site into docs/build
julia --project=docs docs/make.jl
```

Open `docs/build/index.html` in a browser to preview.

### Building the PDF

The site is also compiled to a single PDF (like [JuMP's manual](https://jump.dev/JuMP.jl/stable/))
using Documenter's LaTeX backend and the self-contained
[`tectonic`](https://tectonic-typesetting.github.io) TeX engine. Set `DOCS_PDF=true`
to build it locally in addition to the HTML:

```bash
DOCS_PDF=true julia --project=docs docs/make.jl
```

The PDF is written to `docs/build/DistributionSystemModelSpecification.pdf` (and is
linked from the site's home page). SVG figures are rasterised to PDF automatically
during the build.

Two system tools are required for the PDF (already handled in CI):

- **DejaVu fonts** — selected by the Documenter LaTeX template
  (`brew install --cask font-dejavu`, or `apt install fonts-dejavu`).
- **Pygments** (`pygmentize`) — for `minted` code highlighting
  (`brew install pygments`, or `apt install python3-pygments`).

`tectonic` itself needs no installation — it ships as a Julia artifact via
`tectonic_jll`.

## Continuous integration and deployment

The [Documentation workflow](.github/workflows/documentation.yml) builds the site
(HTML + PDF) on every push and pull request. It deploys the development docs on
pushes to `main`, a released version on each `v*` tag, and a preview on pull
requests. Deployment publishes to the `gh-pages` branch, which GitHub Pages serves.

### Versioned documentation

Historical versions are handled automatically by Documenter's `deploydocs` — no
extra configuration. Each build lands in its own folder on `gh-pages`, and a
version selector (top-left of the site) switches between them:

- **`dev`** — always tracks the latest `main`.
- **`vX.Y.Z`** — one immutable folder per release tag; these are the historical
  versions and never change once published.
- **`stable`** — an alias pointing at the most recent release tag.

To cut a release, tag a commit on `main` with a semver `v*` tag and push it:

```bash
git tag v0.2.2
git push origin v0.2.2
```

The tag trigger is restricted to `v*`, so JSON-Schema tags (`schema-v*`) do not
deploy docs. See the [Contributing guide](docs/src/contributing.md) for the tag
conventions and release policy.
