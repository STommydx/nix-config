{ config, ... }:

{
  services.restic.backups = {
    forgejo-repo = {
      environmentFile = config.sops.templates.restic-env.path;
      passwordFile = config.sops.secrets.restic-password.path;
      paths = [
        config.services.forgejo.repositoryRoot
      ];
      pruneOpts = [
        "--keep-within 30d"
      ];
      repositoryFile = config.sops.templates.restic-repository.path;
      timerConfig = {
        OnCalendar = "*-*-* *:0/5:00";
      };
    };
  };

  sops = {
    secrets = {
      restic-password = {
        sopsFile = ./secrets/restic.json;
        format = "json";
      };
    };
    templates = {
      restic-repository = {
        content = "s3:https://${config.sops.placeholder.r2-endpoint}/forgejo-repo";
      };
      restic-env = {
        content = ''
          AWS_ACCESS_KEY_ID=${config.sops.placeholder.r2-access-key}
          AWS_SECRET_ACCESS_KEY=${config.sops.placeholder.r2-secret-key}
        '';
      };
    };
  };
}
