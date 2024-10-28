"""
    CompositeCost{N, M} <: AbstractCost{N}

A cost function that combines multiple cost functions into a composite cost. The composite cost is a weighted sum of the individual costs:
```math
cost(x, y) = \\sum_{k=1}^{M} w_k c_k(x, y)
```
where `c_k` is the `k`-th individual cost function, and `w_k` is the weight for the `k`-th cost function. The weights are normalized to sum to 1.

If a weight is set to `Inf`, the composite cost is the maximum of the individual costs. Otherwise, the composite cost is the weighted average of the individual costs.

# Type Parameters
- `N`: The maximum number of neighbors considered by the composite cost function.
- `M`: The number of individual cost functions combined in the composite cost.

# Fields
- `costs::NTuple{M, AbstractCost}`: A tuple of individual cost functions.
- `weights::NTuple{M, Float64}`: A tuple of weights for the individual cost functions.

# Constructors
- `CompositeCost(costs::NTuple{M, AbstractCost}, weights::NTuple{M, Real}) where {M}`: Creates a `CompositeCost` with the specified cost functions and weights. The weights are normalized to sum to 1.
- `CompositeCost(costs::Vararg{AbstractCost, M}) where {M}`: Creates a `CompositeCost` with the specified cost functions and default weights of `Inf`.
"""
struct CompositeCost{N, M} <: AbstractCost{N} where {M}
    costs::NTuple{M, AbstractCost}
    weights::NTuple{M, Float64}
end

function CompositeCost(costs::NTuple{M, AbstractCost}, weights::NTuple{M, Real}) where {M}
    N = maximum(number_neighbours(c) for c in costs)
    W = Float64(sum(weights))
    CompositeCost{N, M}(costs, weights./W)
end

function CompositeCost(costs::Vararg{AbstractCost, M}) where {M}
    CompositeCost(costs, ntuple(i -> Inf, M))
end

function (c::CompositeCost{N, M})(x, y) where {N, M}
    avg_cost = 0.0
    max_cost = 0.0
    for k in 1:M
        ck = c.costs[k](x, y)
        if isfinite(c.weights[k])
            avg_cost += c.weights[k]*ck
        else
            if ck > max_cost
                max_cost = ck
            end
        end
    end
    return avg_cost > max_cost ? avg_cost : max_cost
end