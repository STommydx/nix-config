{ pkgs, ... }:

{
  # Office software
  environment.systemPackages = with pkgs; [
    qpdf # command line pdf manipulation tool
  ];

  homebrew = {
    casks = [
      "signal"
      "telegram"
      "zoom"
    ];
    masApps = {
      "WhatsApp Messenger" = 310633997;
    };
  };

}
