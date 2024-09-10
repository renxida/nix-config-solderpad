{ name, username, ... }:

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = name;

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "$olderpad";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
  };

  # Add any host-specific configurations here
  # For example:
  # services.someService.enable = true;
}

