{ ... }:

{
  services.adguardhome = {
    enable = true;
  };
  # https://github.com/AdguardTeam/AdGuardHome/wiki/FAQ#bindinuse
  services.resolved.settings.Resolve = {
    DNS = "127.0.0.1";
    DNSStubListener = "no";
  };
}
