return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "left",
        width = 40,
      },
    },
    keys = {
      { "<leader>f e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    },
    -- Auto-open Neo-tree when nvim starts with a directory
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Open Neo-tree when nvim starts with a directory",
        once = true,
        callback = function()
          -- Check if nvim was started with a directory argument
          if vim.fn.argc() > 0 then
            local arg = vim.fn.argv(0)
            local stats = vim.uv.fs_stat(arg)
            if stats and stats.type == "directory" then
              -- Change to the directory and open Neo-tree
              vim.cmd.cd(arg)
              require("neo-tree.command").execute({ action = "show", dir = vim.fn.getcwd() })
            end
          end
        end,
      })
    end,
  },
}