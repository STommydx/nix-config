{
  outputs,
  config,
  lib,
  ...
}:

{
  imports = [
    outputs.nixosModules.opengist
  ];

  services.opengist = {
    enable = true;
    settings =
      {
        external-url = "https://gist.stommydx.net";
      }
      // lib.mapAttrs' (key: value: lib.nameValuePair "gitea.${key}" value) {
        url = "https://git.stommydx.net";
        name = "Forgejo";
      };
    environmentFile = config.sops.templates.opengist-env.path;
    ssh.enable = true;
    user = "git";
    group = "git";
  };
  sops = {
    secrets = {
      forgejo-client-key = {
        sopsFile = ./secrets/opengist.json;
        format = "json";
        owner = "git";
        group = "git";
      };
      forgejo-client-secret = {
        sopsFile = ./secrets/opengist.json;
        format = "json";
        owner = "git";
        group = "git";
      };
    };
    templates = {
      opengist-env = {
        content = ''
          OG_GITEA_CLIENT_KEY=${config.sops.placeholder.forgejo-client-key}
          OG_GITEA_SECRET=${config.sops.placeholder.forgejo-client-secret}
        '';
        owner = config.services.opengist.user;
        group = config.services.opengist.group;
      };
    };
  };
}
