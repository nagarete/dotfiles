-- blink.cmp configuration with Tailwind CSS color support
-- This enables color preview in the completion menu for Tailwind classes

return {
  "saghen/blink.cmp",
  optional = true,
  opts = {
    completion = {
      menu = {
        draw = {
          -- Enable treesitter highlighting for better completion item display
          treesitter = { "lsp" },
          -- Configure components to show Tailwind colors
          components = {
            kind_icon = {
              text = function(ctx)
                -- Check if this is a Tailwind color completion item
                local tailwind_hack = require("blink.cmp.sources.lsp.hacks.tailwind")
                local hex_color = tailwind_hack.get_hex_color(ctx.item)
                if hex_color then
                  -- Return a colored circle icon for Tailwind colors
                  return "██"
                end
                -- Default behavior for non-Tailwind items
                return ctx.kind_icon .. ctx.icon_gap
              end,
              -- Set the highlight group to the actual color for Tailwind items
              highlight = function(ctx)
                local tailwind_hack = require("blink.cmp.sources.lsp.hacks.tailwind")
                local hex_color = tailwind_hack.get_hex_color(ctx.item)
                if hex_color then
                  -- Create a dynamic highlight group for this color
                  local hl_name = "TailwindColor_" .. hex_color:sub(2)
                  if vim.fn.hlID(hl_name) == 0 then
                    vim.api.nvim_set_hl(0, hl_name, { fg = hex_color, bg = hex_color })
                  end
                  return hl_name
                end
                -- Default highlight
                return ctx.kind_hl
              end,
            },
          },
        },
      },
    },
  },
}
