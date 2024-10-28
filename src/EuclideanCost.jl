"""
    EuclideanCost <: AbstractCost{2}

A cost function that computes the cost as the Euclidean distance between last and first elements of the input vectors, normalized by a specified norm:
```math
cost(x, y) = \\frac{\\sqrt{(x[end] - x[1])^2 + (y[end] - y[1])^2}}{\\text{norm}}
```

# Fields
- `norm::Float64`: The normalization factor for the cost.

# Constructors
- `EuclideanCost()`: Creates a `EuclideanCost` with a default norm of `1.0`.
- `EuclideanCost(norm)`: Creates a `EuclideanCost` with the specified norm.
- `EuclideanCost(a, b, fa, fb)`: Creates a `EuclideanCost` with the norm set to the Euclidean distance between points `(a, fa)` and `(b, fb)`.
"""
struct EuclideanCost <: AbstractCost{2}
    norm::Float64

    EuclideanCost() = new(1.0)

    EuclideanCost(norm) = new(Float64(norm))

    EuclideanCost(a, b, fa, fb) = EuclideanCost(hypot(b - a, fb - fa))
end

(c::EuclideanCost)(x, y) = hypot(last(x) - first(x), last(y) - first(y))/c.norm