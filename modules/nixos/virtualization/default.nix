{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

}
