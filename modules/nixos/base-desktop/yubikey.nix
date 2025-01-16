{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    pam_u2f
    yubikey-manager
  ];

  # Yubikey sudo authentication
  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    settings = {
      cue = true;
      appId = "pam://auth.stdx.space";
      origin = "pam://auth.stdx.space";
    };
  };

}
