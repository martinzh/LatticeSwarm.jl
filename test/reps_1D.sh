#!/bin/bash

e="$1"

for i in {1..10}
do
    time  nohup julia 1D_test.jl $e $i &
done
