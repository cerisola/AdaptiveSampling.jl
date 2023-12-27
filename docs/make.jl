using AdaptiveSampling
using Documenter

DocMeta.setdocmeta!(AdaptiveSampling, :DocTestSetup, :(using AdaptiveSampling); recursive=true)

makedocs(;
    modules=[AdaptiveSampling],
    authors="Federico Cerisola <federico@cerisola.net>",
    repo="https://github.com/cerisola/AdaptiveSampling.jl/blob/{commit}{path}#{line}",
    sitename="AdaptiveSampling.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cerisola.github.io/AdaptiveSampling.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/cerisola/AdaptiveSampling.jl",
    devbranch="main",
)
