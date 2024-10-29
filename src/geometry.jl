@inline midpoint(x) = (first(x) + last(x))/2

@inline area(x, y) = 0.5*abs(x[1]*(y[2] - y[3]) + x[2]*(y[3] - y[1]) + x[3]*(y[1] - y[2]))