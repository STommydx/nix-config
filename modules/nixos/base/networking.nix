{ lib, ... }:

{

  # firewall is disabled by default
  networking.firewall.enable = lib.mkDefault false;

  # use networkmanager for network management
  # TODO: add options to use systemd-networkd instead
  networking.networkmanager = {
    enable = lib.mkDefault true;
    connectionConfig = {
      "connection.mdns" = 2;
    };
    # Networkmanager option by default install plugins that pulls in GTK
    # dependencies which are undesired for a minimal system.
    # Here, we override the default with prority 99, which allows additional
    # overrides (e.g. mkForce) from the user's configuration.
    # https://github.com/NixOS/nixpkgs/pull/164531
    # https://discourse.nixos.org/t/networkmanager-plugins-installed-by-default/39682
    plugins = lib.mkOverride 99 [ ];
  };

  # disable avahi in favor of systemd-resolved mDNS
  services.avahi.enable = false;

  # use resolved for managing DNS
  services.resolved = {
    enable = true;
    extraConfig = "MulticastDNS=yes";
  };

  # enable Tailscale mesh VPN by default
  services.tailscale.enable = true;

  # temporary workaround for https://github.com/NixOS/nixpkgs/issues/180175
  # NetworkManager-wait-online.service fails system activation if enabled
  systemd.services.NetworkManager-wait-online.enable = false;
}
