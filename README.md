# nix-env
My personal [Nix](https://nixos.org) home-manager configuration, used to bootstrap
development environments on my personal machines.

## Usage
To use this configuration, you'll need to install [Nix](https://nixos.org/nix/)
and [home-manager](https://nix-community.github.io/home-manager/index.html#ch-installation).

Then place the contents of `home.nix` into your `~/.config/nixpkgs/home.nix` file
and run `home-manager switch` to apply the configuration.
