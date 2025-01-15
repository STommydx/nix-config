{ config, ... }:

{

  imports = [
    ./vscode.nix
  ];


  # Set PATH for JetBrains tools
  home.sessionPath = [
    "${config.xdg.dataHome}/JetBrains/Toolbox/scripts"
  ];

  # Zed binary name is `zeditor` in NixOS
  # Set alias for consistency
  home.shellAliases = {
    zed = "zeditor";
  };

}
