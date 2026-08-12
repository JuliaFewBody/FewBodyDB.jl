module FewBodyDB

export DatabaseEntry, db, dbkeys, bib, @get, @bib

import Base: put!

"""
    DatabaseEntry(reference, system, observable, state, value)

A benchmark result stored in the database. `reference` identifies its
bibliographic source, while `system`, `observable`, and `state` describe the
calculation. `value` retains the concrete numeric type used by the source.
"""
struct DatabaseEntry{S,T<:Real}
    reference::Symbol
    system::Symbol
    observable::Symbol
    state::S
    value::T
end

# These registries are deliberately private. All lookup and registration goes
# through the functions below so validation and storage can evolve independently
# of the public API.
const _DATABASE = Dict{String,DatabaseEntry}()
const _REFERENCES = Dict{Symbol,String}()

_symbol(value::Symbol) = value
_symbol(value::AbstractString) = Symbol(value)

function _dbkey(reference, system, observable, state)
    return join(
        string.((_symbol(reference), _symbol(system), _symbol(observable), state)),
        "/",
    )
end

function _available(values)
    isempty(values) && return "none"
    return join(repr.(values), ", ")
end

# Register bundled bibliography while loading the package.
function _register_reference!(key::Union{Symbol,AbstractString}, bibtex::AbstractString)
    reference = _symbol(key)
    haskey(_REFERENCES, reference) &&
        throw(ArgumentError("reference $(repr(reference)) is already registered"))

    _REFERENCES[reference] = String(bibtex)
    return _REFERENCES[reference]
end

"""
    put!(reference, system, observable, state, value) -> DatabaseEntry

Add a benchmark result to the database. The first three arguments may be
symbols or strings, `reference` must already exist in the bundled bibliography,
and `value` must be real. Registering the same result twice throws an
`ArgumentError`.
"""
function put!(
    reference::Union{Symbol,AbstractString},
    system::Union{Symbol,AbstractString},
    observable::Union{Symbol,AbstractString},
    state,
    value::T,
) where {T<:Real}
    reference_symbol = _symbol(reference)
    haskey(_REFERENCES, reference_symbol) || throw(
        ArgumentError(
            "unknown reference $(repr(reference_symbol)); available references: " *
            _available(_referencekeys()),
        ),
    )

    key = _dbkey(reference_symbol, system, observable, state)
    haskey(_DATABASE, key) &&
        throw(ArgumentError("database key $(repr(key)) is already registered"))

    entry = DatabaseEntry(
        reference_symbol,
        _symbol(system),
        _symbol(observable),
        deepcopy(state),
        value,
    )
    _DATABASE[key] = entry
    return deepcopy(entry)
end

"""
    db(key::Union{Symbol,AbstractString}) -> DatabaseEntry
    db(reference, system, observable, state) -> DatabaseEntry

Return a benchmark result. A result can be addressed by its slash-separated
key or by its four structured key components. The returned entry is independent
of the stored value and can safely be modified if its `state` is mutable.

# Examples

```julia
entry = db(:Bubin2005Jan, Symbol("HD⁺"), :energy, (J = 0, v = 0))
entry.value == -0.5978979685

db("Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)").value
```
"""
function db(key::AbstractString)
    haskey(_DATABASE, key) || throw(
        ArgumentError(
            "unknown database key $(repr(key)); available keys: " *
            _available(dbkeys()),
        ),
    )

    return deepcopy(_DATABASE[key])
end

db(key::Symbol) = db(string(key))

function db(
    reference::Union{Symbol,AbstractString},
    system::Union{Symbol,AbstractString},
    observable::Union{Symbol,AbstractString},
    state,
)
    return db(_dbkey(reference, system, observable, state))
end

"""
    dbkeys() -> Vector{String}

Return all database keys in deterministic order.
"""
dbkeys() = sort!(collect(keys(_DATABASE)))

"""
    bib(key::Union{Symbol,AbstractString}) -> String
    bib(entry::DatabaseEntry) -> String

Return the BibTeX source associated with a reference key or database entry.
"""
function bib(key::Union{Symbol,AbstractString})
    reference = _symbol(key)
    haskey(_REFERENCES, reference) || throw(
        ArgumentError(
            "unknown reference $(repr(reference)); available references: " *
            _available(_referencekeys()),
        ),
    )

    return _REFERENCES[reference]
end

bib(entry::DatabaseEntry) = bib(entry.reference)

_referencekeys() = sort!(collect(keys(_REFERENCES)); by = string)

# Compatibility wrappers for the original macro API. New code should prefer
# `db(...).value`, `bib(...)`, and `dbkeys()`.
macro get(expr)
    if expr isa Expr && expr.head === :tuple && length(expr.args) == 4
        reference, system, observable, state = expr.args
        quote_component = value -> value isa Symbol ? QuoteNode(value) : esc(value)
        return :(
            FewBodyDB.db(
                $(quote_component(reference)),
                $(quote_component(system)),
                $(quote_component(observable)),
                $(esc(state)),
            ).value
        )
    end

    return :(FewBodyDB.db($(esc(expr))).value)
end

macro bib(expr)
    key = expr isa Symbol ? QuoteNode(expr) : esc(expr)
    return :(FewBodyDB.bib($key))
end

macro keys()
    return :(FewBodyDB.dbkeys())
end

# Declarative registration helpers used only by the bundled source files.
macro ref(expr)
    expr isa Expr && expr.head === :tuple && length(expr.args) == 2 ||
        throw(ArgumentError("@ref expects a reference key and a BibTeX string"))
    reference, bibtex = expr.args
    key = reference isa Symbol ? QuoteNode(reference) : esc(reference)
    return :(FewBodyDB._register_reference!($key, $(esc(bibtex))))
end

macro put(expr)
    expr isa Expr && expr.head === :tuple && length(expr.args) == 5 || throw(
        ArgumentError(
            "@put expects a reference, system, observable, state, and numeric value",
        ),
    )
    reference, system, observable, state, value = expr.args
    quote_component =
        component -> component isa Symbol ? QuoteNode(component) : esc(component)
    return :(
        FewBodyDB.put!(
            $(quote_component(reference)),
            $(quote_component(system)),
            $(quote_component(observable)),
            $(esc(state)),
            $(esc(value)),
        )
    )
end

include("refs/Bubin2005Jan.jl")
include("refs/Karr2006Apr.jl")
include("refs/Suzuki2003Jul.jl")

end
