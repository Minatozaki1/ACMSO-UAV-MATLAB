# Terrain data

The UAV example uses `ChrismasTerrain.tif`. The file is not committed here
because its verified upstream source is the `duongpm/SPSO` repository.

Run either of the following commands in MATLAB:

```matlab
setup_terrain
```

or simply run `ACMSO_MAIN`; it invokes the setup function when necessary.

The downloader is pinned to upstream commit
`30bcef24b4cf62d06f50afb0d67368588dd148b4` and verifies this SHA-256 digest:

```text
481f16efbea8270a6d609ad5dc147063e8acbd88482ea0bc36d99b1e99bda197
```

The downloaded file remains untracked by Git. Review the upstream terms and
`../SOURCE_AND_LICENSE_REVIEW.md` before redistributing it.
