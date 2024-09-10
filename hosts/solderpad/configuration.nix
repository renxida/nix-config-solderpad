{hostname ? "solderpad", username ? "cedar"}:

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "solderpad";

  users.users.cedar = {
    isNormalUser = true;
    initialPassword = "$olderpad";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
  };

  # Add any host-specific configurations here
  # For example:
  # services.someService.enable = true;

  # You can also use lib.mkDefault for values that you want to be able to override easily:
  # networking.firewall.enable = lib.mkDefault false;
}