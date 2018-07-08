#!/bin/bash

model=$1

output_root="/Data/Scratch/science/GloegeMcKinley/${model}"

R --slave --no-save output=$output_root < make_final_netcdf.R
