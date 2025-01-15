{ config, ... }:

{
  # Force applications to compliant to XDG directories standard

  home.sessionVariables = {
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    ANSIBLE_HOME = "${config.xdg.dataHome}/ansible";
    ANSIBLE_CONFIG = "${config.xdg.configHome}/ansible.cfg";
    ANSIBLE_GALAXY_CACHE_DIR = "${config.xdg.cacheHome}/ansible/galaxy_cache";
    BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
    BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
    BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    NPM_CONFIG_USERCONFIG = "${config.home.homeDirectory}/${config.xdg.configFile."npm/npmrc".target}";
    WGETRC = "${config.home.homeDirectory}/${config.xdg.configFile."wgetrc".target}";
  };

  xdg.enable = true;
  # https://wiki.archlinux.org/title/XDG_Base_Directory
  xdg.configFile."npm/npmrc".text = ''
    prefix=${config.xdg.dataHome}/npm
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
    logs-dir=${config.xdg.stateHome}/npm/logs
  '';
  xdg.configFile."wgetrc".text = ''
    hsts-file=${config.xdg.cacheHome}/wget-hsts
  '';

}
