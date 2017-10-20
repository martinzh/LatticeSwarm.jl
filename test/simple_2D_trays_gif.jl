### ================================== ###

using Plots, CollectiveDynamics.DataAnalysis

### ================================== ###

N = parse(Int, ARGS[1])
ϵ = ARGS[2]

### ================================== ###

# T = 6
T = 4
times = get_times(T)

# ϵ = "0.0"
# ϵ = "0.01"
# ϵ = "0.05"
# ϵ = "0.1"
# ϵ = "0.25"
# ϵ = "0.5"

### ================================== ###

# N = 128
# N = 256
# N = 512
# N = 1024
# N = 2048
# N = 4096

### ================================== ###

# output_path = "$(homedir())/GitRepos/LatticeSwarm.jl/graphs"
output_path = "$(homedir())/graphs/LatticeSwarm"

make_dir_from_path(output_path)
make_dir_from_path(output_path*"/r_2D_t")
make_dir_from_path(output_path*"/r_2D_t/trays_2D")
# make_dir_from_path(output_path*"/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ)")

### ================================== ###

println("N = $(N)")
println("e = $(ϵ)")

data_path = "$(homedir())/art_DATA/LS_2D/DATA/data_N_$(N)/data_eh_$(ϵ)_ev_$(ϵ)"

# raw_data = reinterpret(Int, read(data_path*"/"*rand(readdir(data_path))))

k = 1

pyplot()

p = [plot() for i in 1:length(readdir(data_path))]
# t_plots = Any[]

for f in readdir(data_path)

    println(f)

    raw_data = reinterpret(Int, read(data_path*"/"*f))

    pos_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

    # anim  = Animation()
    #
    # for i in 1:size(pos_data, 2)
    #
    #     println(i)
    #
    #     x = pos_data[ 1:2:2N , i]
    #     y = pos_data[ 2:2:2N , i]
    #
    #     scatter(x, y, leg = false, xlabel = "x", ylabel = "y")
    #
    #     frame(anim)
    #
    # end
    #
    # gif(anim, output_path*"/r_2D_t/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ).gif", fps = 15)


    ### ================================== ###


    for i in 1:2:2N
        plot!(p[k], pos_data[i,:], pos_data[i+1,:], leg = false)
    end

    # xlabel!(p[k], "x")
    # ylabel!(p[k], "y")
    # title!("N = $(N), e = $(ϵ), $(k)")

    # display(p)

    # png(output_path*"/r_2D_t/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ)_$(k)")
    k += 1
end

plot(p..., size = (1024, 720))
png(output_path*"/r_2D_t/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ)")

# display(p[1])
# png(output_path*"/r_2D_t/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ)_$(k)")

### ================================== ###

# pyplot()
# gr()

p = plot()

files = readdir(data_path)

i_x_pos = zeros(Int, (N, length(files)))
i_y_pos = zeros(Int, (N, length(files)))

f_x_pos = zeros(Int, (N, length(files)))
f_y_pos = zeros(Int, (N, length(files)))

for i in 1:length(files)

    println(i)

    raw_data = reinterpret(Int, read(data_path*"/"*files[i]))

    pos_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

    i_x_pos[:, i] = pos_data[1:2:2N,1]
    i_y_pos[:, i] = pos_data[2:2:2N,1]

    f_x_pos[:, i] = pos_data[1:2:2N,end]
    f_y_pos[:, i] = pos_data[2:2:2N,end]

end

# ih = histogram2d(x_i_pos, y_i_pos)
# fh = histogram2d(x_f_pos, y_f_pos)

ih = histogram2d(vcat(i_x_pos...), vcat(i_y_pos...))
fh = histogram2d(vcat(f_x_pos...), vcat(f_y_pos...))

h = plot(ih, fh, size = (1024,720), aspect_ratio = :equal)

xlabel!(h, "x")
ylabel!(h, "y")

png(output_path*"/r_2D_t/2D_hist_N_$(N)_e_$(ϵ)")

### ================================== ###
