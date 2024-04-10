{
  description = "Darwin configuration for Benjamin Pannell";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-tool = {
        url = "github:SierraSoftworks/git-tool";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    grey = {
        url = "github:SierraSoftworks/grey";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nix-darwin, git-tool, grey, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system} // {
        config.allowUnfree = true;
      };
      username = "bpannell";
    in {
      darwinConfigurations.sierra-mbp = nix-darwin.lib.darwinSystem {
        inherit pkgs;

        modules = [
          ./configuration.nix
        ];

        specialArgs = {
          system = system;
          extraPackages = [
              grey.packages.${system}.default
              git-tool.packages.${system}.default
          ];
        };
      };
    };
}