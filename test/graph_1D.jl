using Plots, CollectiveDynamics.DataAnalysis

### ================================== ###


T = 6
times = get_times(T)

### ================================== ###

N = 128
N = 256
N = 512
N = 1024
N = 2048
N = 4096

output_path = "$(homedir())/GitRepos/LatticeSwarm.jl/graphs"

for N in [convert(Int, exp2(i)) for i in 7:12]

    println("N = $(N)")

    data_path = "$(homedir())/art_DATA/LS_1D/EXP/data_N_$(N)"

    make_dir_from_path(output_path*"/r_1D")
    make_dir_from_path(output_path*"/pos_hist_1D")
    make_dir_from_path(output_path*"/pos_hist_1D/pos_hist_N_$(N)")

    exp_files = filter( x -> ismatch(r"^exp.", x), readdir(data_path))
    ip_files = filter( x -> ismatch(r"^i_pos.", x), readdir(data_path))
    fp_files = filter( x -> ismatch(r"^f_pos.", x), readdir(data_path))

    vals = [ parse(Float64, match(r"(\d+\.\d+)\.dat$", x).captures[1]) for x in exp_files ]

    ### ================================== ###

    p = plot()

    ### ================================== ###

    for i in 1:length(exp_files)
        println(i)
        raw_data = reinterpret(Int, read(data_path*"/"*exp_files[i]))
        exp_data = reshape(raw_data, length(times), div(length(raw_data), length(times)))

        r = mean(exp_data, 2)

        plot!(p, times, r, xscale = :log10, yscale = :log10, label = "$(vals[i])", legend = :topleft, lw = 1.2, size = (1024,720))
    end

    xlabel!(p, "t")
    ylabel!(p, "r")
    title!("N = $(N)")
    xlims!(p, (exp10(2), exp10(6)))

    savefig(p, output_path*"/r_1D/rVSt_N_$(N).png")

    for i in 1:length(exp_files)

        println(i)
        p = plot()

        raw_data = reinterpret(Int, read(data_path*"/"*ip_files[i]))
        histogram!(p, raw_data, norm = true, label = "pos inicial", alpha = 0.5)
        # ip_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

        raw_data = reinterpret(Int, read(data_path*"/"*fp_files[i]))
        histogram!(p, raw_data, norm = true, label = "pos final", alpha = 0.5)
        # fp_data = reshape(raw_data, 2N, div(length(raw_data), 2N))

        xlabel!(p, "x")
        ylabel!(p, "p(x)")
        title!("N = $(N), sesgo = $(vals[i])")
        savefig(p, output_path*"/pos_hist_1D/pos_hist_N_$(N)/hist_N_$(N)_e_$(vals[i]).png")
    end


end

display(p)

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
