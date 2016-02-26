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
