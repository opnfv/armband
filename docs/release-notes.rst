============================================================================================
OPNFV Release Note for the AArch64 Brahmaputra 3.0 release of OPNFV when using Fuel as a deployment tool
============================================================================================

License
=======

This work is licensed under a Creative Commons Attribution 4.0 International
License. .. http://creativecommons.org/licenses/by/4.0 ..
(c) Jonas Bjurel (Ericsson AB) and others

Abstract
========

This document compiles the release notes for the Brahmaputra 3.0 release of
OPNFV when using Fuel as a deployment tool, with an AArch64 (only) target
node pool.

Important notes
===============

These notes provide release information for the use of Fuel as deployment
tool for the AArch64 Brahmaputra 3.0 release of OPNFV.

The goal of the Brahmaputra release and this Fuel-based deployment process is
to establish a lab ready platform accelerating further development
of the OPNFV infrastructure on AArch64 architecture.

Due to early docker and nodejs support on AArch64, we will still use an
x86_64 Fuel Master to build and deploy an AArch64 target pool.

Although not currently supported, mixing x86_64 and AArch64 architectures
inside the target pool will be possible later.

Carefully follow the installation-instructions provided in *Reference 13*.

Summary
=======

For AArch64 Brahmaputra, the typical use of Fuel as an OpenStack installer is
supplemented with OPNFV unique components such as:

- `OpenDaylight <http://www.opendaylight.org/software>`_ version "Berylium SR1"

The following OPNFV plugins are not yet ported for AArch64:

- `ONOS <http://onosproject.org/>`_ version "Drake"

- `Service function chaining <https://wiki.opnfv.org/service_function_chaining>`_

- `SDN distributed routing and VPN <https://wiki.opnfv.org/sdnvpn>`_

- `NFV Hypervisors-KVM <https://wiki.opnfv.org/nfv-kvm>`_

- `Open vSwitch for NFV <https://wiki.opnfv.org/ovsnfv>`_

- `VSPERF <https://wiki.opnfv.org/characterize_vswitch_performance_for_telco_nfv_use_cases>`_

As well as OPNFV-unique configurations of the Hardware- and Software stack.

This Brahmaputra artifact provides Fuel as the deployment stage tool in the
OPNFV CI pipeline including:

- Documentation built by Jenkins

  - overall OPNFV documentation

  - this document (release notes)

  - installation instructions

  - build-instructions

- The Brahmaputra Fuel installer image for AArch64 (.iso) built by Jenkins

- Automated deployment of Brahmaputra with running on bare metal or a nested hypervisor environment (KVM)

- Automated validation of the Brahmaputra deployment

Release Data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | fuel                                 |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Repo/tag**                         | brahmaputra.3.0                      |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release designation**              | Brahmaputra 3.0 follow-up release    |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | May 6 2016                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Purpose of the delivery**          | Brahmaputra alignment to Released    |
|                                      | Fuel 8.0 baseline + Bug-fixes for    |
|                                      | the following feaures/scenarios:     |
|                                      | - Added AArch64 target support       |
|                                      | - OpenDaylight SR1                   |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Version change
--------------

Module version changes
~~~~~~~~~~~~~~~~~~~~~~
This is the first AArch64 release for Brahmaputra 3.0. It is based on
following upstream versions:

- Fuel 8.0 Base release

- OpenStack Liberty release

- OPNFV Fuel Brahmaputra 3.0 release

- OpenDaylight Beryllium SR1 release


Document changes
~~~~~~~~~~~~~~~~
This is based upon a follow-up release to Brahmaputra 1.0. It
comes with the following documentation:

- Installation instructions - *Reference 13* - **Changed**

- Build instructions - *Reference 14* - **Changed**

- Release notes - *Reference 15* - **Changed** (This document)

Reason for version
------------------

Feature additions
~~~~~~~~~~~~~~~~~

**JIRA TICKETS:**

`AArch64 new features <https://jira.opnfv.org/issues/?filter=11129>`_ 'https://jira.opnfv.org/issues/?filter=11129'

(Also See respective Integrated feature project's bug tracking)

Bug corrections
~~~~~~~~~~~~~~~

**JIRA TICKETS:**

`AArch64 Workarounds <https://jira.opnfv.org/issues/?filter=11126>`_ 'https://jira.opnfv.org/issues/?filter=11126'

(Also See respective Integrated feature project's bug tracking)

Deliverables
------------

Software deliverables
~~~~~~~~~~~~~~~~~~~~~

Fuel-based installer iso file for AArch64 targets found in *Reference 2*

Documentation deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~

- Installation instructions - *Reference 13*

- Build instructions - *Reference 14*

- Release notes - *Reference 15* (This document)

Known Limitations, Issues and Workarounds
=========================================

System Limitations
------------------

- **Max number of blades:** 1 Fuel master, 3 Controllers, 20 Compute blades

- **Min number of blades:** 1 Fuel master, 1 Controller, 1 Compute blade

- **Storage:** Ceph is the only supported storage configuration

- **Max number of networks:** 65k

- **Fuel master arch:** x86_64

- **Target node arch:** aarch64


Known issues
------------

**JIRA TICKETS:**

`AArch64 Known issues <https://jira.opnfv.org/issues/?filter=11127>`_ 'https://jira.opnfv.org/issues/?filter=11127'

(Also See respective Integrated feature project's bug tracking)

Workarounds
-----------

**JIRA TICKETS:**

`AArch64 Workarounds <https://jira.opnfv.org/issues/?filter=11128>`_ 'https://jira.opnfv.org/issues/?filter=11128'

(Also See respective Integrated feature project's bug tracking)

Test results
============
The Brahmaputra 3.0 release with the Fuel deployment tool has undergone QA test
runs, see separate test results.

References
==========
For more information on the OPNFV Brahmaputra release, please see:

OPNFV
-----

1) `OPNFV Home Page <www.opnfv.org>`_

2) `OPNFV documentation- and software downloads <https://www.opnfv.org/software/download>`_

OpenStack
---------

3) `OpenStack Liberty Release artifacts <http://www.openstack.org/software/liberty>`_

4) `OpenStack documentation <http://docs.openstack.org>`_

OpenDaylight
------------

5) `OpenDaylight artifacts <http://www.opendaylight.org/software/downloads>`_

Fuel
----

6) `The Fuel OpenStack project <https://wiki.openstack.org/wiki/Fuel>`_

7) `Fuel documentation overview <https://docs.fuel-infra.org/openstack/fuel/fuel-8.0/>`_

8) `Fuel planning guide <https://docs.fuel-infra.org/openstack/fuel/fuel-8.0/mos-planning-guide.html>`_

9) `Fuel quick start guide <https://docs.mirantis.com/openstack/fuel/fuel-8.0/quickstart-guide.html>`_

10) `Fuel operations guide <https://docs.mirantis.com/openstack/fuel/fuel-8.0/operations.html>`_

11) `Fuel Plugin Developers Guide <https://wiki.openstack.org/wiki/Fuel/Plugins>`_

12) `(N/A on AArch64) Fuel OpenStack Hardware Compatibility List <https://www.mirantis.com/products/openstack-drivers-and-plugins/hardware-compatibility-list>`_

Fuel in OPNFV
-------------

13) `OPNFV Installation instruction for the AArch64 Brahmaputra release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/brahmaputra/docs/installation-instruction.html>`_

14) `OPNFV Build instruction for the AArch64 Brahmaputra release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/brahmaputra/docs/build-instruction.html>`_

15) `OPNFV Release Note for the AArch64 Brahmaputra release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/brahmaputra/docs/release-notes.html>`_
