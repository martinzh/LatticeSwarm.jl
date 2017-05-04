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

using Plots

gr()

### ================================== ###

# number of walkers
N = 256

# bias intensity
ϵ = 0.2

# initial density
ρ_0 = 0.5

# initalization space
L = convert(Int, ceil(sqrt(N/ρ_0)))

### ================================== ###
# inital particles positions
x_pos = rand(1:L, N)
y_pos = rand(1:L, N)

part_plot = scatter(x_pos, y_pos, leg = false)
border_plot = scatter()

pos = sparse(x_pos, y_pos, ones(Int,N))

hx_b, hy_b = get_borders(pos)
vy_b, vx_b = get_borders(transpose(pos))

scatter!(border_plot, hx_b, hy_b, leg = false)
scatter!(border_plot, vx_b, vy_b, leg = false)

plot(part_plot, border_plot, layout = @layout [a b])
