#!/bin/bash
# Copyright (c) 2016 Enea Software AB
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0

error_exit() {
    echo "$@" >&2
    exit 1
}

if [ $# -eq 0 ]; then
    OUTPUT_DIR=$(pwd)
else
    OUTPUT_DIR=$(readlink -f $1)
    shift
fi

mkdir -p $OUTPUT_DIR || error_exit "Could not create directory $OUTPUT_DIR"

echo "Building armband, output dir: $OUTPUT_DIR"
cd ..

SCRIPT_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
BUILD_BASE=$(readlink -e ${SCRIPT_DIR}/upstream/fuel/build/)
RESULT_DIR="${BUILD_BASE}/release"

make release || error_exit "Make release failed"

echo "Copying results to $OUTPUT_DIR"
sort ${BUILD_BASE}/gitinfo*.txt > ${OUTPUT_DIR}/gitinfo.txt
cp ${RESULT_DIR}/*.iso ${OUTPUT_DIR}/
cp ${RESULT_DIR}/*.iso.txt ${OUTPUT_DIR}/
