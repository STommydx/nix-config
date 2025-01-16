{ config, ... }:

{

  sops = {
    secrets = {
      minio_credentials = { };
      restic_password = { };
    };
  };

  services.restic.backups = {
    datastore = {
      environmentFile = config.sops.secrets.minio_credentials.path;
      passwordFile = config.sops.secrets.restic_password.path;
      paths = [
        "/data/datastore"
      ];
      pruneOpts = [
        "--keep-within 30d"
      ];
      repository = "s3:https://artifacts.stdx.space/restic";
      timerConfig = {
        OnCalendar = "Mon,Wed,Sat";
        Persistent = true;
      };
    };
    home = {
      environmentFile = config.sops.secrets.minio_credentials.path;
      passwordFile = config.sops.secrets.restic_password.path;
      paths = [
        "/home/stommydx/Documents"
        "/home/stommydx/Downloads"
        "/home/stommydx/Pictures"
        "/home/stommydx/Videos"
        "/home/stommydx/workspace"
      ];
      pruneOpts = [
        "--keep-within 30d"
      ];
      repository = "s3:https://artifacts.stdx.space/restic";
      timerConfig = {
        OnCalendar = "Mon,Wed,Sat";
        Persistent = true;
      };
    };
  };

}
