{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.opengist;
  exe = lib.getExe cfg.package;

  configFile = yamlFormat.generate "config.yml" cfg.settings;

  yamlFormat = pkgs.formats.yaml { };
in

{
  options = {
    services.opengist = {
      enable = mkEnableOption "Opengist";

      package = mkPackageOption pkgs "opengist" { };
      sshPackage = mkPackageOption pkgs "openssh" { };

      stateDir = mkOption {
        default = "/var/lib/opengist";
        type = types.str;
        description = "Opengist data directory.";
      };

      user = mkOption {
        type = types.str;
        default = "opengist";
        description = "User to run Opengist as.";
      };

      group = mkOption {
        type = types.str;
        default = "opengist";
        description = "Group to run Opengist as.";
      };

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "The host on which the HTTP server should bind.";
      };

      port = mkOption {
        type = types.port;
        default = 6157;
        description = "The port on which the HTTP server should listen.";
      };

      database = mkOption {
        type = types.submodule {
          options = {
            type = mkOption {
              type = types.enum [
                "sqlite"
                "mysql"
                "postgres"
              ];
              example = "mysql";
              default = "sqlite";
              description = "Database engine to use.";
            };
            path = mkOption {
              type = types.str;
              default = "${cfg.stateDir}/opengist.db";
              defaultText = literalExpression ''"${cfg.stateDir}/opengist.db"'';
              description = "Path to the SQLite database file.";
            };
          };
        };
        default = { };
        description = "Database configuration.";
      };

      ssh = mkOption {
        type = types.submodule {
          options = {
            enable = mkEnableOption "builtin SSH";
            host = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = "The host on which the SSH server should bind.";
            };
            port = mkOption {
              type = types.port;
              default = 2222;
              description = "The port on which the SSH server should listen.";
            };
          };
        };
        default = { };
        description = ''
          SSH server settings.
        '';
      };

      environmentFile = mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service without adding them to the
          world-readable Nix store, by specifying placeholder variables as
          the option value in Nix and setting these variables accordingly in the
          environment file.
        '';
        example = /run/keys/github.secret;
      };

      settings = mkOption {
        type = yamlFormat.type;
        default = { };
        description = ''
          Free-form settings writtend directly to `config.yml` config file.
          See <https://opengist.io/docs/configuration/cheat-sheet.html> for available options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.opengist.settings =
      {
        db-uri = mkIf (cfg.database.type == "sqlite") "file:${cfg.database.path}";
        opengist-home = cfg.stateDir;
        "http.host" = cfg.host;
        "http.port" = cfg.port;
      }
      // (lib.optionalAttrs cfg.ssh.enable {
        "ssh.git-enabled" = true;
        "ssh.host" = cfg.ssh.host;
        "ssh.port" = cfg.ssh.port;
        "ssh.keygen-executable" = lib.getExe' cfg.sshPackage "ssh-keygen";
      });

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.opengist = {
      description = "Opengist Server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.git
        cfg.sshPackage
      ];
      serviceConfig = {
        ExecStart = "${exe} --config ${configFile}";
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
      };
    };

    users.users = mkIf (cfg.user == "opengist") {
      opengist = {
        home = cfg.stateDir;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "opengist") {
      opengist = { };
    };
  };
}
