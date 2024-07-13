{ config, pkg, lib, ... }:

{
  programs.zsh.shellAliases = {
    pbcopy = "powershell.exe -noprofile Get-Clipboard";
    pbpaste = "clip.exe";
  };
}
