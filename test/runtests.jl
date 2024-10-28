using AdaptiveSampling
using Test

@testset "AdaptiveSampling.jl" begin
    @testset "sample_costs" begin
        f(x) = sin(x)
        a = 0
        b = 2π
        cost = VisvalingamCost(1.0)
        x, y, c = sample_costs(f, a, b, cost; tol=1e-2, maxsamples=10000)
        @test length(x) > 0
        @test length(y) == length(x)
        @test length(c) == length(x) - 2
    end

    @testset "UniformCost" begin
        cost = UniformCost(2.0)
        x = [1.0, 3.0, 5.0]
        y = [4.0, 2.0, 6.0]
        result = cost(x, y)
        @test result == 2.0
    end

    @testset "EuclideanCost" begin
        cost = EuclideanCost(2.0)
        x = [1.0, 3.0, 5.0]
        y = [4.0, 2.0, 6.0]
        result = cost(x, y)
        @test isapprox(result, 2.23606797749979)
    end

    @testset "VisvalingamCost" begin
        cost = VisvalingamCost(2.0)
        x = [1.0, 3.0, 5.0]
        y = [4.0, 2.0, 6.0]
        result = cost(x, y)
        @test isapprox(result, 1.7320508075688772)
    end

    @testset "CompositeCost" begin
        cost1 = UniformCost(1.0)
        cost2 = EuclideanCost(2.0)
        composite_cost = CompositeCost((cost1, cost2), (0.5, 0.5))
        x = [1.0, 3.0, 5.0]
        y = [4.0, 2.0, 6.0]
        result = composite_cost(x, y)
        @test isapprox(result, 3.118033988749895)
    end

end