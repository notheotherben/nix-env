{
  description = "Home Manager configuration for Benjamin Pannell";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grey = {
        url = "github:SierraSoftworks/grey";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, grey, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system} // {
        config.allowUnfree = true;
      };
      username = "bpannell";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs system username;

        configuration = {
            nixpkgs.config.allowUnfree = true;
        };

        homeDirectory = "/Users/${username}";

        stateVersion = "22.05";

        extraModules = [ ./home.nix ];

        extraSpecialArgs = {
            extraPackages = [
                grey.packages.${system}.default
            ];
        };
      };
    };
}