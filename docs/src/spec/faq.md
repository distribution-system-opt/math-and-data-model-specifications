# Modelling notes and FAQ

Practical questions that recur when building cases. Symbols are defined in
[Notation](notation.md).

## How do I model a constant-impedance or constant-current load?

Use the [load](load.md) `model` field: `constant_impedance` ($P\propto|V|^2$),
`constant_current` ($P\propto|V|$), or a full `zip` mix, with `v_nom` giving the
reference voltage. (Older guidance suggested emulating a constant-impedance load with a
[shunt](shunt.md); that is no longer necessary now that voltage-dependent load models
are supported.)

## How do I define a triplex (split-phase service) load?

As one or more **single-phase** loads across the triplex terminals. For a 1 kW load
across legs `1`–`2` of a triplex bus with `terminal_names` `["1","n","2"]`, define a
`SINGLE_PHASE` load with `terminal_map` `["1","2"]` and `p_nom` `[1000.0]`. A
two-terminal `SINGLE_PHASE` map is modelled across exactly those two terminals (here
line-to-line, 240 V), not phase-to-ground — see [Loads](load.md).

## I converted a wye load to delta with the standard transform and got a different answer. Why?

Because a distribution **wye load is four-wire** — three phase branches to a *neutral
return* conductor — whereas the textbook delta–wye (Y–Δ) transform assumes a *three-wire*
wye with no return (a graph-theoretic star). The transform is **not applicable** to a
wye-with-neutral load. Model the wye and delta connections directly via the load
`configuration` field; do not pre-transform.

## How do I model a three-wire wye load (no neutral return)?

Add a **floating midpoint** terminal at the bus and connect three single-phase loads (or
a wye-with-return whose neutral ties to that floating node) across the phases to it. The
floating node carries no external connection, so it enforces the zero-return-current
condition of a true three-wire star. There is no dedicated "wye-without-neutral" load
subtype.

## How do I get center-tap transformer impedances from OpenDSS or Gridlab-D?

**OpenDSS** specifies the three inter-winding short-circuit reactances
$\texttt{Xhl},\texttt{Xlt},\texttt{Xht}$ (% p.u.). These map to the per-winding
reactances by the star (T) transform
$[\texttt{Xh};\texttt{Xl};\texttt{Xt}] = \tfrac12\,\mathbf{S}\,[\texttt{Xhl};\texttt{Xlt};\texttt{Xht}]$
with $\mathbf{S}=\left[\begin{smallmatrix}1&-1&1\\1&1&-1\\-1&1&1\end{smallmatrix}\right]$,
then to ohms via the winding voltage/power base. The [transformer](transformer.md)
page gives the full partitioning (and warns against the common $\texttt{Xhl}/2$ shortcut,
which is wrong for center-tap under unbalance).

**Gridlab-D** gives per-unit primary `impedance` and secondary `impedance1` with a
`power_rating` for the *whole* transformer. The per-winding SI impedances are

```math
\textcolor{brown}{Z_i} = \texttt{impedance}\cdot\frac{3}{1000}\cdot\frac{\texttt{primary\_voltage}^2}{\texttt{power\_rating}},
\qquad
\textcolor{brown}{Z_j} = \texttt{impedance1}\cdot\frac{3}{1000}\cdot\frac{\texttt{secondary\_voltage}^2}{\texttt{power\_rating}},
```

where the factor 3 accounts for the total rating being three times the primary-winding
power, and 1000 converts the kVA rating to VA.

!!! note "Import tools usually apply these conversions"
    Tools that import from OpenDSS or Gridlab-D typically apply these conversions
    automatically when reading source models. The formulas are given here for authors
    constructing data by hand or auditing an import.

## My line impedances are sequence components only — can I convert them to wire coordinates?

Yes. Sequence-component impedances convert to phase (wire) coordinates through the
Fortescue transform $\textcolor{brown}{\mathbf{F}}$ (defined in [Notation](notation.md)).
Writing sequence voltages and currents as $\textcolor{blue}{\mathbf{U}^{\text{sym}}_i}=\textcolor{brown}{\mathbf{F}}\,\textcolor{blue}{\mathbf{U}_i}[\mathcal{P}]$
and $\textcolor{blue}{\mathbf{I}^{\text{sym,s}}_{\ell ij}}=\textcolor{brown}{\mathbf{F}}\,\textcolor{blue}{\mathbf{I}^{\text{s}}_{\ell ij}}[\mathcal{P}]$,
and premultiplying the phase Ohm's law $\textcolor{blue}{\mathbf{U}_j}[\mathcal{P}]=\textcolor{blue}{\mathbf{U}_i}[\mathcal{P}]-\textcolor{brown}{\mathbf{Z}^{\text{s}}_\ell}\,\textcolor{blue}{\mathbf{I}^{\text{s}}_{\ell ij}}[\mathcal{P}]$
by $\textcolor{brown}{\mathbf{F}}$ (inserting $\mathbf{I}=\textcolor{brown}{\mathbf{F}}^{-1}\textcolor{brown}{\mathbf{F}}$) gives the sequence-domain impedance

```math
\textcolor{brown}{\mathbf{Z}^{\text{sym,s}}_\ell} = \textcolor{brown}{\mathbf{F}}\,\textcolor{brown}{\mathbf{Z}^{\text{s}}_\ell}\,\textcolor{brown}{\mathbf{F}}^{-1}
= \begin{bmatrix}
\textcolor{brown}{Z_{\ell,00}} & \textcolor{brown}{Z_{\ell,01}} & \textcolor{brown}{Z_{\ell,02}} \\
\textcolor{brown}{Z_{\ell,10}} & \textcolor{brown}{Z_{\ell,11}} & \textcolor{brown}{Z_{\ell,12}} \\
\textcolor{brown}{Z_{\ell,20}} & \textcolor{brown}{Z_{\ell,21}} & \textcolor{brown}{Z_{\ell,22}}
\end{bmatrix}.
```

Lines are commonly assumed transposed, so the off-diagonal terms are neglected and the
positive and negative sequences take equal value, leaving
$\textcolor{brown}{\mathbf{Z}^{\text{sym,s}}_\ell}\approx\operatorname{diag}(\textcolor{brown}{Z_{\ell,00}},\textcolor{brown}{Z_{\ell,11}},\textcolor{brown}{Z_{\ell,11}})$.
Inverting the transform then recovers the phase impedance matrix from just the zero- and
positive-sequence values $\textcolor{brown}{Z_{\ell,00}},\textcolor{brown}{Z_{\ell,11}}$:

```math
\textcolor{brown}{\mathbf{Z}^{\text{s}}_\ell} = \frac{1}{3}
\begin{bmatrix}
2\textcolor{brown}{Z_{\ell,11}}+\textcolor{brown}{Z_{\ell,00}} & \textcolor{brown}{Z_{\ell,00}}-\textcolor{brown}{Z_{\ell,11}} & \textcolor{brown}{Z_{\ell,00}}-\textcolor{brown}{Z_{\ell,11}} \\
\textcolor{brown}{Z_{\ell,00}}-\textcolor{brown}{Z_{\ell,11}} & 2\textcolor{brown}{Z_{\ell,11}}+\textcolor{brown}{Z_{\ell,00}} & \textcolor{brown}{Z_{\ell,00}}-\textcolor{brown}{Z_{\ell,11}} \\
\textcolor{brown}{Z_{\ell,00}}-\textcolor{brown}{Z_{\ell,11}} & \textcolor{brown}{Z_{\ell,00}}-\textcolor{brown}{Z_{\ell,11}} & 2\textcolor{brown}{Z_{\ell,11}}+\textcolor{brown}{Z_{\ell,00}}
\end{bmatrix}.
```

Here $\textcolor{brown}{\mathbf{Z}^{\text{s}}_\ell}$ is the (three-wire, or Kron-reduced
four-wire) $3\times3$ series-impedance matrix used as the line's `R_series`/`X_series`.
