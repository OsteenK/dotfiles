return {
  -- Current active theme: solarized-osaka
  -- To switch: change LazyVim colorscheme in ~/.config/nvim/lua/config/lazy.lua
  -- or run :colorscheme <name> to preview live

  {
    "craftzdog/solarized-osaka.nvim",
    branch = "osaka",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      on_highlights = function(hl, c)
        -- Strong diff backgrounds (VC-style: visible on transparent bg)
        hl.DiffAdd = { bg = "#1a3a2a", fg = "#a6e3a1", bold = true } -- green bg
        hl.DiffDelete = { bg = "#3a1a1a", fg = "#f38ba8", bold = true } -- red bg
        hl.DiffChange = { bg = "#1a2a3a", fg = "#89b4fa", bold = true } -- blue bg (changed lines)
        hl.DiffText = { bg = "#3a3a1a", fg = "#f9e2af", bold = true } -- yellow bg (changed text within line)
      end,
    },
  },

  -- Tokyo Night (dark blue, very popular)
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = { transparent = true, style = "night" }, -- styles: night, storm, moon, day
  },

  -- Catppuccin (soft pastel colors)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
    },
  },

  -- Rose Pine (warm, muted tones)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    opts = { variant = "moon", disable_background = true },
  },

  -- Gruvbox (earthy, retro feel)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = { transparent_mode = true },
  },
}
