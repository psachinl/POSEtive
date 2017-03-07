#!/bin/bash

output_file=$1
matlab_file="'${output_file}'"

sleep 1
matlab -nodesktop -nosplash -r "realtimeOrientation("${matlab_file}")"
