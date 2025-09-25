module FewBodyDB

# import / export
export @get, @bib

# set dictionary
REFS = Dict{String,String}()
DATA = Dict{String,String}()

# put new data (for development use only)
macro put(expr)
  DATA[join(string.(expr.args[begin:end-1]), "/")] = string(expr.args[end])
end

# get data
"""
Get data from `FewBodyDB.DATA`.
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
  return DATA[key]
end

# put new bibliography (for development use only)
macro ref(expr)
  REFS[string(expr.args[begin])] = string(expr.args[end])
end

# get BibTeX entry
"""
Get BibTeX entry from `FewBodyDB.DATA`.
```julia
julia> println(@bib Bubin2005Jan)
@article{Bubin2005Jan,
  title = {Charge asymmetry in HD+},
  volume = {122},
  ISSN = {1089-7690},
  url = {http://dx.doi.org/10.1063/1.1850905},
  DOI = {10.1063/1.1850905},
  number = {4},
  journal = {The Journal of Chemical Physics},
  publisher = {AIP Publishing},
  author = {Bubin,  Sergiy and Bednarz,  Eugeniusz and Adamowicz,  Ludwik},
  year = {2005},
  month = jan 
}
```
"""
macro bib(expr)
  if expr isa String
    # @bib "Bubin2005Jan"
    return :( FewBodyDB.bib($expr) )
  elseif expr isa Expr && expr.head == :string
    # s = Bubin2005Jan; @bib "$s"
    return :( FewBodyDB.bib(string($(esc(expr)))) )
  elseif expr isa Symbol
    try
      # @bib Bubin2005Jan
      return FewBodyDB.bib(string(expr))
    catch
      # k = "Bubin2005Jan"; @bib k
      return :( FewBodyDB.bib(string($(esc(expr)))) )
    end
  else
    # others
    return :( FewBodyDB.bib(string($(esc(expr)))) )
  end
end

function bib(key)
  return REFS[key]
end

# list keys
macro keys()
  return collect(Base.keys(DATA))
end

# update bibliography & database
include("refs/Bubin2005Jan.jl")
include("refs/Karr2006Apr.jl")
include("refs/Suzuki2003Jul.jl")
end
