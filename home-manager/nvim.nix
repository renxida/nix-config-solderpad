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
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
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

  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua/plugins.lua".source = ./nvim/lua/plugins.lua;
  xdg.configFile."nvim/lua/plugin-config.lua".source = ./nvim/lua/plugin-config.lua;
}
