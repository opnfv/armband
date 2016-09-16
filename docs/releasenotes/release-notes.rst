.. This document is protected/licensed under the following conditions
.. (c) Jonas Bjurel (Ericsson AB)
.. Licensed under a Creative Commons Attribution 4.0 International License.
.. You should have received a copy of the license along with this work.
.. If not, see <http://creativecommons.org/licenses/by/4.0/>.

========
Abstract
========

This document compiles the release notes for the Colorado 1.0 release of
OPNFV when using Fuel as a deployment tool, with an AArch64 (only) target
node pool.

===============
Important notes
===============

These notes provides release information for the use of Fuel as deployment
tool for the AArch64 Colorado 1.0 release of OPNFV.

The goal of the AArch64 Colorado release and this Fuel-based deployment process
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

For AArch64 Colorado, the typical use of Fuel as an OpenStack installer is
supplemented with OPNFV unique components such as:

- `OpenDaylight <http://www.opendaylight.org/software>`_ version "Beryllium SR3" [1]_ - 'http://www.opendaylight.org/software'

- `Open vSwitch for NFV <https://wiki.opnfv.org/ovsnfv>`_ 'https://wiki.opnfv.org/ovsnfv'

- `BGPVPN <http://docs.openstack.org/developer/networking-bgpvpn>`_ 'http://docs.openstack.org/developer/networking-bgpvpn/'

The following OPNFV plugins are not yet ported for AArch64:

- `ONOS <http://onosproject.org/>`_ version "Drake" - 'http://onosproject.org/'

- `Service function chaining <https://wiki.opnfv.org/service_function_chaining>`_ 'https://wiki.opnfv.org/service_function_chaining'

- `SDN distributed routing and VPN <https://wiki.opnfv.org/sdnvpn>`_ 'https://wiki.opnfv.org/sdnvpn'

- `NFV Hypervisors-KVM <https://wiki.opnfv.org/nfv-kvm>`_ 'https://wiki.opnfv.org/nfv-kvm'

- `VSPERF <https://wiki.opnfv.org/characterize_vswitch_performance_for_telco_nfv_use_cases>`_ 'https://wiki.opnfv.org/characterize_vswitch_performance_for_telco_nfv_use_cases'

As well as OPNFV-unique configurations of the Hardware- and Software stack.

This Colorado artifact provides Fuel as the deployment stage tool in the
OPNFV CI pipeline including:

- Documentation built by Jenkins

  - overall OPNFV documentation

  - this document (release notes)

  - installation instructions

  - build-instructions

- The Colorado Fuel installer image AArch64 (.iso) built by Jenkins

- Automated deployment of Colorado with running on bare metal or a nested hypervisor environment (KVM)

- Automated validation of the Colorado deployment

============
Release Data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | armband                              |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Repo/tag**                         | colorado.1.0                         |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release designation**              | Colorado 1.0 main release            |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | September 22 2016                    |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Purpose of the delivery**          | Colorado alignment to Released       |
|                                      | Fuel 9.0 baseline + Bug-fixes for    |
|                                      | the following feaures/scenarios:     |
|                                      | - Open vSwitch for NFV               |
|                                      | - OpenDaylight                       |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Version change
==============

Module version changes
----------------------
This is a main release. It is based on
following upstream versions:

- Fuel 9.0 Base release

- OpenStack Mitaka release

- OpenDaylight Beryllium SR3 release [1]_


Document changes
----------------
This is a main release.
It comes with the following documentation:

- Installation instructions - *Reference 13* - **Changed**

- Build instructions - *Reference 14* - **Changed**

- Release notes - *Reference 15* - **Changed** (This document)

Reason for version
==================

Feature additions
-----------------

**JIRA TICKETS:**

-

Bug corrections
---------------

**JIRA TICKETS:**

`Workarounds <https://jira.opnfv.org/issues/?filter=11175>`_ 'https://jira.opnfv.org/issues/?filter=11175'

(Also See respective Integrated feature project's bug tracking)

Deliverables
============

Software deliverables
---------------------

AArch64 Fuel-based installer iso file found in *Reference 2*

Documentation deliverables
--------------------------

- Installation instructions - *Reference 13*

- Build instructions - *Reference 14*

- Release notes - *Reference 15* (This document)

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

Known issues
============

**JIRA TICKETS:**

`Known issues <https://jira.opnfv.org/issues/?filter=11176>`_ 'https://jira.opnfv.org/issues/?filter=11176'

(Also See respective Integrated feature project's bug tracking)

Workarounds
===========

**JIRA TICKETS:**

-

(Also See respective Integrated feature project's bug tracking)

============
Test results
============
The Colorado 1.0 release with the Fuel deployment tool has undergone QA test
runs, see separate test results.

==========
References
==========
For more information on the OPNFV Colorado release, please see:

OPNFV
=====

1) `OPNFV Home Page <http://www.opnfv.org>`_ 'http://www.opnfv.org'

2) `OPNFV documentation- and software downloads <https://www.opnfv.org/software/download>`_ 'https://www.opnfv.org/software/download'

OpenStack
=========

3) `OpenStack Mitaka Release artifacts <http://www.openstack.org/software/mitaka>`_ 'http://www.openstack.org/software/mitaka'

4) `OpenStack documentation <http://docs.openstack.org>`_ 'http://docs.openstack.org'

OpenDaylight
============

5) `OpenDaylight artifacts <http://www.opendaylight.org/software/downloads>`_ 'http://www.opendaylight.org/software/downloads'

Fuel
====

6) `The Fuel OpenStack project <https://wiki.openstack.org/wiki/Fuel>`_ 'https://wiki.openstack.org/wiki/Fuel'

7) `Fuel documentation overview <https://docs.fuel-infra.org/openstack/fuel/fuel-9.0/>`_ 'https://docs.fuel-infra.org/openstack/fuel/fuel-9.0/'

8) `Fuel planning guide <https://docs.fuel-infra.org/openstack/fuel/fuel-9.0/mos-planning-guide.html>`_ 'https://docs.fuel-infra.org/openstack/fuel/fuel-9.0/mos-planning-guide.html'

9) `Fuel quick start guide <https://docs.mirantis.com/openstack/fuel/fuel-9.0/quickstart-guide.html>`_ 'https://docs.mirantis.com/openstack/fuel/fuel-9.0/quickstart-guide.html'

10) `Fuel reference architecture <https://docs.mirantis.com/openstack/fuel/fuel-9.0/reference-architecture.html>`_ 'https://docs.mirantis.com/openstack/fuel/fuel-9.0/reference-architecture.html'

11) `Fuel Plugin Developers Guide <https://wiki.openstack.org/wiki/Fuel/Plugins>`_ 'https://wiki.openstack.org/wiki/Fuel/Plugins'

12) `Fuel OpenStack Hardware Compatibility List <https://www.mirantis.com/products/openstack-drivers-and-plugins/hardware-compatibility-list>`_ 'https://www.mirantis.com/products/openstack-drivers-and-plugins/hardware-compatibility-list'

Fuel in OPNFV
=============

13) `OPNFV Installation instruction for the AArch64 Colorado release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/colorado/docs/installationprocedure/index.html>`_ 'http://artifacts.opnfv.org/armband/colorado/docs/installationprocedure/index.html'

14) `OPNFV Build instruction for the AArch64 Colorado release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/colorado/docs/buildprocedure/index.html>`_ 'http://artifacts.opnfv.org/armband/colorado/docs/buildprocedure/index.html'

15) `OPNFV Release Note for the AArch64 Colorado release of OPNFV when using Fuel as a deployment tool <http://artifacts.opnfv.org/armband/colorado/docs/releasenotes/index.html>`_ 'http://artifacts.opnfv.org/armband/colorado/docs/releasenotes/index.html'

.. [1] OpenDaylight Boron RC2 is used when Service Function Chaining is enabled in Fuel plugin.
