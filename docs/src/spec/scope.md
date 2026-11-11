# Background and scope

Why this specification exists, what it does and does not cover, and the design choices
behind it. This page frames the rest of the specification; it introduces no model
content.

## Motivation

Distribution networks are unbalanced: single-phase loads, untransposed lines, and
single-phase laterals mean the phases cannot be collapsed to a positive-sequence
equivalent without losing physical details or accuracy. An optimal power flow (OPF) for
distribution networks must therefore reason at the level of **individual conductors**.

At the same time, the range of utility problems posed as network-constrained
optimisation has grown: power flow, state estimation, volt-var control, DER scheduling,
dynamic operating envelopes, optimal droop settings. Yet there is little standardisation:
few openly-licensed unbalanced network models exist, so papers rely on ad-hoc modified
cases and results are hard to compare. This specification, with its companion data
library, provides a **common, openly-licensed model** so approaches can be compared
directly, the distribution analogue of transmission-side benchmark libraries such as [pglib](https://github.com/power-grid-lib/pglib-opf).

## Scope: beyond classical OPF

Although "OPF" names multiple sections of this document, the goal is broader than 
minimising generation cost.
The unifying requirement of the target problems is **an accurate conductor-level
representation of an unbalanced network subject to a selectable set of bounds**, i.e., it is not
constrained to one single objective. Bounded cost minimisation is a convenient, solver-comparable
starting point. With fixed demand and one uniform non-negative price on every
real-power injection, minimizing total injection is equivalent to minimizing
real losses. It does not make the nonconvex feasible set or optimum unique. The same physics
underpins maximum load delivery, conservation voltage reduction, dynamic operating
envelopes, and state estimation.

This is why **bounds are optional throughout the data model**: different problems 
activate different subsets of the feasible region. The specification is a reusable
foundation, and not specialised for a single problem class.

## Design choices

- **SI units.** All physical quantities in SI (see [Data input formatting](data-format.md)),
  so the data model commits to no per-unit base. Per-unit is a solver-internal convenience,
  out of scope here.
- **JSON schema.** Parseable from any programming language; producer-specific data goes in `extras`,
  and later releases of a schema line add only optional fields. A JSON Schema provides structural checks.
- **Real numbers, not complex.** Every complex quantity is a pair of real fields, and the
  model solves in real variables, for cross-language compatibility (see [Notation](notation.md)).
- **Explicit buses.** Buses are a first-class list with their own terminals and bounds,
  unlike OpenDSS, where buses are implicit in element connectivity.
- **String identifiers.** Buses, lines, loads, etc. carry unique string IDs, not forced
  sequential integers (unlike MATPOWER).
- **Wire coordinates.** Quantities are per-conductor ("wire"), not sequence/symmetrical
  components, keeping the format flexible and extendable to any wire count.

## What is modelled

The specification covers the common branch and nodal elements, with these capabilities:

- **Topology:** meshed networks, electrically parallel branches, radial or looped.
- **Conductors:** 1- to 4-wire lines with full mutual coupling; explicit neutral and earth
  (no Kron reduction); perfect grounding and grounding through impedance.

- **Branch elements:** [lines](line.md), [switches](switch.md), and galvanically-isolated
  [transformers](transformer.md) (single-phase, centre-tap, wye–delta, delta–wye).
- **Nodal elements:** [loads](load.md) (constant-power and voltage-dependent ZIP/exponential),
  [generators](generator.md), [shunts](shunt.md), [capacitors](capacitor.md),
  and [voltage sources](source.md).
- **Impedance:** line series impedance and shunt admittance given directly, either
  as a shared linecode or as per-line matrices.

## Present limitations

The model deliberately targets features universally required for distribution network OPF, not
every possible problem specification. In this version:

- Only a **single voltage source** (one reference bus) is supported.
- **Snapshot** solves: no inter-temporal coupling (no storage state-of-charge
  dynamics, no OLTC time-domain control).
- Transformer **saturation** and detailed frequency-dependent effects are not
  modelled. The [Transformers](transformer.md) page fixes the turns ratio by nameplate
  voltages and keeps winding-neutral grounding external to the element, like every
  other component (see [Grounding](grounding.md)). From 0.2.0 the data can also state
  no-load (core) shunts, a `tap_ratio` with bounds, and winding-neutral grounding
  impedances; the
  [0.2.0 supplement](../proposals/bmopf-0.2.0.md#Two-winding-transformers) gives OPF
  equations for these where it has them (the tapped coil ratio and the core-shunt
  admittance), and the rest are planned 0.2.x formulation pages.
- The default objective is linear generation/dispatch cost; quadratic cost terms are not
  included.

## Out of scope

The format is a model for OPF research. It does not aim to replace
the Common Information Model (CIM), and it does not prescribe solver software. Its OPF
formulation was inspired by [PowerModelsDistribution](references.md)'s `IVRENPowerModel`,
but extends it: native JSON data, the full set of element
configurations above, and explicit grounding.
