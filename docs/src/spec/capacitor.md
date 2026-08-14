# Capacitors

A **capacitor** is a fixed, nameplate-rated shunt capacitor bank — a special case of
the [Shunt](shunt.md) whose susceptance is derived from nameplate data (a rated
reactive power and voltage) rather than given as an explicit admittance matrix. Three
connection configurations are supported: `WYE`, `DELTA`, and `SINGLE_PHASE`. Symbols
are defined in [Notation](notation.md).

## 1. Data model

A capacitor is an entry of the top-level `capacitor` object, keyed by its string ID
$\kappa$.

| Field | Type | Unit | Req. | Description |
|-------|------|:----:|:----:|-------------|
| `bus` | string | – | ✔ | Host bus ID $i$ |
| `terminal_map` | string[] | – | ✔ | Conductor→terminal map $\textcolor{purple}{\mathbf{N}_\kappa}$ |
| `configuration` | string | – | ✔ | `WYE`, `SINGLE_PHASE`, or `DELTA` |
| `q_rated` | number | var | ✔ | Rated reactive power of the whole bank |
| `v_nom` | number | V | ✔ | Nominal voltage: line-to-line for `WYE`/`DELTA`, across the element for `SINGLE_PHASE` |

## 2. Input symbols

| Field | Symbol | Notes |
|-------|:------:|-------|
| `q_rated` | $\textcolor{red}{Q^{\text{rated}}_\kappa}$ | whole-bank rating |
| `v_nom` | $\textcolor{red}{V^{\text{nom}}_\kappa}$ | line-to-line (`WYE`/`DELTA`) or across-element (`SINGLE_PHASE`) |

The bank is assumed balanced: a single element susceptance
$\textcolor{red}{b_\kappa}$ — derived, not input, see [§4](#4.-Equality-constraints) —
is stamped identically onto every phase (or phase pair) of the bank.

## 3. Variables

**None.** Like a shunt, a capacitor introduces no unknown — its current follows from
the bus voltage and its fixed susceptance.

## 4. Equality constraints

### Susceptance from nameplate data

A capacitor delivers its rated reactive power when the voltage across its terminals
equals the nominal value. The element susceptance is

```math
\textcolor{red}{b_\kappa} = \dfrac{\textcolor{red}{Q^{\text{rated}}_\kappa}}{\textcolor{red}{\beta_\kappa}\,(\textcolor{red}{V^{\text{nom}}_\kappa})^2},
```

where $\textcolor{red}{\beta_\kappa}$ is a configuration-dependent constant:

| `configuration` | $\textcolor{red}{\beta_\kappa}$ | Why |
|---|:--:|---|
| `SINGLE_PHASE` | 1 | the nominal voltage is across the sole element |
| `DELTA` | 3 | three elements, each at the nominal (line-to-line) voltage |
| `WYE` | 1 | three elements, each at $\textcolor{red}{V^{\text{nom}}_\kappa}/\sqrt3$ (phase-to-neutral) |

### Terminal-space assembly

The element susecptance $\textcolor{red}{b_\kappa}$ is assembled into a terminal-space susceptance matrix
$\textcolor{red}{\mathbf{B}_\kappa}$ by a reciprocal two-node stamp
$\textcolor{red}{b_\kappa}\begin{bmatrix}1&-1\\-1&1\end{bmatrix}$, applied once per
element and accumulated onto shared terminals:

- **`SINGLE_PHASE`** — one stamp across the element's two terminals $[p,\,q]$:

```math
\textcolor{red}{\mathbf{B}_\kappa} = \textcolor{red}{b_\kappa}\begin{bmatrix}1&-1\\-1&1\end{bmatrix}.
```

- **`WYE`** — one stamp per phase, between that phase and neutral, on $[a,b,c,n]$:

```math
\textcolor{red}{\mathbf{B}_\kappa} = \textcolor{red}{b_\kappa}
\begin{bmatrix}
1&0&0&-1\\
0&1&0&-1\\
0&0&1&-1\\
-1&-1&-1&3
\end{bmatrix}.
```

- **`DELTA`** — one stamp per phase pair $(a,b),\,(b,c),\,(c,a)$, on $[a,b,c]$:

```math
\textcolor{red}{\mathbf{B}_\kappa} = \textcolor{red}{b_\kappa}
\begin{bmatrix}
2&-1&-1\\
-1&2&-1\\
-1&-1&2
\end{bmatrix}.
```

### Current injection

The bank injects current into KCL at its bus exactly as a shunt would:

```math
\textcolor{blue}{\mathbf{I}_\kappa} = \textcolor{brown}{j}\,\textcolor{red}{\mathbf{B}_\kappa}\,\textcolor{blue}{\mathbf{U}_i}[\textcolor{purple}{\mathbf{N}_\kappa}].
```

The reactive power drawn by each element is voltage-dependent — for a `SINGLE_PHASE`
capacitor, $Q = \textcolor{red}{b_\kappa}\,|\textcolor{blue}{U}|^2$ — rising and
falling with the square of the terminal voltage, the defining behaviour of a fixed
capacitor (as opposed to a fixed-power source). At the balanced nominal voltage the
bank delivers exactly $\textcolor{red}{Q^{\text{rated}}_\kappa}$.

## 5. Inequality constraints

**None.** With a fixed susceptance the current follows the voltage; no rating bound is
imposed.
