Armband Fuel@OPNFV
==================

This repository holds build scripts for Fuel 10.0 OPNFV installer
for AArch64 machines.

Workflow
--------
The standard workflow should look as follows:

1. Clone the repository.

2. All the sub-projects are registered as submodules. To initialize them, call:
   $ make submodules-init

3. Apply patches from `patches/<sub-project>/*` to respective submodules via:
   $ make patches-import

   This will result in creation of:
   - a tag called `${A_OPNFV_TAG}-root` at submodule remote branch HEAD;
   - a new branch `opnfv-armband` which will hold all the armband work.
   Then each patch is applied on this new branch with `git-am`.
   The new HEAD is tagged with `${A_OPNFV_TAG}`.

4. Modify sub-projects for whatever you need.
   Commit your changes when you want them taken into account in the build.

   NOTE: If you want to re-export patches, make sure to move the tag
   `${A_OPNFV_TAG}` to the latest commit that should be included.

5. Build with:
   $ make build

6. Re-create patches via:
   $ make patches-export

   Each commit on `opnfv-armband` branch of each subproject will be
   exported to `patches/subproject/` via `git format-patch`.

7. Clean workbench branches and tags with:
   $ make submodules-clean

Sub-projects
------------
If you need to add another subproject, you can do it with `git submodule`.
Make sure that you specify branch (with `-b`), short name (with `--name`)
and point it to `upstream/*` directory, i.e.:

   $ git submodule -b stable/mitaka add --name fuel-web \
     https://github.com/openstack/fuel-web.git upstream/fuel-web

Fuel@OPNFV submodule patch development
--------------------------------------
Fuel-submodules (fuel-astute, ... , fuel-ui) patches also reside in Armband,
like previously described patches that are applied to Armband submodules,
but they are not directly applied to any submodule in Armband.
Instead, they are copied (staged) to Fuel@OPNFV submodule, which will
automatically pick them up and apply them to its own submodules
(fuel-astute, ... , fuel-ui) during ISO build.

The following helpers are available for working with patches for
Fuel-submodules (fuel-astute, ... , fuel-ui):

1. Clean Fuel-submodules (fuel-astute, ... , fuel-ui) patches
   $ make fuel-patches-clean

2. Import Fuel-submodules staged patches
   $ make fuel-patches-import

3. Export Fuel-submodules patches
   $ make fuel-patches-export
