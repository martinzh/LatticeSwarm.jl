### ================================== ###

using Plots, StatsBase

### ================================== ###
function update_bulk(trans_prob)

    p = rand()

    # print("move\t")
    if findfirst( x -> p <= x, trans_prob) == 1
        # print("L\t")
        return 1

    elseif findfirst( x -> p <= x, trans_prob) == 2
        # print("R\t")
        return 2

    elseif findfirst( x -> p <= x, trans_prob) == 3
        # print("U\t")
        return 3

    elseif findfirst( x -> p <= x, trans_prob) == 4
        # print("D\t")
        return 4

    elseif findfirst( x -> p <= x, trans_prob) == 5
        # print("C\t")
        return 5
    end
end

### ================================== ##

ϵ_h = 0.25
ϵ_v = ϵ_h

n = 5.

trans_prob = [
    cumsum(fill(1./n, 5)), # bulk (unbiased)
    cumsum([(1.-ϵ_h)/n, 1./n, 1./n, 1./n, (1.+ϵ_h)/n]), # left and right bias
    cumsum([(1.-ϵ_v)/n, 1./n, 1./n, 1./n, (1.+ϵ_v)/n]), # up and down bias
    cumsum([(1.-ϵ_h)/n, (1.-ϵ_h)/n, 1./n, (1.+ϵ_h)/n, (1.+ϵ_v)/n]) ] # corner bias

vals = zeros(Int, (convert(Int, exp10(6)), 4))

for j in 1:size(vals, 2)
    println(j)
    for i in 1:size(vals, 1)
        vals[i, j] = update_bulk(trans_prob[j])
    end
end

p = [plot() for i in 1:size(vals, 2)]

for j in 1:size(vals, 2)
    h = fit(Histogram, vals[:, j], nbins = 5)

    # h.edges
    # h.weights ./ exp10(6)

    p[j] = bar(collect(midpoints(h.edges[1])), h.weights ./ exp10(6), leg = false)
end

plot(p[1], p[2], p[3], p[4], layout=(2,2), legend = false)
