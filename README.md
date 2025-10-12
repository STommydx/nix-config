# Nix Config

Personal Nix configuration repository for provisioning and maintaining Nix-powered machines across multiple platforms including NixOS, macOS (Darwin), and Windows Subsystem for Linux (WSL).

## Overview

This repository manages my entire computing ecosystem using Nix flakes, providing declarative and reproducible configurations for:

- **Personal devices**: Desktops, laptops, and development machines
- **Work machines**: Both personal and company-provided equipment
- **Servers**: Git server, DNS server, bastion host, and development environments
- **Specialized environments**: Custom installer ISO and deployment configurations

### Design Principles

1. **Modular Architecture**: Configurations are built from reusable modules that encapsulate specific functionality
2. **Platform Agnostic**: Support for NixOS, Darwin, and Home Manager with shared abstractions where possible
3. **Declarative Management**: All system state is declared in code, including secrets via sops-nix
4. **Reproducible Builds**: Every configuration can be reproduced from scratch with consistent results
5. **Minimal Maintenance**: Automated garbage collection and optimized storage settings

### Key Features

- BTRFS with zstd compression enabled by default
- Centralized secret management using nix-sops
- Automated deployments with deploy-rs
- Custom NixOS installer ISO with pre-configured tools
- Comprehensive module system for easy customization

## Repository Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Nix Config                           │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │    Hosts    │  │   Modules   │  │      Profiles        │  │
│  │             │  │             │  │                     │  │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────────────┐ │  │
│  │ │ NixOS   │ │  │ │ NixOS   │ │  │ │ NixOS           │ │  │
│  │ │ Darwin  │ │  │ │ Darwin  │ │  │ │ Darwin          │ │  │
│  │ │ HomeMgr │ │  │ │ HomeMgr │ │  │ │ HomeManager     │ │  │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────────────┘ │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Systems   │  │    Users    │  │       Tools          │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Directory Structure

```
├── hosts/                  # Host-specific configurations
│   ├── darwin/            # macOS configurations
│   ├── homeManager/       # Home Manager only configurations
│   └── nixos/             # NixOS configurations
├── modules/               # Reusable modules organized by platform
│   ├── darwin/            # macOS modules
│   ├── homeManager/       # Home Manager modules
│   └── nixos/             # NixOS modules
├── profiles/              # Combinations of modules for specific use cases
│   ├── darwin/            # macOS profiles
│   ├── homeManager/       # Home Manager profiles
│   └── nixos/             # NixOS profiles
├── systems/               # Hardware-specific configurations
├── users/                 # User-specific configurations
├── tools/                 # Installation and setup tools
└── secrets/               # Encrypted secrets (managed with sops-nix)
```

### Module System

The configuration follows a hierarchical module system:

1. **Modules**: Reusable components that encapsulate specific functionality (e.g., `dev-tools`, `gaming`)
2. **Profiles**: Combinations of modules for specific use cases (e.g., `devops`, `alltheway-desktop`)
3. **Hosts**: Machine-specific configurations that import relevant profiles
4. **Systems**: Hardware-specific configurations

## Quick Reference

### Essential Commands

```bash
# Check the configuration for syntax and logical errors
nix flake check

# Build a specific host configuration (without applying changes)
# For NixOS hosts:
nixos-rebuild build --flake ".#<hostname>"
# For Home Manager hosts:
home-manager build --flake ".#<hostname>"
# For Darwin hosts:
darwin-rebuild build --flake ".#<hostname>"

# Apply NixOS configuration (for NixOS hosts)
sudo nixos-rebuild switch --flake ".#<hostname>"

# Apply Home Manager configuration (for Home Manager hosts)
home-manager switch --flake ".#<hostname>"

# Apply Darwin configuration (for macOS hosts)
darwin-rebuild switch --flake ".#<hostname>"

# Deploy to remote servers (requires deploy-rs setup)
deploy

# Show available configurations
nix flake show
```

### Testing Workflow

1. Always run `nix flake check` before committing changes
2. Test specific configurations before deployment:
   # For NixOS hosts:
   nixos-rebuild build --flake ".#<hostname>"
   # For Home Manager hosts:
   home-manager build --flake ".#<hostname>"
   # For Darwin hosts:
   darwin-rebuild build --flake ".#<hostname>"
3. Apply configurations only after successful testing:
   # For NixOS hosts:
   sudo nixos-rebuild switch --flake ".#<hostname>"
   # For Home Manager hosts:
   home-manager switch --flake ".#<hostname>"
   # For Darwin hosts:
   darwin-rebuild switch --flake ".#<hostname>"
4. Avoid building in production during development sessions

## Host Configurations

### NixOS Hosts

| Host | Type | Purpose | Platform |
|------|------|---------|----------|
| desktopdx | Bare-metal | Main PC desktop, gaming and development | AMD |
| workpcdx | Bare-metal | Work PC desktop | Intel |
| gitdx | Proxmox LXC | Git server running Forgejo | Container |
| guardiandx | Proxmox LXC | AdGuard Home DNS server | Container |
| bastiondx | Proxmox LXC | Bastion host, Tailscale exit node and DNS AdBlocker | Container |
| winpcdx | WSL | WSL environment in Windows PC | WSL |
| sysspcdx | WSL Tarball | WSL Tarball building for SYSS PCs | WSL |
| installer-iso | NixOS | Custom installer ISO | ISO |

### Darwin Hosts

| Host | Type | Purpose |
|------|------|---------|
| macbookdx | MacBook Air | Development and casual entertainment |

### Home Manager Hosts

| Host | Platform | Purpose |
|------|----------|---------|
| CLEA-DELL-001 | Linux | Work PC for CLEA |
| CLEA-MAC-001 | macOS | Work Mac for CLEA |
| devdx | Linux | Development environment |
| makcpu1 | Linux | GPU dev machine @ HKUST for Signify app development |
| syoi | Linux | Remote code-server at code.syoi.org |

## Workflows

### Adding a New Host

1. Create host directory in appropriate platform folder (`hosts/<platform>/<hostname>/`)
2. Create `default.nix` with host configuration
3. Import appropriate profiles and system configuration
4. Add host to the appropriate list in `flake.nix`
5. Test with `nix flake check`
6. Build and test configuration:
   # For NixOS hosts:
   nixos-rebuild build --flake ".#<hostname>"
   # For Home Manager hosts:
   home-manager build --flake ".#<hostname>"
   # For Darwin hosts:
   darwin-rebuild build --flake ".#<hostname>"

### Updating Configurations

1. Make changes to appropriate modules or profiles
2. Test with `nix flake check`
3. Apply changes to specific host:
   - NixOS: `sudo nixos-rebuild switch --flake ".#<hostname>"`
   - Home Manager: `home-manager switch --flake ".#<hostname>"`
   - Darwin: `darwin-rebuild switch --flake ".#<hostname>"`

### Managing Secrets

1. Secrets are managed using sops-nix
2. Never commit actual secrets to the repository
3. Only age public keys should be in `.sops.yaml`
4. To update secrets:
   ```bash
   sops <secret-file>
   ```

### Remote Deployment

Remote deployments are configured using deploy-rs for:
- gitdx (10.101.151.229)
- guardiandx (10.101.255.22)

#### Deploying to Remote Systems

To deploy configurations to remote systems:

```bash
# Deploy all configured nodes
deploy

# Deploy to a specific node
deploy .#gitdx

# Deploy to a specific profile on a node
deploy .#gitdx.system
```


#### Deployment Configuration

Each remote node is configured in `flake.nix` with:
- Hostname or IP address
- SSH user for connecting
- Target user for deployment (often root)
- Profile paths and activation methods

Deployments require proper SSH access and authentication set up beforehand.

## Platform-Specific Setup

### Bare-metal NixOS Hosts (with secrets)

1. Build installation ISO: `nix build .#installer-iso`
2. Burn ISO to USB and boot
3. Add SSH keys to authorized_keys
4. Run Ansible scripts in `tools` directory to prepare installation
5. Add public key of `/mnt/etc/sops-nix/key.txt` to `.sops.yaml` and update keys
6. Run `nixos-generate-config --root /mnt --show-hardware-config` and copy result to `hosts/nixos/$HOSTNAME/hardware-configuration.nix`
7. Clone repo and `nixos-install --flake ".#<hostname>"`

### WSL Hosts (with secrets)

1. Download and install [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/install.html)
2. Setup Nix flakes by enabling flags and install git in `/etc/nixos/configuration.nix`
3. Install `age` and generate an age key at `/etc/sops-nix/key.txt`
4. Add public key of generated age key to `.sops.yaml` and update keys
5. Switch to configuration: `nixos-rebuild switch --flake ".#<hostname>"`

Note: Ensure `dotfiles/p10k.conf.d/.p10k.zsh` is in `LF` instead of `CRLF` when checked out by Git for Windows.

### Proxmox LXC Containers

1. Build tarball: `nix build .#<hostname>`
2. Upload tarball to Proxmox
3. Create LXC container with tarball template
4. Note IP and change root password if necessary
5. Apply configuration: `nixos-rebuild switch --flake ".#<hostname>"`
6. Reboot and reapply configuration if needed

### Home Manager Only

1. Follow Nix and Home Manager installation if not yet installed
2. Clone repo and `home-manager switch --flake ".#<hostname>"`

## Troubleshooting

### Common Issues

1. **Build Failures**: Check that all inputs are properly defined in `flake.nix`
2. **Secret Decryption**: Ensure age keys are properly configured and accessible
3. **Network Issues**: Check firewall settings for deployments
4. **Disk Configuration**: Verify disk-config.nix matches actual disk layout

### Debugging Techniques

1. Use `nix flake check` to validate configuration syntax
2. Use platform-specific build commands with --verbose for detailed output:
   # For NixOS hosts:
   nixos-rebuild build --flake ".#<hostname>" --verbose
   # For Home Manager hosts:
   home-manager build --flake ".#<hostname>" --verbose
   # For Darwin hosts:
   darwin-rebuild build --flake ".#<hostname>" --verbose
3. Check journalctl for service-specific errors
4. Use `nix repl` to debug Nix expressions

### Recovery Procedures

Since GRUB is configured as the bootloader, system recovery is straightforward:

Reboot and select "NixOS - All configurations" from the GRUB menu, then choose the previous working generation.

## File Conventions

- Use `default.nix` for module and profile definitions
- Host-specific configurations go in `hosts/<platform>/<hostname>/default.nix`
- Hardware configurations go in `hardware-configuration.nix` files
- Disk configurations go in `disk-config.nix` files
- Service-specific configurations are often split into separate files

## Development Notes

### Key Decisions

1. **Modular Architecture**: Chosen for reusability and maintainability across different systems
2. **Flakes**: Adopted for reproducibility and better dependency management
3. **sops-nix**: Selected for secret management to avoid committing sensitive data
4. **BTRFS with compression**: Default filesystem for space efficiency and data integrity

### Future Improvements

1. Consider adding more automated testing
2. Explore containerization for development environments
3. Investigate better backup strategies
4. Evaluate additional security hardening options