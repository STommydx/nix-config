{ config, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    database = {
      type = "sqlite3";
    };
    secrets = {
      storage = {
        MINIO_ENDPOINT = config.sops.secrets.r2-endpoint.path;
        MINIO_ACCESS_KEY_ID = config.sops.secrets.r2-access-key.path;
        MINIO_SECRET_ACCESS_KEY = config.sops.secrets.r2-secret-key.path;
      };
    };
    settings = {
      cache = {
        TYPE = "redis";
        CONN_STR = "redis://${config.services.redis.servers.forgejo.unixSocket}/0";
      };
      queue = {
        TYPE = "redis";
        CONN_STR = "redis://${config.services.redis.servers.forgejo.unixSocket}/0";
      };
      server = {
        DOMAIN = "git.stommydx.net";
        ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}/";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      storage = {
        STORAGE_TYPE = "minio";
        MINIO_BUCKET = "forgejo-data";
        MINIO_USE_SSL = true;
        MINIO_CHECKSUM_ALGORITHM = "md5"; # for compatibility with R2
      };
    };
    user = "git";
    group = "git";
  };
  services.redis = {
    package = pkgs.valkey;
    servers.forgejo = {
      enable = true;
      user = "git";
      group = "git";
      port = 0; # disable TCP, use UNIX socket instead
    };
  };
  sops.secrets = {
    r2-access-key = {
      sopsFile = ./secrets/r2.json;
      key = "access_key";
      format = "json";
      owner = "git";
      group = "git";
      restartUnits = [ "forgejo.service" ];
    };
    r2-secret-key = {
      sopsFile = ./secrets/r2.json;
      key = "secret_key";
      format = "json";
      owner = "git";
      group = "git";
      restartUnits = [ "forgejo.service" ];
    };
    r2-endpoint = {
      sopsFile = ./secrets/r2.json;
      key = "endpoint";
      format = "json";
      owner = "git";
      group = "git";
      restartUnits = [ "forgejo.service" ];
    };
  };
}
