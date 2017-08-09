#!/bin/bash

N="$1"
T="$2"

bash reps_2D.sh $N 0.0 $T
bash reps_2D.sh $N 0.01 $T
bash reps_2D.sh $N 0.05 $T
bash reps_2D.sh $N 0.1 $T
bash reps_2D.sh $N 0.25 $T
bash reps_2D.sh $N 0.5 $T
bash reps_2D.sh $N 0.75 $T
bash reps_2D.sh $N 1.0 $T
