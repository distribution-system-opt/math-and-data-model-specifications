# BMOPF 0.2.0 proposal supplement

!!! note "Proposed material, subject to Task Force review"
    This supplement accompanies the `propose-bmopf-0.2.0` schema branch.
    PowerIO v0.11.0 is preparing an implementation of draft BMOPF 0.2.
    That implementation does not constitute Task Force ratification. The
    accepted component pages retain their current status.

The proposal makes equipment data already encountered in interchange files
explicit and checks the resulting contract in a reference consumer. The
[schema proposal](https://github.com/distribution-system-opt/dsopt-schema/tree/propose-bmopf-0.2.0)
contains exact field definitions, a worked feeder, a field inventory and
structural/semantic tests. The additions below require paired review of those
field definitions and these proposed interpretations.

## Identity, units and conductor order

Equipment identity is its table key. Bus and element terminal maps establish
ordered conductors. A line connects matching positions in its two maps, not
matching spelling. Matrix entries use one-based positions in that order.
Explicit terminal role lists are disjoint and case-sensitive. The historical
neutral-name inference applies only when those lists are absent.

Bus phase-to-ground bounds remain per-phase vectors in volts. The neutral has
its own `vn_max`; unequal phase bounds cannot be replaced by their first value
or their average. WYE load powers describe phase-to-neutral sub-loads, and
DELTA powers describe phase-pair sub-loads. Voltage-source terminal-voltage
arrays include every fixed terminal. These orderings agree with the current
bus, load and voltage-source component pages.

Linecode matrices use ohm/m and S/m; inline line matrices use ohm and S for the
complete line. The case must select one impedance source. Power, voltage and
current values remain absolute SI quantities. Producer version, dataset version
and schema version are independent metadata.

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

A regulator has a regulation ratio rather than a nameplate-ratio multiplier.
For the proposed type B convention, `v_to = a v_from` and
`i_from = -a i_to`; the proposed type A convention reverses the effective ratio.
The two relations preserve power with currents positive into the device.
Open-delta connection codes establish which two phase-pair legs are controlled.
Their terminal orientation and ratio convention must be checked together.

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

| Addition | Contract requiring review |
|---|---|
| Inverter-based resources | Phase power/cost limits, conductor current limits, topology, filter impedance and optional DC coupling |
| Control profiles | Explicit voltage/power reference, units and ordered breakpoints for Volt-VAr, Volt-Watt and power-factor laws |
| Wire data and line geometry | Conductor order and derivation provenance; frequency and earth-model assumptions must match the compiled linecode |
| DC network tables | Signed terminal-to-ground voltages, conductor resistances, grounding and converter coupling |
| Named time profiles | Multipliers attached to named numeric fields; state selection precedes a snapshot calculation |
| Source and IBR costs | Per-phase cost arrays matching the equipment terms already named in the objective |

These descriptions do not prescribe one solver implementation. A snapshot
solver must require a selected time state, and an AC-only solver must reject
required DC coupling rather than discard it. Retained control data does not
prove that a control law participated in the solve.

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
IR storage, profile emission and computational support. Explicit legacy output
may relocate proposed-only physics to `extras`, with diagnostics. A consumer
that ignores those extensions is not computationally equivalent. Producer
provenance pins a proposal commit and schema digest; the Task Force retains
control of ratification and the eventual `schema-v0.2.0` tag.

## Voltage-source injections and energy prices

This supplement incorporates the proposed naming and ordering in
[the voltage-source and objective update](https://github.com/distribution-system-opt/math-and-data-model-specifications/pull/36)
and [the coordinated data update](https://github.com/distribution-system-opt/bmopf-resources/pull/21).
The shared modelling choices remain subject to Task Force review.

Define generator and ideal voltage-source currents as injections into the bus.
Their contributions therefore have the opposite sign from load currents and
currents leaving the bus into lines, switches, shunts and transformer windings.
An ideal voltage source fixes each stated terminal voltage; its independently
solved terminal currents enforce KCL. This includes a fixed neutral terminal.
Generator connection constraints must not impose a zero-neutral-current or
zero-sum-current restriction on an ideal voltage source.

The proposed `energy_cost_rate` vector uses $/kWh. Generator and IBR entries
follow phase order. Voltage-source entries follow the entire `terminal_map`,
including any neutral. With injection power `p` in W and duration `d` in hours,
the linear energy cost is `d * sum(energy_cost_rate * p) / 1000`. A one-hour
interval is a calculation convention, not an implicit conversion of W to kWh.
A 1000 W injection at 0.10 $/kWh for one hour costs $0.10.

The schema accepts the deprecated per-phase `cost` spelling for compatibility.
A source's legacy vector expands to terminal order with zero rates for nonphase
terminals. Both spellings must agree after this expansion when both are present.
PowerIO v0.11.0 retains these prices through typed source records, generation-2
IR, and the C and Julia bindings. Its draft BMOPF 0.2 writer uses the proposed
name. Retaining an objective coefficient does not imply that every downstream
calculation optimizes that objective.
