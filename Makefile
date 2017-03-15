##############################################################################
# Copyright (c) 2016 Cavium
# Copyright (c) 2016 Enea AB and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# NOTE: Armband patching consists of:
# - clone upstream repositories to git submodules, tracking remotes;
# - tag each submodule (before patching) with "${A_OPNFV_TAG}-root";
# - apply Armband patches for each submodule;
# - tag each submodule (after patching) with "${OPNFV_TAG}";
# - stage Fuel submodule patches by copying them to Fuel f_repos/patch dir;
# - pass updated repository info to Fuel@OPNFV build system
#   (e.g. FUEL_PLUGIN_ODL_CHANGE="${OPNFV_TAG}") via armband-fuel-config.mk;

# NOTE: Long-term goals (Armband repo should merge with Fuel@OPNFV):
# - all build related changes should affect Fuel@OPNFV, NOT Armband;
# - Armband make/build system should only handle patching non-Fuel submodules,
#   and then invoke Fuel@OPNFV's patch & build system;
# - Fuel@OPNFV is made aware of an Armband type build by passing
#   the "ARMBAND_BASE" env var;

SHELL = /bin/sh

export ARMBAND_BASE  := $(shell pwd)
export OPNFV_GIT_SHA := $(shell git rev-parse HEAD)
export REVSTATE

include armband-fuel-config.mk

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
	@test ! -d ${F_REPOS_DIR} || $(MAKE) fuel-patches-clean
	@git submodule -q foreach ' \
		git am -q --abort 2>/dev/null; \
		git checkout -q -f ${A_OPNFV_TAG}-root 2>/dev/null; \
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
			sed -i -e "1{/From: /!d}" -e "s/[[:space:]]*$$//" \
				$$SUB_DIR/$$SUB_FEATURE/*.patch; \
		done'

# Apply patches from patches/* to respective submodules
.PHONY: patches-import
patches-import: .submodules-init .submodules-patched

.submodules-patched: ${A_PATCHES}
	@$(MAKE) submodules-clean
	@git submodule -q foreach ' \
		SUB_DIR=${A_PATCH_DIR}/$$name; mkdir -p $$SUB_DIR && \
		git tag ${A_OPNFV_TAG}-root && \
		git checkout -q -b opnfv-armband && \
		find $$SUB_DIR -type d | sort | while read p_dir; do \
			SUB_PATCHES=$$(ls $$p_dir/*.patch 2>/dev/null); \
			if [ -n "$$SUB_PATCHES" ]; then \
				SUB_FEATURE=$${p_dir#$$SUB_DIR} \
				SUB_TAG=${A_OPNFV_TAG}-fuel$$SUB_FEATURE/patch; \
				echo "`tput setaf 2`== patching $$name ($$SUB_TAG)`tput sgr0`";\
				git tag $$SUB_TAG-root && \
				git am -3 --whitespace=nowarn --patch-format=mbox \
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
				if [ -h $$A_PATCH ]; then \
					echo "`tput setaf 3`* PHONY: $$R_PATCH`tput sgr0`"; \
				else \
					echo "`tput setaf 6`* Staging $$R_PATCH`tput sgr0`"; \
					mkdir -p `dirname $$F_PATCH` && cp $$A_PATCH $$F_PATCH; \
				fi; \
			fi' "$$SUB_NAME" \; || true ; \
	done
	@touch $@

# Pass down debug/clean/deepclean/build to Fuel@OPNFV
.PHONY: clean debug
clean: .submodules-init
debug: fuel-patches-import
clean debug:
	$(MAKE) -e --no-print-directory -C ${F_BUILD_DIR} $@

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
fuel-patches-import: .submodules-patched fuel-patches-clean
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
