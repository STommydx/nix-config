# Nix Config

My Nix configuration to provision Nix-powered machines and images.

## Highlights

- BTRFS zstd compression enable by default
- nix-sops for secret management

## Hosts

- `desktopdx` (bare-metal NixOS): main PC desktop, for gaming and development
- `workpcdx` (bare-metal NixOS): work PC desktop
- `macbookdx` (Mac): Macbook Air, for development and casual entertainment
- `winpcdx` (WSL): WSL environment in Windows PC
- `bastiondx` (Proxmox LXC): bastion host, as Tailscale exit node and DNS AdBlocker
- `syoi` (Home Manager only): remote code-server at code.syoi.org
- `sysspcdx` (WSL Tarball): WSL Tarball building for importing to PCs in SYSS

## Configuation Files

TODO: Update section for updated folder structure

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

### WSL Hosts (with secrets)

Currently building from tarball is not tested.

1. Download and install [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/install.html)
2. Setup Nix flakes by enabling flags and install git in `/etc/nixos/configuration.nix`
3. Install `age` and generate an age key at `/etc/sops-nix/key.txt`
4. Add public key of generated age key to `.sops.yaml` and update keys
5. Switch to configuration as usual with `nixos-build switch --flake ".#host"`

Note: You should make sure `dotfiles/p10k.conf.d/.p10k.zsh` is in `LF` instead
of `CRLF` checked out by Git for Windows.

### Proxmox LXC Containers

1. Build tarball by `nix build .#container`
2. Upload tarball to Proxmox
3. Create LXC container with tarball template
4. Mark down IP and change root password if necessary. See instructions [here](https://www.reddit.com/r/NixOS/comments/1aw9k9v/default_username_password_for_nixos_lxc_on_proxmox/) and [here](https://nixos.wiki/wiki/Proxmox_Linux_Container#Entering_into_container_by_pct_enter). Note that users configurations are not built into the tarball
5. Apply configuration with `nixos-build switch --flake ".#container"`. Note that this apply is expected to fail
6. Reboot and reapply configuration

### Home-manager Only

1. Follow Nix and Home Manager installation if they are not yet installed
2. Clone repo and `home-manager switch --flake ".#host"`
