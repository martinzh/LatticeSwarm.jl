#!/bin/bash

N="$1"
e="$2"
T="$3"

for i in {1..20}
do
    time nohup julia 1D_test.jl $N $e $T $i &
done

sleep 10m

for i in {21..40}
do
    time nohup julia 1D_test.jl $N $e $T $i &
done

sleep 10m

for i in {41..60}
do
    time nohup julia 1D_test.jl $N $e $T $i &
done

sleep 10m
