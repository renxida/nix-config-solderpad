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
      pkgs = nixpkgs.legacyPackages.${system};

      lib = nixpkgs.lib;

      # Define the list of hosts
      hosts = [
        { name = "solderpad"; username = "cedar"; }
        # Add more hosts here as needed
      ];

      # Function to generate host configurations
      mkHost = { name, username }: lib.nixosSystem {
        inherit system;
        modules = [
          # Common NixOS configuration
          ./nixos/configuration.nix

          # Host-specific configuration
          (import ./hosts/${name}/configuration.nix { inherit name username; })

          # Home-manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home-manager/home.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (map
        (host: lib.nameValuePair host.name (mkHost host))
        hosts);
    };
}
