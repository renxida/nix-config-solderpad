return {
  "neovim/nvim-lspconfig",
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  }
  -- Add any other plugins you want to use here
}
