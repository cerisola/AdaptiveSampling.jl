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