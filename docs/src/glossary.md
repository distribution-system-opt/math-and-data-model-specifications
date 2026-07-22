# Glossary

A quick reference for the terms and abbreviations used throughout the
specification. Symbols and mathematical notation are defined on the
[Notation](spec/notation.md) page.

!!! note "Work in progress"
    This glossary is a stub. Entries are added as terms are introduced across
    the specification — contributions welcome (see [Contributing](contributing.md)).

## Terms

Four-wire model
: A network representation in which each of the three phases **and** the neutral
  conductor are modelled explicitly, with earth as a separate return path.

Nodal admittance matrix (Ybus)
: The matrix ``\mathbf{Y}`` relating injected currents to node voltages,
  ``\mathbf{I} = \mathbf{Y}\,\mathbf{V}``.

OPF — Optimal Power Flow
: An optimisation problem that determines the operating point of a network
  minimising an objective (e.g. cost, losses) subject to physical and
  operational constraints. See [Objective & feasibility](spec/objective.md).

ZIP load
: A voltage-dependent load model combining constant-impedance (Z),
  constant-current (I), and constant-power (P) components. See
  [Loads](spec/load.md).
