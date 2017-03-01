#!/bin/bash

data_file="outData.txt"
data_file_size=0
# json_file="test.json" # HARDCODED FOR NOW

while :
do
    x=$(stat -f%z "${data_file}")
    if [[ "${x}" -gt "${data_file_size}" ]]; then
        data_file_size="${x}"
        # If the file size has increased, update the json
        ./insert2json.sh "${data_file}"
    fi
done
