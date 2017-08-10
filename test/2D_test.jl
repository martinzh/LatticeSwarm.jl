### ============== ### ============== ###
## Collective Motion in Lattice Systems 2D
## Martin Zumaya Hernandez
## 08 / 2017
### ============== ### ============== ###

### ================================== ###

function make_dir_from_path(path)

    try
        mkdir(path)
    catch error
        println("Folder already exists")
    end

end

### ================================== ###
## Left and Right Boundaries

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
## Up and Down Boundaries

function get_ud_bounds(pos)

    u_bound = Vector{Int}[]
    d_bound = Vector{Int}[]

    #possible x values
    x_vals = unique(hcat(pos...)[1,:])

    for x in x_vals
        y = extrema([pos[i][2] for i in find(y -> y[1] == x, pos)])
        push!(u_bound, [x, y[1]])
        push!(d_bound, [x, y[2]])
    end

    return u_bound, d_bound
end

### ================================== ###

function get_bounds(pos, bounds)

    bounds[1], bounds[2] = get_lr_bounds(pos)
    bounds[3], bounds[4] = get_ud_bounds(pos)

    bounds[5] = intersect(bounds[1], bounds[3])
    bounds[6] = intersect(bounds[1], bounds[4])
    bounds[7] = intersect(bounds[2], bounds[3])
    bounds[8] = intersect(bounds[2], bounds[4])

    deleteat!(bounds[1], findin(bounds[1],bounds[5]))
    deleteat!(bounds[3], findin(bounds[3],bounds[5]))

    deleteat!(bounds[1], findin(bounds[1],bounds[6]))
    deleteat!(bounds[4], findin(bounds[4],bounds[6]))

    deleteat!(bounds[2], findin(bounds[2],bounds[7]))
    deleteat!(bounds[3], findin(bounds[3],bounds[7]))

    deleteat!(bounds[2], findin(bounds[2],bounds[8]))
    deleteat!(bounds[4], findin(bounds[4],bounds[8]))
end

### ================================== ###
function update_bulk(pos, trans_prob)

    p = rand()

    # print("move\t")
    if findfirst( x -> p <= x, trans_prob[2]) == 1
        # print("L\t")
        pos[1] -= 1

    elseif findfirst( x -> p <= x, trans_prob[2]) == 2
        # print("R\t")
        pos[1] += 1

    elseif findfirst( x -> p <= x, trans_prob[2]) == 3
        # print("U\t")
        pos[2] -= 1

    elseif findfirst( x -> p <= x, trans_prob[2]) == 4
        # print("D\t")
        pos[2] += 1

    # elseif findfirst( x -> p <= x, trans_prob[2]) == 5
        # print("C\t")

    end
end

### ================================== ###

function update_corner(pos, d_h, d_v, trans_prob)

    p = rand()

    # print("MOVE\t")
    if findfirst( x -> p < x, trans_prob[4]) == 1
        # print("OUT H\t")
        pos[1] += d_h*(1)

    elseif findfirst( x -> p < x, trans_prob[4]) == 2
        # print("IN H\t")
        pos[1] += d_h*(-1)

    # elseif findfirst( x -> p < x, trans_prob[4]) == 3
        # print("C\t")

    elseif findfirst( x -> p < x, trans_prob[4]) == 4
        # print("OUT V\t")
        pos[2] += d_v*(1)

    elseif findfirst( x -> p < x, trans_prob[4]) == 5
        # print("IN V\t")
        pos[2] += d_v*(-1)

    end
end

### ================================== ###

function update_bound(pos, b, dir, trans_prob)

    p = rand()

    if b == 'h'
        # print("MOVE\t")
        if findfirst( x -> p < x, trans_prob[2]) == 1
            # print("OUT\t")
            pos[1] += dir*(1)

        elseif findfirst( x -> p < x, trans_prob[2]) == 2
            # print("U\t")
            pos[2] += 1

        # elseif findfirst( x -> p < x, trans_prob[2]) == 3
        #     print("C\t")

        elseif findfirst( x -> p < x, trans_prob[2]) == 4
            # print("D\t")
            pos[2] -= 1

        elseif findfirst( x -> p < x, trans_prob[2]) == 5
            # print("IN\t")
            pos[1] += dir*(-1)

        end

    elseif b == 'v'

        # print("MOVE\t")
        if findfirst( x -> p < x, trans_prob[3]) == 1
            # print("OUT\t")
            pos[2] += dir*(1)

        elseif findfirst( x -> p < x, trans_prob[3]) == 2
            # print("L\t")
            pos[1] -= 1

        # elseif findfirst( x -> p < x, trans_prob[3]) == 3
            # print("C\t")

        elseif findfirst( x -> p < x, trans_prob[3]) == 4
            # print("R\t")
            pos[1] += 1

        elseif findfirst( x -> p < x, trans_prob[3]) == 5
            # print("IN\t")
            pos[2] += dir*(-1)

        end

    end
end

### ================================== ###

function update_pos(p, trans_prob, bounds)

    if p in bounds[1]
        # print("$(p)\tLEFT\t")
        update_bound(p, 'h', -1, trans_prob)
        # println(p)
    elseif p in bounds[2]
        # print("$(p)\tRIGHT\t")
        update_bound(p, 'h', 1, trans_prob)
        # println(p)
    elseif p in bounds[3]
        # print("$(p)\tDOWN\t")
        update_bound(p, 'v', -1, trans_prob)
        # println(p)
    elseif p in bounds[4]
        # print("$(p)\tUP\t")
        update_bound(p, 'v', 1, trans_prob)
        # println(p)
    elseif p in bounds[5]
        # print("$(p)\tLOWER LEFT\t")
        update_corner(p, -1, -1, trans_prob)
        # println(p)
    elseif p in bounds[6]
        # print("$(p)\tUPPER LEFT\t")
        update_corner(p, 1, -1, trans_prob)
        # println(p)
    elseif p in bounds[7]
        # print("$(p)\tLOWER RIGHT\t")
        update_corner(p, -1, 1, trans_prob)
        # println(p)
    elseif p in bounds[8]
        # print("$(p)\tUPPER RIGHT\t")
        update_corner(p, 1, 1, trans_prob)
        # println(p)
    else
        # print("$(p)\tBULK\t")
        update_bulk(p, trans_prob)
        # println(p)
    end

end

### ================================== ###

function sys_step(pos, trans_prob, bounds)

    get_bounds(pos, bounds)
    # map(p -> update_pos(p, trans_prob, bounds), pos)
    for i in 1:length(pos)
        # pos[i] = update_pos(pos[i], trans_prob, bounds)
        update_pos(pos[i], trans_prob, bounds)
    end

end

### ================================== ###

N = parse(Int, ARGS[1])
ϵ_v = parse(Float64, ARGS[2])
# ϵ_h = parse(Float64, ARGS[2])
T = parse(Int, ARGS[3]) # integration time steps
rep = parse(Int, ARGS[4])

# N = 256
# ϵ_v = 0.0
# # ϵ_h = parse(Float64, ARGS[2])
# T = 3
# rep = 1

# bias intensity
# ϵ_v = 1.0
ϵ_h = ϵ_v

### ================================== ###

output_path = "$(homedir())/art_DATA/LS_2D"

make_dir_from_path(output_path)
make_dir_from_path(output_path*"/DATA")
make_dir_from_path(output_path*"/DATA/data_N_$(N)")
make_dir_from_path(output_path*"/DATA/data_N_$(N)/data_eh_$(ϵ_h)_ev_$(ϵ_v)")

pos_file = open(output_path * "/DATA/data_N_$(N)/data_eh_$(ϵ_h)_ev_$(ϵ_v)/pos_$(rep).dat", "w+")

### ================================== ###
# number of walkers
# N = 256

# initial density
ρ_0 = 2.0

# time steps
# T = convert(Int, exp10(4))

### ================================== ###
# transition probabilities
# trans_prob = [ cumsum([ϵ_v, 1-ϵ_v]), cumsum(fill(1./3., 3)), cumsum([(1.-ϵ_h)/3., 1./3., (1.+ϵ_h)/3.]) ]

n = 5.

trans_prob = [
    cumsum(fill(1./n, 5)), # bulk (unbiased)
    cumsum([(1.-ϵ_h)/n, 1./n, 1./n, 1./n, (1.+ϵ_h)/n]), # left and right bias
    cumsum([(1.-ϵ_v)/n, 1./n, 1./n, 1./n, (1.+ϵ_v)/n]), # up and down bias
    cumsum([(1.-ϵ_h)/n, (1.+ϵ_h)/n, 1./n, (1.-ϵ_v)/n, (1.+ϵ_v)/n]) ] # corner bias

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
# 5 -> lower left corner
# 6 -> upper left corner
# 7 -> lower right corner
# 8 -> upper right corner
bounds = Vector{Vector{Array{Int64,1}}}(8)

### ================================== ###

times = [convert(Int, exp10(i)) for i in 0:T]

for i in 1:(length(times) - 1)

    if i > 1

        for t in (times[i]+1):times[i+1]

            sys_step(pos, trans_prob, bounds)

            if t % times[i] == 0 || t % times[i-1] == 0
                println("//////// ", t)
                write(pos_file, vcat(pos...))
            end
        end

    else

        for t in (times[i]+1):times[i+1]

            sys_step(pos, trans_prob, bounds)

            if t % times[i] == 0
                println("//////// ", t)
                write(pos_file, vcat(pos...))
            end
        end

    end

end

close(pos_file)

### ================================== ###

println("Done")

### ================================== ###
