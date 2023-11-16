# Apply GNOME Terminal transparency patch
# Patch authored by https://aur.archlinux.org/packages/gnome-terminal-transparency

self: super:
{
  # https://nixos.wiki/wiki/Overlays#Overriding_a_package_inside_a_scope
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-terminal = gsuper.gnome-terminal.overrideAttrs (old: rec {
      # downgrade to support AUR patch
      version = "3.48.2";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "gnome-terminal";
        rev = version;
        sha256 = "sha256-WvFKFh5BK6AS+Lqyh27xIfH1rxs1+YTkywX4w9UashQ=";
      };

      patches = [
        (super.fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=fcfc3f2ccf9cdc0a55e07bafc6efc25310bdf4c3";
          sha256 = "sha256-tnzhEyqTpd6AHVACf4Sgwe4yYLWZ+mWPmlLXGMsqzBY=";
        })
      ];
    });
  });
}
