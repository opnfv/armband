#!/bin/bash
#
# (c) 2017 Enea Software AB
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
set -e

SCRIPT_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

export ARMBAND_BASE=$(readlink -e ${SCRIPT_DIR}/..)

cd ${WORKSPACE:-${ARMBAND_BASE}}
make patches-import

# source local environment variables
if ! [ -z $LAB_CONFIG_URL ]; then
    while getopts "b:B:dfFl:L:p:s:S:T:i:he" OPTION 2>/dev/null
    do
        case $OPTION in
            l) TARGET_LAB=$OPTARG;;
            p) TARGET_POD=$OPTARG;;
        esac
    done
    local_env=${LAB_CONFIG_URL}/labs/${TARGET_LAB}/${TARGET_POD}/fuel/config/local_env
    # try to fetch this file, but don't create it if it does not exist.
    # We add "|| true" to ignore the curl error when the file does not exist
    echo "curl -s -f -O $local_env || true"
    curl -s -f -O $local_env || true
    local_env=$(basename $local_env)
    if [ -e $local_env ]; then
        echo "-- Sourcing local environment file"
        source $local_env
    fi
fi

cd upstream/fuel/ci
./deploy.sh $@
