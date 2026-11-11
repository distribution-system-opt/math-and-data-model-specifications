# Proposed BMOPF v0.2.0: additional field semantics

!!! note "Proposed material, subject to Task Force review"
    This supplement builds on Matt Deakin's [source and objective proposal](https://github.com/distribution-system-opt/math-and-data-model-specifications/pull/36)
    and accompanies the `propose-bmopf-0.2.0` schema branch.
    It contributes to a versioned BMOPF v0.2.0, subject to Task Force approval.
    Findings from developing a reference implementation in PowerIO v0.11.0
    provide compatibility and numerical evidence for that review. The
    accepted component pages retain their current status.

The proposal makes equipment data already encountered in interchange files
explicit and checks the proposed definitions through implementation evidence.
The [contribution record](https://github.com/distribution-system-opt/dsopt-schema/blob/propose-bmopf-0.2.0/docs/contributors.md)
credits the preceding schema, specification and review work. The
[schema proposal](https://github.com/distribution-system-opt/dsopt-schema/tree/propose-bmopf-0.2.0)
contains exact field definitions, a worked feeder, a field inventory and
structural/semantic tests. The additions below require paired review of those
field definitions and these proposed interpretations.

## Identity, units and conductor order

Equipment identity is its table key. Bus and element terminal maps establish
ordered conductors. A line connects matching positions in its two maps, not
matching spelling. Matrix entries use one-based positions in that order.
Terminal naming and role conventions remain under discussion in
[Matt Deakin's data-format update](https://github.com/distribution-system-opt/math-and-data-model-specifications/pull/26).
No particular labels are made canonical here. PowerIO retains existing role
metadata and applies its documented compatibility rules when old datasets omit
it; those reader rules do not settle the Task Force's role taxonomy.

Bus phase-to-ground bounds remain per-phase vectors in volts, under the 0.1.1
names `vpg_min`/`vpg_max` adopted after [issue #51](https://github.com/distribution-system-opt/math-and-data-model-specifications/issues/51)
(`v_min`/`v_max` was ambiguous between phase-to-ground and phase-to-neutral).
The neutral has its own bound, `vng_max` (neutral-to-ground; 0.1.x named it
`vn_max`, and 0.2.0 renames it to read like `vpg`); unequal phase bounds cannot be
replaced by their first value or their average. The 0.1.0 and 0.1.1 schema texts say "one
entry per bus terminal", while the [bus page](../spec/bus.md) and the 0.2.0 schema
say one entry per phase terminal with the neutral bounded by `vng_max`; the Task
Force confirmed one entry per phase terminal on 2026-11-11. WYE load powers describe phase-to-neutral sub-loads, and
DELTA powers describe phase-pair sub-loads. Voltage-source terminal-voltage
arrays include every fixed terminal. These orderings agree with the current
bus, load and voltage-source component pages.

Linecode matrices use ohm/m and S/m; inline line matrices use ohm and S for the
complete line. The case must select one impedance source. Line `s_max`, like
linecode `s_max`, has one entry per conductor, in `terminal_map_from` order, applied
at both ends (the 0.1.1 line text said per phase). Power, voltage and
current values remain absolute SI quantities. Producer version, dataset version
and schema version are independent metadata.

`meta.schema_version` is the document's only version identifier: the release it
was written against, as `MAJOR.MINOR.PATCH`. It is required, and the 0.2 schema
accepts any 0.2.x release, because a later release of a line only adds optional
content. `meta.$schema` is not part of 0.2.0. Documents written before 0.2.0 carry
no `schema_version`, and a reader identifies a 0.1.x document by its `meta.$schema`.
Identity and retrieval are separate questions: a producer that writes against an
untagged schema records its commit and digest in `meta.provenance`. The reference
implementations showed why the identifier names no URL. PowerIO 0.11 stamped an
immutable archive URL of its own so the exact bytes were retrievable, BMOPFTools
accepted `meta.$schema` values from an allow-list, and valid documents then failed
intake over a string ([BMOPFTools #487](https://github.com/frederikgeth/BMOPFTools.jl/issues/487));
every new producer revision would have needed a new alias in every consumer. A
`$schema` fixed to each release's `$id` would have moved the problem to releases:
every patch release would have rejected every earlier document. The
[versioning policy](https://github.com/distribution-system-opt/dsopt-schema/blob/propose-bmopf-0.2.0/README.md#versioning-and-compatibility)
states the full rules.

### Geometry

`bus.*.geo` is a GeoJSON Point and `line.*.geo` a GeoJSON LineString from
`bus_from` through any bends to `bus_to`; `meta.crs` names one coordinate
reference system for the document (`OGC:CRS84`, WGS84 longitude and latitude, when
absent). Coordinates are always written x then y, longitude then latitude or easting
then northing, whatever the authority's own axis order. Geometry is descriptive: no
constraint reads it, `length` stays the electrical length, and a route's geodesic
length need not equal it. The shape
follows [BMOPFTools PR 258](https://github.com/frederikgeth/BMOPFTools.jl/pull/258)
and the form PowerIO already reads. PowerIO 0.11 had to write the same data as a
FeatureCollection under `extras.geojson`, the one free-form object, because no
typed slot existed, and each consumer then needed a sideload path (BMOPFTools
[#486](https://github.com/frederikgeth/BMOPFTools.jl/pull/486)); on a 1,000-bus
synthetic feeder that layer was 36 % of the file, mostly repeated keys. Every
other element with a place on the map may also carry `geo`, so no tool needs a
side channel for it: single-bus elements (sources, loads, generators, inverters,
shunts, capacitors, and the DC bus, load, source and grounding) take a Point and
are otherwise drawn at their bus; switches, every transformer type and DC branches
take a Point for their site or a LineString from their first bus to their last.
Any `geo` may carry a GeoJSON `bbox`. All of it is optional.

## Two-winding transformers

Let coil currents be positive into the ideal transformer and let the real,
positive effective coil ratio be `a`. For an ideal winding pair:

```math
v_f = a v_t, \qquad i_t = -a i_f,
\qquad v_f i_f^* + v_t i_t^* = 0.
```

The ratio includes the proposed `tap_ratio` multiplier and the nameplate coil
ratio. Three-phase `v_nom_from` and `v_nom_to` are line-to-line ratings; WYE coil
ratings divide by the square root of three, while DELTA coil ratings do not.
Winding connection maps convert terminal voltages into coil voltages. A WYE
coil spans its phase and neutral. A DELTA coil spans the consecutive phase pair
specified by its orientation. Terminal current maps are the corresponding
transpose incidence maps, preserving complex power.

`tap_ratio` defaults to 1 when absent. A fixed-tap calculation uses the stated
ratio. A bounded tap decision requires the selected formulation to implement
that decision and enforce `tap_ratio_min <= tap_ratio <= tap_ratio_max`.
The start value must lie in the stated interval. A consumer must not silently
turn a requested tap decision into a fixed nominal transformer.

Series impedances remain on the side named by their field. The wye/delta
subtypes' `r_series` and `x_series` are referred to the WYE side. Conversion
between winding bases uses the square of the coil ratio. Current limits stay
in the amperes of their named side and are not copied unchanged across a turns
ratio.

`r_neutral_from`, `x_neutral_from`, `r_neutral_to` and `x_neutral_to` describe
internal winding-neutral grounding branches in ohms. When both fields are absent, they add no internal grounding branch; the
terminal map and external bus grounding still apply. An explicitly zero
impedance adds a solid ground. This preserves the meaning of existing cases
that supplied only terminal maps. The distinction requires Task Force review.
An OpenDSS negative-resistance open-neutral marker maps to an absent branch,
not a zero-impedance branch. Bus grounding remains separate data.

`g_no_load + j b_no_load` is the from-side core shunt admittance in siemens.
Negative `b_no_load` gives lagging magnetizing current. Zero leakage impedance
does not by itself eliminate a stated core shunt: ideal coupling and core loss
are separate parts of the equivalent circuit.

### A core shunt on an explicit winding

The optional `no_load_shunt` object specifies `{winding, g, b}`. The winding
index is one-based, and each coil on that winding receives `g + j b` siemens
at its terminal voltage. It cannot coexist with `g_no_load` or `b_no_load`.
Existing fields retain their from-side meaning, while the explicit object
supports equipment whose exciting branch lies on a different physical winding.

For coil incidence row `c` and bus-terminal voltage vector `v`, the contribution
is

```math
u = c v, \qquad Y_0 = c^T (g + j b)c,
\qquad S_0 = (g - j b)|u|^2.
```

Contributions add across the selected winding's coils. For a centre tap,
winding 2 spans the first secondary terminal to the centre terminal and winding
3 spans the centre terminal to the last secondary terminal. The shunt remains
an ordinary terminal branch when a fixed tap changes; a producer deriving
admittance from nameplate percentages must account for that tap explicitly.

OpenDSS places its exciting branch on winding 2. PowerIO uses
`g = loss_percent / 100 * S_base / (n_phase * U_coil^2)` and
`b = -imag_percent / 100 * S_base / (n_phase * U_coil^2)`, with the actual tapped
coil voltage. A WYE coil uses the phase-to-neutral base; a DELTA coil uses the
phase-to-phase base. Referring that branch through a ratio to the other side
of a nonzero leakage network changes its equations and is not a lossless
conversion. The paired schema conformance packet records six direct OpenDSS
admittance comparisons for these conventions.

## Regulators and n-winding equipment

A regulator states `voltage_ratio`, with bounds `voltage_ratio_min` and
`voltage_ratio_max`, rather than a nameplate-ratio multiplier. It is the regulated
over source voltage (`bus_to` over `bus_from`) for both ANSI types: with `a` the
voltage ratio, `v_to = a v_from` and `i_from = -a i_to`. `regulator_type` records
only the hardware arrangement (A or B), which affects how a physical tap position
maps to a ratio but not what `voltage_ratio` means. The name differs from
`tap_ratio` because a transformer's `tap_ratio` multiplies the from-side ratio, so
1.02 lowers the to-side voltage, while a `voltage_ratio` of 1.02 raises it.
The two relations preserve power with currents positive into the device.
Open-delta connection codes establish which two phase-pair legs are controlled,
and an open-delta regulator states one `voltage_ratio` per leg. Their terminal
orientation and ratio convention must be checked together.

The `n_winding` subtype holds an ordered list of windings with winding 1 as the
reference. Each winding retains its connection, nominal coil voltage, rating,
resistance, tap and neutral impedance. Optional winding `s_rating` defaults to
the transformer power base, while `r_winding` is in ohms on its own coil side. Pairwise short-circuit reactances refer
to the declared common base. A consumer must validate the complete pair set
and physical realizability before constructing its leakage network; pairwise
data must not be replaced by a guessed chain of two-winding transformers.

With all leakage terms and core shunts zero, the ideal core has equal referred
coil voltages and the sum of winding complex powers is zero. Nonzero leakage
and magnetizing terms add their corresponding losses and voltage drops.

## Other proposed equipment and controls

| Addition | Definitions requiring review |
|---|---|
| Inverter-based resources | Phase power/cost limits, conductor current limits, topology, filter impedance and optional DC coupling |
| Control profiles | Explicit voltage/power reference, units and ordered breakpoints for Volt-VAr, Volt-Watt and power-factor laws |
| Wire data and line geometry | Conductor order and derivation provenance; frequency and earth-model assumptions must match the compiled linecode |
| DC network tables | Signed terminal-to-ground voltages, conductor resistances, grounding and converter coupling |
| Named time profiles | Multipliers attached to named numeric fields; state selection precedes a snapshot calculation |
| IBR cost data | Optional per-phase `energy_cost_rate`, priced in the [objective](../spec/objective.md) as a generator's is, with the same injected-power sign |

These descriptions do not prescribe one solver implementation. A snapshot
solver must require a selected time state, and an AC-only solver must reject
required DC coupling rather than discard it. Retained control data does not
prove that a control law participated in the solve.

Inverter power factor is signed as in OpenDSS, with P and Q positive when injected:
`pf > 0` means Q has the same sign as P (both injected or both absorbed), `pf < 0`
means opposite signs, and `pf = 0` is invalid. A Volt-Watt `p_limits` is
`[p_low, p_high]`, ordered by value like a Volt-VAr `q_limits`: `p_high` applies at
or below breakpoint U5 and `p_low` at or above U6. A `PU` active-power limit is per
unit of the base that `p_ref` names (by default `S_MAX`, the per-phase `s_max`),
and a `PU` reactive-power limit (`q_unit`) is per unit of the per-phase `s_max`.

## Status of the 0.2.0 tables

For inverters (`ibr`), control profiles (`control_profile`), the DC tables
(`dc_*`), `time_series`, `wire_data` and `line_geometry`, the meaning of each field
is normative as the schema states it. Their OPF formulations, apart from the
inverter term in the [objective](../spec/objective.md), are not yet standardised;
the [roadmap](https://github.com/distribution-system-opt/dsopt-schema/blob/propose-bmopf-0.2.0/docs/roadmap.md)
plans them as 0.2.x formulation pages, which add equations without changing what a
0.2.0 document means. A consumer that does not
model one of these tables must report it rather than silently drop it.

The steps of a `time_series` profile are independent snapshots: 0.2.0 couples no
steps, and the objective costs each step as one hour of operation.

## Exact ideal constraints

An ideal closed switch enforces equal terminal voltages and opposite entering
currents conductor by conductor. An open switch carries zero current and does
not couple its terminal voltages. An ideal voltage source fixes its stated
complex terminal voltage while its current follows from network balance.
Zero-resistance DC grounding fixes terminal voltage to zero while earth-return
current remains a balance variable. These are exact algebraic constraints;
substituting a small arbitrary impedance changes the model.

## Compatibility and implementation evidence

The schema proposal preserves the historical example bytes and records known
semantic findings separately. Structural validation of the historical ENWL
case passes, but its undeclared grounded terminal requires an explicit dataset
repair before numerical use. New semantic rejection checks name inconsistent
versions, role lists, dimensions, references and bounds.

PowerIO distinguishes source-byte preservation, typed conversion, generation-2
IR storage, schema-version selection and computational support. Explicit legacy output
may relocate proposed-only physics to `extras`, with diagnostics. A consumer
that ignores those extensions is not computationally equivalent. Producer
provenance pins a proposal commit and schema digest; the Task Force retains
control of ratification and the eventual `schema-v0.2.0` tag.

## Compatibility with the source and objective proposal

The [source](../spec/source.md), [generator](../spec/generator.md),
[bus](../spec/bus.md) and [objective](../spec/objective.md) pages from
[Matt Deakin's PR #36](https://github.com/distribution-system-opt/math-and-data-model-specifications/pull/36)
define the injected-power sign, slack currents, `energy_cost_rate`, and the
one-hour objective. This supplement adds no alternative definitions or duration
parameter; it extends the objective's sum to inverters, which the 0.2.0 schema
prices as it prices generators. Further changes to those definitions belong in that
PR and its [paired schema change](https://github.com/distribution-system-opt/bmopf-resources/pull/21).

PowerIO v0.11.0 follows the per-phase ordering in the source and generator pages.
Voltage-source magnitudes and angles still include all stated terminals; the
energy-price vector omits neutral terminals. The draft schema retains `cost` as
a deprecated alias with the same values and phase order, so existing datasets
remain readable. If both spellings occur, they must agree. Fresh draft output
uses `energy_cost_rate`.

Additional implementation evidence covers IR persistence, typed source prices in
C and Julia, and relocation to `extras.voltage_source` when explicitly writing
0.1.0. Optional IBR prices enter the objective as generator prices do, with the
same injected-power sign; they leave the source and generator terms of PR #36
unchanged.

## Baseline, dependencies, and contributions

The [historical v0.1.0 baseline](https://github.com/distribution-system-opt/dsopt-schema/blob/baseline/bmopf-0.1.0/docs/baseline-0.1.0.md)
records the Task Force schema with unchanged validation rules. This supplement
and schema PR #2 propose changes above it; they do not declare a schema release.
The baseline credits Matt Deakin's initial schema and alignment work,
Frederik Geth's schema development and review-driven changes, and Samuel
Talkington's port and versioned import.

Matt's source/objective PR #36 remains the prerequisite for this supplement.
The energy-price spelling and units are still discussed in
[issue #17](https://github.com/distribution-system-opt/math-and-data-model-specifications/issues/17)
and the [paired resources PR #21](https://github.com/distribution-system-opt/bmopf-resources/pull/21).
The current proposed spelling does not establish consensus on final units.
Terminal-role questions remain in PR #26 and issue #27.

The [contributor record](https://github.com/distribution-system-opt/dsopt-schema/blob/propose-bmopf-0.2.0/docs/contributors.md)
distinguishes authored definitions, integration work, review, and coordination.
Credits identify the work carried forward, not endorsement of every addition.
Corrections, narrower proposals, and additional evidence are welcome.
