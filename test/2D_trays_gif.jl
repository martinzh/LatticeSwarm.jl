### ================================== ###

using Plots, CollectiveDynamics.DataAnalysis

### ================================== ###

T = 6
times = get_times(T)

ϵ = "0.0"

### ================================== ###

N = 128
N = 256
N = 512
N = 1024
N = 2048
N = 4096

### ================================== ###

output_path = "$(homedir())/GitRepos/LatticeSwarm.jl/graphs"

make_dir_from_path(output_path*"/r_2D")
make_dir_from_path(output_path*"/r_2D/trays_2D")
# make_dir_from_path(output_path*"/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ)")

### ================================== ###

# for N in [convert(Int, exp2(i)) for i in 7:12]
for N in [convert(Int, exp2(i)) for i in 7:9]

    println("N = $(N)")

    for ϵ in ["0.0", "0.01", "0.05", "0.1", "0.25", "0.5", "0.75", "1.0" ]

        println("e = $(ϵ)")

        data_path = "$(homedir())/art_DATA/LS_2D/DATA/data_N_$(N)/data_eh_$(ϵ)_ev_$(ϵ)"

        raw_data = reinterpret(Int, read(data_path*"/"*rand(readdir(data_path))))

        pos_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

        anim  = Animation()

        for i in 1:size(pos_data, 2)

            println(i)

            x = pos_data[ 1:2:2N , i]
            y = pos_data[ 2:2:2N , i]

            scatter(x, y, leg = false, xlabel = "x", ylabel = "y")

            frame(anim)

        end

        gif(anim, output_path*"/r_2D/trays_2D/trays_N_$(N)_eh_$(ϵ)_ev_$(ϵ).gif", fps = 15)

    end
end

### ================================== ###

p = plot()

raw_data = reinterpret(Int, read(data_path*"/"*ip_files[i]))
histogram!(p, raw_data, norm = true, label = "pos inicial")
# ip_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

raw_data = reinterpret(Int, read(data_path*"/"*fp_files[i]))
histogram!(p, raw_data, norm = true, label = "pos final")
# fp_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

xlabel!(p, "t")
ylabel!(p, "r")
title!("N = $(N), sesgo = $(vals[i])")
savefig(p, output_path*"/pos_hist"*"/hist_N_$(N)_e_$(vals[i]).png")


### ================================== ###
