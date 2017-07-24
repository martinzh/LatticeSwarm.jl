### ============== ### ============== ###
## Collective Motion in Lattice Systems
## Martin Zumaya Hernandez
## 05 / 2017
### ============== ### ============== ###

### ================================== ###

function get_lr_bounds(sp_mat)

    l_bound = Vector{Int}[]
    h_bound = Vector{Int}[]

    for i in 1:size(sp_mat, 2)

        r_vals = rowvals(sp_mat)[nzrange(sp_mat, i)]

        if isempty(r_vals) == false

            x = collect(extrema(r_vals))

            push!(l_bound, [x[1], i])
            push!(h_bound, [x[2], i])
        end

    end

    return l_bound, h_bound

end

function get_lr_bounds(pos)

    l_bound = Vector{Int}[]
    h_bound = Vector{Int}[]

    #possible y values
    y_vals = unique(hcat(pos...)[2,:])

    for y in y_vals
        x = extrema([pos[i][1] for i in find(x -> x[2] == y, pos)])
        push!(l_bound, [x[1], y])
        push!(h_bound, [x[2], y])
    end

    return l_bound, h_bound
end

### ================================== ###

function get_ud_bounds(sp_mat)

    l_bound = Vector{Int}[]
    h_bound = Vector{Int}[]

    for i in 1:size(sp_mat, 2)

        r_vals = rowvals(sp_mat)[nzrange(sp_mat, i)]

        if isempty(r_vals) == false

            x = collect(extrema(r_vals))

            push!(l_bound, [i, x[1]])
            push!(h_bound, [i, x[2]])
        end

    end

    return l_bound, h_bound

end

### ================================== ###
function update_bulk(pos, trans_prob)
    if findfirst( x -> rand() <= x, trans_prob[1]) == 1

        p = rand()

        # print("move\t")
        if findfirst( x -> p <= x, trans_prob[2]) == 1
            # print("L\t")
            pos[1] -= 1
            pos[2] += 1

        elseif findfirst( x -> p <= x, trans_prob[2]) == 2
            # print("C\t")
            pos[2] += 1

        elseif findfirst( x -> p <= x, trans_prob[2]) == 3
            # print("R\t")
            pos[1] += 1
            pos[2] += 1

        end
    # else
    #     # print("DON'T MOVE\t")
    #     p = rand()
    #
    #     # print("move\t")
    #     if findfirst( x -> p <= x, trans_prob[2]) == 1
    #         # print("L\t")
    #         pos[1] -= 1
    #         # pos[2] += 1
    #
    #     elseif findfirst( x -> p <= x, trans_prob[2]) == 2
    #         # print("C\t")
    #         # pos[2] += 1
    #
    #     elseif findfirst( x -> p <= x, trans_prob[2]) == 3
    #         # print("R\t")
    #         pos[1] += 1
    #         # pos[2] += 1
    #
    #     end

    end
end

### ================================== ###

function update_bound(pos, dir, trans_prob)
    if findfirst( x -> x>rand(), trans_prob[1]) == 1

        p = rand()

        # print("MOVE\t")
        if findfirst( x -> p < x, trans_prob[3]) == 1
            # print("OUT\t")
            pos[1] += dir*(1)
            pos[2] += 1

        elseif findfirst( x -> p < x, trans_prob[3]) == 2
            # print("C\t")
            pos[2] += 1

        elseif findfirst( x -> p < x, trans_prob[3]) == 3
            # print("IN\t")
            pos[1] += dir*(-1)
            pos[2] += 1

        end
    # else
    #     # print("DON'T MOVE\t")
    #     p = rand()
    #
    #     # print("MOVE\t")
    #     if findfirst( x -> p < x, trans_prob[3]) == 1
    #         # print("IN\t")
    #         pos[1] += dir*(-1)
    #         # pos[2] += 1
    #
    #     elseif findfirst( x -> p < x, trans_prob[3]) == 2
    #         # print("C\t")
    #         # pos[2] += 1
    #
    #     elseif findfirst( x -> p < x, trans_prob[3]) == 3
    #         # print("OUT\t")
    #         pos[1] += dir*(1)
    #         # pos[2] += 1
    #
    #     end

    end
end

### ================================== ###

function update_pos(p, trans_prob, bounds)

    if p in bounds[1]
        # print("$(p)\tLEFT\t")
        update_bound(p, -1, trans_prob)
        # println(p)
    elseif p in bounds[2]
        # print("$(p)\tRIGHT\t")
        update_bound(p, 1, trans_prob)
        # println(p)
    else
        # print("$(p)\tBULK\t")
        update_bulk(p, trans_prob)
        # println(p)
    end

end

### ================================== ###

function sys_step(pos, trans_prob, bounds)

    # bounds[1], bounds[2]  = get_lr_bounds(sparse(x, hcat(pos...)[2,:], ones(Int,N)))
    bounds[1], bounds[2]  = get_lr_bounds(pos)
    map(p -> update_pos(p, trans_prob, bounds), pos)
end

### ================================== ###

using Plots
gr()

### ================================== ###

# number of walkers
N = 256

# bias intensity
ϵ_v = 0.5
ϵ_h = 1.0

# initial density
ρ_0 = 0.5

# time steps
T = convert(Int, exp10(4))

### ================================== ###
# transition probabilities
trans_prob = [ cumsum([ϵ_v, 1-ϵ_v]), cumsum(fill(1./3., 3)), cumsum([(1.-ϵ_h)/3., 1./3., (1.+ϵ_h)/3.]) ]

### ================================== ###
# initalization space
L = convert(Int, ceil(sqrt(N/ρ_0)))

# inital particles' positions
pos = [[rand(1:L), rand(1:L)] for i in 1:N]

# indices of particles in boundaries, corners and bulk
# 1 -> left boundary
# 2 -> right boundary
bounds = Vector{Vector{Array{Int64,1}}}(2)

### ================================== ###

rep = 1

output_path = "$(homedir())/GitRepos/LatticeSwarm.jl"

pos_file = open(output_path * "/pos_$(rep).dat", "w+")

for i in 1:T
    println(i)
    write(pos_file, vcat(pos...))
    sys_step(pos, trans_prob, bounds)
end

close(pos_file)

### ================================== ###

raw_data = reinterpret(Int, read("$(homedir())/GitRepos/LatticeSwarm.jl//pos_$(rep).dat"))

pos_data = transpose(reshape(raw_data, 2N, div(length(raw_data),2N)))

x = view(pos_data, :, 1:2:2N)
y = view(pos_data, :, 2:2:2N)

plot(x,y, leg = false, xlabel = "x", ylabel = "y")
# plot(x,y, leg = false, xlabel = "x", ylabel = "y", lw = 2.5)

### ================================== ###

# part_plot = scatter(x_pos, y_pos, leg = false, xlabel = "x", ylabel = "y", ms = 4)
# border_plot = scatter(xlabel = "x", ylabel = "y")
#
# for i in 1:2
#     scatter!(border_plot, hcat(bounds[i]...)[1,:], hcat(bounds[i]...)[2,:], leg = false, ms = 4)
# end
#
# plot(part_plot, border_plot, layout = @layout [a b])

### ================================== ###
