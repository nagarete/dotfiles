return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- New telescope keymaps
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
      
      -- Override default LazyVim keymaps to new mappings
      { "<leader>sf", "<leader>ff", desc = "Find Files (Search)", remap = true },
      { "<leader>sg", "<leader>fg", desc = "Find Grep (Search)", remap = true },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
}