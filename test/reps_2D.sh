#!/bin/bash

N="$1"
e="$2"
T="$3"

for i in {1..20}
do
    nohup /home/martin/Code/julia/julia 2D_test.jl $N $e $T $i &
done

wait

for i in {21..40}
do
    nohup /home/martin/Code/julia/julia 2D_test.jl $N $e $T $i &
done

# wait
#
# for i in {41..60}
# do
#     time nohup julia 2D_test.jl $N $e $T $i &
# done
