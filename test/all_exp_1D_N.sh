#!/bin/bash

N="$2"

bash exp_1D.sh LS_1D $N 0.0 
bash exp_1D.sh LS_1D $N 0.01
bash exp_1D.sh LS_1D $N 0.05
bash exp_1D.sh LS_1D $N 0.1
bash exp_1D.sh LS_1D $N 0.25
bash exp_1D.sh LS_1D $N 0.5
bash exp_1D.sh LS_1D $N 0.75
bash exp_1D.sh LS_1D $N 1.0
