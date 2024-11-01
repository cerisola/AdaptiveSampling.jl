"""
    VisvalingamCost <: AbstractCost{3}

A cost function that computes the Visvalingam-Whyatt area-based cost between two points. The cost is defined as the square root of the area formed by the points, normalized by a specified norm:
```math
cost(x, y) = \\sqrt{\\frac{\\text{area}(x, y)}{\\text{norm}}}
```
where `area(x, y)` is the area of the triangle formed by the points `x` and `y`, each of length 3 identifying three points in the `x`-`y` plane.

# Fields
- `norm::Float64`: The normalization factor for the cost.

# Constructors
- `VisvalingamCost()`: Creates a `VisvalingamCost` with a default norm of `1.0`.
- `VisvalingamCost(norm)`: Creates a `VisvalingamCost` with the specified norm.
- `VisvalingamCost(a, b, fa, fb)`: Creates a `VisvalingamCost` with the norm set to the area of the triangle formed by points `(a, fa)` and `(b, fb)`.
"""
struct VisvalingamCost <: AbstractCost{3}
    norm::Float64

    VisvalingamCost() = new(1.0)

    VisvalingamCost(norm::Real) = new(Float64(norm))

    VisvalingamCost(x) = VisvalingamCost(x, x)

    function VisvalingamCost(x, y)
        if maximum(y) == minimum(y)
            return VisvalingamCost(x, x)
        else
            return VisvalingamCost((maximum(x) - minimum(x))*(maximum(y) - minimum(y))/2)
        end
    end
end

(c::VisvalingamCost)(x, y) = sqrt(area(x, y)/c.norm)