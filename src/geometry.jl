midpoint(x) = (first(x) + last(x))/2

area(x, y) = 0.5*abs(x[1]*(y[2] - y[3]) + x[2]*(y[3] - y[1]) + x[3]*(y[1] - y[2]))

# centroid(t::Triangle{T}) where {T<:Real} = (t.x[1] + t.x[2] + t.x[3])/3