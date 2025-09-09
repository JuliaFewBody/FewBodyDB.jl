using FewBodyDatabase
using Documenter

DocMeta.setdocmeta!(FewBodyDatabase, :DocTestSetup, :(using FewBodyDatabase); recursive=true)

makedocs(;
    modules=[FewBodyDatabase],
    authors="Shuhei Ohno, Martin Mikkelsen",
    sitename="FewBodyDatabase.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaFewBody.github.io/FewBodyDatabase.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaFewBody/FewBodyDatabase.jl",
    devbranch="main",
)
