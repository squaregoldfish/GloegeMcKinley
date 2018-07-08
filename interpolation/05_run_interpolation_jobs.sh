#!/bin/bash

threads=$1
model=$2
indir=$3
outdir=$4

if [ -z $threads ] || [ -z $model ] || [ -z $indir ] || [ -z $outdir ]
then
	echo "Usage: 05_run_interpolation_jobs.sh <threads> <model> <indir> <outdir>"
	exit
fi

output_root="/Data/Scratch/science/GloegeMcKinley/${model}"

./make_interpolation_jobs.tcl $output_root $indir $outdir
make -j $threads
./count_success_cells.tcl $output_root $outdir
