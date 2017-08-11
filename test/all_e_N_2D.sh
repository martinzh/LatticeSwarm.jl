#!/bin/bash

N="$1"
T="$2"

bash reps_2D.sh $N 0.0 $T
wait
bash reps_2D.sh $N 0.01 $T
wait
bash reps_2D.sh $N 0.05 $T
wait
bash reps_2D.sh $N 0.1 $T
wait
bash reps_2D.sh $N 0.25 $T
wait
bash reps_2D.sh $N 0.5 $T
wait
bash reps_2D.sh $N 0.75 $T
wait
bash reps_2D.sh $N 1.0 $T
