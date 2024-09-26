{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Use the configuration from the nvim directory
    extraLuaConfig = ''
      require('init')
    '';

    # Install lazy.nvim and Treesitter
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    ];

    extraPackages = with pkgs; [
      gcc  # Required for compiling Treesitter parsers
    ];
  };

  # Copy your Neovim config to the appropriate location
  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}