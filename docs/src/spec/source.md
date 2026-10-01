# Voltage sources

A **voltage source** is an ideal voltage reference with a current slack: it fixes the
bus terminal voltages and injects whatever current the rest of the network requires.
It is the power-flow reference (slack) bus. This model version permits exactly one.
Symbols are defined in [Notation](notation.md).

![Voltage source: a fixed line-to-ground voltage reference with a free slack current.](assets/vsource.svg)

!!! danger "Amrit"
    The figure and the text below describe **different sources**.

    1. **Current direction is reversed.** §3 says the source *injects* a slack current
       into the bus. The figure draws every $I_{s,k}$ arrow pointing from the bus
       terminal back into the source, i.e. *leaving* the bus. The figure matches the
       leaving-the-bus-positive convention the bus KCL actually uses; the text does not.
    2. **Symbols differ.** The figure uses $U^{\text{ref}}$; the page uses $U^{s}$.

## 1. Data model

A voltage source is an entry of the top-level `voltage_source` object, keyed by its
string ID $s$.

| Field | Type | Unit | Req. | Description |
|-------|------|:----:|:----:|-------------|
| `bus` | string | – | ✔ | Host bus ID $i$ |
| `terminal_map` | string[] | – | ✔ | Conductor→terminal map $\textcolor{purple}{\mathbf{N}_{s}}$ (phase terminals) |
| `v_magnitude` | number[] | V | ✔ | Per-terminal voltage magnitude |
| `v_angle` | number[] | rad | ✔ | Per-terminal voltage angle |
| `energy_cost_rate` | number[] | \$/kWh |   | Per-phase linear dispatch cost |

## 2. Input symbols

| Field | Symbol | Notes |
|-------|:------:|-------|
| `v_magnitude` | $\textcolor{red}{\lvert\mathbf{U}^{s}_{s}\rvert}$ | per terminal |
| `v_angle` | $\textcolor{red}{\boldsymbol{\theta}^{s}_{s}}$ | per terminal |
| `energy_cost_rate` | $\textcolor{red}{\mathbf{c}_{s}}$ | per phase |

## 3. Variables

The source injects a **slack current** $\textcolor{blue}{I_{s,k}}$ per phase terminal,
stacked into $\textcolor{blue}{\mathbf{I}_{s}}$. It is otherwise unconstrained. It
absorbs whatever power balance the network requires, which is what makes this the
reference bus. Like the generator current, it is an injection into the bus and enters
the bus KCL with a **minus** sign (see
[Buses §4](bus.md#Kirchhoff's-current-law)).

## 4. Equality constraints

### Fixed reference voltage

Each phase terminal is fixed to its polar reference, and the source-bus neutral to
ground:

```math
\textcolor{blue}{U_{i,p}} = \textcolor{red}{|U^{s}_{s,p}|}\,\textcolor{brown}{\angle}\,\textcolor{red}{\theta^{s}_{s,p}},
\qquad
\textcolor{blue}{U_{i,n}} = 0.
```


### Injected power

The complex power injected at phase terminal $p$ is

```math
\textcolor{blue}{S_{s,p}} = \textcolor{blue}{U_{i,p}}\,(\textcolor{blue}{I_{s,p}})^{*}
= P_{s,p} + \textcolor{brown}{j}\,Q_{s,p}.
```

The [Objective](objective.md) multiplies $P_{s,p}$ by the per-phase `energy_cost_rate` field
(and appropriate constant scaling coefficients) to compute the source's contribution to total dispatch cost.
Here current {I_{s,p}} is entering the node {p}.

## 5. Inequality constraints

### Cartesian variable bounds

**None.** The slack current is free.

### Engineering bounds

**None (foundational).** A pure slack has no rating.
