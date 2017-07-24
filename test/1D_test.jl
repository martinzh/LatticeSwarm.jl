### ============== ### ============== ###
## Collective Motion in Lattice Systems
## Martin Zumaya Hernandez
## 05 / 2017
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

function update_bulk(pos, trans_prob)

    p = rand()

    u_pos = pos

    if findfirst( x -> p <= x, trans_prob[1]) == 1
        # print("L\t")
        u_pos -= 1

    # elseif findfirst( x -> p <= x, trans_prob[1]) == 2
        # print("C\t")

    elseif findfirst( x -> p <= x, trans_prob[1]) == 3
        # print("R\t")
        u_pos += 1

    end

    return u_pos
end

### ================================== ###

function update_bound(pos, dir, trans_prob)

    p = rand()

    u_pos = pos

    # print("MOVE\t")
    if findfirst( x -> p < x, trans_prob[2]) == 1
        # print("OUT\t")
        u_pos += dir*(1)

    # elseif findfirst( x -> p < x, trans_prob[2]) == 2
    #     print("C\t")

    elseif findfirst( x -> p < x, trans_prob[2]) == 3
        # print("IN\t")
        u_pos += dir*(-1)

    end

    return u_pos
end

### ================================== ###

function update_pos(p, trans_prob, l_b, r_b)

    if p == l_b
        # print("$(p)\tLEFT\t")
        return update_bound(p, -1, trans_prob)
        # println(p)
    elseif p == r_b
        # print("$(p)\tRIGHT\t")
        return update_bound(p, 1, trans_prob)
        # println(p)
    else
        # print("$(p)\tBULK\t")
        return update_bulk(p, trans_prob)
        # println(p)
    end

end

### ================================== ###

function sys_step(pos, trans_prob)
    l_b, r_b  = extrema(pos)
    # map(p -> update_pos(p, trans_prob, l_b, r_b) pos)
    for i in 1:length(pos)
        pos[i] = update_pos(pos[i], trans_prob, l_b, r_b)
    end
end

### ================================== ###

# bias intensity
ϵ = parse(Float64, ARGS[1])
rep = parse(Int, ARGS[2])

# number of walkers
N = 1024

# initial density
ρ_0 = 0.1

# time steps
T = convert(Int, exp10(3))

### ================================== ###
# transition probabilities
trans_prob = [ cumsum(fill(1./3., 3)), cumsum([(1.-ϵ)/3., 1./3., (1.+ϵ)/3.]) ]

### ================================== ###
# initalization space
L = convert(Int, ceil(N/ρ_0))

# inital particles' positions
pos = [rand(1:L) for i in 1:N]

### ================================== ###

output_path = "$(homedir())/art_DATA/LS_1D"

make_dir_from_path(output_path)
make_dir_from_path(output_path*"/DATA")
make_dir_from_path(output_path*"/DATA/data_N_$(N)")
make_dir_from_path(output_path*"/DATA/data_N_$(N)/data_e_$(ϵ)")

pos_file = open(output_path * "/DATA/data_N_$(N)/data_e_$(ϵ)/pos_$(rep).dat", "w+")

for i in 1:T
    println(i)
    # write(pos_file, vcat(pos...))
    write(pos_file, pos)
    sys_step(pos, trans_prob)
    # println(pos)
end

close(pos_file)

### ================================== ###
