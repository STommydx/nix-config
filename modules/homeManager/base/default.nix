{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hm.nix
    ./vim.nix
    ./xdg.nix
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin" # add local binaries to PATH
  ];

  # ls alternative, colorize output
  programs.eza = {
    enable = true;
    extraOptions = [
      "-g"
      "--classify=auto"
    ];
    icons = "auto";
  };

  # find command alternative
  programs.fd.enable = true;

  # fuzzy search, for history
  programs.fzf.enable = true;

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  programs.less.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "ssh.syoi.org" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };
      "git.syoi.org" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname ssh.syoi.org";
      };
      "git.stommydx.net" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname git-ssh.stommydx.net";
      };
      "gist.stommydx.net" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname gist-ssh.stommydx.net";
      };
    };
  };

  # Terminal Prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$os$all";
      right_format = "$status$cmd_duration$time";
      directory = {
        before_repo_root_style = "dimmed cyan";
        repo_root_style = "bold cyan";
        fish_style_pwd_dir_length = 2;
      };
      line_break = {
        disabled = true;
      };
      status = {
        disabled = false;
      };
      time = {
        disabled = false;
      };
      os = {
        disabled = false;
        symbols = {
          Android = "[](fg:#48B157)  ";
          Fedora = "[](fg:#3C6EB4)  ";
          Macos = "[](fg:#A2AAAD)  ";
          NixOS = "[](fg:#5277C3)  ";
          Ubuntu = "[](fg:#E95420)  ";
        };
      };
    };
  };

  programs.thefuck.enable = true;
  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      power-theme
      sensible
      yank
    ];
  };
  programs.zsh = {
    enable = true;
    dotDir = lib.removePrefix config.home.homeDirectory "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.stateHome}/zsh/history";
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
  };

  services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
