##############################################################################
# Copyright (c) 2016 Cavium
# Copyright (c) 2016 Enea AB and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# NOTE: Armband patching consists of:
# FIXME
# - clone upstream repositories to git submodules;
# - checkout submodule commits where set in Fuel@OPNFV's config.mk
#   (e.g. FUEL_ASTUTE_COMMIT=...);
# - tag each submodule (before patching) with "armband-workbench-root";
# - apply Armband patches for each submodule;
# - tag each submodule (after patching) with "armband-workbench";
# - pass updated repository info to Fuel@OPNFV build system
#   (e.g. FUEL_ASTUTE_COMMIT=HEAD) via armband.mk;

# NOTE: Long-term goals (Armband repo should merge with Fuel@OPNFV):
# FIXME
# - all build related changes should affect Fuel@OPNFV, NOT Armband;
# - Armband make/build system should only handle patching,
#   including eventual build related patching of Fuel@OPNFV,
#   and then invoke Fuel@OPNFV's build system;
# - Fuel@OPNFV is made aware of an Armband type build by passing
#   the "ARMBAND_BASE" env var;

# NOTE: FIXME: reversed feature order

export ARMBAND_BASE  := $(shell pwd)
export OPNFV_GIT_SHA := $(shell git rev-parse HEAD)
export REVSTATE

# Prepare for future directory re-layout when merging with Fuel@OPNFV
A_FUEL_BASE := ${ARMBAND_BASE}/upstream/fuel
A_PATCH_DIR := ${ARMBAND_BASE}/patches
A_OPNFV_TAG  = armband-opnfv
A_PATCHES    = $(shell find ${A_PATCH_DIR} -name '*.patch')
F_BUILD_DIR := ${A_FUEL_BASE}/build
F_REPOS_DIR := ${F_BUILD_DIR}/f_repos
F_PATCH_DIR := ${F_REPOS_DIR}/patch
F_SUB_DIR   := ${F_REPOS_DIR}/sub

# To enable remote tracking, set the following var to any non-empty string.
# Leaving this var empty will bind each git submodule to its saved commit.
ARMBAND_TRACK_REMOTES ?= yes

all: release

# Fetch & update git submodules, checkout remote HEAD
.PHONY: submodules-init
submodules-init: .submodules-init

.submodules-init:
	@if [ -n "${ARMBAND_TRACK_REMOTES}" ]; then \
		git submodule update --init --remote 2>/dev/null; \
	else \
		git submodule update --init 2>/dev/null; \
	fi
	@ln -sf ${A_FUEL_BASE}/ci/clean_cache.sh ${ARMBAND_BASE}/ci/clean_cache.sh
	@touch $@

# Clean any changes made to submodules, checkout Armband root commit
.PHONY: submodules-clean
submodules-clean: .submodules-init
	@git submodule -q foreach ' \
		git am -q --abort 2>/dev/null; \
		git checkout -q ${A_OPNFV_TAG}-root 2>/dev/null; \
		git branch -q -D opnfv-armband 2>/dev/null; \
		git tag | grep ${A_OPNFV_TAG} | xargs git tag -d > /dev/null 2>&1; \
		git reset -q --hard HEAD; \
		git clean -xdff'
	@rm -f .submodules-patched

# Generate patches from submodules
.PHONY: patches-export
patches-export: .submodules-init
	@git submodule -q foreach ' \
		SUB_DIR=${A_PATCH_DIR}/$$name; \
		git tag | awk "!/root/ && /${A_OPNFV_TAG}-fuel/" | while read A_TAG; do \
			SUB_FEATURE=`dirname $${A_TAG#${A_OPNFV_TAG}-fuel/}`; \
			echo "`tput setaf 2`== exporting $$name ($$A_TAG)`tput sgr0`"; \
			mkdir -p $$SUB_DIR/$${SUB_FEATURE} && \
			git format-patch --no-signature --ignore-space-at-eol \
				-o $$SUB_DIR/$$SUB_FEATURE -N $$A_TAG-root..$$A_TAG; \
		done'
	@sed -i -e '1d' -e 's/[[:space:]]*$$//' ${A_PATCHES}

# Apply patches from patches/* to respective submodules
# For repos pinned in Fuel@OPNFV's config.mk, checkout pinned commit first
.PHONY: patches-import
patches-import: .submodules-init .submodules-patched

.submodules-patched: ${A_PATCHES}
	@$(MAKE) submodules-clean
	@git submodule -q foreach ' \
		SUB_DIR=${A_PATCH_DIR}/$$name; mkdir -p $$SUB_DIR && \
		git tag ${A_OPNFV_TAG}-root && \
		git checkout -q -b opnfv-armband && \
		find $$SUB_DIR -type d | sort -r | while read p_dir; do \
			SUB_PATCHES=$$(ls $$p_dir/*.patch 2>/dev/null); \
			if [ -n "$$SUB_PATCHES" ]; then \
				SUB_FEATURE=$${p_dir#$$SUB_DIR} \
				SUB_TAG=${A_OPNFV_TAG}-fuel$$SUB_FEATURE/patch; \
				echo "`tput setaf 2`== patching $$name ($$SUB_TAG)`tput sgr0`";\
				git tag $$SUB_TAG-root && git am -3 --whitespace=nowarn \
					--committer-date-is-author-date $$SUB_PATCHES && \
				git tag $$SUB_TAG || exit 1; \
			fi \
		done && \
		git tag ${A_OPNFV_TAG}'
	# Staging Fuel@OPNFV patches
	@ls -d ${F_SUB_DIR}/* 2>/dev/null | while read p_sub_path; do \
		SUB_NAME=`basename $$p_sub_path`; \
		find ${A_PATCH_DIR}/$$SUB_NAME -name '*.patch' 2>/dev/null -exec sh -c '\
			A_PATCH={}; R_PATCH=$${A_PATCH#${A_PATCH_DIR}/}; \
			F_PATCH=${F_PATCH_DIR}/$${0}/armband/$${R_PATCH#$${0}/}; \
			if [ -f $$F_PATCH ]; then \
				echo "`tput setaf 3`* WARN: $$R_PATCH upstream.`tput sgr0`"; \
			else \
				echo "`tput setaf 6`* Staging $$R_PATCH`tput sgr0`"; \
				mkdir -p `dirname $$F_PATCH` && cp $$A_PATCH $$F_PATCH; \
			fi' "$$SUB_NAME" \; || true ; \
	done
	@touch $@

# Pass down clean/deepclean/build to Fuel@OPNFV
.PHONY: clean
clean: .submodules-init
	$(MAKE) -e --no-print-directory -C ${F_BUILD_DIR} clean

.PHONY: deepclean
deepclean: clean
	$(MAKE) -e --no-print-directory -C ${F_BUILD_DIR} deepclean
	@git submodule deinit -f .
	@rm -f .submodules*

.PHONY: build
build: patches-import
	$(MAKE) -e --no-print-directory -C ${F_BUILD_DIR} all

.PHONY: release
release: export LC_ALL=en_US.UTF-8
release: build

##############################################################################
# Fuel@OPNFV patch operations - to be used only during development
##############################################################################

# Apply all Fuel@OPNFV patches, including Armband patches
.PHONY: fuel-patches-import
fuel-patches-import: .submodules-patched
	$(MAKE) -e -C ${F_REPOS_DIR} patches-import

# Export Fuel@OPNFV patches, including Armband patches
.PHONY: fuel-patches-export
fuel-patches-export: .submodules-patched
	$(MAKE) -e -C ${F_REPOS_DIR} patches-export
	@ls -d ${F_PATCH_DIR}/* 2>/dev/null | while read p_sub_path; do \
		SUB_NAME=`basename $$p_sub_path`; \
		if [ -d $$p_sub_path/armband ]; then \
			echo "`tput setaf 6`* Pulling $$SUB_NAME patches.`tput sgr0`"; \
			cp -R $$p_sub_path/armband/* ${A_PATCH_DIR}/$$SUB_NAME && \
				rm -rf $$p_sub_path/armband; \
		fi \
	done

.PHONY: fuel-patches-clean
fuel-patches-clean:
	$(MAKE) -e -C ${F_REPOS_DIR} clean
