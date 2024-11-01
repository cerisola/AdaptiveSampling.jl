@inline svk(x, k, N) = view(x, k:k+N-1)

function nextsample(x)
    kc = 0
    dx = zero(eltype(x))
    @inbounds for k in 1:(length(x)-1)
        if abs(x[k+1] - x[k]) ≥ dx
            dx = abs(x[k+1] - x[k])
            kc = k
        end
    end
    return kc, (x[kc] + x[kc+1])/2
end

function refine!(x, y, c, f, cost::AbstractCost{N}) where {N}
    k = argmax(c)

    kc, xnew = nextsample(svk(x, k, N))
    k += kc
    
    insert!(x, k, xnew)
    insert!(y, k, f(xnew))

    #   there are k affected costs
    #   Ck must be inserted
    #   Ck-1, Ck-2, ..., C1 must be updated
    if k < N
        @inbounds for j in 1:(k-1)
            c[j] = cost(svk(x, j, N), svk(y, j, N))
        end
        insert!(c, k, cost(svk(x, k, N), svk(y, k, N)))
    # handle centre
    #   there are N affected costs
    #   Ck must be inserted
    #   Ck-1, Ck-2, ..., Ck-(N-1) must be updated
    elseif k < length(x) - (N - 1) + 1
        @inbounds for j in 1:(N-1)
            c[k - j] = cost(svk(x, k - j, N), svk(y, k - j , N))
        end
        insert!(c, k, cost(svk(x, k, N), svk(y, k, N)))
    # handle right edge
    #   there are 1 + len(x) - k affected costs
    #   C(1 + len(x) - N) must be inserted
    #   C(1 + len(x) - N - 1), C(1 + len(x) - N - 2), ..., C(1 - N + k) must be updated
    else
        @inbounds for j in 1:(length(x) - k)
            c[length(x) - (N - 1) - j] = cost(svk(x, length(x) - (N - 1) - j, N), svk(y, length(x) - (N - 1) - j, N))
        end
        insert!(c, length(x) - (N - 1), cost(svk(x, length(x) - (N - 1), N), svk(y, length(x) - (N - 1), N)))
    end
end

"""
    sample_costs(f, a, b; cost::AbstractCost=CompositeCost((UniformCost(a, b), VisvalingamCost(a, b, f(a), f(b))), (1, 100)), tol=1e-3, maxsamples=10000)

Samples the function `f` over the interval `[a, b]` and computes the associated costs using the specified cost function. The sampling process continues until the maximum cost is below the tolerance `tol` or the maximum number of samples `maxsamples` is reached.

# Arguments
- `f`: The function to be sampled.
- `a`: The start of the interval.
- `b`: The end of the interval.
- `cost::AbstractCost`: The cost function to be used. Defaults to a composite cost combining `UniformCost` and `VisvalingamCost`.
- `tol`: The tolerance for the maximum cost. Defaults to `1e-3`.
- `maxsamples`: The maximum number of samples. Defaults to `10000`.

# Returns
- `x`: A vector of sample points.
- `y`: A vector of function values at the sample points.
- `c`: A vector of costs associated with the sample points.
"""
function sample_costs(
    f,
    a,
    b,
    cost::AbstractCost{N}=CompositeCost((UniformCost((a, b)), VisvalingamCost((a, b), (a, b))), (1, 100));
    tol=1e-3,
    maxsamples=10000
) where {N}
    a, b = promote(a, b)
    L = abs(b - a)
    shift = min(10*eps(), 1/maxsamples/2)
    x = collect(range(a + L*shift, b - L*shift; length=N))
    y = f.(x)
    c = [cost(svk(x, 1, N), svk(y, 1, N))]

    counter = N
    while maximum(c) > tol && counter < maxsamples
        refine!(x, y, c, f, cost)
        counter += 1
    end

    if counter == maxsamples
        @warn "Maximum number of iterations reached without convergence."
    end

    resize!(x, length(x))
    resize!(y, length(y))
    resize!(c, length(c))

    return x, y, c
end

"""
    sample(f, a, b; cost::AbstractCost=CompositeCost((UniformCost(a, b), VisvalingamCost(a, b, f(a), f(b))), (1, 100)), tol=1e-3, maxsamples=10000)

Samples the function `f` over the interval `[a, b]` using the specified cost function. The sampling process continues until the maximum cost is below the tolerance `tol` or the maximum number of samples `maxsamples` is reached.

# Arguments
- `f`: The function to be sampled.
- `a`: The start of the interval.
- `b`: The end of the interval.
- `cost::AbstractCost`: The cost function to be used. Defaults to a composite cost combining `UniformCost` and `VisvalingamCost`.
- `tol`: The tolerance for the maximum cost. Defaults to `1e-3`.
- `maxsamples`: The maximum number of samples. Defaults to `10000`.

# Returns
- `x`: A vector of sample points.
- `y`: A vector of function values at the sample points.
"""
function sample(
    f,
    a,
    b,
    cost=CompositeCost((UniformCost((a, b)), VisvalingamCost((a, b), (a, b))), (1, 100));
    tol=1e-3,
    maxsamples=10000
)
    x, y, c = sample_costs(f, a, b, cost; tol=tol, maxsamples=maxsamples)
    return x, y
end