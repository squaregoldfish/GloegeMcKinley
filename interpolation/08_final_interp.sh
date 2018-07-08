#!/bin/bash

model=$1

output_root="/Data/Scratch/science/GloegeMcKinley/${model}"

echo "Removing old input..."
rm -r /tmp/final_interp_input
echo "Copying input..."
cp -RH "${output_root}/uncertainty_output"  /tmp/final_interp_input
echo "Removing old output..."
rm -r  "${output_root}/final_output"
echo "Running..."
R --slave --no-save output="${output_root}" < final_interp.R

