root:=$(shell pwd)

all: build

.PHONY: submodules-init submodules-clean
submodules-init:
	@git submodule -q init
	@git submodule -q sync
	@git submodule -q update

# Cleans any changes made to submodules
submodules-clean:
	@git submodule -q foreach \
		'git checkout -q armband-workbench-root; \
		git branch -q -D armband-workbench; \
		git tag -d armband-workbench-root; \
		git reset -q --hard HEAD; git clean -qxdf'

.PHONY: patches-export patches-import
# Generate patches from submodules
patches-export:
	@git submodule -q foreach 'mkdir -p ${root}/patches/$$name'
	@git submodule -q foreach 'git format-patch \
		-o ${root}/patches/$$name -N armband-workbench-root'
	@find ${root}/patches -name '*.patch' -exec sed -i -e '1d' {} \;

# apply patches from patches/* to respective submodules
patches-import:
	@git submodule -q foreach 'mkdir -p ${root}/patches/$$name'
	@git submodule -q foreach 'git tag armband-workbench-root'
	@git submodule -q foreach 'git checkout -q -b armband-workbench'
	@git submodule -q foreach \
		'for p in $$(ls ${root}/patches/$$name/); do \
			git am ${root}/patches/$$name/$$p; \
		done'

build:
	cd ${root}/upstream/fuel/build && \
		time make \
			FUEL_MAIN_REPO=${root}/upstream/fuel-main \
			FUEL_MAIN_TAG= \
			OVSNFV_DPDK_CHANGE=refs/changes/81/10881/1 \
			UBUNTU_ARCH="amd64 arm64" \
			SEPARATE_IMAGES="/boot,ext2 /,ext4 /boot/efi,vfat" \
			FUELLIB_REPO=${root}/upstream/fuel-library \
			NAILGUN_REPO=${root}/upstream/fuel-web \
			FUEL_AGENT_REPO=${root}/upstream/fuel-agent \
			FUEL_MIRROR_REPO=${root}/upstream/fuel-mirror \
			QEMU_REPO=${root}/upstream/fuel-plugin-qemu \
			OVSNFV_DPDK_REPO=${root}/upstream/fuel-plugin-ovsnfv \
			FUELLIB_COMMIT=HEAD \
			NAILGUN_COMMIT=HEAD \
			FUEL_AGENT_COMMIT=HEAD \
			FUEL_MIRROR_COMMIT=HEAD \
			QEMU_BRANCH=HEAD \
			OVSNFV_DPDK_BRANCH=HEAD \
			PRODUCT_VERSION=8.0 \
			PRODUCT_NAME=mos \
			CENTOS_MAJOR=7 \
			MIRROR_FUEL=http://linux.enea.com/mos-repos/centos/mos8.0-centos7-fuel/os/x86_64/ \
			MIRROR_UBUNTU_URL=http://archive.ubuntu.com/ubuntu/ \
			LATEST_MIRROR_ID_URL=http://linux.enea.com/ \
			JAVA8_URL=https://launchpad.net/~openjdk-r/+archive/ubuntu/ppa/+files/openjdk-8-jre-headless_8u72-b15-1~trusty1_arm64.deb \
			iso 2>&1 | tee ${root}/build.log

