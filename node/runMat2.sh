#!/bin/bash

output_file=$1
matlab_file="'${output_file}'"

sleep 2
matlab -nodesktop -nosplash -r "plotST2("${matlab_file}")"
