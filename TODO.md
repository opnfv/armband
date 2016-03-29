List of missing features and things to do
=========================================

Nice to have, should be fixed before rel
=========================================
* [fuel?] Disabling rx-vlan-filter from Fuel WebUI is not applied during netcheck
* [thunderx] rtc-efi disable

Cleanup tasks
=========================================
* [armband-rpm-repo] Armband CentOS repository as additional repo (x86_64)
* [arm64-master] Find `puppetlabs-products` repo for arm64.
* [arm64-master] Fix license in ubuntu_1404_arm64.pp
* [arm64-master] Look into default ubuntu_debootstrap change in cobbler.pp
* [arm64-master] [fuel-agent] Package and repo update for arm64 in [2] (?)
* [fuel] Add QEMU_VERSION for fuel-plugin-qemu
* [ohai] ThunderX network card speed reported as N/A
* [arm64-master] change docker repo in `upstream/fuel/build/config.mk`,
  perhaps by figuring out current architecture with `uname -m`
* [arm64-master] Fuel Master YUM repos still point to mirror.fuel-infra.org,
  due to bootstrap_admin_node.sh hardcodes from OPNFV

Needed for all arch support (todo, later)
=========================================
* [arm64-master] Extend arch list for auxiliary repo on fuel master
  (e.g. "amd64 arm64", or "arm64" if people want to support arm64 only).
  Use UBUNTU_ARCH in constructs like "for arch in arm64 amd64; do"
* [arm64-master] [fuel-agent] Custom package selection for arm64 in [1] or from above
* [arm64-master] Stop hardcoding grub-efi-arm64/grub-pc 
* [fuel-main] deb/rpm building for arm64 support
* [fuel-main] mirror arm64 support
* [fuel] Figure a way for not hardcoding the bootstrap image architecture,
  preferably selectable using fuel-menu

Needed for aarch64 Fuel Master support
=========================================
* [arm64-master] Add arm64 support for CentOS based actions.

[1] https://github.com/openstack/fuel-agent/blob/master/fuel_agent/drivers/nailgun.py#L687-L693
[2] https://github.com/openstack/fuel-agent/blob/master/contrib/fuel_bootstrap/fuel_bootstrap_cli/fuel_bootstrap/settings.yaml.sample#L19
