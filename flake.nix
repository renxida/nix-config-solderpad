{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
      inherit (self) outputs;
      lib = nixpkgs.lib;
      systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    commonModules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        {
          nixpkgs = {
            overlays = [
              outputs.overlays.additions
              outputs.overlays.modifications
              outputs.overlays.unstable-packages
            ];
            config = {
              allowUnfree = true;
            };
          };
        }
      ];
  in {
    overlays = import ./overlays { inherit inputs; };
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      
    nixosConfigurations = {

      # Define hosts
      solderpad = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };
        modules = commonModules ++ [
          (import ./hosts/solderpad/configuration.nix)
          {
            home-manager.users.cedar = import ./home-manager/home.nix;
          }
        ];
      };

      # You can add more hosts here following the same pattern
      # examplehost = lib.nixosSystem { ... };
    };
  };
}
