{ config, pkgs, ... }:

let
  chatsh = (builtins.getFlake "github:renxida/chatsh/57f077e6196eeff45896fb59e9d28a01c8af7667").packages.${pkgs.system}.default;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Cedar";
      userEmail = "cedar.ren@gmail.com";
    };
    neovim.enable = true;
    firefox.enable = true;
    rofi = {
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
    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 12;
      };
    };
  };

  home.username = "cedar";
  home.homeDirectory = "/home/cedar";

  home.packages = with pkgs; [
    (import ./vscode.nix { inherit pkgs; })
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
    chatsh
  ];

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

  home.sessionVariables = {
    CC = "clang";
    CXX = "clang++";
  };

  home.stateVersion = "24.05";
}
