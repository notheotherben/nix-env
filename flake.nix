{
  description = "Darwin configuration for Benjamin Pannell";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-tool = {
        url = "github:SierraSoftworks/git-tool";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # grey = {
    #     url = "github:SierraSoftworks/grey";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
    # somo = {
    #   url = "github:theopfr/somo?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  }:
    let
      system = "aarch64-darwin";
      username = "bpannell";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      darwinConfigurations.sierra-mbp = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;

            home-manager.extraSpecialArgs = {
              username = username;
              stateVersion = "25.05";
            };
          }
        ];

        inputs = {
          username = username;
          system = system;
          extraPackages = [
              inputs.git-tool.packages.${system}.default
              # inputs.grey.packages.${system}.default
              # inputs.somo.outputs.packages.${system}.default
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
          stateVersion = "25.05";
        };
      };
    };
}
