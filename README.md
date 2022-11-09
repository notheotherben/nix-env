# nix-env
My personal [Nix](https://nixos.org) home-manager configuration, used to bootstrap
development environments on my personal machines.

## Usage
To use this configuration, you'll need to install [Nix](https://nixos.org/nix/) and then run the following commands:

```bash
export NIXPKGS_ALLOW_UNFREE=1

# Install the activation package
nix build --no-link 'github:notheotherben/nix-env#homeConfigurations.bpannell.activationPackage' --impure

# Activate the configuration
"$(nix path-info 'github:notheotherben/nix-env#homeConfigurations.bpannell.activationPackage' --impure)"/activate
```

In future, if you wish to update your configuration, you can run the following commands:

```bash
nix flake update 'github:notheotherben/nix-env'

export NIXPKGS_ALLOW_UNFREE=1
home-manager switch --flake 'github:notheotherben/nix-env#bpannell' --impure
```