return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", function() 
        local ok, oil = pcall(require, "oil")
        if ok then
          oil.toggle_float()
        else
          vim.notify("Oil not available", vim.log.levels.ERROR)
        end
      end, desc = "Oil File Explorer" },
    },
    config = function(_, opts)
      require("oil").setup(opts)
    end,
    -- Note: Auto-open disabled to let Neo-tree be default for nvim .
    -- Use <leader>e to open Oil manually
  },
}