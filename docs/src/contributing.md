# Contributing

This specification evolves through pull requests rather than by editing a PDF.
Corrections, clarifications, and new content are all welcome.

!!! note "Licensing of contributions"
    This repository is licensed under
    [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). **By submitting a
    pull request, you agree to license your contribution under the same CC BY 4.0
    terms.**

## Governance

The specification is maintained by **project maintainers** — members of the
IEEE PES BMOPF Task Force who review pull requests and hold merge rights. Anyone
may open issues, join the discussion, and propose changes: the goal is for the
community to drive the specification's direction, with maintainers reviewing,
ratifying, and merging.

Maintainers aim to give an **initial response within about 48 hours** — a review
comment, a question, or a merge, not necessarily a final decision. Larger
normative changes usually take longer to reach consensus (see the review tiers
below).

## Editing a page

Every page has an **"Edit on GitHub"** link (top right) that takes you straight
to its Markdown source under [`docs/src/`](https://github.com/distribution-system-opt/math-and-data-model-specifications/tree/main/docs/src).
For small fixes you can edit in the GitHub web UI and open a pull request without
cloning the repository.

## Building the docs locally

Requires [Julia](https://julialang.org) 1.10 or newer.

```bash
# Install the documentation dependencies (first time only)
julia --project=docs -e 'using Pkg; Pkg.instantiate()'

# Build the HTML site into docs/build
julia --project=docs docs/make.jl
```

Open `docs/build/index.html` to preview. To also build the PDF, set
`DOCS_PDF=true` (see the [README](https://github.com/distribution-system-opt/math-and-data-model-specifications#building-the-pdf)
for the two system tools that requires).

## Types of change and review expectations

Not all contributions carry the same weight. This specification is developed by
the IEEE PES Task Force on Benchmarking Multiconductor OPF (BMOPF) for
Distribution Systems, and parts of it are **normative**: the data model field
names, the mathematical constraints, and the accompanying **JSON Schema** define
a contract that datasets and tools depend on. The review a pull request receives
scales with how much of that contract it touches.

### Editorial / minor changes — fast track

Typo fixes, wording and grammar, formatting, broken links, clearer phrasing that
preserves meaning, and new illustrative examples or FAQ entries that do not
change the model. These can be reviewed and merged quickly, typically by a single
maintainer. Open a pull request directly — no prior discussion is needed.

### Explanatory / non-normative changes — standard review

New tutorials, expanded derivations, restructured sections, added figures, and
notation clarifications that **do not alter any field name, equation, bound, or
schema constraint**. These get a normal maintainer review. It is generally fine
for the Documenter site to carry *more* explanatory detail than the baseline
document, provided the normative content stays consistent.

### Normative / major changes — Task Force review

Any change that touches the **contract** requires Task Force review and should
**start as an issue or discussion before a pull request**, because it can take
significant time to agree and ratify. This includes:

- **Data model fields** — adding, removing, renaming, or re-typing any field; or
  changing its units, optionality, or meaning.
- **The JSON Schema** — any change to the schema, which must stay in lock-step
  with the documented field names. A field rename is not complete until the prose,
  the tables, the worked example, and the schema all agree.
- **Mathematical model** — adding, removing, or changing constraints, bounds,
  objectives, or the sets/notation they rely on.
- **Supported values** — changing the permitted configurations, string
  enumerations, or element subtypes.

For these, expect maintainers to ask for: a clear motivation, the impact on
existing datasets, a corresponding schema update, and — where a field or value is
renamed or removed — a migration note and, if warranted, a deprecation path.
Contract changes move the schema version; see
[Versioning and releases](#Versioning-and-releases) below.

When in doubt about which tier a change falls into, open an issue and ask.

## Modelling principles

Normative contributions are judged against the principles below. They exist to
keep the specification a single, coherent reference rather than a collection of
alternatives, and to keep it faithful to real distribution-system physics.

- **State of the art.** Models must be consistent with contemporary
  distribution-system modelling and accepted physics and engineering practice.
  A proposed model should be defensible against the current literature.

- **Do not avoid nonlinearity.** The reference model captures the true physics,
  including where that is nonlinear or nonconvex (constant-power loads, apparent
  power limits, voltage magnitudes). Convex relaxations, linearisations, and
  lifts to other variable spaces are legitimate *downstream* choices for solvers
  and studies — they are not baked into the reference formulation.

- **Well-defined edge-case behaviour.** Degenerate and limiting configurations
  must be specified, not left implementation-defined. For example, an idealised
  (zero-impedance) transformer, an ungrounded or floating neutral, and
  single-phase / triplex connections must all have a defined meaning.

- **No hard-coded grounding assumptions.** Grounding is always explicit and
  general — perfect, through an impedance, or ungrounded — and never assumed.
  Neutral and earth conductors stay explicit; no scheme silently Kron-reduces
  them away.

- **Respect object semantics.** Each object means one thing. A shunt can be
  numerically parameterised to behave like a capacitor, but a capacitor bank must
  be modelled as a `capacitor`. Do not overload one object to stand in for
  another; add or use the semantically correct element instead.

- **One canonical model, not a model zoo.** The specification defines a single
  reference formulation per element, not a menu of competing modelling
  approaches. Where several mathematically equivalent representations exist,
  choose one (a continuously differentiable form is preferred) and document it;
  alternatives may be *mentioned* but are not normative.

- **The nodal contract is voltages and currents.** The interface between a device
  and the network is the complex bus voltage and the complex current injected at
  its terminals; nodal balance (KCL) is enforced in currents. Device models may
  introduce power variables or other internal variables for their own
  formulation, but what they exchange with the network at a bus is current and
  voltage.

- **Prefer solver-friendly, differentiable forms.** When a constraint admits
  several equivalent expressions, prefer a continuously differentiable one, so
  the reference formulation is directly usable by gradient-based solvers.

- **Well-posed and objective-agnostic.** Reference problems should be well-posed
  (the default generation-cost objective, for instance, is chosen because it is
  well-posed and typically has a unique solution). The invariant is the network
  physics, not any particular objective — models should not bake in assumptions
  that only make sense for one problem class.

- **Explicit, SI, and portable data.** The data model uses SI units (no
  per-unit, no unit fields), represents complex quantities as pairs of real
  numbers, lists buses and terminals explicitly, and identifies elements by
  unique string IDs. New fields should follow these conventions.

- **Compose from primitives.** Prefer building richer elements from documented
  primitives (for example, transformers as idealised winding pairs plus series
  impedance) over introducing bespoke, monolithic models.

## Conventions

- **Keep the prose, tables, worked example, and JSON Schema in agreement.** The
  field names in the text are normative; they must match the schema exactly.
- Define symbols on the [Notation](spec/notation.md) page and reuse them; add new
  terms to the [Glossary](glossary.md).
- Keep pages self-contained — this repository is the canonical home of the
  specification and should not depend on external manuals.
- Figures live in `docs/src/spec/assets/` as SVG; they are rasterised
  automatically for the PDF build.

## Pull request workflow

1. For a normative change, **open an issue first** (see above). Editorial fixes
   can skip straight to a pull request.
2. Branch from `main`.
3. Make your change and build locally to check it renders.
4. Open a pull request. CI builds the docs (and a preview) on every PR.
5. Once merged to `main`, the site rebuilds and redeploys automatically.

## Versioning and releases

Changes are staged on the `main` branch, and the documentation built from `main`
is always available as the live development version. When a batch of merged
changes has accumulated that warrants a release, maintainers **tag a version**.

- Versioning follows **[semantic versioning](https://semver.org)**.
- The **specification** and the **JSON Schema** are versioned independently. We
  expect the specification to be tagged more often than the schema — editorial
  and explanatory changes advance the specification without moving the schema,
  while a contract change advances both.
- The full documentation history is retained: every tagged version stays
  browsable through the site's version selector, so earlier releases remain
  citable.
- Notable changes are recorded in the [Changelog](changelog.md), and the dataset
  `version` in [document metadata](spec/metadata.md) stays distinct from the
  schema version.

**Tag naming.** Specification releases are tagged `vMAJOR.MINOR.PATCH`
(e.g. `v0.2.2`) — these are the tags the documentation version selector reads,
and pushing one publishes that version of the site. JSON Schema releases use a
distinct `schema-vMAJOR.MINOR.PATCH` prefix (e.g. `schema-v1.0.0`), so a schema
bump neither collides with nor masquerades as a specification documentation
version. Only `v*` tags trigger a documentation deployment.
