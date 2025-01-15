{ config, lib, ... }:

{

  # cat alternative, colorize code outputs
  programs.bat.enable = true;

  # per directory ENV loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # GitHub command line
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
      init = {
        defaultBranch = "main"; # modern convention
      };
      push = {
        autoSetupRemote = "true";
      };
      # https://youtu.be/aolI_Rz0ZqY?t=901
      rerere.enabled = true;
    };
  };

  programs.go = {
    enable = true;
    goPath = lib.removePrefix config.home.homeDirectory "${config.xdg.dataHome}/go"; # Follow XDG spec
  };

  # Git TUI
  programs.lazygit.enable = true;

}
