{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chatsh = {
      url = "github:renxida/chatsh/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, chatsh, rust-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ rust-overlay.overlays.default ];
      };
    in {
      homeConfigurations = {
        xidaren2 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/home.nix
            {
              home = {
                username = "xidaren2";
                homeDirectory = "/home/xidaren2";
              };
            }
          ];
          extraSpecialArgs = { inherit chatsh; };
        };
        cedar = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/home.nix
            {
              home = {
                username = "cedar";
                homeDirectory = "/home/cedar";
              };
            }
          ];
          extraSpecialArgs = { inherit chatsh; };
        };
      };
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
              home-manager.extraSpecialArgs = { inherit chatsh; };
            }
          ];
          specialArgs = { inherit pkgs; };
        };
      };
    };
}
