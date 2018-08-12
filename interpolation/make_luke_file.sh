#!/bin/bash

model=$1

cdo remapbil,luke_grid.grd /Data/Scratch/science/GloegeMcKinley/$model/fco2.nc /tmp/regrid.nc
mv /tmp/regrid.nc /Data/Scratch/science/GloegeMcKinley/outputs/pCO2_2D_mon_${model}_1x1_198201_201701_UEA-SI.nc

