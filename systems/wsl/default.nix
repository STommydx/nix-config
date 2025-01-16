{ inputs, lib, ... }:

{

  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  # WSL hosts have home manager managed by NixOS config
  home-manager.sharedModules = [
    {
      home.shellAliases = {
        # wsl pbcopy alias by https://lloydrochester.com/post/unix/wsl-pbcopy-pbpaste/
        pbcopy = "tee <&0 | clip.exe";
        pbpaste = "powershell.exe Get-Clipboard | sed 's/\\r$//' | sed -z '$ s/\\n$//'";
      };
    }
  ];

  wsl.enable = true;
  wsl.defaultUser = "stommydx";

  # no mounted disks for containers
  services.btrfs.autoScrub.enable = false;

  # resolv.conf is managed by WSL (wsl.wslConf.network.generateResolvConf)
  services.resolved.enable = lib.mkForce false;

}
