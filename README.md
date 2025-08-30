# nix-env

My personal [Nix](https://nixos.org) home-manager configuration, used to bootstrap
development environments on my personal machines.

```bash
sudo darwin-rebuild switch --flake .#
```

## Usage

To use this configuration, you'll need to install [Nix](https://nixos.org/nix/) and then run the following commands:

```bash
# Install the nix-darwin package
nix run nix-darwin -- switch --flake github:notheotherben/nix-env

# Install the home-manager activation package
nix build --no-link 'github:notheotherben/nix-env#homeConfigurations.sierra-mbp.activationPackage'

# Activate the configuration
"$(nix path-info 'github:notheotherben/nix-env#homeConfigurations.sierra-mbp.activationPackage')"/activate
```

In future, if you wish to update your configuration, you can run the following commands:

```bash
nix flake update --flake 'github:notheotherben/nix-env'

nix run nix-darwin -- switch --flake github:notheotherben/nix-env

# Build the flake using concurrent builders
nix build --no-link 'github:notheotherben/nix-env#homeConfigurations.sierra-mbp.activationPackage' -j auto

home-manager switch --flake 'github:notheotherben/nix-env#sierra-mbp'
```
