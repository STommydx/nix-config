{ ... }:

{

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # efiInstallAsRemovable = true; # install as removable for easy recovery after windows overwriting bootloader
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };

  hardware.bluetooth.enable = true;
  hardware.cpu.amd.updateMicrocode = true;

  # services.fprintd.enable = true; # temporarily disabled due to build failure

}
