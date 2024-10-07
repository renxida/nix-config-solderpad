{ config, pkgs, ... }:

let 
  nvimConfig = import ./nvim.nix { inherit config pkgs; };
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  imports = [ nvimConfig ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Cedar";
      userEmail = "cedar.ren@gmail.com";
    };
    neovim = nvimConfig.programs.neovim;
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

  home.packages = with pkgs; [
    chatsh
    aider
    (import ./vscode.nix { inherit pkgs; })
    asciinema
    maestral
    maestral-gui
    discord
    curl
    gh
    azure-cli
    kitty
    xclip
    clang
    stdenv.cc.cc.lib  # Add this line to include libstdc++
    lld
    llvmPackages.libcxx
    cmake
    gnumake
    dropbox
    openssh
    rofi
    i3
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    i3status-rust
    aria2
    ag
    ripgrep
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
            block = "battery";
            format = " $icon $percentage {$time_remaining |} {$power |} ";
            charging_format = " $icon $percentage {$time_remaining |} {$power |}W Charging ";
          }
          {
            block = "time";
            interval = 60;
          }
        ];
      };
    };
  };

  home.sessionVariables = {
    CC = "clang";
    CXX = "clang++";
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
  };

  home.stateVersion = "24.05";
}
