# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/916E-9B95";
    fsType = "vfat";
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [ "subvol=@data" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/media/windisk" = {
    device = "/dev/disk/by-uuid/96C2577AC2575D95";
    fsType = "lowntfs-3g";
    # options recommendend in https://github.com/ValveSoftware/Proton/wiki/Using-a-NTFS-disk-with-Linux-and-Windows
    options = [ "uid=1000,gid=1000,rw,user,exec,umask=000" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
