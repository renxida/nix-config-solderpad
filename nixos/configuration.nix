{ config, pkgs, lib, ... }:

{

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      flake-registry = "";
    };
    channel.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      git
      xclip
      clang
      llvmPackages.libcxx
      pamixer
      wireplumber
      brightnessctl
      unzip
    ];
    shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };
    variables = {
      CC = "clang";
      CXX = "clang++";
    };
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  networking.networkmanager.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+i3";
      };
      windowManager.i3.enable = true;
    };
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  security.rtkit.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
  ];

  system.stateVersion = "24.05";
}
