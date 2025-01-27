{ inputs, config, ... }:

{

  sops = {
    secrets = {
      password = {
        neededForUsers = true;
      };
    };
  };

  users.users.stommydx = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "storage"
      "networkmanager"
    ];
    hashedPasswordFile = config.sops.secrets.password.path;
    openssh.authorizedKeys.keyFiles = [ inputs.authorized-keys ];
  };

}
