-- ~/.config/nvim/lua/plugins/mappings.lua
return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "gl", function() vim.diagnostic.open_float({ scope = "line" }) end, desc = "Show line diagnostics" },
      },
    },
  },
}
