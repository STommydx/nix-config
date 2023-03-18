# Nix Config

My Nix configuration to provision Nix-powered machines and images.

## Highlights

- BTRFS zstd compression enable by default
- nix-sops for secret management

## Hosts

- `desktopdx` (bare-metal NixOS): main PC desktop, for gaming and development

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
6. Clone repo and `nixos-install --flake ".#host"`
