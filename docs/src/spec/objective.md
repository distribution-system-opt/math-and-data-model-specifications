# Objective

The component pages define the network's variables and constraints, i.e., the *feasible
set*. This page defines what is optimised over that feasible set: the **objective**.
Symbols are defined in [Notation](notation.md).

The default objective minimises total **active-power dispatch cost**,
in $. This is summed over every dispatchable element (generators and voltage source;
with the power injected by the voltage source representing electricity drawn from
the upstream (e.g., transmission) grid) and every phase:

```math
\min \;
\frac{\textcolor{red}{\Delta_T}}{1000}
\left(
\underbrace{\sum_{g\in\mathcal{G}} \sum_{p} \textcolor{red}{c_{g,p}}\; P_{g,p}}_{\text{generators}}
\;+\;
\underbrace{\sum_{s\in\mathcal{S}} \sum_{p} \textcolor{red}{c_{s,p}}\; P_{s,p}}_{\text{voltage source}},
\right)
```

where $\textcolor{red}{c_{g,p}}$ and $\textcolor{red}{c_{s,p}}$ (currency/kWh,
from each element's per-phase `cost` array — see
[Generators](generator.md#1.-Data-model) and
[Voltage sources](source.md#1.-Data-model)) are the energy price of phase $p$
for generator $g\in\mathcal{G}$ and voltage source $s\in\mathcal{S}$
respectively, and $P_{g,p}$, $P_{s,p}$ are that phase's injected active power
in watts, as defined in [Generators §4](generator.md#4.-Equality-constraints)
and [Voltage sources §4](source.md#4.-Equality-constraints). The constant factor
$\textcolor{red}{\Delta_T}$ accounts for the duration of the snapshot analysis
(with fixed value 1 hr) and the factor of 1000 converts power injections from
W to kW (so that the value of the objective is then in $).

### Sign convention

Here, $P_{g,p}$ and $P_{s,p}$ are the power **injected into the network** by the
element, uniformly across generators and voltage source (each stamps $+I$ into KCL).
Therefore:

- a **positive** cost minimises that element's injection;
- a **negative** cost maximises it.

The voltage source is *not* special: for the slack, positive injection means importing
from the grid, so a positive source cost is the grid import price (and export, a
negative injection, is credited at the same price).