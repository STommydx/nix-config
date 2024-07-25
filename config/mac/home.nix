{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared/home.nix
  ];
  programs.git.ignores = [
    ".DS_Store"
  ];
  programs.zsh.initExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
  programs.vscode = {
    enable = true;
  };
  xdg.configFile."vscode-neovim/init.lua".text = ''
    vim.keymap.set("v", "<C-c>", "\"+y", {noremap=true})
    vim.keymap.set("v", "<C-x>", "\"+d", {noremap=true})
  '';
}
