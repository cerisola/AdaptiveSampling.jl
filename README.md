# AdaptiveSampling

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://cerisola.github.io/AdaptiveSampling.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://cerisola.github.io/AdaptiveSampling.jl/dev/)
[![Build Status](https://github.com/cerisola/AdaptiveSampling.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/cerisola/AdaptiveSampling.jl/actions/workflows/CI.yml?query=branch%3Amain)

AdaptiveSampling.jl is a Julia library to adaptively sample a given function.

For most users, the core functionality of the library can be accessed by calling
the `sample` function.
```julia
x, y = sample(f, a, b)
```
where `f` is the function that you want to sample over the interval `[a, b]`.
The `sample` function will adaptively subdivide the `[a, b]` interval to
accurately sample `f` with as little points as possible. Usage of `sample` over
a simple uniform grid is noticeable for the cases where the function has very
quick variations over a small sub-interval, and when `f` is expensive to
evaluate.

`sample` additional takes as keyword arguments `tol`, which sets the desired
tolerance to determine convergence of the sampling, and `maxsamples` which sets
the maximum number of samples to take before aborting.

Finally, a third optional argument can be passed to `sample` to determine the
choice of adaptive subdivision algorithm. See documentation for different
built-in options and for instructions on how to define a custom algorithm.