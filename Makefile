root:=$(shell pwd)

all: build

.PHONY: submodules-init submodules-clean
submodules-init:
	@git submodule -q init
	@git submodule -q sync
	@git submodule update --remote

# Cleans any changes made to submodules
submodules-clean:
	@git submodule -q foreach \
		'git am --abort; \
		git checkout -q armband-workbench-root; \
		git branch -q -D armband-workbench; \
		git tag -d armband-workbench-root; \
		git reset -q --hard HEAD; git clean -xdff'

.PHONY: patches-export patches-import
# Generate patches from submodules
patches-export:
	@git submodule -q foreach 'mkdir -p ${root}/patches/$$name'
	@git submodule -q foreach 'git format-patch \
		-o ${root}/patches/$$name -N armband-workbench-root \
	    --no-signature'
	@find ${root}/patches -name '*.patch' -exec sed -i -e '1d' {} \;

# apply patches from patches/* to respective submodules
patches-import:
	@git submodule -q foreach 'mkdir -p ${root}/patches/$$name'
	@git submodule -q foreach 'git tag armband-workbench-root'
	@git submodule -q foreach 'git checkout -q -b armband-workbench'
	@git submodule -q foreach \
		'if [ ! -z "$$(ls ${root}/patches/$$name/)" ]; then \
			echo "-- patching $$name"; \
			git am ${root}/patches/$$name/*.patch; \
		fi'
clean-docker:
	@if [ -d ${root}/upstream/fuel/build ]; then \
		sudo make -C ${root}/upstream/fuel/build deepclean; \
	fi
	@for container in $(shell sudo docker ps -a -q); do \
		sudo docker rm -f -v $${container}; \
	done
	@for image in $(shell sudo docker images -q); do \
		sudo docker rmi -f $${image}; \
	done

clean-build:
	sudo rm -rf /tmp/fuel-main
	git -C ${root}/upstream/fuel reset --hard HEAD
	git -C ${root}/upstream/fuel clean -xdff

release: export LC_ALL=en_US.UTF-8
release: submodules-clean clean-docker clean-build submodules-init patches-import build

ifneq ($(REVSTATE),)
    EXTRA_PARAMS="REVSTATE=$(REVSTATE)"
endif

build:
	cd ${root}/upstream/fuel/build && \
		make \
			BUILD_FUEL_PLUGINS="f_odlpluginbuild f_bgpvpn-pluginbuild" \
			UBUNTU_ARCH="amd64 arm64" \
			PRODNO="OPNFV_FUEL_AARCH64" \
			OPNFV_GIT_SHA=$(shell git rev-parse HEAD) \
			ASTUTE_REPO=${root}/upstream/fuel-astute \
			ASTUTE_COMMIT=HEAD \
			NAILGUN_REPO=${root}/upstream/fuel-web \
			NAILGUN_COMMIT=HEAD \
			FUEL_AGENT_REPO=${root}/upstream/fuel-agent \
			FUEL_AGENT_COMMIT=HEAD \
			FUEL_NAILGUN_AGENT_REPO=${root}/upstream/fuel-nailgun-agent \
			FUEL_NAILGUN_AGENT_COMMIT=HEAD \
			FUEL_MIRROR_REPO=${root}/upstream/fuel-mirror \
			FUEL_MIRROR_COMMIT=HEAD \
			FUELLIB_REPO=${root}/upstream/fuel-library \
			FUELLIB_COMMIT=HEAD \
			ODL_REPO=${root}/upstream/fuel-plugin-opendaylight \
			ODL_BRANCH=armband-workbench \
			ODL_CHANGE= \
			OPNFV_QUAGGE_PACKAGING_REPO="https://github.com/alexandruavadanii/opnfv-quagga-packaging" \
			OVS_NSH_DPDK_REPO=${root}/upstream/fuel-plugin-ovs \
			OVS_NSH_DPDK_BRANCH=HEAD \
			VSPERF_REPO=${root}/upstream/vswitchperf \
			VSPERF_BRANCH=armband-workbench \
			VSPERF_CHANGE= \
			YARDSTICK_REPO=${root}/upstream/yardstick \
			YARDSTICK_BRANCH=armband-workbench \
			YARDSTICK_CHANGE= \
			EXTRA_RPM_REPOS="armband,http://linux.enea.com/mos-repos/centos/mos9.0-centos7/armband/x86_64,10" \
			MIRROR_MOS_UBUNTU=linux.enea.com \
			$(EXTRA_PARAMS) \
			iso 2>&1 | tee ${root}/build.log

