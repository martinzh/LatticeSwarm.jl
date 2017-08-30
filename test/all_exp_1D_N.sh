#!/bin/bash

N="$2"

nohup julia exp_1D.jl LS_1D $N 0.0  &
nohup julia exp_1D.jl LS_1D $N 0.01 &
nohup julia exp_1D.jl LS_1D $N 0.05 &
nohup julia exp_1D.jl LS_1D $N 0.1 &
nohup julia exp_1D.jl LS_1D $N 0.25 &
nohup julia exp_1D.jl LS_1D $N 0.5 &
nohup julia exp_1D.jl LS_1D $N 0.75 &
nohup julia exp_1D.jl LS_1D $N 1.0 &
