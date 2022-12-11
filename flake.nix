{
  description = "Home Manager configuration for Benjamin Pannell";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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

  outputs = { nixpkgs, home-manager, git-tool, grey, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system} // {
        config.allowUnfree = true;
      };
      username = "bpannell";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];

        extraSpecialArgs = {
          username = username;
          stateVersion = "22.11";
          extraPackages = [
              grey.packages.${system}.default
              git-tool.packages.${system}.default
          ];
        };
      };
    };
}