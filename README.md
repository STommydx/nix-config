# Nix Config

My Nix configuration to provision Nix-powered machines and images.

## Highlights

- BTRFS zstd compression enable by default
- nix-sops for secret management

## Hosts

- `desktopdx` (bare-metal NixOS): main PC desktop, for gaming and development
- `syoi` (Home Manager only): remote code-server at code.syoi.org

## Configuation Files

The configuration is organized as multiple profiles (minimal, standard and desktop) and additional host-specific
configs. The idea is to keep config structure reusable without complicated and hard-to-trace tree structures.

### NixOS Config

- `configuration.minimal.nix`: Minimal package set and settings. For ISO and containers
- `configuration.nix`: Standard package set and settings. For headless servers. Includes `configuration.minimal.nix`.
- `configuration.desktop.nix`: Desktop package set and settings. For desktop. Includes `configuration.nix`.

### Darwin Config

- `darwin-configuration.nix`: Settings for Macs. Manually merged from `configuration.desktop.nix`, `configuraton.nix` and `configuration.minimal.nix` and removed incompatiable settings.

### Home Manager Config

- `home.nix`: Standard home configuration.
- `home.desktop.nix`: Desktop home configuration. Includes `home.nix`.

## Usage

### Bare-metal NixOS Hosts (with secrets)

1. Build installation ISO (`nix build .#iso`) and burn ISO to USB
2. Boot up USB
3. Add SSH keys to authorized_keys
4. Run Ansible scripts in `tools` directory to prepare installation
5. Add public key of `/mnt/etc/sops-nix/key.txt` to `.sops.yaml` and update keys
6. Run `nixos-generate-config --root /mnt --show-hardware-config` and copy result to `hosts/$HOSTNAME/hardware-configuration.nix`
7. Clone repo and `nixos-install --flake ".#host"`

### Home-manager Only

1. Follow Nix and Home Manager installation if they are not yet installed
2. Clone repo and `home-manager switch --flake ".#host"`
