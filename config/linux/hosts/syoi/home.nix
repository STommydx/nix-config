{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home.nix
  ];
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "syoi.github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_syoi";
      };
    };
  };
  xdg.configFile."vscode-neovim/init.lua".text = ''
    vim.keymap.set("v", "<C-c>", "\"+y", {noremap=true})
    vim.keymap.set("v", "<C-x>", "\"+d", {noremap=true})
  '';
}
