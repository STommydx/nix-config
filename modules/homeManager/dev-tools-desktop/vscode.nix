{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      golang.go
      hashicorp.terraform
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.makefile-tools
      ms-vscode-remote.remote-ssh
      redhat.vscode-yaml
      tomoki1207.pdf
    ];
    userSettings = {
      "editor.inlineSuggest.suppressSuggestions" = true; # weird option added by extension
      "editor.rulers" = [ 120 ];
      "explicitFolding.rules" = {
        "*" = {
          begin = "{{{";
          end = "}}}";
          autoFold = true;
        };
      };
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1; # recommended settings from extension author
      };
      "git.confirmSync" = false;
      "remote.autoForwardPorts" = false;
      "terminal.integrated.fontFamily" = "MesloLGM Nerd Font, DroidSansMono Nerd Font, monospace";
      "vscode-neovim.neovimInitVimPaths.linux" = "${config.home.homeDirectory}/${
        config.xdg.configFile."vscode-neovim/init.lua".target
      }";
      "vscode-neovim.mouseSelectionStartVisualMode" = true;
      "workbench.colorTheme" = "Tokyo Night";
      "yaml.customTags" = [
        # default settings added by extension
        "!And"
        "!And sequence"
        "!If"
        "!If sequence"
        "!Not"
        "!Not sequence"
        "!Equals"
        "!Equals sequence"
        "!Or"
        "!Or sequence"
        "!FindInMap"
        "!FindInMap sequence"
        "!Base64"
        "!Join"
        "!Join sequence"
        "!Cidr"
        "!Ref"
        "!Sub"
        "!Sub sequence"
        "!GetAtt"
        "!GetAZs"
        "!ImportValue"
        "!ImportValue sequence"
        "!Select"
        "!Select sequence"
        "!Split"
        "!Split sequence"
      ];
    };
  };

  # use neovim with minimal plugins for vscode
  xdg.configFile."vscode-neovim/init.lua".text = ''
    require("Comment").setup{}
    vim.keymap.set("v", "<C-c>", "\"+y", {noremap=true})
    vim.keymap.set("v", "<C-x>", "\"+d", {noremap=true})
  '';
}
