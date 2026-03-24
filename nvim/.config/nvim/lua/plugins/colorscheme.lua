return {
  -- Current active theme: solarized-osaka
  -- To switch: change LazyVim colorscheme in ~/.config/nvim/lua/config/lazy.lua
  -- or run :colorscheme <name> to preview live

  {
    "craftzdog/solarized-osaka.nvim",
    branch = "osaka",
    lazy = true,
    priority = 1000,
    opts = { transparent = true },
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
