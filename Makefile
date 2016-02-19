root:=$(shell pwd)

all: build

.PHONY: submodules-init submodules-clean
submodules-init:
	@git submodule -q init
	@git submodule -q sync
	@git submodule -q update

submodules-clean:
	@git submodule -q foreach \
		'git reset -q --hard HEAD; git clean -qxdf'

.PHONY: patches-export patches-import
# Generate patches from submodules
patches-export: submodules-init
	@git submodule -q foreach 'git add -N *; git diff > \
		${root}/patches/$$name.patch'

# apply patches from patches/* to respective submodules
patches-import: submodules-init
	@git submodule -q foreach 'patch -p1 -s -N < \
		${root}/patches/$$name.patch || true'

patches-commit: submodules-init
	@git submodule -q foreach 'git add *; git commit -q -m "armband-fuel build commit"'

patches-uncommit: submodules-init
	@git submodule -q foreach 'echo "$(git log -n 1 --oneline)" | grep --quiet "armband-fuel build commit" && git reset HEAD~1'

# In order for this to work, the patches will have to 
build: submodules-init patches-import
	cd ${root}/upstream/fuel/build && \
		make \
			FUEL_MAIN_REPO=${root}/upstream/fuel-main \
			FUEL_MAIN_TAG= \
			UBUNTU_ARCH=arm64 \
			SEPARATE_IMAGES=/boot,ext2 /,ext4 /boot/efi,vfat \
			FUELLIB_REPO=${root}/upstream/fuel-library \
			NAILGUN_REPO=${root}/upstream/fuel-web \
			FUEL_AGENT_REPO=${root}/upstream/fuel-agent \
			MIRROR_UBUNTU=https://linux.enea.com/repo/opnfv/armband \
			iso

