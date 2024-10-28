struct VisvalingamCost <: AbstractCost{3}
    norm::Float64

    VisvalingamCost() = new(1.0)

    VisvalingamCost(norm) = new(Float64(norm))

    VisvalingamCost(a, b, fa, fb) = VisvalingamCost((b - a)*(fb - fa)/2)
end

(c::VisvalingamCost)(x, y) = sqrt(area(x, y)/c.norm)