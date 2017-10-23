#!/bin/bash -e
##############################################################################
# Copyright (c) 2017 Enea Software AB and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
CI_DEBUG=${CI_DEBUG:-0}; [[ "${CI_DEBUG}" =~ (false|0) ]] || set -x
SCRIPT_DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
ARMBAND_BASE=$(readlink -e "${SCRIPT_DIR}/..")

export ARMBAND_BASE
export CI_DEBUG

cd "${WORKSPACE:-${ARMBAND_BASE}}"
make patches-import

cd upstream/fuel/ci
./deploy.sh "$@"
