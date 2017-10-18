.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) 2017 Enea AB and others

Armband Fuel@OPNFV
==================

This repository holds build scripts for MCP Fuel OPNFV installer
for AArch64 machines.

Development Workflow
====================

The standard workflow should look as follows:

#. Clone the repository.

#. All the sub-projects are registered as submodules. To initialize them, call:

       .. code-block:: bash

           $ make submodules-init

#. Apply patches from ``patches/<sub-project>/*`` to respective submodules via:

       .. code-block:: bash

           $ make patches-import

   This will result in creation of:

   - a tag called ``${A_OPNFV_TAG}-root`` at submodule remote branch HEAD;
   - a new branch ``opnfv-armband`` which will hold all the armband work.

   Then each patch is applied on this new branch with ``git-am``.

   The new HEAD is tagged with ``${A_OPNFV_TAG}``.

#. Modify sub-projects for whatever you need.

   Commit your changes when you want them taken into account in the build.

   *NOTE*: If you want to re-export patches, make sure to move the tag
   ``${A_OPNFV_TAG}`` to the latest commit that should be included.

#. Re-create patches and add default copyright header via:

       .. code-block:: bash

           $ make patches-export patches-copyright

   Each commit on ``opnfv-armband`` branch of each subproject will be
   exported to ``patches/subproject/`` via ``git format-patch``.

#. Clean workbench branches and tags with:

       .. code-block:: bash

           $ make submodules-clean

Sub-projects
============

If you need to add another subproject, you can do it with ``git submodule``.
Make sure that you specify branch (with ``-b``), short name (with ``--name``)
and point it to ``upstream/*`` directory, i.e.:

   .. code-block:: bash

       $ git submodule -b stable/mitaka add --name fuel-web \
         https://github.com/openstack/fuel-web.git upstream/fuel-web
