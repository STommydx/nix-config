{ pkgs, ... }:

{
  # Office software
  environment.systemPackages = with pkgs; [
    # element-desktop
    libreoffice # office suite
    qpdf # command line pdf manipulation tool
    signal-desktop
    telegram-desktop
    thunderbird # email client
    wasistlos # whatsapp client
    zoom-us # video conference
  ];
}
