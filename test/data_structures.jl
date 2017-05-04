
using Plots

gr()

# number of walkers
N = 256

# bias intensity
ϵ = 0.2

# initalization space
Lx = 15
Ly = 15

# inital particles positions
x_pos = rand(1:2Lx, N)
y_pos = rand(1:2Ly, N)

x_pos = rand(1:Lx, N)
y_pos = rand(1:Ly, N)

scatter(x_pos, y_pos, leg = false)

pos = sparse(x_pos, y_pos, ones(N))

rowvals(pos)
nzrange(pos, 1)
