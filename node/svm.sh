#!/bin/bash

output_file="data_"$(date +"%F-%H%M%S")".txt"
# matlab_file = '"${output_file}"'

node accelog.js > "${output_file}" &
./runSVM.sh "${output_file}"
