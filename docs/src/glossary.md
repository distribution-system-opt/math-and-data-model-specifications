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

Galvanically isolated
: A connection with no direct conductive path between two circuits — power transfers
  only via magnetic coupling. Transformers in this specification are modelled as
  galvanically isolated winding pairs. See [Transformers](spec/transformer.md).

Kron reduction
: The algebraic elimination of a conductor (typically the neutral) from an impedance or
  admittance matrix, folding its mutual coupling into the remaining conductors. Valid
  when a branch element's terminals are perfectly grounded, so the terminal voltage at
  each end of the branch element (e.g. the conductor of a line or cable) is common at
  0 V.

  **Note:** this specification keeps neutral and earth conductors explicit and does
  not apply Kron reduction. See [Grounding](spec/grounding.md).

Nodal admittance matrix (Ybus)
: The matrix ``\mathbf{Y}`` relating injected currents to node voltages,
  ``\mathbf{I} = \mathbf{Y}\,\mathbf{V}``.

OPF — Optimal Power Flow
: An optimisation problem that determines the operating point of a network
  minimising an objective (e.g. cost, losses) subject to physical and
  operational constraints. See [Objective & feasibility](spec/objective.md).

Per-unit
: A normalisation convention that expresses a quantity as a fraction of a chosen base
  value (e.g. a base voltage or power) rather than in physical units. This
  specification uses SI units throughout and defines no per-unit base. See
  [Data input formatting](spec/data-format.md).

Triplex (split-phase) service
: A single-phase secondary service from a centre-tapped transformer winding, giving two
  legs and a line-to-line voltage from one source phase, typically 120 V and 240 V in
  North American practice. Modelled as one or more single-phase loads across the
  triplex terminals. See [Modelling notes & FAQ](spec/faq.md).

ZIP load
: A voltage-dependent load model combining constant-impedance (Z),
  constant-current (I), and constant-power (P) components. See
  [Loads](spec/load.md).
