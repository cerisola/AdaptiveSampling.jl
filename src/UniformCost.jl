struct UniformCost <: AbstractCost{2}
    norm::Float64

    UniformCost() = new(1.0)

    UniformCost(norm) = new(Float64(norm))

    UniformCost(a, b) = UniformCost(abs(b - a))
end

(c::UniformCost)(x, y) = abs(last(x) - first(x))/c.norm