# References

This specification stands on a large body of work in distribution-system modelling and
optimal power flow. Foundational papers and tools which have influenced the data
specification and network cases, including the four-wire current–voltage (IVR-EN)
formulation, are as follows:

- **F. Geth et al.**, "Considerations and design goals for unbalanced optimal power flow
  benchmarks," *Electric Power Systems Research*, 2024. The benchmarking philosophy
  behind this Task Force effort.
- **D. M. Fobes, S. Claeys, F. Geth, C. Coffrin**, "PowerModelsDistribution.jl: An
  open-source framework for exploring distribution power flow formulations," *Electric
  Power Systems Research*, 2020. The `IVRENPowerModel` referenced from
  [Background & scope](scope.md).
- **R. C. Dugan**, "A perspective on transformer modeling for distribution system
  analysis," *IEEE PES General Meeting*, 2003. Background for the
  [transformer](transformer.md) winding models and grounding conventions.
- **W. H. Kersting**, *Distribution System Modeling and Analysis*, CRC Press (4th ed.,
  2017). The standard reference for line/cable impedance (Carson's equations, Kron
  reduction), transformer connections, and unbalanced power flow — the physics behind
  the [line](line.md) and [transformer](transformer.md) pages.
- **T. A. Short**, *Electric Power Distribution Handbook*, CRC Press (2nd ed., 2014). An
  equipment-oriented companion covering feeders, grounding, and protection.
  This has influenced the field names for the [capacitor](capacitor.md) page.
- **OpenDSS** (EPRI) — a widely used distribution power-flow engine and a common
  source and cross-validation reference for distribution models.
- **S. Babaeinejadsarookolaee et al.**, "The Power Grid Library for benchmarking AC
  optimal power flow algorithms" (PGLib-OPF), 2019. The transmission-side, positive-
  sequence analogue of the data specification and network cases provided by the 
  BMOPF Task Force.
