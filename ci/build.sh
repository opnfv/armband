#!/bin/bash

if [ $# -gt 1 ]; then
    OUTPUT_DIR=shift
else
    OUTPUT_DIR=""
fi

echo "Building armband, output dir: $OUTPUT_DIR"
