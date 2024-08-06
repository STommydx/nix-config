# Apply GNOME Terminal transparency patch
# Patch authored by https://aur.archlinux.org/packages/gnome-terminal-transparency

final: prev:
{
  gnome-terminal = prev.gnome-terminal.overrideAttrs (old: rec {
    # downgrade to support AUR patch
    version = "3.52.2";
    src = prev.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "gnome-terminal";
      rev = version;
      sha256 = "sha256-c6xMUyhQnJiIrFnnUEx6vGVvFghGvLjTxiAFq+nSj2A=";
    };

    patches = [
      (prev.fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=e346aad64be4663045c1b39be04e7a705d3a545e";
        sha256 = "sha256-MmiyYHxWM6uB9aA6R9ZMKcDfZe9y1z7o/7KXTzdZMY8=";
      })
    ];
  });
}
