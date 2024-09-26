{ config, pkgs, ... }:

let
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" ];
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      require('init')
    '';
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-nix
        tree-sitter-lua
        tree-sitter-rust
        tree-sitter-python
        # Add more languages as needed
      ]))
    ];
    extraPackages = with pkgs; [
      gcc  # Required for compiling Treesitter parsers
      rustToolchain
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted  # Includes HTML, CSS, JSON LSPs
      lua-language-server
      pyright  # Python LSP
      nil  # Nix LSP
    ];
  };

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };

  home.packages = with pkgs; [
    rustfmt
    clippy
  ];
}