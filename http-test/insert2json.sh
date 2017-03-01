#!/bin/bash

x=$1
# json_file="test.json" # HARDCODED FOR NOW

node read_data.js "${x}" | xargs node inject.js
