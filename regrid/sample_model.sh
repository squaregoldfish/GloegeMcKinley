#!/bin/bash

modelname=$1

scratch_root="/Data/Scratch/science/GloegeMcKinley/$modelname"

mkdir "$scratch_root"
mkdir "$scratch_root/cell_series_daily"
mkdir "$scratch_root/final_output"
mkdir "$scratch_root/spline_output"
mkdir "$scratch_root/uncertainty_output"
mkdir "$scratch_root/interpolation_outputs"
mkdir "$scratch_root/interpolation_outputs/output1"
mkdir "$scratch_root/interpolation_outputs/output2"
mkdir "$scratch_root/interpolation_outputs/output3"
mkdir "$scratch_root/interpolation_outputs/output4"
mkdir "$scratch_root/interpolation_outputs/output5"
mkdir "$scratch_root/interpolation_outputs/output6"
mkdir "$scratch_root/interpolation_outputs/output7"
mkdir "$scratch_root/interpolation_outputs/output8"
cd "$scratch_root/interpolation_outputs"
ln -s ../cell_series_daily initial_input
cd -


inpath="/Data/science/LukeGalen/model_files/pCO2_2D_mon_${modelname}_1x1_198201-201701.nc"
regridded="$scratch_root/monthly_25.nc"
model_daily="$scratch_root/daily_25.nc"

pyferret -nojnl -quiet > /dev/null << EOF
use "$inpath"
set mem/size=2048
define axis/x=1.25:358.75:2.5 lon25
define axis/y=-88.75:88.75:2.5 lat25
define grid/x=lon25/y=lat25 grid25
save/clobber/file="$regridded" pco2[g=grid25]
quit
EOF

R --slave --no-save inpath=$regridded outpath=$model_daily < make_model_daily.R
