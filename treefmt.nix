{ ... }:

{

  projectRootFile = "flake.nix";
  settings.global.excludes = [
    "*.png"
    "*.jpg"
    "u2f_keys"
  ];

  programs.mdformat = {
    enable = true;
    settings.number = true;
  };
  programs.nixfmt.enable = true;
  programs.shfmt.enable = true;
  programs.yamlfmt.enable = true;

}
