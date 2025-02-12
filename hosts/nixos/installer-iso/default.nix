{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-images.nixosModules.image-installer
  ];

  # additional packages for debugging and fixing installation
  environment.systemPackages = with pkgs; [
    age
    dig
    file
    jq
    rclone
    sops
    wget
  ];

  # disable unneeded Tor service
  hidden-ssh-announce.enable = lib.mkForce false;

  # additional packages for debugging and fixing installation
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  programs.tmux.enable = true;

  # enable qemu guest agent
  services.qemuGuest.enable = true;

  # enable tailscale for P2P access
  services.tailscale.enable = true;

  # add SSH keys for easy access
  users.users.root.openssh.authorizedKeys.keyFiles = [
    inputs.authorized-keys
  ];

  # nixos-images uses `config.system.nixos.version` for state version which
  # will include commit hash in latest version (e.g. 25.05.20250210.64e75cd)
  # as stateVersion only accept format "YY.MM", this is used to override the
  # setting before it is fixed upstream
  system.stateVersion = lib.mkForce "25.05";

}
