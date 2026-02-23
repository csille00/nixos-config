{
  description = "Connor NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }:
  let
    mkHost = { name, user, system ? "x86_64-linux", extraModules ? [ ] }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${name}/configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./hosts/${name}/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ]
        ++ extraModules;
      };
  in {
    nixosConfigurations = {
      ellis-server = mkHost {
        name = "ellis-server";
        user = "ellisserver";
      };
      dell-xps = mkHost {
        name = "dell-xps";
        user = "connor-dell";
      };
      framework = mkHost {
        name = "framework";
        user = "connor-framework";
      };
    };
  };
}
