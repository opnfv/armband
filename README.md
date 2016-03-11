Armband Fuel test
=================

This is a test repository to hold build scripts for Fuel 8 based OPNFV
installer for aarch64 machines. Construction of this repository will change.

Workflow
--------
The standard workflow should look as follows:

1. Clone the repository.
2. All the sub-projects are registered as submodules. Call `make submodules-init` to initialize them.
2. Apply patches from `patches/sub-project/*` to respective submodules via `make patches-import`. This will result in creation of a tag `armband-workbench-root` at the `HEAD` of the submodule and creation of a new branch `armband-workbench` which will hold all the armband related work. Then each patch is applied on this new branch with `git-am`.
3. Modify sub-projects for whatever you need. Commit your changes when you want them taken into account in the build.
4. Build with `make build`
5. Re-create patches via `make patches-export`. Each commit on `armband-workbench` branch of each subproject will be exported to the `patches/subproject/` via `git format-patch`. Remember to commit only patches! Commiting changed submodules (`git diff` will list something like: `Subproject commit: {hash}`) will result in breaking them as the new commit hash is non-existant in the upstream repo. Hence anybody cloning the repository will fail on `make submodules-init`. Similarily commiting changes to patches which only report a new hash (`git diff` reports something like: `From {hash} {date}`) is not needed (although won't break anything) because `git am` will discard them anyway.
6. Clean workbench branches and tags with `make submodules-clean`.


Sub-projects
------------
If you need to add another subproject, you can do it with `git submodule`. Make sure that you specify branch (with `-b`), short name (with `--name`) and point it to `upstream/*` directory, i.e.:
```
git submodule -b stable/8.0 add --name fuel-web git@github.com:openstack/fuel-web.git upstream/fuel-web
```
