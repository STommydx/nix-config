{ config, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      gitdx-tunnel = {
        ingress = {
          "git.stommydx.net" =
            "http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}";
          "gist.stommydx.net" = "http://localhost:${toString config.services.opengist.port}";
          "git-ssh.stommydx.net" = "ssh://localhost:22";
          "gist-ssh.stommydx.net" = "ssh://localhost:${toString config.services.opengist.ssh.port}";
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
