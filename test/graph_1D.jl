
using Plots

N = 1024
N = 256

T = convert(Int, exp10(2))

data_path = "$(homedir())/art_DATA/LS_1D/EXP/data_N_$(N)"

folders = readdir(data_path)

files = readdir(data_path*"/"*folders[1])

p = plot()

t = collect(1:T)

# i = 6
for i in 1:length(files)
    println(i)
    raw_data = reinterpret(Int, read(data_path*"/"**folders[i]*"/"*files[i])))
    pos_data = reshape(raw_data, T, div(length(raw_data), T))

    r = mean(pos_data, 2)

    dr = broadcast(x -> (x - r[1])^2, r)

    plot!(p, [t[i] for i in findn(dr)][1], [dr[i] for i in findn(dr)][1], leg = false, xscale = :log10, yscale = :log10)
end

gui()

raw_data = reinterpret(Int, read(data_path*"/"*folders[1]*"/"*files[1]))
pos_data = reshape(raw_data, T, div(length(raw_data), T))


[t[i] for i in findn(dr)][1]
[dr[i] for i in findn(dr)][1]

### ================================== ###
