### ============== ### ============== ###
## Collective Motion in Lattice Systems
## Martin Zumaya Hernandez
## 05 / 2017
### ============== ### ============== ###


### ================================== ###

function get_borders(sp_mat)

    x_b = Array{Int}[]
    y_b = Array{Int}[]

    for i in 1:size(sp_mat, 2)
        v_range = nzrange(sp_mat, i)

        x = collect(extrema(rowvals(sp_mat)[v_range]))
        y = fill(i, length(x))

        push!(x_b, x)
        push!(y_b, y)

    end
    return vcat(x_b...), vcat(y_b...)
end

### ================================== ###

function get_lr_bounds(sp_mat)

    # M = size(sp_mat, 2)

    # l_bound = [zeros(Int,2) for i in 1:M]
    # h_bound = [zeros(Int,2) for i in 1:M]
    l_bound = Vector{Int}[]
    h_bound = Vector{Int}[]

    for i in 1:size(sp_mat, 2)

        # v_range = nzrange(sp_mat, i)

        r_vals = rowvals(sp_mat)[nzrange(sp_mat, i)]

        if isempty(r_vals) == false

            x = collect(extrema(r_vals))

            push!(l_bound, [x[1], i])
            push!(h_bound, [x[2], i])
        end

        # l_bound[i] = [x[1], i]
        # h_bound[i] = [x[2], i]

    end

    return l_bound, h_bound

end

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

function get_corners(bound, funct, dir)

    l_c = zeros(Int, 2)
    h_c = zeros(Int, 2)

    m = funct(hcat(bound...)[dir, :])

    l_b, h_b = extrema(find( x -> x == m, hcat(bound...)[dir,:]))

    l_c[dir] = m
    h_c[dir] = m

    if dir == 1
        l_c[2] = l_b
        h_c[2] = h_b
    else
        l_c[1] = l_b
        h_c[1] = h_b
    end

    return [l_c, h_c]
end

### ================================== ###

using Plots

gr()

### ================================== ###

# number of walkers
N = 2048

# bias intensity
ϵ_h = 0.2
ϵ_v = 0.2

# move probability
p = 0.4

# initial density
ρ_0 = 1.

### ================================== ###
# initalization space
L = convert(Int, ceil(sqrt(N/ρ_0)))

# inital particles' positions
pos = [[rand(1:L), rand(1:L)] for i in 1:N]

# indices of particles in boundaries, corners and bulk
# 1 -> left boundary
# 2 -> right boundary
# 3 -> down boundary
# 4 -> up boundary
# 5 -> lower left
# 6 -> upper left
# 7 -> lower right
# 8 -> upper right
bounds = Vector{Vector{Array{Int64,1}}}(8)

### ================================== ###
# transition probabilities

trans_prob = [
[],
[],
[],
[],
[],
[],
[],
[],
[]
]
### ================================== ###

x_pos = hcat(pos...)[1,:]
y_pos = hcat(pos...)[2,:]

sp_pos = sparse(y_pos, x_pos, ones(Int,N))

bounds[1], bounds[2]  = get_lr_bounds(transpose(sp_pos))
bounds[3], bounds[4] = get_ud_bounds(sp_pos)

bounds[5] = intersect(bounds[1], bounds[3])
bounds[6] = intersect(bounds[1], bounds[4])

bounds[7] = intersect(bounds[2], bounds[3])
bounds[8] = intersect(bounds[2], bounds[4])
### ================================== ###

part_plot = scatter(x_pos, y_pos, leg = false, xlabel = "x", ylabel = "y", ms = 4)
border_plot = scatter(xlabel = "x", ylabel = "y")

for i in 1:8
    # scatter!(border_plot, hcat(bounds[i]...)[1,:], hcat(bounds[i]...)[2,:], label = "$(i)")
    scatter!(border_plot, hcat(bounds[i]...)[1,:], hcat(bounds[i]...)[2,:], leg = false, ms = 4)
end

plot(part_plot, border_plot, layout = @layout [a b])

scatter!(border_plot, hcat(up_b...)[1,:], hcat(up_b...)[2,:], leg = false)
scatter!(border_plot, hcat(down_b...)[1,:], hcat(down_b...)[2,:], leg = false)

scatter!(border_plot, hcat(left_b...)[1,:], hcat(left_b...)[2,:], leg = false)
scatter!(border_plot, hcat(right_b...)[1,:], hcat(right_b...)[2,:], leg = false)

scatter!(border_plot, hcat(ul_c, ur_c, dl_c, dr_c)[1,:], hcat(ul_c, ur_c, dl_c, dr_c)[2,:], leg = false)


### ================================== ###

all_c = []

all_c =  [ get_corners(up_b, maximum, 2), get_corners(down_b, minimum, 2), get_corners(left_b, minimum, 1), get_corners(right_b, maximum, 1)]


for i in 1:size(sp_pos, 2)

    v_range = nzrange(sp_pos, i)

    vals = rowvals(sp_pos)[v_range]

    isempty(vals) == false ? println(i,"\t",extrema(vals)) : println()


    # x = collect(extrema(rowvals(sp_pos)[v_range]))

end
