#!/bin/bash

output_file="data_"$(date +"%F-%H%M%S")".txt"
# matlab_file = '"${output_file}"'

node accelog.js > "${output_file}" &
./runMat3.sh "${output_file}"
# matlab -nodesktop -nosplash -r "Prahnav_Orientation_RealTime("${output_file}")"
