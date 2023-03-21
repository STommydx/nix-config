# Apply GNOME Terminal transparency patch
# Patch authored by https://aur.archlinux.org/packages/gnome-terminal-transparency

self: super:
{
  # https://nixos.wiki/wiki/Overlays#Overriding_a_package_inside_a_scope
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-terminal = gsuper.gnome-terminal.overrideAttrs (old: rec {
      # downgrade to support AUR patch
      version = "3.46.8";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "gnome-terminal";
        rev = version;
        sha256 = "P3n1fksUxrwoM8ZCVAXWnNaNhK+9Tkl9DM9zmA0U6ks=";
      };

      patches = [
        (super.fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=13c036ee706670f5db701c6e99229c1e60321aa6";
          sha256 = "NvuTE8l05Sf+CeqBXAgvVJgqBEhU/3+RzCITJWeDaB8=";
        })
      ];
    });
  });
}
