{ config, pkgs, lib, ... }:

with lib.hm.gvariant;

{

  imports = [ ./home.nix ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us+colemak" ]) (mkTuple [ "xkb" "us" ]) ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      cursor-theme = "breeze_cursors";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];
      move-to-workspace-10 = [ "<Shift><Super>0" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize:appmenu";
      num-workspaces = 6;
    };
    "org/gnome/mutter" = {
      check-alive-timeout = mkUint32 30000;
      dynamic-workspaces = false;
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "arcmenu@arcmenu.com"
        "blur-my-shell@aunetx"
        "dash-to-dock@micxgx.gmail.com"
        "gsconnect@andyholmes.github.io"
        "pop-shell@system76.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Nautilus.desktop"
        "signal-desktop.desktop"
        "discord.desktop"
        "spotify.desktop"
      ];
    };
    "org/gnome/shell/extensions/arcmenu" = {
      distro-icon = 0;
      menu-layout = "Redmond";
      menu-button-appearance = "Icon_Text";
      menu-button-icon = "Distro_Icon";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      click-action = "minimize-or-previews";
      custom-theme-shrink = true;
      dash-max-icon-size = 40;
      dock-position = "BOTTOM";
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      running-indicator-dominant-color = true;
      running-indicator-style = "CILIORA";
      show-favorites = true;
      show-mounts = false;
      show-trash = false;
    };
    "org/gnome/shell/extensions/pop-shell" = {
      smart-gaps = true;
      tile-by-default = true;
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      switch-to-application-10 = [ ];
    };
    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = "[<(uint32 2, <('Hong Kong', 'VHHH', true, [(0.38979019379430269, 1.9928751117510946)], [(0.38949931722116538, 1.9928751117510946)])>)>]";
    };
    "org/gnome/terminal/legacy/profiles:/:842ec37e-9d77-4e26-86c5-41fc3bca62c5" = {
      background-transparency-percent = 20;
      default-size-columns = 120;
      default-size-rows = 36;
      use-transparent-background = true;
    };
  };

  fonts.fontconfig.enable = true;

  home.file.".face".source = ./assets/propic.jpg;

  home.packages = with pkgs; (
    with gnomeExtensions; [
      appindicator
      arcmenu
      blur-my-shell
      dash-to-dock
      gsconnect
      pop-shell
    ]
  );

  home.sessionPath = [
    "${config.xdg.dataHome}/JetBrains/Toolbox/scripts"
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "~/${config.xdg.configFile."alacritty/themes/tokyo-night.yaml".target}"
      ];
      env = {
        # https://wiki.archlinux.org/title/Alacritty#Terminal_functionality_unavailable_in_remote_shells
        TERM = "xterm-256color";
      };
      windows = {
        dimensions = {
          columns = 120;
          lines = 36;
        };
        opacity = 0.8;
      };
    };
  };
  programs.firefox.enable = true;
  programs.gnome-terminal = {
    enable = true;
    profile."842ec37e-9d77-4e26-86c5-41fc3bca62c5" = {
      default = true;
      visibleName = "Default";
      # transparencyPercent = 20; # this option does not work with colors = null
    };
  };
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_stats = true;
      gpu_temp = true;
      gpu_load_change = true;
      cpu_stats = true;
      cpu_temp = true;
      cpu_load_change = true;
      core_load_change = true;
      vram = true;
      ram = true;
      fps = true;
      gamemode = true;
      no_display = true;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
    };
  };
  programs.mpv.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };
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
      "terminal.integrated.fontFamily" = "MesloLGM Nerd Font Mono, DroidSansMono Nerd Font Mono, monospace";
      "vscode-neovim.neovimInitVimPaths.linux" = "${config.home.homeDirectory}/${config.xdg.configFile."vscode-neovim/init.lua".target}";
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
  programs.zsh.shellAliases = {
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };

  services.gnome-keyring.enable = true;

  # manage autostart config
  xdg.configFile."autostart/solaar.desktop".source = pkgs.solaar + "/share/applications/solaar.desktop";

  xdg.configFile."alacritty/themes/tokyo-night.yaml".source = ./dotfiles/alacritty/tokyo-night.yaml;
  xdg.configFile."vscode-neovim/init.lua".text = ''
    require("Comment").setup{}
    vim.keymap.set("v", "<C-c>", "\"+y", {noremap=true})
    vim.keymap.set("v", "<C-x>", "\"+d", {noremap=true})
  '';
  # pamu2fcfg -o pam://auth.stdx.space -i pam://auth.stdx.space > secrets/u2f_keys
  xdg.configFile."Yubico/u2f_keys".source = ./secrets/u2f_keys;
}
