#!/bin/bash

output_file="data_"$(date +"%F-%H%M%S")".txt"

node accelog.js > "${output_file}"
matlab -nodesktop -nosplash -r "plotST("${output_file}")"
