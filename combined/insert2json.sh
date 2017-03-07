#!/bin/bash

x=$1
# json_file="test.json" # HARDCODED FOR NOW

# TODO: Add a check so the JSON file is only updated when the classification
# changes

node read_data.js "${x}" | xargs node inject.js
