```@meta
CurrentModule = FewBodyDB
```

# FewBodyDB.jl

FewBodyDB is a database of reference results for few-body systems. It is
intended for validating numerical solvers in
[JuliaFewBody](https://github.com/JuliaFewBody) projects.

## Usage

[`db`](@ref) returns a typed [`DatabaseEntry`](@ref), including the result's
provenance and state metadata.

```@repl
using FewBodyDB
entry = db(:Bubin2005Jan, Symbol("HD⁺"), :energy, (J = 0, v = 0))
entry.value
entry.state
println(bib(entry))
```

A slash-separated key returned by [`dbkeys`](@ref) can also be used directly:

```@repl
using FewBodyDB
db("Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)").value
```

The old `@get` and `@bib` macros remain available as compatibility wrappers,
but function calls are preferred for new code.

## Data

```@eval
using FewBodyDB
using Markdown
rows = map(dbkeys()) do key
    entry = db(key)
    "| `$(key)` | `$(entry.value)` | `$(entry.reference)` |\n"
end
Markdown.parse(
    "| key | value | reference |\n" *
    "| :-- | --: | :-- |\n" *
    join(rows),
)
```

## Bibliography

```@example
using FewBodyDB # hide
references = sort!(unique([db(key).reference for key in dbkeys()]); by = string) # hide
for key in references # hide
    println(bib(key)) # hide
end # hide
```

## Citation

Please use [CITATION.bib](https://github.com/JuliaFewBody/FewBodyDB.jl/blob/main/CITATION.bib)
if you need to cite this package.

```@example
println(read("../../CITATION.bib", String))
```

## API reference

```@index
```

```@autodocs
Modules = [FewBodyDB]
```
