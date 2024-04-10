{
  description = "Darwin configuration for Benjamin Pannell";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, git-tool, grey, ... }:
    let
      system = "aarch64-darwin";
      username = "bpannell";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      darwinConfigurations.sierra-mbp = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
        ];

        inputs = {
          username = username;
          system = system;
          extraPackages = [
              grey.packages.${system}.default
              git-tool.packages.${system}.default
          ];
        };
      };

      homeConfigurations.sierra-mbp = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];

        extraSpecialArgs = {
          username = username;
          stateVersion = "23.11";
        };
      };
    };
}