#!/bin/bash

output_file=$1
matlab_file="'${output_file}'"

sleep 5
matlab -nodesktop -nosplash -r "Prahnav_Orientation_RealTime("${matlab_file}")"
