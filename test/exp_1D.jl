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

N = 1024
# ϵ = "0.0"
ϵ = ARGS[1]
T = convert(Int, exp10(3))

## ================================== ###

output_path = "$(homedir())/art_DATA/LS_1D"

make_dir_from_path(output_path)
make_dir_from_path(output_path*"/EXP")
make_dir_from_path(output_path*"/EXP/data_N_$(N)")
make_dir_from_path(output_path*"/EXP/data_N_$(N)/data_e_$(ϵ)")

output_file = open(output_path*"/EXP/data_N_$(N)/data_e_$(ϵ)/exp_data_N_$(N)_e_$(ϵ).dat", "w+")

## ================================== ###

data_path = output_path * "/DATA/data_N_$(N)/data_e_$(ϵ)"

files = readdir(data_path)

r = zeros(T, length(files))

## ================================== ###

# rep = 1
for rep in 1:length(files)
    raw_data = reinterpret(Int, read(data_path*"/pos_$(rep).dat"))
    pos_data = reshape(raw_data, N, div(length(raw_data),N))

    r[:,rep] = [maximum(pos_data[:,i]) - minimum(pos_data[:,i]) for i in 1:size(pos_data,2)]
end

write(output_file, r)
close(output_file)

println("Done")
## ================================== ###

# plot(collect(1:1000), broadcast(x -> (x - r[1])^2, r), leg = false, xlabel = "t", ylabel = "r")
#
# plot(collect(1:1000), r, leg = false, xlabel = "t", ylabel = "r")
#
# plot(collect(1:1000), mean(r, 2), leg = false, xlabel = "t", ylabel = "r")
# plot(collect(1:1000), broadcast(x -> (x - mean(r, 2)[1])^2, mean(r, 2)), leg = false, xlabel = "t", ylabel = "r")

## ================================== ###
