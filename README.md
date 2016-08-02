Armband Fuel@OPNFV
==================

This repository holds build scripts for Fuel 9.0 OPNFV installer
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
   - a tag called `armband-workbench-root` at the same commit as Fuel@OPNFV
   hard sets in `build/config.mk` (inside fuel submodule);
   - a new branch `armband-workbench` which will hold all the armband work.
   Then each patch is applied on this new branch with `git-am`.

4. Modify sub-projects for whatever you need.
   Commit your changes when you want them taken into account in the build.

5. Build with:
   $ make build

6. Re-create patches via:
   $ make patches-export

   Each commit on `armband-workbench` branch of each subproject will be
   exported to `patches/subproject/` via `git format-patch`.

   NOTE: DO NOT commit changed submodules. Remember to commit only patches!

   Commiting changed submodules (`git diff` will list something like:
   `Subproject commit: {hash}`) will break the repo, as the new commit hash
   is non-existant in the upstream repo, hence anybody cloning the repository
   later will fail on `make submodules-init`.

7. Clean workbench branches and tags with:
   $ make submodules-clean

Sub-projects
------------
If you need to add another subproject, you can do it with `git submodule`.
Make sure that you specify branch (with `-b`), short name (with `--name`)
and point it to `upstream/*` directory, i.e.:

   $ git submodule -b stable/mitaka add --name fuel-web \
     https://github.com/openstack/fuel-web.git upstream/fuel-web
