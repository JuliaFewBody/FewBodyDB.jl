# FewBodyDB.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaFewBody.github.io/FewBodyDB.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaFewBody.github.io/FewBodyDB.jl/dev/)
[![Build Status](https://github.com/JuliaFewBody/FewBodyDB.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaFewBody/FewBodyDB.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaFewBody/FewBodyDB.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaFewBody/FewBodyDB.jl)

## Documentation

See https://juliafewbody.github.io/FewBodyDB.jl.

## Usage

```julia
using FewBodyDB

entry = db(:Bubin2005Jan, Symbol("HD⁺"), :energy, (J = 0, v = 0))
entry.value # -0.5978979685
bib(entry)  # BibTeX source
```

## Citation

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
