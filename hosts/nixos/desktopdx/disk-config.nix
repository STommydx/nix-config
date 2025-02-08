{ ... }:

{
  # disko is not used as it cannot manage external windows partitions

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd:1"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/916E-9B95";
    fsType = "vfat";
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [
      "subvol=@data"
      "compress=zstd:1"
    ];
  };

  fileSystems."/data/datastore" = {
    device = "/dev/disk/by-uuid/caf1d0f4-5ce4-48b8-a0c3-801b21d9e5ba";
    fsType = "btrfs";
    options = [
      "subvol=@datastore"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd:1"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bb6013b6-26ce-46f9-a05b-9c9ec8b11cdd";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd:1"
      "noatime"
    ];
  };

  fileSystems."/media/windisk" = {
    device = "/dev/disk/by-uuid/96C2577AC2575D95";
    fsType = "lowntfs-3g";
    # options recommendend in https://github.com/ValveSoftware/Proton/wiki/Using-a-NTFS-disk-with-Linux-and-Windows
    options = [ "uid=1000,gid=1000,rw,user,exec,umask=000" ];
  };

  # zram is used instead of swap devices
  swapDevices = [ ];

}
