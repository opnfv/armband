DEA: Deployment Environment Adapter
-----------------------------------

This file has several sections, some of the sections are self describing:

```
title: Deployment Environment Adapter (DEA)
version:
comment: Config for LF POD1 - HA deployment with Ceph and Opendaylight
wanted_release: Kilo on Ubuntu 14.04
```

## The Environment section

environment:
  name: opnfv
  mode: ha                     # noha, no-ha?
  net_segment_type: tun        # ?


## The "Fuel" section

```
fuel:
  ADMIN_NETWORK:                 # Static Fuel admin network configuration
    cidr: 10.20.0.0/24           # this is the "fuelweb_admin" in the nodes
    dhcp_gateway: 10.20.0.2      # nodes us this as default gateway
    dhcp_pool_end: 10.20.0.254   # nodes get addresses from here
    dhcp_pool_start: 10.20.0.3   # This is the Fuel server IP address
    ipaddress: 10.20.0.2
    netmask: 255.255.0.0         # netmask for nodes (otherwise why is it
                                 # needed if CIDR above?
  DNS_DOMAIN: domain.tld         #
  DNS_SEARCH: domain.tld         #
  DNS_UPSTREAM: 8.8.8.8          # Fuel->Network Settings->Other->DNS Servers
  FUEL_ACCESS:
    password: admin
    user: admin
  HOSTNAME: opnfv
  NTP1: 0.pool.ntp.org           # Fuel->Newtok Setting->Other->NTP server list
  NTP2: 1.pool.ntp.org
  NTP3: 2.pool.ntp.org
```

It would make more sense if NTP was a list:

```
  NTP:
     - 0.pool.ntp.org
     - 1.pool.ntp.org
     - 2.pool.ntp.org
```

Now I don't know if NTP4 would be a valid key...

## The "node" section

Then there is the important "node" section:

```
node:
   - id: 1
     interfaces: <some section describing interfaces>
     transformations: <section describing what to do with the interfaces>
     role: [controller|compute|cinder|...]
   - id: 2
      interfaces: interfaces_1
      transformations: transformations_1
      role: ceph-osd,controller
   ...
   - id: n
     ...
```

Now, the "interfaces" section could be something line:

```
node:
   - id: 1
     interfaces: interfaces_1
     transformations: transformations_1
```

## Interfaces

In this case we would have a "section" called intefaces_apm, that looks like:

```
interfaces_1:
  eth0:
  - none # I made this up, I don't know if "none" is valid
  eth1:
  - fuelweb_admin
  eth2:
  - public
  - storage     # vlan 2010
  - management  # vlan 2011
  - private     # vlan 2012
```

This is self describing in a way. eth1 is used as the interface for the
"fuel admin" network, while eth2 will be used for what Fuel calls "public",
"storage", "management" and "private" networks. These match the networks in
the "networks" tab in the Fuel dashboard.

## Transformations

For now we won't come into huge detail about the transformations, but they
seem to contain a list of "commands" issued to ovs-vsctl (Open vSwitch).
For example:

```
transformations_1:
  transformations:
  - ...
  - action: add-port
    bridge: br-mgmt
    name: eth1.300
  - ...
```

Basically the deploy script will issue the command:

```
  ovs-vsctl add-port br-mgmt eth1.300
```
(or ...eth1 tag=300)

## The "network" section:

The networks listed in each of the devices of the "interfaces_1" section
are defined in the "network" section. Inside the "network" section, there is
another section called "networks", with a list of networks defined:

```
network:
   ...
   networks:
  - cidr: 192.168.0.0/24
    gateway: null
    ip_ranges:
    - - 192.168.0.1
      - 192.168.0.254
    meta:
      cidr: 192.168.0.0/24        # TBD: Can it be different from previos CIDR?
                                  # Is this the default value in the UI?
      configurable: true          # TBD, UI?
      map_priority: 2             # TBD, UI?
      name: management
      notation: cidr              # TBD, UI?
      render_addr_mask: internal  # TBD, UI?
      render_type: cidr           # TBD, UI stuff?
      use_gateway: false          # Only for public net, or for
      vips:                       # TBD
      - haproxy
      - vrouter
      vlan_start: 101
    name: management
    vlan_start: 300               # must match transformations
  - cidr: ...
    ...
```

Let's take the "management" network as an example. Here we define the
netmask and several parameters that will look familiar when looking at the
"Networks" Fuel dashboard tab. The available keys:
- name: the name of the 
- cdir: the CDIR for this network
- gateway: an IP address (only for public network?)
- ip_ranges: a list with the IP ranges available to this network.
- vlan_start: When using vlan tagging, the first vlan tag
- meta: (explained below)

The purpose of the "meta" key is less obvious here, and some of the data
appears to be redundant. My guess is that it is part of Fuel's user
interface. The CIDR here would be the default and "notation" is probably the
way it is displayed in the form field:

- cidr: again the same CDIR as above [is this redundant? error prone?]
- configurable: boolean [?]
- map_priority: int [?]
- name: again the same name as above?
- notation: cidr [any other available keys?]
- use_gateway: boolean [apparently only "true "if an IP was given above]
- vips: This seems to be a list of "namespaces" defined later in the
-       "network section".
- vlan_start same as above...

Now if we look back, in the "interfaces_1" section we had this:

```
interfaces_1:
   eth2:
      - management
```

This is clearly the network defined above. The same goes for "public",
"storage" and "private".

## The "network" section continued

Apart from the definition of each of the networks and required by Fuel,
the "network" section also has a "preamble" with the following parameters
and corresponding setting in Fuel:

```
network:
  management_vip: 192.168.0.2         # TBD (see vips)
  management_vrouter_vip: 192.168.0.1 # TBD
  public_vip: 172.30.9.64             # TBD
  public_vrouter_vip: 172.30.9.65     # TBD
  networking_parameters:              # Fuel->Networ->Settings
    base_mac: fa:16:3e:00:00:00       # Neutron L2
    configuration_template: null
    dns_nameservers:                  # Neutron L3, guess OS DNS Servers
    - 8.8.4.4
    - 8.8.8.8
    floating_ranges:                  # Neutron L3, floating Network Param
    - - 172.30.9.160                  #  floating IP range start
      - 172.30.9.254                  #  floating IP range end
    gre_id_range:                     # Neutron L2, what if VXLAN?
    - 2                               # Neutron L2, tunnel ID range start
    - 65535                           # Neutron L2, tunnel ID range end
                                      # Neutron L3, Internal Network
                                      # Parameters
    internal_cidr: 192.168.111.0/24   #  internal network CDIR
    internal_gateway: 192.168.111.1   #  internal network gateway
    net_l23_provider: ovs             # TBD: must match transformations?
    segmentation_type: tun            # TBD: what options are there? tun/vlan?
    vlan_range:                       # TBD
    - 1000
    - 1030
  vips:
    ...
```

## The "vips" in the "network" section

In addition to all the above, the network section contains a "vips" section.
I don't know what they mean, but there are some relations between these
vips, and the networks defined above:

```
network:
   vips:
      management:
         ipaddr: 192.168.0.2     # TBD: same as management_vip?
         namespace: haproxy      # TBD: network namespace?
         network_role: mgmt/vip  # TBD
         node_roles:
         - controller            # Why do we define it here?
         - primary-controller    # for an HA environment?
      public:
         ...
      vrouter:
         ...
      vrouter_pub:
         ...
```

Also, in contrast to the "networks" section, the "vips" section is not a list,
but a series of records...

Some Fuel plugins seem to look at this particular setup, one of the examples
in [2], absolute-dashboard-link.pp, reads:

```
$os_public_vip = $network_metadata['vips']['public']['ipaddr']
```

If you remember from above, each network has a "metadata" section, this
matches the name of the variable $network_metadata. In that section there is
a "vips" section, that contains a list of "vips", and one of the vips is
"public", and one of the fields is "ipaddr".

* [1] https://docs.mirantis.com/openstack/fuel/fuel-8.0/file-ref.html#fuel-file-reference-pages
* [2] https://wiki.openstack.org/wiki/Fuel/Plugins


## The "Settings" section

This looks like user interface stuff and default settings. For instance:
settings:

```
  editable:
    ...
    additional_components:
      ceilometer:
        description: If selected, Ceilometer component will be installed
        label: Install Ceilometer
        type: checkbox
        value: false
        weight: 40
```

This is clearly the label "Install Ceilometer" in the Fuel web dashboard.

This looks like an email label entry with the corresponding regex to
validate it:

```
settings:
  editable:
    access:
      email:
        description: Email address for Administrator
        label: Email
        regex:
          error: Invalid email
          source: ^\S+@\S+$
        type: text
        value: admin@localhost
        weight: 40
  ...
```

## Other

I think most of it, specially the "settings" part, has been machine created.
It would be nice to recreate one of this files from a manual Fuel
deployment.
