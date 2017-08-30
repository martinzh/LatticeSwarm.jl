using CollectiveDynamics.DataAnalysis

### ================================== ###
function make_dir_from_path(path)

    try
        mkdir(path)
    catch error
        println("Folder already exists")
    end

end

### ================================== ###

# using Plots

### ================================== ###

folder = ARGS[1]
N = parse(Int, ARGS[2])
ϵ = ARGS[3]

#N = 1024
# N = 256
# ϵ = "0.0"
T = 6

times = get_times(T)

## ================================== ###

output_path = "$(homedir())/art_DATA/$(folder)"
# output_path = "$(homedir())/art_DATA/LS_1D"

make_dir_from_path(output_path)
make_dir_from_path(output_path*"/EXP")
make_dir_from_path(output_path*"/EXP/data_N_$(N)")
make_dir_from_path(output_path*"/EXP/data_N_$(N)/data_e_$(ϵ)")

output_file = open(output_path*"/EXP/data_N_$(N)/data_e_$(ϵ)/exp_data_N_$(N)_e_$(ϵ).dat", "w+")
i_pos_file = open(output_path*"/EXP/data_N_$(N)/data_e_$(ϵ)/i_pos_data_N_$(N)_e_$(ϵ).dat", "w+")
f_pos_file = open(output_path*"/EXP/data_N_$(N)/data_e_$(ϵ)/f_pos_data_N_$(N)_e_$(ϵ).dat", "w+")

## ================================== ###

data_path = output_path * "/DATA/data_N_$(N)/data_e_$(ϵ)"

files = readdir(data_path)

r     = zeros(Int, length(times), length(files))
i_pos = zeros(Int, N, length(files))
f_pos = zeros(Int, N, length(files))

## ================================== ###

# rep = 1
for rep in 1:length(files)
    println(rep)
    raw_data = reinterpret(Int, read(data_path*"/pos_$(rep).dat"))
    pos_data = reshape(raw_data, N, div(length(raw_data),N))

    r[:,rep] = [maximum(pos_data[:,i]) - minimum(pos_data[:,i]) for i in 1:size(pos_data,2)]

    i_pos[:, rep] = pos_data[:, 1]
    f_pos[:, rep] = pos_data[:, end]
end

write(output_file, r)
write(i_pos_file, i_pos)
write(f_pos_file, f_pos)

close(output_file)
close(i_pos_file)
close(f_pos_file)

println("Done")
## ================================== ###

# plot(collect(1:1000), broadcast(x -> (x - r[1])^2, r), leg = false, xlabel = "t", ylabel = "r")
#
# plot(collect(1:1000), r, leg = false, xlabel = "t", ylabel = "r")
#
# plot(collect(1:1000), mean(r, 2), leg = false, xlabel = "t", ylabel = "r")
# plot(collect(1:1000), broadcast(x -> (x - mean(r, 2)[1])^2, mean(r, 2)), leg = false, xlabel = "t", ylabel = "r")

## ================================== ###
