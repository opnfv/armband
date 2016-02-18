Armband Fuel test
=================

This is a test repository to hold build scripts for Fuel 8 based OPNFV
installer for aarch64 machines. Construction of this repository will change.

Workflow
--------
The standard workflow should look as follows:

1. Clone the repository. All the sub-projects are registered as submodules,
2. Apply patches from `patches/*` to respective submodules via `make patches-import`,
3. Modify sub-projects for whatever you need,
4. Re-create patches via `make patches-export`

Sub-projects
------------
If you need to add another subproject, you can do it with `git submodule`. Make sure that you specify branch (with `-b`), short name (with `--name`) and point it to `upstream/*` directory, i.e.:
```
git submodule -b stable/8.0 add --name fuel-web git@github.com:openstack/fuel-web.git upstream/fuel-web
```
