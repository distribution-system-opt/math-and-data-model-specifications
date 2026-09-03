# Nomenclature

A consolidated list of the recurring symbols. The typography and colour convention
(variable vs parameter, real vs complex) and the transform constants are defined on the
[Notation](notation.md) page; the string-valued parameters and their permitted values are
listed under [Data input formatting](data-format.md#Permissible-strings-and-string-arrays);
and the element sets, topology, connectivity, and terminal mappings are collected in
[Notation → Sets and indices](notation.md#Sets-and-indices).

Matrix dimensions $n\times n$ have $1 \le n \le 4$; per-phase vector lengths have
$1 \le n \le 3$ (excluding the neutral).

## Complex-valued variables

| Symbol | Unit | Length | Represents |
|:------:|:----:|:------:|------------|
| $\mathbf{U}_i$ | V | 4 | Bus $i$ phase-to-ground voltage vector |
| $\mathbf{U}^{\Delta}_i$ | V | 3 | Bus $i$ phase-to-phase voltage vector |
| $\mathbf{U}^{\text{pn}}_i$ | V | 3 | Bus $i$ phase-to-neutral voltage vector |
| $\mathbf{U}^{012}_i$ | V | 3 | Bus $i$ symmetrical-component voltage vector |
| $\mathbf{I}_{\ell ij}$ | A | 4 | Line $\ell$ total current, direction $i\to j$ |
| $\mathbf{I}^{\text{s}}_{\ell ij}$ | A | 4 | Line $\ell$ series current, direction $i\to j$ |
| $\mathbf{I}^{\text{sh}}_{\ell ij}$ | A | 4 | Line $\ell$ shunt current, direction $i\to j$ |
| $\mathbf{S}_{\ell ij}$ | W | 4 | Line $\ell$ total power, direction $i\to j$ |
| $\mathbf{S}^{\text{s}}_{\ell ij}$ | W | 4 | Line $\ell$ series power, direction $i\to j$ |
| $\mathbf{S}_d$ | W | 4 | Load $d$ power at its bus |
| $\mathbf{S}^{\text{pn}}_d$ | W | 3 | Load $d$ power in wye (phase-to-neutral) frame |
| $\mathbf{S}^{\Delta}_d$ | W | 3 | Load $d$ power in delta frame |
| $\mathbf{I}_d$ | A | 2, 3 or 4 | Load $d$ current at its bus |
| $\mathbf{I}^{\Delta}_d$ | A | 3 | Load $d$ internal delta current |
| $\mathbf{S}_g$ | W | 4 | Generator $g$ power at its bus |
| $\mathbf{S}^{\text{pn}}_g$ | W | 3 | Generator $g$ power in wye frame |
| $\mathbf{S}^{\Delta}_g$ | W | 3 | Generator $g$ power in delta frame |
| $\mathbf{I}_g$ | A | 4 | Generator $g$ current at its bus |

## Complex-valued parameters

| Symbol | Unit | Size | Represents |
|:------:|:----:|:----:|------------|
| $\mathbf{Y}^{\text{sh}}_{\ell ij}$ | S | $n\times n$ | Line $\ell$ shunt admittance at sending end $i$ |
| $\mathbf{Y}^{\text{sh}}_{\ell ji}$ | S | $n\times n$ | Line $\ell$ shunt admittance at receiving end $j$ |
| $\mathbf{Z}^{\text{s}}_\ell$ | Ω | $n\times n$ | Line $\ell$ series impedance matrix |
| $\mathbf{Y}_h$ | S | $n\times n$ | Bus shunt admittance (neutral grounding, capacitor banks, …) |
| $\mathbf{S}^{\text{ref,pn}}_d$ | W+$j$var | $3\times1$ | Load $d$ complex power set-point (wye-connected) |
| $\mathbf{S}^{\text{ref},\Delta}_d$ | W+$j$var | $3\times1$ | Load $d$ complex power set-point (delta-connected) |
| $\mathbf{S}^{\text{ref,pn}}_g$ | W+$j$var | $3\times1$ | Generator $g$ complex power set-point |
| $\bar{\mathbf{Z}}^{\text{s}}_c$ | Ω/m | $n\times n$ | Linecode per-length series impedance |
| $\bar{\mathbf{Y}}^{\text{sh}}_c$ | S/m | $n\times n$ | Linecode per-length shunt admittance |

## Real-valued parameters

| Symbol | Unit | Size | Represents |
|:------:|:----:|:----:|------------|
| $\mathbf{U}^{\min}_i,\ \mathbf{U}^{\max}_i$ | V | $4\times1$ | Bus $i$ phase-to-ground magnitude bounds |
| $\mathbf{U}^{\text{pn},\min}_i,\ \mathbf{U}^{\text{pn},\max}_i$ | V | $3\times1$ | Bus $i$ phase-to-neutral magnitude bounds |
| $\mathbf{U}^{012,\min}_i,\ \mathbf{U}^{012,\max}_i$ | V | $3\times1$ | Bus $i$ symmetrical-component magnitude bounds |
| $\mathbf{I}^{\max}_{\ell ij}$ | A | $4\times1$ | Line $\ell$ current-magnitude upper bound |
| $\mathbf{S}^{\max}_{\ell ij}$ | VA | $4\times1$ | Line $\ell$ apparent-power upper bound |
| $\mathbf{P}^{\min}_g,\ \mathbf{P}^{\max}_g$ | W | $n\times1$ | Generator $g$ active-power bounds |
| $\mathbf{Q}^{\min}_g,\ \mathbf{Q}^{\max}_g$ | var | $n\times1$ | Generator $g$ reactive-power bounds |
| $\mathbf{c}_g$ | \$/kWh | $n\times1$ | Generator $g$ per-phase dispatch cost |
| $\mathbf{c}_s$ | \$/kWh | $n\times1$ | Voltage source $s$ per-phase dispatch cost |
| $\ell_l$ | m | scalar | Line length |
