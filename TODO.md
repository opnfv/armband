List of missing features and things to do
=========================================

* Extend arch list for auxiliary repo on fuel master (e.g. "amd64 arm64", or "arm64" if people want to support arm64 only).
* Add Armband CentOS repository either as URL override.
* [arm64-master] Add arm64 support for CentOS based actions.
* [arm64-master] change docker repo in `upstream/fuel/build/config.mk`, perhaps by figuring out current architecture with `uname -m`
* [arm64-master] Find `puppetlabs-products` repo for arm64.
* [arm64-master] Fix license in ubuntu_1404_arm64.pp
* [arm64-master] Remove/replace mini.iso with own kernel/initrd
* [arm64-master] Look into default ubuntu_debootstrap change in cobbler.pp
* [arm64-master] Add Cobbler aarch64 loader
* [arm64-master] [fuel-agent] Custom package selection for arm64 in [1] or from above
* [arm64-master] [fuel-agent] --kernel-flavor override in fuel_bootstrap based on arch [2]
* [arm64-master] [fuel-agent] Package and repo update for arm64 in [3] (?)
* [arm64-master] [fuel-agent] (?) Update image build tests for arm64 in [4] (+efi?)
* [arm64-master] Factor out 10.0.2.6 local mirrors and switch to HTTPS for MOS mirror
* [armband-deb-repo] Re-compile mixed-binaries (all+arch) debs for amd64 (e.g. ceph)
* [ohai] ThunderX network card speed reported as N/A
* [fuel?] Disabling rx-vlan-filter from Fuel WebUI is not applied during netcheck
* [fuel?] Gray out vCenter & co for archs other than x86
* [fuel] Figure a way for not hardcoding the bootstrap image architecture
* [fuel] Add QEMU_VERSION for fuel-plugin-qemu

[1] https://github.com/openstack/fuel-agent/blob/master/fuel_agent/drivers/nailgun.py#L687-L693
[2] https://github.com/openstack/fuel-agent/blob/master/contrib/fuel_bootstrap/fuel_bootstrap_cli/fuel_bootstrap/commands/build.py#L107 
[3] https://github.com/openstack/fuel-agent/blob/master/contrib/fuel_bootstrap/fuel_bootstrap_cli/fuel_bootstrap/settings.yaml.sample#L19
[4] https://github.com/openstack/fuel-agent/blob/master/fuel_agent/tests/test_nailgun_build_image.py#L26
