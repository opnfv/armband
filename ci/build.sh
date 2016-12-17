#!/bin/bash
# Copyright (c) 2016 Enea Software AB
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0

set -e

SCRIPT_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
BUILD_BASE=$(readlink -f ${SCRIPT_DIR}/../upstream/fuel/build)

export ARMBAND_BASE=$(readlink -e ${SCRIPT_DIR}/..)
export OPNFV_GIT_SHA=$(git rev-parse HEAD)
export LOCAL_CACHE_ARCH_NAME="armband-cache"

# Initialize Armband git submodules & apply patches first
make -C ${ARMBAND_BASE} submodules-clean patches-import
cd ${ARMBAND_BASE}/upstream/fuel/ci && ./build.sh $*
