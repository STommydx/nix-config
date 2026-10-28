{ pkgs, ... }:

let
  # SOCKS port of the ssh dynamic forward; the Chrome extension points at it
  tunnelPort = 41080;
in
{
  programs.ssh.settings."claude.narwhl.internal" = {
    HostName = "100.121.61.2";
    User = "system";
    ProxyCommand = "${pkgs.netcat}/bin/nc -X 5 -x 127.0.0.1:1055 %h %p";
    DynamicForward = "127.0.0.1:${toString tunnelPort}";
    # share one connection so the forward is bound once across sessions
    ControlMaster = "auto";
    ControlPath = "~/.ssh/cm-%C";
    ControlPersist = "10m";
  };

  # Chrome extension that sends one profile's traffic through the tunnel,
  # localhost included. Load it once per profile with "Load unpacked" on
  # chrome://extensions. One entry per file keeps the directory a stable real
  # path across rebuilds; only the files link into the store.
  xdg.dataFile."claude-tunnel/chrome-extension/manifest.json".text = builtins.toJSON {
    manifest_version = 3;
    name = "Claude tunnel";
    version = "1.0";
    description = "Sends this profile's traffic through the ssh SOCKS tunnel, localhost included.";
    permissions = [ "proxy" ];
    background.service_worker = "background.js";
  };
  xdg.dataFile."claude-tunnel/chrome-extension/background.js".text = ''
    // Proxy settings set by an extension apply only to the profile it is installed in.
    const config = {
      mode: "fixed_servers",
      rules: {
        singleProxy: { scheme: "socks5", host: "127.0.0.1", port: ${toString tunnelPort} },
        // Chrome sends loopback hosts direct unless this rule removes that bypass.
        bypassList: ["<-loopback>"],
      },
    };
    const apply = () => chrome.proxy.settings.set({ value: config, scope: "regular" });
    chrome.runtime.onInstalled.addListener(apply);
    chrome.runtime.onStartup.addListener(apply);
  '';
}
