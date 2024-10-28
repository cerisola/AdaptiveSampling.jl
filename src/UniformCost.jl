"""
    UniformCost <: AbstractCost{2}

A cost function that computes the cost as the absolute difference between the last and first elements of the input vectors, normalized by a specified norm:
```math
cost(x, y) = \\frac{|x[end] - x[1]|}{\\text{norm}}
```

# Fields
- `norm::Float64`: The normalization factor for the cost.

# Constructors
- `UniformCost()`: Creates a `UniformCost` with a default norm of `1.0`.
- `UniformCost(norm)`: Creates a `UniformCost` with the specified norm.
- `UniformCost(a, b)`: Creates a `UniformCost` with the norm set to the absolute difference between `a` and `b`.
"""
struct UniformCost <: AbstractCost{2}
    norm::Float64

    UniformCost() = new(1.0)

    UniformCost(norm) = new(Float64(norm))

    UniformCost(a, b) = UniformCost(abs(b - a))
end

(c::UniformCost)(x, y) = abs(last(x) - first(x))/c.norm