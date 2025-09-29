using FewBodyDB
using Documenter

DocMeta.setdocmeta!(FewBodyDB, :DocTestSetup, :(using FewBodyDB); recursive = true)

makedocs(;
    modules = [FewBodyDB],
    authors = "Shuhei Ohno, Martin Mikkelsen",
    sitename = "FewBodyDB.jl",
    format = Documenter.HTML(;
        canonical = "https://JuliaFewBody.github.io/FewBodyDB.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo = "github.com/JuliaFewBody/FewBodyDB.jl",
    devbranch = "main",
)
