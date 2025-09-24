```@meta
CurrentModule = FewBodyDB
```

# FewBodyDB.jl

This package is a database of calculation results for few-body systems. It was developed for testing solvers in [JuliaFewBody](https://github.com/JuliaFewBody) projects.

## Usage

The `@get` macro returns the bibliographic value corresponding to the given key.

```@repl
using FewBodyDB
@get Bubin2005Jan, HD⁺, energy, (J=0, v=0)
```

## Data

```@eval
using FewBodyDB
using Markdown
Markdown.parse(string("| command | value |\n| :------ | :---- |\n", [string("| `@get ", replace(k, "/" => ", "), "` | `\"", @get(k), "\"` |\n") for k in @keys]...))
```

## Citation

Please cite this package, the original paper

```@example
file = open("../../CITATION.bib", "r") # hide
text = Base.read(file, String) # hide
close(file) # hide
println(text) # hide
file = open("../../src/refs.bib", "r") # hide
text = Base.read(file, String) # hide
close(file) # hide
println(text) # hide
```

## API reference

```@index
```

```@autodocs
Modules = [FewBodyDB]
```
