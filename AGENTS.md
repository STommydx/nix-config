# AGENTS.md

This file provides context and instructions for AI coding agents working on this Nix configuration repository.

## Project Overview

This is a comprehensive Nix configuration repository for managing multiple systems and environments. It provisions and maintains Nix-powered machines across different platforms including NixOS, macOS (Darwin), and Windows Subsystem for Linux (WSL).

## Agent Instructions

### Key Commands for Working with This Repository

When making changes to this Nix configuration:

```bash
# Check the configuration for syntax and logical errors
nix flake check

# Build a specific host configuration
nix build .#<hostname>

# Apply NixOS configuration (for NixOS hosts)
sudo nixos-rebuild switch --flake ".#<hostname>"

# Apply Home Manager configuration (for Home Manager hosts)
home-manager switch --flake ".#<hostname>"

# Apply Darwin configuration (for macOS hosts)
darwin-rebuild switch --flake ".#<hostname>"

# Deploy to remote servers (requires deploy-rs setup)
deploy --skip-checksums
```

### Testing Guidelines

- Always run `nix flake check` before committing changes
- Test specific configurations before deployment
- For Home Manager configurations, use `home-manager switch --flake ".#<hostname>"`
- Avoid building in production during agent sessions

## Repository Structure

```
├── hosts/          # Host-specific configurations
│   ├── darwin/     # macOS configurations
│   ├── homeManager/ # Home Manager only configurations
│   └── nixos/      # NixOS configurations
├── modules/        # Reusable modules organized by platform
│   ├── darwin/     # macOS modules
│   ├── homeManager/ # Home Manager modules
│   └── nixos/      # NixOS modules
├── profiles/       # Combinations of modules for specific use cases
│   ├── darwin/     # macOS profiles
│   ├── homeManager/ # Home Manager profiles
│   └── nixos/      # NixOS profiles
├── systems/        # Hardware-specific configurations
├── users/          # User-specific configurations
├── tools/          # Installation and setup tools
└── secrets/        # Encrypted secrets (managed with sops-nix)
```

## Key Concepts

### Modular Architecture

- **Modules**: Reusable components that encapsulate specific functionality
- **Profiles**: Combinations of modules for specific use cases (devops, alltheway-desktop, etc.)
- **Hosts**: Machine-specific configurations that import relevant profiles
- **Systems**: Hardware-specific configurations

### Platform Support

- **NixOS**: Full system configurations for bare-metal and virtual machines
- **Darwin**: macOS configurations using nix-darwin
- **Home Manager**: User environment configurations that can be standalone or integrated

### Managed Systems

- Personal desktops and laptops
- Work machines
- Servers (Git server, DNS server, bastion host)
- Development environments
- Custom installer ISO

## Working with This Repository

### Making Changes

1. Understand the modular structure before making changes
2. Check if a change should be made in a module, profile, or host-specific file
3. Test changes with `nix flake check` before committing
4. Consider impact across different platforms and systems

### Common Tasks

- **Adding a new package**: Add to the appropriate module based on functionality
- **Configuring a new service**: Create or modify the relevant module
- **Adding a new host**: Create a new host configuration and import appropriate profiles
- **Modifying user settings**: Update the user configuration or relevant Home Manager profile

### Testing

- Use `nix flake check` to validate configurations
- Test specific configurations with `nix build .#<hostname>`
- For Home Manager configurations: `home-manager switch --flake ".#<hostname>"`

## Important Notes

### Secret Management

- Secrets are managed using sops-nix
- Never commit actual secrets to the repository
- Only age public keys should be in `.sops.yaml`

### Deployment

- Remote deployments are configured using deploy-rs
- Currently configured for gitdx and guardiandx hosts
- Deployments require proper SSH access and authentication

### System-Specific Considerations

- NixOS systems include full system configuration
- Darwin systems work alongside existing macOS configuration
- Home Manager can be used standalone or with NixOS/Darwin

## File Conventions

- Use `default.nix` for module and profile definitions
- Host-specific configurations go in `hosts/<platform>/<hostname>/default.nix`
- Hardware configurations go in `hardware-configuration.nix` files
- Disk configurations go in `disk-config.nix` files
- Service-specific configurations are often split into separate files

## Development Workflow

1. Make changes to appropriate modules or profiles
2. Test with `nix flake check`
3. If adding a new host, update `flake.nix` to include it in the appropriate host list
4. Test specific configurations before deployment
5. Use deploy-rs for remote deployments where configured

## Getting Help

- Refer to existing modules and profiles for examples
- Check the NixOS and Home Manager documentation
- Look at similar hosts for configuration patterns
- Use `nix flake show` to understand available configurations
