##############################################################################
# Copyright (c) 2016 Enea AB and others.
# Alexandru.Avadanii@enea.com
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

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

# Armband plugins, supported archs & specific info
export PLUGINS           := f_odlpluginbuild f_bgpvpn-pluginbuild f_ovs-nsh-dpdk-pluginbuild
export UBUNTU_ARCH       := amd64 arm64
export PRODNO            := OPNFV_A_FUEL
export MIRROR_MOS_UBUNTU := linux.enea.com
export EXTRA_RPM_REPOS   := armband,http://linux.enea.com/mos-repos/centos/mos9.0-centos7/armband/x86_64,10

# Temporary fuel-plugin-builder repo info for runtime patching
export FPB_REPO      := https://github.com/openstack/fuel-plugins
export FPB_BRANCH    := master
export FPB_CHANGE    := refs/changes/31/311031/2

# Armband git submodules for Fuel/OPNFV components
export FUEL_PLUGIN_ODL_REPO        := ${ARMBAND_BASE}/upstream/fuel-plugin-opendaylight
export FUEL_PLUGIN_ODL_BRANCH      := opnfv-armband
export FUEL_PLUGIN_ODL_CHANGE      := ${A_OPNFV_TAG}
export OPNFV_QUAGGE_PACKAGING_REPO := https://github.com/alexandruavadanii/opnfv-quagga-packaging

export OVS_NSH_DPDK_REPO   := ${ARMBAND_BASE}/upstream/fuel-plugin-ovs
export OVS_NSH_DPDK_BRANCH := ${A_OPNFV_TAG}

export VSPERF_REPO   := ${ARMBAND_BASE}/upstream/vswitchperf
export VSPERF_BRANCH := opnfv-armband
export VSPERF_CHANGE := ${A_OPNFV_TAG}
