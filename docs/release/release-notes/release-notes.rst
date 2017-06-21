.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) Open Platform for NFV Project, Inc. and its contributors

========
Abstract
========

This document compiles the release notes for the Danube release of
OPNFV when using Fuel as a deployment tool with an AArch64 (only) target
node pool.

===============
Important Notes
===============

These notes provides release information for the use of Fuel as deployment
tool for the AArch64 Danube release of OPNFV.

The goal of the AArch64 Danube release and this Fuel-based deployment process
is to establish a lab ready platform accelerating further development
of the OPNFV on AArch64 infrastructure.

Due to early docker and nodejs support on AArch64, we will still use an
x86_64 Fuel Master to build and deploy an AArch64 target pool.

Although not currently supported, mixing x86_64 and AArch64 architectures
inside the target pool will be possible later.

Carefully follow the installation-instructions provided in *Reference 13*.

=======
Summary
=======

For AArch64 Danube, the typical use of Fuel as an OpenStack installer is
supplemented with OPNFV unique components such as:

- `OpenDaylight <http://www.opendaylight.org/software>`_
- `Open vSwitch for NFV <https://wiki.opnfv.org/ovsnfv>`_
- `Tacker <https://wiki.openstack.org/wiki/Tacker>`_
- `Service Function Chaining <https://wiki.opnfv.org/service_function_chaining>`_

The following OPNFV plugins are not yet ported for AArch64:

- `BGPVPN <http://docs.openstack.org/developer/networking-bgpvpn>`_
- `SDN distributed routing and VPN <https://wiki.opnfv.org/sdnvpn>`_
- `NFV Hypervisors-KVM <https://wiki.opnfv.org/nfv-kvm>`_
- `VSPERF <https://wiki.opnfv.org/characterize_vswitch_performance_for_telco_nfv_use_cases>`_
- `Promise <https://wiki.opnfv.org/display/promise>`_
- `Parser <https://wiki.opnfv.org/display/parser>`_
- `Doctor <https://wiki.opnfv.org/display/doctor>`_

As well as OPNFV-unique configurations of the Hardware and Software stack.

This Danube artifact provides Fuel as the deployment stage tool in the
OPNFV CI pipeline including:

- Documentation built by Jenkins

  - overall OPNFV documentation

  - this document (release notes)

  - installation instructions

  - build-instructions

- The Danube Fuel installer image AArch64 (.iso) built by Jenkins

- Automated deployment of Danube with running on bare metal or a nested hypervisor environment (KVM)

- Automated validation of the Danube deployment

============
Release Data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | armband                              |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Repo/tag**                         | danube.3.0                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release designation**              | Danube 3.0                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | June 23 2017                         |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Purpose of the delivery**          | Danube alignment to Released         |
|                                      | Fuel 10.0 baseline + features and    |
|                                      | bug-fixes for the following          |
|                                      | feaures:                             |
|                                      | - Open vSwitch for NFV               |
|                                      | - OpenDaylight                       |
|                                      | - Tacker                             |
+--------------------------------------+--------------------------------------+

Version Change
==============

Module Version Changes
----------------------
This is the Danube 3.0 release.
It is based on following upstream versions:

- Fuel 10.0 Base Release

- OpenStack Newton Release

- OpenDaylight

Document Changes
----------------
This is the Danube 3.0 release.
It comes with the following documentation:

- Installation instructions

- Build instructions

- Release notes (This document)

Reason for Version
==================

Feature Additions
-----------------

**JIRA TICKETS:**


Bug Corrections
---------------

**JIRA TICKETS:**

`Danube 3.0 bug fixes  <https://jira.opnfv.org/issues/?filter=11802>`_

(Also See respective Integrated feature project's bug tracking)

Deliverables
============

Software Deliverables
---------------------

AArch64 Fuel-based installer iso file found in `OPNFV Downloads <https://www.opnfv.org/software/download>`.

Documentation Deliverables
--------------------------

- Installation instructions

- Build instructions

- Release notes(This document)

=========================================
Known Limitations, Issues and Workarounds
=========================================

System Limitations
==================

- **Max number of blades:** 1 Fuel master, 3 Controllers, 20 Compute blades

- **Min number of blades:** 1 Fuel master, 1 Controller, 1 Compute blade

- **Storage:** Ceph is the only supported storage configuration

- **Max number of networks:** 65k

- **Fuel master arch:** x86_64

- **Target node arch:** aarch64

Known Issues
============

**JIRA TICKETS:**

`Known issues <https://jira.opnfv.org/issues/?filter=11803>`_

(Also See respective Integrated feature project's bug tracking)

Workarounds
===========

**JIRA TICKETS:**

-

(Also See respective Integrated feature project's bug tracking)

============
Test Results
============
The Danube 3.0 release with the Fuel deployment tool has undergone QA test
runs, see separate test results.

==========
References
==========
For more information on the OPNFV Danube 3.0 release, please see:

OPNFV
=====

1) `OPNFV Home Page <http://www.opnfv.org>`_
2) `OPNFV Documentation - and Software Downloads <https://www.opnfv.org/software/download>`_

OpenStack
=========

3) `OpenStack Newton Release Artifacts <http://www.openstack.org/software/newton>`_

4) `OpenStack Documentation <http://docs.openstack.org>`_

OpenDaylight
============

5) `OpenDaylight Artifacts <http://www.opendaylight.org/software/downloads>`_

Fuel
====

6) `The Fuel OpenStack Project <https://wiki.openstack.org/wiki/Fuel>`_
7) `Fuel Documentation <http://docs.openstack.org/developer/fuel-docs>`_

Fuel in OPNFV
=============

13) `OPNFV Installation instruction for the AArch64 Danube release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/docs/release_installation/index.html>`_

14) `OPNFV Build instruction for the AArch64 Danube release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/docs/development_overview_build/index.html>`_

15) `OPNFV Release Note for the AArch64 Danube release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/docs/release_release-notes/index.html>`_
