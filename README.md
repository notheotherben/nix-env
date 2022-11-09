# nix-env
My personal [Nix](https://nixos.org) home-manager configuration, used to bootstrap
development environments on my personal machines.

## Usage
To use this configuration, you'll need to install [Nix](https://nixos.org/nix/) and then run the following commands:

```bash
# Install the activation package
nix build --no-link 'github:notheotherben/nix-env#homeConfigurations.bpannell.activationPackage'

# Activate the configuration
"$(nix path-info 'github:notheotherben/nix-env#homeConfigurations.bpannell.activationPackage')"/activate
```

In future, if you wish to update your configuration, you can run the following commands:

```bash
nix flake update github:notheotherben/nix-env
home-manager switch --flake 'github:notheotherben/nix-env#bpannell'
```