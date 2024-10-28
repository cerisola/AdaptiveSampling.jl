module AdaptiveSampling

export UniformCost, EuclideanCost, VisvalingamCost, CompositeCost
export sample, sample_costs

include("geometry.jl")
include("AbstractCost.jl")
include("UniformCost.jl")
include("EuclideanCost.jl")
include("VisvalingamCost.jl")
include("CompositeCost.jl")
include("sample.jl")

end