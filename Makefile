all: submodules-init submodules-import build

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
		$(shell pwd)/patches/$$name.patch'

# apply patches from patches/* to respective submodules
patches-import: submodules-init
	@git submodule -q foreach 'patch -p1 -s -N < \
		$(shell pwd)/patches/$$name.patch || true'

build:
	@echo "this should build ISO"
