#!/bin/bash

model=$1

./06_do_spline.sh $model
./07_calc_uncertainty.sh $model
./08_final_interp.sh $model
./09_make_final_netcdf.sh $model

