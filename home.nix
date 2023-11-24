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

  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [ "-g" ];
  };
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
    };
    userName = "Tommy Li";
    userEmail = "dev@stdx.space";
    signing = {
      key = "577E858EDCFECA83";
    };
    delta.enable = true;
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
      style = "night";
    };
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
    options = {
      number = true;
    };
    plugins = {
      bufferline = {
        enable = true;
        separatorStyle = "slant";
      };
      comment-nvim.enable = true;
      coq-nvim.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          gopls.enable = true;
          rnix-lsp.enable = true;
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
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./dotfiles/p10k.conf.d;
        file = ".p10k.zsh";
      }
    ];
  };

  services.gpg-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    pinentryFlavor = "curses";
  };

  xdg.enable = true;
}
