"""
    AbstractCost{N}

An abstract type representing a cost function with `N` neighbors. This type serves as a base for defining various cost functions that compute the cost between points in a vector space.

To define a custom cost function, a subtype of `AbstractCost` must implement a method call for the type that takes two vectors as input and returns the cost between them.

# Example
```julia
struct MyCustomCost <: AbstractCost{2}
    norm::Float64
end

function (c::MyCustomCost)(x, y)
    # Custom cost computation
    return abs(last(x) - first(x)) / c.norm
end

cost = MyCustomCost(1.0)
cost([1, 3], [4, 6]) # returns 2.0
"""
abstract type AbstractCost{N} end

number_neighbours(::AbstractCost{N}) where {N} = N