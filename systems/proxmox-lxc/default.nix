{ lib, ... }:

{

  # disable systemd-resolved as resolv.conf is managed by lxc host
  # services.resolved.enable = lib.mkForce false;

  # disable boot loader (for obvious reasons)
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # no mounted disks for containers
  services.btrfs.autoScrub.enable = false;

}
