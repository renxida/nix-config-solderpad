{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
    # Add other modules specific to solderpad here
  ];

  # Add solderpad-specific configurations here
  networking.hostName = "solderpad";

  # You can override or add to common configurations here
}
