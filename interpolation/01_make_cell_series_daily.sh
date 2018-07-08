#!/bin/bash

model=$1

sample_file="/Data/Scratch/science/GloegeMcKinley/SOCATv5_indices.tsv"
model_file="/Data/Scratch/science/GloegeMcKinley/${model}/daily_25.nc"
output_root="/Data/Scratch/science/GloegeMcKinley/${model}"

R --slave --no-save sample=$sample_file model=$model_file output=$output_root < make_cell_series_daily.R
