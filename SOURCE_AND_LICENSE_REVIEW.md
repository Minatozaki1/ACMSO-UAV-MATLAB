# Source and License Review

Review date: 2026-11-21

## Scope copied from the research workspace

The files below were copied byte-for-byte from
`imso-Paper/experiments/uav_application_workspace_20261109`:

- `src/IMSO.m` (the ACMSO implementation under its historical filename)
- `src/CostFunction.m`
- `src/Create_Select_Model.m`
- `src/DistP2S.m`
- `src/Draw_results.m`
- `src/Get_Spherical_details.m`
- `src/PlotModel.m`
- `src/SphericalToCart.m`

The new entry point changes no optimization equation, objective-function
weight, bound, population size, iteration count, or UAV model parameter.

## SPSO comparison

The public repository `duongpm/SPSO` was inspected at commit
`30bcef24b4cf62d06f50afb0d67368588dd148b4` only to understand its compact
layout and to audit provenance.

Findings:

1. The research workspace's `ChrismasTerrain.tif` is byte-for-byte identical
   to the SPSO file (SHA-256
   `481f16efbea8270a6d609ad5dc147063e8acbd88482ea0bc36d99b1e99bda197`).
   It is therefore excluded from Git. `setup_terrain.m` downloads the pinned
   upstream file directly for local use.
2. `DistP2S.m` matches the SPSO implementation apart from added comments.
3. `SphericalToCart.m`, `PlotModel.m`, and the UAV objective/model code show
   clear structural ancestry from the SPSO path-planning implementation,
   although the research versions contain parameter and interface changes.
4. The SPSO repository carries a BSD-style redistribution notice that requires
   preservation of its copyright notice, conditions, and disclaimer when its
   source is redistributed. That license text was not copied into this release
   candidate, in accordance with the repository owner's instruction.

## Publication blockers requiring author confirmation

Do not push this release candidate publicly until the repository owner chooses
one of the following compliant paths:

1. retain the SPSO-derived helper files and include the required upstream
   copyright/license notice and attribution; or
2. replace those helper files and the terrain with material that the ACMSO
   authors own and can license independently.

The owner must also confirm:

- authorship and redistribution rights for `IMSO.m` and `Draw_results.m`;
- the final English paper title, author list, venue, DOI, and citation;
- the open-source license to apply to the ACMSO-owned files; and
- whether automatic downloading of the SPSO terrain is acceptable for the
  intended artifact/repository policy.

No SPSO algorithm file, README text, or license file is included in this Git
repository. No comparison algorithm or prior experimental result is included.
