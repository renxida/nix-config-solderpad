# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "cedar";
    homeDirectory = "/home/cedar";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    vscode
    firefox
    discord
    curl
    gh
    azure-cli
    docker
    kitty
    xclip
    clang
    llvmPackages.libcxx
    cmake
    gnumake
    dropbox
    openssh
    rofi
    i3
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    i3status-rust
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Cedar";
    userEmail = "cedar.ren@gmail.com";
  };

  programs.firefox.enable = true;
  programs.rofi = {
    enable = true;
    theme = "Monokai";
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Papirus";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };
  programs.kitty = {
    enable = true;
    font.name = "FiraCode Nerd Font";
    font.size = 12;
  };
  xsession.windowManager.i3 = {
    enable = true;
    extraConfig = builtins.readFile ./i3-config;
    config = {
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
        }
      ];
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        theme = "Monokai";
        icons = "awesome5";
        settings = {
          theme = {
            overrides = {
              separator = " | ";
              separator_bg = "auto";
              separator_fg = "auto";
            };
          };
        };
        blocks = [
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "memory";
            format = " $icon $mem_total_used_percents.eng(w:2) ";
            format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
            format = " $icon $available.eng(w:2) ";
          }
          {
            block = "net";
            format = " $icon {$signal_strength $ssid $frequency|Disconnected} ";
            format_alt = " $icon {$ip|Disconnected} ";
            interval = 5;
          }
	  {
            block = "sound";
	    step_width = 5;
	  }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %m-%d %R') ";
          }
        ];
      };
    };
  };

  # Set Clang as the default C compiler
  home.sessionVariables = {
    CC = "clang";
    CXX = "clang++";
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
