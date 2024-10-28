abstract type AbstractCost{N} end

number_neighbours(::AbstractCost{N}) where {N} = N