{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        solderpad = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/solderpad/configuration.nix
            {
              users.users.cedar = {
                home = "/home/cedar";
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" "bluetooth" "audio" "video" "docker"];
              };
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cedar = import ./home-manager/home.nix;
            }
          ];
        };
      };
    };
}
