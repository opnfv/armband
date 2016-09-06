##############################################################################
# Copyright (c) 2016 Cavium
# Copyright (c) 2016 Enea AB and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# NOTE: Armband patching consists of:
# - clone upstream repositories to git submodules;
# - checkout submodule commits where set in Fuel@OPNFV's config.mk
#   (e.g. FUEL_ASTUTE_COMMIT=...);
# - tag each submodule (before patching) with "armband-workbench-root";
# - apply Armband patches for each submodule;
# - tag each submodule (after patching) with "armband-workbench";
# - pass updated repository info to Fuel@OPNFV build system
#   (e.g. FUEL_ASTUTE_COMMIT=HEAD) via armband.mk;

# NOTE: Long-term goals (Armband repo should merge with Fuel@OPNFV):
# - all build related changes should affect Fuel@OPNFV, NOT Armband;
# - Armband make/build system should only handle patching,
#   including eventual build related patching of Fuel@OPNFV,
#   and then invoke Fuel@OPNFV's build system;
# - Fuel@OPNFV is made aware of an Armband type build by passing
#   the "ARMBAND_BASE" env var;

# Fist, inherit Fuel submodule commit references from Fuel@OPNFV
# using "config.mk" as a make target that links to Fuel's config.mk.
# Some values will be overriden at Fuel ISO build time by armband.mk.
include config.mk

export ARMBAND_BASE  := $(shell pwd)
export OPNFV_GIT_SHA := $(shell git rev-parse HEAD)
export REVSTATE

# Prepare for future directory re-layout when merging with Fuel@OPNFV
PATCH_DIR  := ${ARMBAND_BASE}/patches
SUBMOD_DIR := ${ARMBAND_BASE}/upstream
FUEL_BASE  := ${SUBMOD_DIR}/fuel

all: release

# Use config.mk & clean_cache.sh from Fuel@OPNFV
config.mk: submodules-init
	@ln -sf ${FUEL_BASE}/build/config.mk ${ARMBAND_BASE}/config.mk
	@ln -sf ${FUEL_BASE}/ci/clean_cache.sh ${ARMBAND_BASE}/ci/clean_cache.sh

# Fetch & update git submodules, checkout remote HEAD
.PHONY: submodules-init
submodules-init:
	@if [ ! -d ${FUEL_BASE}/build ]; then \
		git submodule -q init; \
		git submodule -q sync; \
		git submodule update --remote; \
	fi

# Clean any changes made to submodules, checkout Armband root commit
.PHONY: submodules-clean
submodules-clean: submodules-init
	@git submodule -q foreach ' \
		git am -q --abort 2>/dev/null; \
		git checkout -q armband-workbench-root 2>/dev/null; \
		git branch -q -D armband-workbench 2>/dev/null; \
		git tag -d armband-workbench-root 2>/dev/null; \
		git reset -q --hard HEAD; \
		git clean -xdff'

# Generate patches from submodules
.PHONY: patches-export
patches-export: submodules-init
	@git submodule -q foreach ' \
		mkdir -p ${PATCH_DIR}/$$name; \
		git format-patch --no-signature \
			-o ${PATCH_DIR}/$$name -N armband-workbench-root'
	@find ${PATCH_DIR} -name '*.patch' -exec sed -i -e '1d' {} \;

# Apply patches from patches/* to respective submodules
# For repos pinned in Fuel@OPNFV's config.mk, checkout pinned commit first
.PHONY: patches-import
patches-import: submodules-init
	@cd ${FUEL_BASE} && git checkout -q master
	@cd ${SUBMOD_DIR}/fuel-agent && git checkout -q ${FUEL_AGENT_COMMIT}
	@cd ${SUBMOD_DIR}/fuel-astute && git checkout -q ${ASTUTE_COMMIT}
	@cd ${SUBMOD_DIR}/fuel-library && git checkout -q ${FUELLIB_COMMIT}
	@cd ${SUBMOD_DIR}/fuel-mirror && git checkout -q ${FUEL_MIRROR_COMMIT}
	@cd ${SUBMOD_DIR}/fuel-nailgun-agent && \
		git checkout -q ${FUEL_NAILGUN_AGENT_COMMIT}
	@cd ${SUBMOD_DIR}/fuel-web && git checkout -q ${NAILGUN_COMMIT}
	@git submodule -q foreach ' \
		mkdir -p ${PATCH_DIR}/$$name; \
		git tag armband-workbench-root; \
		git checkout -q -b armband-workbench; \
		if [ ! -z "$$(ls ${PATCH_DIR}/$$name/)" ]; then \
			echo "-- patching $$name"; \
			git am --whitespace=nowarn \
				--committer-date-is-author-date \
				${PATCH_DIR}/$$name/*.patch; \
		fi'

# Pass down clean/deepclean/build to Fuel@OPNFV
.PHONY: clean
clean: submodules-init
	$(MAKE) -e --no-print-directory -C ${FUEL_BASE}/build clean

.PHONY: deepclean
deepclean: submodules-init
	$(MAKE) -e --no-print-directory -C ${FUEL_BASE}/build deepclean

.PHONY: build
build:
	$(MAKE) -e --no-print-directory -C ${FUEL_BASE}/build all

.PHONY: release
release: export LC_ALL=en_US.UTF-8
release: submodules-clean patches-import build
