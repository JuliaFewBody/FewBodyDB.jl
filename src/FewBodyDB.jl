module FewBodyDB

# import / export
import JLD2, Bibliography
export @put, @get, @bib, @keys

# set path
const PATH_DATA = joinpath(@__DIR__, "data.jld2")
const PATH_REFS = joinpath(@__DIR__, "refs.bib")

# put new data
"""
!!! note
    For development use only.
Insert new data into the database.
```julia
julia> @put Bubin2005Jan, HD⁺, energy, (J=0, v=0), -0.5978979685 
```
"""
macro put(expr)
  JLD2.jldopen(PATH_DATA, "a+") do file
    file[join(string.(expr.args[begin:end-1]), "/")] = string(expr.args[end])
  end
end

# get data
"""
Select data from the database.
```repl
julia> @get Bubin2005Jan, HD⁺, energy, (J=0, v=0)
"-0.5978979685"
```
"""
macro get(expr)
  if expr isa String
    # @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)"
    return :( FewBodyDB.get($expr) )
  elseif expr isa Expr && expr.head == :string
    # v = 0; @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = $v)"
    return :( FewBodyDB.get(string($(esc(expr)))) )
  elseif expr isa Symbol
    # k = "Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)"; @get k
    return :( FewBodyDB.get(string($(esc(expr)))) )
  elseif expr isa Expr && expr.head == :tuple
    # @get Bubin2005Jan, HD⁺, energy, (J=0, v=0)
    return FewBodyDB.get(join(string.(expr.args), "/"))
  else
    # others
    return :( FewBodyDB.get(string($(esc(expr)))) )
  end
end

function get(key)
  JLD2.jldopen(PATH_DATA, "r") do file
    return file[key]
  end
end

# bibliography
"""
Get bibliographic information for a given key.
```julia
julia> @bib Bubin2005Jan
```
"""
macro bib(expr)
  if expr isa String
    return :( FewBodyDB.bib($expr) )
  elseif expr isa Symbol && isdefined(Main, expr)
    return :( FewBodyDB.bib(string($(esc(expr)))) )
  else
    return FewBodyDB.bib(string(expr))
  end
end

function bib(key)
  imported_bib = Bibliography.import_bibtex(PATH_REFS)
  bib = Bibliography.select(imported_bib, [key])[key]
  return Bibliography.export_bibtex(bib)
end

# list keys
"""
List all keys in the database.
```julia
julia> @keys
71-element Vector{String}:
 "Karr2006Apr/HD⁺/energy/(J = 2, v = 17)"
 "Karr2006Apr/HD⁺/energy/(J = 0, v = 10)"
 "Karr2006Apr/HD⁺/energy/(J = 1, v = 8)"
 "Karr2006Apr/HD⁺/energy/(J = 0, v = 3)"
 "Karr2006Apr/HD⁺/energy/(J = 1, v = 10)"
 "Karr2006Apr/HD⁺/energy/(J = 0, v = 17)"
 "Karr2006Apr/HD⁺/energy/(J = 0, v = 9)"
 "Karr2006Apr/HD⁺/energy/(J = 2, v = 6)"
 "Karr2006Apr/HD⁺/energy/(J = 2, v = 14)"
 "Karr2006Apr/HD⁺/energy/(J = 1, v = 11)"
 "Karr2006Apr/HD⁺/energy/(J = 0, v = 2)"
 "Karr2006Apr/HD⁺/energy/(J = 0, v = 20)"
 "Karr2006Apr/HD⁺/energy/(J = 2, v = 18)"
 ⋮
```
"""
macro keys()
  return collect(Base.keys(JLD2.load(PATH_DATA)))
end

# update database
function 
  JLD2.jldopen(PATH_DATA, "w+") do file
  end
  include("refs/Bubin2005Jan.jl")
  include("refs/Karr2006Apr.jl")
end

end
