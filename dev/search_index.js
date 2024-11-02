var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = AdaptiveSampling","category":"page"},{"location":"#AdaptiveSampling","page":"Home","title":"AdaptiveSampling","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for AdaptiveSampling.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [AdaptiveSampling]","category":"page"},{"location":"#AdaptiveSampling.AbstractCost","page":"Home","title":"AdaptiveSampling.AbstractCost","text":"AbstractCost{N}\n\nAn abstract type representing a cost function with N neighbors. This type serves as a base for defining various cost functions that compute the cost between points in a vector space.\n\nTo define a custom cost function, a subtype of AbstractCost must implement a method call for the type that takes two vectors as input and returns the cost between them.\n\nExample\n\n```julia struct MyCustomCost <: AbstractCost{2}     norm::Float64 end\n\nfunction (c::MyCustomCost)(x, y)     # Custom cost computation     return abs(last(x) - first(x)) / c.norm end\n\ncost = MyCustomCost(1.0) cost([1, 3], [4, 6]) # returns 2.0\n\n\n\n\n\n","category":"type"},{"location":"#AdaptiveSampling.CompositeCost","page":"Home","title":"AdaptiveSampling.CompositeCost","text":"CompositeCost{N, M} <: AbstractCost{N}\n\nA cost function that combines multiple cost functions into a composite cost. The composite cost is a weighted sum of the individual costs:\n\ncost(x y) = sum_k=1^M w_k c_k(x y)\n\nwhere c_k is the k-th individual cost function, and w_k is the weight for the k-th cost function. The weights are normalized to sum to 1.\n\nIf a weight is set to Inf, the composite cost is the maximum of the individual costs. Otherwise, the composite cost is the weighted average of the individual costs.\n\nType Parameters\n\nN: The maximum number of neighbors considered by the composite cost function.\nM: The number of individual cost functions combined in the composite cost.\n\nFields\n\ncosts::NTuple{M, AbstractCost}: A tuple of individual cost functions.\nweights::NTuple{M, Float64}: A tuple of weights for the individual cost functions.\n\nConstructors\n\nCompositeCost(costs::NTuple{M, AbstractCost}, weights::NTuple{M, Real}) where {M}: Creates a CompositeCost with the specified cost functions and weights. The weights are normalized to sum to 1.\nCompositeCost(costs::Vararg{AbstractCost, M}) where {M}: Creates a CompositeCost with the specified cost functions and default weights of Inf.\n\n\n\n\n\n","category":"type"},{"location":"#AdaptiveSampling.EuclideanCost","page":"Home","title":"AdaptiveSampling.EuclideanCost","text":"EuclideanCost <: AbstractCost{2}\n\nA cost function that computes the cost as the Euclidean distance between last and first elements of the input vectors, normalized by a specified norm:\n\ncost(x y) = fracsqrt(xend - x1)^2 + (yend - y1)^2textnorm\n\nFields\n\nnorm::Float64: The normalization factor for the cost.\n\nConstructors\n\nEuclideanCost(): Creates a EuclideanCost with a default norm of 1.0.\nEuclideanCost(norm): Creates a EuclideanCost with the specified norm.\nEuclideanCost(a, b, fa, fb): Creates a EuclideanCost with the norm set to the Euclidean distance between points (a, fa) and (b, fb).\n\n\n\n\n\n","category":"type"},{"location":"#AdaptiveSampling.UniformCost","page":"Home","title":"AdaptiveSampling.UniformCost","text":"UniformCost <: AbstractCost{2}\n\nA cost function that computes the cost as the absolute difference between the last and first elements of the input vectors, normalized by a specified norm:\n\ncost(x y) = fracxend - x1textnorm\n\nFields\n\nnorm::Float64: The normalization factor for the cost.\n\nConstructors\n\nUniformCost(): Creates a UniformCost with a default norm of 1.0.\nUniformCost(norm): Creates a UniformCost with the specified norm.\nUniformCost(a, b): Creates a UniformCost with the norm set to the absolute difference between a and b.\n\n\n\n\n\n","category":"type"},{"location":"#AdaptiveSampling.VisvalingamCost","page":"Home","title":"AdaptiveSampling.VisvalingamCost","text":"VisvalingamCost <: AbstractCost{3}\n\nA cost function that computes the Visvalingam-Whyatt area-based cost between two points. The cost is defined as the square root of the area formed by the points, normalized by a specified norm:\n\ncost(x y) = sqrtfractextarea(x y)textnorm\n\nwhere area(x, y) is the area of the triangle formed by the points x and y, each of length 3 identifying three points in the x-y plane.\n\nFields\n\nnorm::Float64: The normalization factor for the cost.\n\nConstructors\n\nVisvalingamCost(): Creates a VisvalingamCost with a default norm of 1.0.\nVisvalingamCost(norm): Creates a VisvalingamCost with the specified norm.\nVisvalingamCost(a, b, fa, fb): Creates a VisvalingamCost with the norm set to the area of the triangle formed by points (a, fa) and (b, fb).\n\n\n\n\n\n","category":"type"},{"location":"#AdaptiveSampling.sample_costs-Union{Tuple{N}, Tuple{Any, Any, Any}, Tuple{Any, Any, Any, Union{Nothing, Int64}}} where N","page":"Home","title":"AdaptiveSampling.sample_costs","text":"sample(f, a, b, nsamples::Uniont{Int, Nothing}; cost::AbstractCost=CompositeCost((UniformCost(a, b), VisvalingamCost(a, b, f(a), f(b))), (1, 100)), tol=1e-3, maxsamples=10000)\nsample_costs(f, a, b, nsamples::Uniont{Int, Nothing}; cost::AbstractCost=CompositeCost((UniformCost(a, b), VisvalingamCost(a, b, f(a), f(b))), (1, 100)), tol=1e-3, maxsamples=10000)\n\nSamples the function f over the interval [a, b] and computes the associated costs using the specified cost function. The sampling process continues until the maximum cost is below the tolerance tol or the maximum number of samples maxsamples is reached.\n\nArguments\n\nf: The function to be sampled.\na: The start of the interval.\nb: The end of the interval.\nnsamples::Union{Int, Nothing}: The number of samples to be taken. If nothing, the number of samples will be determined by the tolerance tol. Defaults to nothing.\ncost::AbstractCost: The cost function to be used. Defaults to a composite cost combining UniformCost and VisvalingamCost.\ntol: The tolerance for the maximum cost. Defaults to 1e-3. The tolerance is only used if nsamples is nothing.\nmaxsamples: The maximum number of samples. Defaults to 10000.\n\nReturns\n\nx: A vector of sample points.\ny: A vector of function values at the sample points.\nc: A vector of costs associated with the sample points (only returned by sample_costs).\n\n\n\n\n\n","category":"method"}]
}