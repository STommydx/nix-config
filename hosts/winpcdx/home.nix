{ config, pkg, lib, ... }:

{
  programs.zsh.shellAliases = {
    # wsl pbcopy alias by https://lloydrochester.com/post/unix/wsl-pbcopy-pbpaste/
    pbcopy = "tee <&0 | clip.exe";
    pbpaste = "powershell.exe Get-Clipboard | sed 's/\\r$//' | sed -z '$ s/\\n$//'";
  };
}
