#!/bin/bash

output_file=$1
matlab_file="'${output_file}'"

sleep 10
matlab -nodesktop -nosplash -r "plotST("${matlab_file}")"
