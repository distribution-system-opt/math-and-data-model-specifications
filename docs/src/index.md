# Distribution System Model and Data Specification

Welcome to the data specification of the four-wire distribution-system optimal power
flow (OPF) model.

This site is the canonical, version-controlled home of
the specification: every page is plain Markdown that evolves through pull requests.

!!! tip "Download as PDF"
    The complete specification is also available as a single, print-ready
    document: [**DistributionSystemModelSpecification.pdf**](DistributionSystemModelSpecification.pdf).

The data specification is one of two outputs maintained by the IEEE PES
Task Force on **Benchmarking Multiconductor OPF (BMOPF) for Distribution
Systems**:
- The **BMOPF data specification**. This defines the basic specification which must be
  met for a given dataset to be considered a network case.
- The **BMOPF network cases**. These are data instances which conform to the
  BMOPF data specification. Network cases are presently work-in-progress.

An JSON file representing a distribution system which meets the data
specification is described as a _network model_. The _BMOPF networks cases_ are
the subset of network models which are curated by the BMOPF Task Force.

The BMOPF data specification is split across two resources:
- **This site** as the main data specification, capturing **data
  semantics and math model** and **further information** aspects,
  consisting of further subsections of [foundations](#foundations),
  [components](#components), [optimisation](#optimisation),
  [reference](#reference) (including FAQs), as well as
  [governance and contribution](#contributing) guidelines.
- The **[data schema](https://github.com/distribution-system-opt/dsopt-schema)**, which defines the basic structure of a JSON instance, including field
  names and some basic data contracts.

## New here? Start with the [Overview](spec/index.md)

Then work through the foundations before diving into individual components.

## Foundations

The shared model that every component page builds on.

- [Overview](spec/index.md) — scope and structure of the specification
- [Background & scope](spec/scope.md) — what is (and isn't) modelled, and why
- [Notation](spec/notation.md) — symbols and mathematical conventions
- [Data input formatting](spec/data-format.md) — how a case is described
- [Grounding](spec/grounding.md) — neutral, earth, and return paths
- [Worked example](spec/example.md) — a small four-bus network end to end
- [Document metadata](spec/metadata.md) — provenance and versioning fields

## Components

Per-element data models and equations.

- [Buses](spec/bus.md) · [Lines](spec/line.md) · [Switches](spec/switch.md)
- [Loads](spec/load.md) · [Generators](spec/generator.md) · [Shunts](spec/shunt.md) · [Capacitors](spec/capacitor.md)
- [Voltage sources](spec/source.md) · [Transformers](spec/transformer.md)

## Optimisation

- [Objective & feasibility](spec/objective.md)

## Reference

- [Modelling notes & FAQ](spec/faq.md)
- [Nomenclature](spec/nomenclature.md)
- [References](spec/references.md)
- [Glossary](glossary.md)

## Contributing

Corrections and refinements are welcome — see the [Contributing](contributing.md)
guide. The "Edit on GitHub" link on any page takes you to its source file, and
every push to `main` rebuilds and publishes this site automatically. Notable
changes are recorded in the [Changelog](changelog.md).
