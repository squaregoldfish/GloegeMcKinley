#!/bin/bash

modelname=$1

inpath="/Data/science/LukeGalen/model_files/pCO2_2D_mon_${modelname}_1x1_198201-201701.nc"
regridded="/Data/Scratch/science/GloegeMcKinley/$modelname/monthly_25.nc"
model_daily="/Data/Scratch/science/GloegeMcKinley/$modelname/daily_25.nc"

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
