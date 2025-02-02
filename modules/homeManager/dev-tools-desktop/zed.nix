{ pkgs, ... }:

{

  home.packages = with pkgs; [
    nixd # make nixd available in zed editor
    nixfmt-rfc-style
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "dockerfile"
      "git-firefly"
      "graphql"
      "html"
      "log"
      "nix"
      "proto"
      "sql"
      "templ"
      "terraform"
      "tokyo-night"
      "toml"
    ];
    userKeymaps = [
      {
        context = "vim_mode == insert";
        bindings."ctrl-v" = "editor::Paste";
      }
      {
        context = "vim_mode == insert || vim_mode == visual";
        bindings = {
          "ctrl-c" = "editor::Copy";
          "ctrl-x" = "editor::Cut";
        };
      }
      {
        # dismiss completion without exiting to normal mode
        context = "Editor && mode == full && inline_completion";
        bindings = {
          "ctrl-escape" = "editor::Cancel"; # alt-escape collides with DE keybinding
        };
      }
    ];
    userSettings = {
      buffer_font_size = 14;
      features = {
        inline_completion_provider = "supermaven";
      };
      format_on_save = "on"; # explicitly enable formatting on save
      languages = {
        "C++" = {
          hard_tabs = true;
        };
        "Nix" = {
          language_servers = [
            "nixd"
            "!nil"
          ]; # use nixd only
        };
      };
      lsp = {
        nil.initialization_options = {
          formatting.command = [ "nixfmt" ];
        };
        nixd.initialization_options = {
          formatting.command = [ "nixfmt" ];
          # setting up expressions for completion
          # this is not working unfortunately
          nixpkgs.expr = "import (builtins.getFlake \"${../../..}\").inputs.nixpkgs { }";
          options = {
            nixos.expr = "(builtins.getFlake \"${../../..}\").nixosConfigurations.desktopdx.options";
            home-manager.expr = "(builtins.getFlake \"${../../..}\").nixosConfigurations.desktopdx.options.home-manager.users.type.getSubOptions [ ]";
          };
        };
      };
      theme = {
        mode = "dark";
        dark = "Tokyo Night";
        light = "Tokyo Night Light";
      };
      terminal = {
        env = {
          TERM = "xterm-256color";
        };
      };
      ui_font_size = 16;
      vim_mode = true;
      vim.use_system_clipboard = "never";
    };
  };

}
