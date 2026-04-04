local discipline = require("craftzdog.discipline")

discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- ── VSCode-like keymaps ──────────────────────────────────────────────
-- Save: Ctrl+S
keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc>:w<CR>", opts)

-- Undo / Redo: Ctrl+Z / Ctrl+Shift+Z
keymap.set("n", "<C-z>", "u", opts)
keymap.set("i", "<C-z>", "<Esc>ui", opts)
keymap.set("n", "<C-S-z>", "<C-r>", opts)

-- Toggle comment: Ctrl+/  (uses gcc / gc from LazyVim)
keymap.set("n", "<C-/>", "gcc", { noremap = false, silent = true })
keymap.set("v", "<C-/>", "gc", { noremap = false, silent = true })

-- Find files: Ctrl+P
keymap.set("n", "<C-p>", "<cmd>lua Snacks.picker.files()<cr>", opts)

-- Find in file: Ctrl+F
keymap.set("n", "<C-f>", "<cmd>lua Snacks.picker.lines()<cr>", opts)

-- Toggle file explorer: Ctrl+B
keymap.set("n", "<C-b>", "<cmd>Neotree toggle<cr>", opts)

-- Toggle terminal: Ctrl+`
keymap.set({ "n", "t" }, "<leader>t", "<cmd>lua Snacks.terminal()<cr>", opts)

-- Close current tab: Ctrl+W
keymap.set("n", "<C-w>w", "<cmd>tabclose<cr>", opts)

-- Move lines up/down: Alt+Up / Alt+Down
keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", opts)
keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", opts)
keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", opts)
keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", opts)

-- Duplicate line: Alt+Shift+Down
keymap.set("n", "<A-S-Down>", "<cmd>t.<cr>", opts)

-- Shift+Arrow selection (VSCode-style)
keymap.set("n", "<S-Up>", "v<Up>", opts)
keymap.set("n", "<S-Down>", "v<Down>", opts)
keymap.set("n", "<S-Left>", "v<Left>", opts)
keymap.set("n", "<S-Right>", "v<Right>", opts)
keymap.set("v", "<S-Up>", "<Up>", opts)
keymap.set("v", "<S-Down>", "<Down>", opts)
keymap.set("v", "<S-Left>", "<Left>", opts)
keymap.set("v", "<S-Right>", "<Right>", opts)
keymap.set("i", "<S-Up>", "<Esc>v<Up>", opts)
keymap.set("i", "<S-Down>", "<Esc>v<Down>", opts)
keymap.set("i", "<S-Left>", "<Esc>v<Left>", opts)
keymap.set("i", "<S-Right>", "<Esc>v<Right>", opts)

-- Ctrl+Shift+Arrow: select by word/block
keymap.set("n", "<C-S-Left>", "vb", opts)
keymap.set("n", "<C-S-Right>", "ve", opts)
keymap.set("v", "<C-S-Left>", "b", opts)
keymap.set("v", "<C-S-Right>", "e", opts)

-- Ctrl+C to copy selection to system clipboard
keymap.set("v", "<C-c>", '"+y', opts)

-- Select all: already Ctrl+A above
-- ─────────────────────────────────────────────────────────────────────

-- ── Terminal scrolling (Claude Code in nvim) ─────────────────────────
-- Ctrl+Q exits terminal mode → normal mode (then use vim keys to scroll)
keymap.set("t", "<C-q>", [[<C-\><C-n>]], opts)
-- PageUp/PageDown scroll in terminal mode without leaving it
keymap.set("t", "<PageUp>", [[<C-\><C-n><C-u>]], opts)
keymap.set("t", "<PageDown>", [[<C-\><C-n><C-d>]], opts)
-- Ctrl+Up/Down for smaller scroll jumps from terminal mode
keymap.set("t", "<C-Up>", [[<C-\><C-n>5k]], opts)
keymap.set("t", "<C-Down>", [[<C-\><C-n>5j]], opts)
-- ─────────────────────────────────────────────────────────────────────

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
	require("craftzdog.hsl").replaceHexWithHSL()
end)

keymap.set("n", "<leader>i", function()
	require("craftzdog.lsp").toggleInlayHints()
end)
