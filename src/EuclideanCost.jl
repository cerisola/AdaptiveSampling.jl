struct EuclideanCost <: AbstractCost{2}
    norm::Float64

    EuclideanCost() = new(1.0)

    EuclideanCost(norm) = new(Float64(norm))

    EuclideanCost(a, b, fa, fb) = EuclideanCost(hypot(b - a, fb - fa))
end

(c::EuclideanCost)(x, y) = hypot(last(x) - first(x), last(y) - first(y))/c.norm