{ pkgs, ... }:

{
  # Office software
  environment.systemPackages = with pkgs; [
    # element-desktop
    # fastmail-desktop # disabled until https://github.com/NixOS/nixpkgs/pull/544808 is merged
    libreoffice # office suite
    qpdf # command line pdf manipulation tool
    signal-desktop
    telegram-desktop
    thunderbird # email client
    karere # whatsapp client
    zoom-us # video conference
  ];
}
