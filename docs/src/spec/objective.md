# Objective

The component pages define the network's variables and constraints, i.e., the *feasible
set*. This page defines what is optimised over that feasible set: the **objective**.
Symbols are defined in [Notation](notation.md).

The default snapshot objective minimises total **active-power dispatch cost
rate**, summed over every dispatchable element (generators, the voltage source) and every phase:

```math
\min \; \sum_{g} \sum_{p} \textcolor{red}{c_{g,p}}\; P_{g,p}/1000,
```

where $\textcolor{red}{c_{g,p}}$ (currency/kWh, from each element's per-phase
`cost` array) is the energy price of phase $p$, and $P_{g,p}$ is that phase's
injected active power in watts — the same bilinear expression the element defines
($P_{g,p}=\Delta v^r\,c^r + \Delta v^i\,c^i$). The factor $1/1000$ converts W to
kW, so the objective function represents cost rate in currency/h.

### Sign convention

$P_{g,k}$ is the power **injected into the network** by the element, uniformly across
generators and voltage source (each stamps $+I$ into KCL). Therefore:

- a **positive** cost minimises that element's injection;
- a **negative** cost maximises it.

The voltage source is *not* special: for the slack, positive injection means importing
from the grid, so a positive source cost is the grid import price (and export, a
negative injection, is credited at the same price). Maximising system exports is a
positive slack cost with free DERs.
