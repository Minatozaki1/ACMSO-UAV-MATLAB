# ACMSO for 3-D UAV Path Planning

This repository contains the MATLAB implementation of Adaptive Cooperative
Mirage Search Optimization (ACMSO) used for a three-dimensional UAV path
planning example.

Working English paper title (confirm before publication):
**Three-Dimensional UAV Path Planning Based on Adaptive Cooperative Mirage
Search Optimization**. The current Chinese title is
**基于自适应协同蜃景搜索优化算法的三维无人机路径规划**.

The repository is a compact runnable package containing only ACMSO and the
files required by the UAV example. Benchmark algorithms and experimental
archives are intentionally excluded.

## Requirements

- MATLAB R2026a (the target environment; older releases have not been checked)
- Curve Fitting Toolbox (`csaps` is used by the unchanged result plotter)
- Internet access on the first run, unless the terrain file has already been
  installed with `setup_terrain`

`ellipj`, used by ACMSO, is part of MATLAB. No C/C++ MEX build is required.

## Quick start

Open MATLAB in the repository root and run:

```matlab
validation = validate_repository;
results = ACMSO_MAIN;
```

On first use, `ACMSO_MAIN` calls `setup_terrain`, which downloads the required
terrain file from its pinned third-party source and verifies its SHA-256 hash.
The terrain is not tracked by this repository.

The example retains the research configuration:

- start position: `[200 100 150]`
- goal position: `[800 800 150]`
- terrain complexity: `4`
- path nodes: `10`
- population size: `100`
- maximum iterations: `1000`
- spherical angle range: `pi/4`

No random seed is forced, matching the original example.

## Repository structure

```text
ACMSO-UAV-MATLAB/
|-- ACMSO_MAIN.m
|-- setup_terrain.m
|-- validate_repository.m
|-- README.md
|-- SOURCE_AND_LICENSE_REVIEW.md
|-- SOURCE_HASHES.sha256
|-- data/
|   `-- README.md
`-- src/
    |-- IMSO.m
    |-- CostFunction.m
    |-- Create_Select_Model.m
    |-- DistP2S.m
    |-- Draw_results.m
    |-- Get_Spherical_details.m
    |-- PlotModel.m
    `-- SphericalToCart.m
```

`IMSO.m` is the historical filename of the ACMSO implementation used in the
research workspace. It is retained unchanged so that the released algorithm
can be traced back to the experimental source.

## Publication status

This is a local release candidate. An open-source license has deliberately not
been selected yet. Before publishing the repository, review and resolve the
items in `SOURCE_AND_LICENSE_REVIEW.md`, then add the chosen license and final
paper citation.
