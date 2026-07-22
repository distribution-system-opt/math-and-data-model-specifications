# Loads

A **load** draws a specified power at a bus. Its power may be constant, or vary with
voltage (ZIP / exponential). Three connection configurations are supported:
single-phase, wye (with neutral return), and delta.
Symbols are defined in [Notation](notation.md).

![Single-phase (left), wye (centre), and delta (right) load connections and their current variables.](assets/load_types.svg)

## 1. Data model

A load is an entry of the top-level `load` object, keyed by its string ID $d$.

| Field | Type | Unit | Req. | Description |
|-------|------|:----:|:----:|-------------|
| `bus` | string | – | ✔ | Host bus ID $i$ |
| `terminal_map` | string[] | – | ✔ | Conductor→terminal map $\textcolor{purple}{\mathbf{N}_{d}}$ |
| `configuration` | string | – | ✔ | `WYE`, `SINGLE_PHASE`, or `DELTA` |
| `p_nom`, `q_nom` | number[] | W, var | ✔ | Nominal per-sub-load active/reactive power |
| `model` | string | – | | `CONSTANT_POWER` (default), `CONSTANT_CURRENT`, `CONSTANT_IMPEDANCE`, `ZIP`, `EXPONENTIAL` |
| `v_nom` | number[] | V | (zip/exp) | Nominal voltage at which `p_nom`/`q_nom` hold |
| `alpha_z`, `alpha_i`, `alpha_p` | number[] | – | (zip) | Active ZIP fractions ($\alpha_Z+\alpha_I+\alpha_P=1$) |
| `beta_z`, `beta_i`, `beta_p` | number[] | – | (zip) | Reactive ZIP fractions |
| `gamma_p`, `gamma_q` | number[] | – | (exp) | Active/reactive voltage exponents |

## 2. Input symbols

| Field | Symbol | Notes |
|-------|:------:|-------|
| `p_nom`, `q_nom` | $\textcolor{red}{P^{\text{nom}}_{d}},\ \textcolor{red}{Q^{\text{nom}}_{d}}$ | per sub-load |
| `v_nom` | $\textcolor{red}{V^{\text{nom}}_{d}}$ | reference voltage |
| ZIP fractions | $\textcolor{red}{\alpha_Z,\alpha_I,\alpha_P},\ \textcolor{red}{\beta_Z,\beta_I,\beta_P}$ | |
| exponents | $\textcolor{red}{\gamma_P},\ \textcolor{red}{\gamma_Q}$ | |

A **sub-load** $k$ is one two-terminal power element of the load: a phase-to-neutral
branch (`WYE`), the single terminal pair (`SINGLE_PHASE`), or one line-to-line branch
(`DELTA`).

## 3. Variables

Each sub-load $k$ draws a complex current $\textcolor{blue}{I_{d,k}}$, stacked into
$\textcolor{blue}{\mathbf{I}_{d}}$. These are the currents the load contributes to
KCL; the neutral return current is not an independent variable.

## 4. Equality constraints

### Sub-load voltage drop and power

Let $\Delta\textcolor{blue}{U_{d,k}}$ be the voltage across sub-load $k$:
phase-to-neutral for `WYE`, the terminal-pair difference for `SINGLE_PHASE`,
line-to-line for `DELTA`. The complex power the sub-load absorbs is

```math
\textcolor{blue}{S_{d,k}} = \Delta\textcolor{blue}{U_{d,k}}\,(\textcolor{blue}{I_{d,k}})^{*}
= P_{d,k} + \textcolor{brown}{j}\,Q_{d,k}.
```

**Constant power** (default) pins it to the nominal setpoint:

```math
P_{d,k} = \textcolor{red}{P^{\text{nom}}_{d,k}},
\qquad
Q_{d,k} = \textcolor{red}{Q^{\text{nom}}_{d,k}}.
```

**Voltage-dependent (ZIP)** scales the setpoint by impedance/current/power fractions
of the voltage-magnitude ratio $|\Delta\textcolor{blue}{U_{d,k}}|/\textcolor{red}{V^{\text{nom}}_{d,k}}$:

```math
\begin{aligned}
P_{d,k} &= \textcolor{red}{P^{\text{nom}}_{d,k}}\left(\textcolor{red}{\alpha_Z}\,\frac{|\Delta\textcolor{blue}{U_{d,k}}|^2}{(\textcolor{red}{V^{\text{nom}}_{d,k}})^2} + \textcolor{red}{\alpha_I}\,\frac{|\Delta\textcolor{blue}{U_{d,k}}|}{\textcolor{red}{V^{\text{nom}}_{d,k}}} + \textcolor{red}{\alpha_P}\right),\\
Q_{d,k} &= \textcolor{red}{Q^{\text{nom}}_{d,k}}\left(\textcolor{red}{\beta_Z}\,\frac{|\Delta\textcolor{blue}{U_{d,k}}|^2}{(\textcolor{red}{V^{\text{nom}}_{d,k}})^2} + \textcolor{red}{\beta_I}\,\frac{|\Delta\textcolor{blue}{U_{d,k}}|}{\textcolor{red}{V^{\text{nom}}_{d,k}}} + \textcolor{red}{\beta_P}\right).
\end{aligned}
```

**Exponential** uses a power law
$P_{d,k} = \textcolor{red}{P^{\text{nom}}_{d,k}}\,(|\Delta\textcolor{blue}{U_{d,k}}|/\textcolor{red}{V^{\text{nom}}_{d,k}})^{\textcolor{red}{\gamma_P}}$
(and likewise $Q$ with $\textcolor{red}{\gamma_Q}$). Constant-impedance, constant-current
and constant-power are the special cases $\alpha=(1,0,0),(0,1,0),(0,0,1)$ and integer
exponents $\gamma\in\{2,1,0\}$.

### Current conservation

The sub-load currents sum to zero over the load's terminals (the neutral / return
carries $-\sum_k\textcolor{blue}{I_{d,k}}$), giving the KCL contribution at each host
terminal.

## 5. Inequality constraints

**None (foundational).** A load has no rating bounds in this model — it is a fixed or
voltage-dependent power sink.
