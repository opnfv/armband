##############################################################################
# Copyright (c) 2016,2017 Enea AB and others.
# Alexandru.Avadanii@enea.com
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# Prepare for merging with Fuel@OPNFV by keeping the same patch dir structure
A_FUEL_BASE := ${ARMBAND_BASE}/upstream/fuel
A_PATCH_DIR := ${ARMBAND_BASE}/patches
A_OPNFV_TAG  = armband-opnfv
A_PATCHES    = $(shell find ${A_PATCH_DIR} -name '*.patch')
A_BRANCH     = $(shell sed -ne 's/defaultbranch=//p' ${ARMBAND_BASE}/.gitreview)
F_PATCH_DIR := ${A_FUEL_BASE}/mcp/patches

# To enable remote tracking, set the following var to any non-empty string.
# Leaving this var empty will bind each git submodule to its saved commit.
ARMBAND_TRACK_REMOTES ?= yes

# for the patches applying purposes (empty git config in docker build container)
export GIT_COMMITTER_NAME?=OPNFV Armband
export GIT_COMMITTER_EMAIL?=armband@enea.com
