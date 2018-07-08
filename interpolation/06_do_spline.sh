#!/bin/bash

model=$1

output_root="/Data/Scratch/science/GloegeMcKinley/${model}"

R --slave --no-save output=$output_root < do_spline.R
