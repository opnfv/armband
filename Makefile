# Fist, inherit Fuel submodule commit references from Fuel@OPNFV
# These values will be overriden at build time by armband.mk
include config.mk

export ARMBAND_BASE  := $(shell pwd)
export OPNFV_GIT_SHA := $(shell git rev-parse HEAD)
export REVSTATE

all: build

config.mk: submodules-init
	@ln -sf ${ARMBAND_BASE}/upstream/fuel/build/config.mk ${ARMBAND_BASE}/config.mk
	@ln -sf ${ARMBAND_BASE}/upstream/fuel/ci/clean_cache.sh ${ARMBAND_BASE}/ci/clean_cache.sh

.PHONY: submodules-init submodules-clean
submodules-init:
	@if [ ! -d ${ARMBAND_BASE}/upstream/fuel/build ]; then \
		git submodule -q init; \
		git submodule -q sync; \
		git submodule update --remote; \
	fi

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
	@git submodule -q foreach 'mkdir -p ${ARMBAND_BASE}/patches/$$name'
	@git submodule -q foreach 'git format-patch \
		-o ${ARMBAND_BASE}/patches/$$name -N armband-workbench-root \
		--no-signature'
	@find ${ARMBAND_BASE}/patches -name '*.patch' -exec sed -i -e '1d' {} \;

# apply patches from patches/* to respective submodules
patches-import:
	@cd ${ARMBAND_BASE}/upstream/fuel && \
		git checkout -q master
	@cd ${ARMBAND_BASE}/upstream/fuel-agent && \
		git checkout -q ${FUEL_AGENT_COMMIT}
	@cd ${ARMBAND_BASE}/upstream/fuel-astute && \
		git checkout -q ${ASTUTE_COMMIT}
	@cd ${ARMBAND_BASE}/upstream/fuel-library && \
		git checkout -q ${FUELLIB_COMMIT}
	@cd ${ARMBAND_BASE}/upstream/fuel-mirror && \
		git checkout -q ${FUEL_MIRROR_COMMIT}
	@cd ${ARMBAND_BASE}/upstream/fuel-nailgun-agent && \
		git checkout -q ${FUEL_NAILGUN_AGENT_COMMIT}
	@cd ${ARMBAND_BASE}/upstream/fuel-web && \
		git checkout -q ${NAILGUN_COMMIT}
	@git submodule -q foreach 'mkdir -p ${ARMBAND_BASE}/patches/$$name'
	@git submodule -q foreach 'git tag armband-workbench-root'
	@git submodule -q foreach 'git checkout -q -b armband-workbench'
	@git submodule -q foreach \
		'if [ ! -z "$$(ls ${ARMBAND_BASE}/patches/$$name/)" ]; then \
			echo "-- patching $$name"; \
			git am --committer-date-is-author-date \
				${ARMBAND_BASE}/patches/$$name/*.patch; \
		fi'
clean-docker:
	@if [ -d ${ARMBAND_BASE}/upstream/fuel/build ]; then \
		sudo $(MAKE) -C ${ARMBAND_BASE}/upstream/fuel/build deepclean; \
	fi
	@for container in $(shell sudo docker ps -a -q); do \
		sudo docker rm -f -v $${container}; \
	done
	@for image in $(shell sudo docker images -q); do \
		sudo docker rmi -f $${image}; \
	done

clean-build:
	sudo rm -rf /tmp/fuel-main
	git -C ${ARMBAND_BASE}/upstream/fuel reset --hard HEAD
	git -C ${ARMBAND_BASE}/upstream/fuel clean -xdff

release: export LC_ALL=en_US.UTF-8
release: submodules-clean clean-docker clean-build submodules-init patches-import build

build:
	$(MAKE) -e --no-print-directory -C ${ARMBAND_BASE}/upstream/fuel/build all
