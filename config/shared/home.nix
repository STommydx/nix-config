{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "stommydx";
  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/stommydx" else "/Users/stommydx";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionPath = [
    "${config.xdg.dataHome}/go/bin"
  ];
  home.sessionVariables = {
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
    ANSIBLE_CONFIG = "${config.xdg.configHome}/ansible.cfg";
    ANSIBLE_GALAXY_CACHE_DIR = "${config.xdg.cacheHome}/ansible/galaxy_cache";
    BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
    BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
    BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    NPM_CONFIG_USERCONFIG = "${config.home.homeDirectory}/${config.xdg.configFile."npm/npmrc".target}";
    WGETRC = "${config.home.homeDirectory}/${config.xdg.configFile."wgetrc".target}";
  };

  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.eza = {
    enable = true;
    extraOptions = [ "-g" "--classify=auto" ];
    icons = true;
  };
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    aliases = {
      # Alias recommendations from various sites
      # https://www.atlassian.com/git/tutorials/git-alias
      # https://betterprogramming.pub/8-amazing-aliases-to-make-you-more-productive-with-git-3be35d1b7e51
      alias = "config --get-regexp ^alias\\."; # show all available alias
      br = "branch";
      ci = "commit";
      co = "checkout";
      st = "status";
      # support cantonese!
      teoi = "push"; # home row ftw! :D
      laai = "pull";
    };
    ignores = [
      ".env"
      ".env.*"
    ];
    userName = "Tommy Li";
    userEmail = "dev@stdx.space";
    signing = {
      key = "577E858EDCFECA83";
    };
    delta.enable = true;
    extraConfig = {
      push = {
        autoSetupRemote = "true";
      };
    };
  };
  programs.go = {
    enable = true;
    goPath = lib.removePrefix config.home.homeDirectory "${config.xdg.dataHome}/go";
  };
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  programs.lazygit.enable = true;
  programs.less.enable = true;
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };
    defaultEditor = true;
    extraConfigLua = ''
      require('neoscroll').setup()
      require("scrollbar").setup()
    '';
    extraPlugins = with pkgs.vimPlugins; [
      neoscroll-nvim
      nvim-scrollbar
      vim-illuminate
    ];
    keymaps = [
      {
        mode = "v";
        key = "<C-c>";
        action = ''"+y'';
      }
      {
        mode = "v";
        key = "<C-x>";
        action = ''"+d'';
      }
    ];
    opts = {
      number = true;
    };
    plugins = {
      bufferline = {
        enable = true;
        separatorStyle = "slant";
      };
      comment.enable = true;
      coq-nvim.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          gopls.enable = true;
          nixd.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
      nix.enable = true;
      noice.enable = true;
      notify.enable = true;
      nvim-autopairs.enable = true;
      nvim-tree.enable = true;
      todo-comments.enable = true;
      treesitter.enable = true;
      trouble.enable = true;
    };
    viAlias = true;
    vimAlias = true;
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "ssh.syoi.org" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };
    };
  };
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

  xdg.enable = true;
  # https://wiki.archlinux.org/title/XDG_Base_Directory
  xdg.configFile."npm/npmrc".text = ''
    prefix=${config.xdg.dataHome}/npm
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
    logs-dir=${config.xdg.stateHome}/npm/logs
  '';
  xdg.configFile."wgetrc".text = ''
    hsts-file=${config.xdg.cacheHome}/wget-hsts
  '';
}
