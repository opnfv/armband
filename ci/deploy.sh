#!/bin/bash
#
# (c) 2016 Enea Software AB
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
set -e

cd $WORKSPACE
make submodules-init
make patches-import

cd upstream/fuel/ci
./deploy.sh $@
