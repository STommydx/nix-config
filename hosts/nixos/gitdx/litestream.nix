{ config, lib, ... }:

{
  services.litestream = {
    enable = true;
    environmentFile = config.sops.templates.litestream.path;
    settings = {
      access-key-id = "$LITESTREAM_ACCESS_KEY_ID";
      secret-access-key = "$LITESTREAM_SECRET_ACCESS_KEY";
      dbs = [
        {
          path = config.services.forgejo.database.path;
          replicas = [
            {
              type = "s3";
              endpoint = "$LITESTREAM_S3_ENDPOINT";
              bucket = "forgejo-litestream";
              force-path-style = true;
            }
          ];
        }
        {
          path = config.services.opengist.database.path;
          replicas = [
            {
              type = "s3";
              endpoint = "$LITESTREAM_S3_ENDPOINT";
              bucket = "opengist-litestream";
              force-path-style = true;
            }
          ];
        }
      ];
    };
  };

  sops = {
    templates = {
      litestream = {
        content = ''
          LITESTREAM_S3_ENDPOINT=${config.sops.placeholder.r2-endpoint}
          LITESTREAM_ACCESS_KEY_ID=${config.sops.placeholder.r2-access-key}
          LITESTREAM_SECRET_ACCESS_KEY=${config.sops.placeholder.r2-secret-key}
        '';
        owner = "git";
        group = "git";
        restartUnits = [ "litestream.service" ];
      };
    };
  };

  systemd.services.litestream.serviceConfig = {
    User = lib.mkForce "git";
    Group = lib.mkForce "git";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "litestream-0.3.13"
  ];
}
