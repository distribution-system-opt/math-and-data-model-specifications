# Model specification

!!! note "Status: prototype"
    This is a **prototype** of a self-contained model + data specification
    spanning the full network model: foundations
    ([Background & scope](scope.md), [Notation](notation.md),
    [Data input formatting](data-format.md), [Grounding](grounding.md),
    [Worked example](example.md), [Document metadata](metadata.md)); every component
    ([Buses](bus.md), [Lines](line.md), [Switches](switch.md), [Loads](load.md),
    [Generators](generator.md), [Shunts](shunt.md), [Capacitors](capacitor.md),
    [Voltage sources](source.md), [Transformers](transformer.md)); and the
    [Objective and feasibility](objective.md) formulation.

## Purpose

This is the mathematical and data-model specification for (up-to-) four-wire distribution
system optimal power flow (OPF), developed by the IEEE PES Task Force on
Benchmarking Multiconductor OPF (BMOPF) for Distribution Systems.

Two principles govern every page:

1. **The specification is the source of truth.** The equations, symbols, bounds,
   and data-model field names on these pages, together with the JSON Schema, form
   the normative contract that datasets and tools implement.

2. **SI units are used in place of per-unit.** Voltages in volts, currents in amperes, impedances in
   ohms, admittances in siemens, powers in watts/var/VA, angles in radians. Per-unit
   scaling may be applied by solvers internally but is **out
   of scope** of this specification.

## How each component page is organised

Every component page follows the same five-part structure, so a reader always knows
where to find the data fields, the physics, and the bounds.

| Part | Question it answers |
|------|---------------------|
| **1. Data model** | Which JSON fields describe this component, with types, units, and required/optional status. |
| **2. Input symbols** | The mathematical symbol each field maps to (a *parameter*). |
| **3. Variables** | The unknowns this component introduces (an optimization *variable*). |
| **4. Equality constraints** | The physical laws that define the *behaviour* of the component. |
| **5. Inequality constraints** | The bounds, split into **cartesian variable bounds** (box bounds on a variable's own components) and **engineering bounds** (physically meaningful magnitude/angle limits). |

The **cartesian vs engineering** split in the **inequality constraints** is deliberate. 
A *cartesian bound* constrains the real and imaginary components of a decision variable directly 
— a (convex) rectangle in the complex plane, used mainly to bound the search.
An *engineering bound* constrains a quantity an engineer cares about — a voltage
magnitude, a thermal current, a sequence-component unbalance — and is generally a
circle (quadratic) or an angle sector (bilinear). Conflating the two would hide which
limits enforce a physical limit and which serve numerical purposes.

The mathematical model is stated in **complex phasors**. A solver typically works in
**rectangular real** variables — each complex equation split into its real and
imaginary parts, each complex variable becoming two real variables — but that
realisation is a downstream implementation choice and is not part of this
specification.

## Model summary

The complete feasible set at a glance — the objective, every bound, and every device
constraint, with the page that defines each. Bounds are optional (absent bounds are
not enforced); constraints are always active for the elements present.

| Category | Item | Page |
|----------|------|------|
| **Objective** | Minimise active-power dispatch cost | [Objective](objective.md#Objective) |
| **Voltage bounds** | Phase-to-ground, -neutral, -phase, sequence, neutral cap, angle | [Buses](bus.md#Engineering-bounds) |
| **Current bounds** | Line / switch / transformer thermal, generator current | [Lines](line.md#Engineering-bounds), [Switches](switch.md), [Generators](generator.md#Engineering-bounds) |
| **Power bounds** | Generator P·Q box + apparent-power circle; transformer rating; line apparent power | [Generators](generator.md#Engineering-bounds), [Transformers](transformer.md#Engineering-bounds) |
| **KVL / Ohm's law** | Line series drop + π-shunt | [Lines](line.md#4.-Equality-constraints) |
| **KCL** | Nodal current balance | [Buses](bus.md#Kirchhoff's-current-law) |
| **Device behaviour** | Load & generator power; control mode; transformer winding pairs; switch state; shunt/capacitor admittance current | [Loads](load.md), [Generators](generator.md), [Transformers](transformer.md), [Switches](switch.md), [Shunts](shunt.md), [Capacitors](capacitor.md) |
| **Reference / grounding** | Voltage-source fixing; perfect, floating or impedance (electrode) grounding | [Voltage sources](source.md), [Grounding](grounding.md) |

## Reading order

Start with the **foundations**:

1. **[Background & scope](scope.md)** — why the specification exists, what it covers, and
   the design choices behind it.
2. **[Notation](notation.md)** — typography (variables vs parameters, real vs complex),
   the complex-phasor symbols and their rectangular realisation, transform matrices, the
   element-wise bound idiom, and the set/topology convention used on every later page.
3. **[Data input formatting](data-format.md)** — units, how complex numbers and matrices
   are encoded in JSON, and required-vs-optional field semantics.
4. **[Grounding](grounding.md)** — the common-reference ground model that the components apply locally.
5. **[Worked example](example.md)** — every set constructed for one small network, to
   practically illustrate the abstraction.

Then the **components** (start with [Buses](bus.md) and [Lines](line.md)), the
[Objective and feasibility](objective.md) formulation, and the
[Document metadata](metadata.md). The [Modelling notes & FAQ](faq.md) collects
recurring case-building questions, and [References](references.md)
points to the textbooks and papers behind the model.

## Self-containment

This section links only within itself, so the whole `spec/` folder can be moved to
another repository without dangling references. 
**Please preserve this feature if you wish to contribute**.
