{
  config,
  ...
}:

{

  imports = [
    ./vibe.nix
  ];

  home.sessionPath = [
    "${config.xdg.dataHome}/go/bin" # Go binaries
  ];

  # cat alternative, colorize code outputs
  programs.bat.enable = true;

  # coloring for diff outputs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # per directory ENV loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # GitHub command line
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    settings = {
      alias = {
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
      user.name = "Tommy Li";
      user.email = "dev@stdx.space";
      init = {
        defaultBranch = "main"; # modern convention
      };
      push = {
        autoSetupRemote = "true";
      };
      # https://youtu.be/aolI_Rz0ZqY?t=901
      rerere.enabled = true;
    };
    ignores = [
      # ignore (usually) sensitive env files
      ".env"
      ".env.*"
      ".envrc"
      # editor settings should not be committed unless explicitly stated
      ".vscode/"
      ".zed/"
    ];
    signing = {
      key = "577E858EDCFECA83";
    };
  };

  programs.go = {
    enable = true;
    env.GOPATH = "${config.xdg.dataHome}/go"; # Follow XDG spec
  };

  # Git TUI
  programs.lazygit.enable = true;

}
