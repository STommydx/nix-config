# Apply GNOME Terminal transparency patch
# Patch authored by https://aur.archlinux.org/packages/gnome-terminal-transparency

self: super:
{
  # https://nixos.wiki/wiki/Overlays#Overriding_a_package_inside_a_scope
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-terminal = gsuper.gnome-terminal.overrideAttrs (old: rec {
      # downgrade to support AUR patch
      version = "3.48.1";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "gnome-terminal";
        rev = version;
        sha256 = "sha256-1t48JRESjAQubOmyK+QOhlp57iE5Ml0cqgy/2wjrLjE=";
      };

      patches = [
        (super.fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=abddafca02e4a353db2780b0d3c3eceaedaccebc";
          sha256 = "sha256-noCHCoM9e/ZuoFQlSDUEXSNk9irYPS0MeyVpVJQOQWk=";
        })
      ];
    });
  });
}
