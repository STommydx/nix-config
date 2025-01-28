{ config, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      gitdx-tunnel = {
        ingress = {
          "git.stommydx.net" = "http://localhost:3000";
          "git-ssh.stommydx.net" = "ssh://localhost:22";
        };
        default = "http_status:404";
        credentialsFile = config.sops.secrets.tunnel-credentials.path;
      };
    };
  };
  sops.secrets.tunnel-credentials = {
    sopsFile = ./secrets/cloudflare-tunnel.json;
    format = "json";
    key = ""; # https://github.com/Mic92/sops-nix?tab=readme-ov-file#emit-plain-file-for-yaml-and-json-formats
    owner = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
  };
}
