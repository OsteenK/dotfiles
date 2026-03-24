# Neovim Keymaps Cheat Sheet

> **Tip:** Press `<Space>` and wait 1 second — `which-key` will pop up and show all available keybindings from that point.
> `<Leader>` = Space key

---

## Modes
| Key | Action |
|-----|--------|
| `i` | Insert mode (type text) |
| `Esc` or `Ctrl+c` | Back to Normal mode |
| `v` | Visual mode (select text) |
| `V` | Visual Line mode |
| `Ctrl+v` | Visual Block mode |
| `:` | Command mode |

---

## Moving Around (Normal Mode)
| Key | Action |
|-----|--------|
| `h j k l` | Left / Down / Up / Right |
| `w` | Jump forward one word |
| `b` | Jump backward one word |
| `e` | Jump to end of word |
| `0` | Start of line |
| `$` | End of line |
| `gg` | Top of file |
| `G` | Bottom of file |
| `Ctrl+d` | Scroll down half page |
| `Ctrl+u` | Scroll up half page |
| `{` / `}` | Jump between blank lines (paragraphs) |
| `%` | Jump to matching bracket |
| `*` | Search for word under cursor |

---

## Editing
| Key | Action |
|-----|--------|
| `x` | Delete character (no register) |
| `dd` | Delete line |
| `dw` | Delete word backwards |
| `yy` | Copy line |
| `p` | Paste after |
| `P` | Paste before |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `o` | New line below, enter insert |
| `O` | New line above, enter insert |
| `A` | Go to end of line, insert |
| `I` | Go to start of line, insert |
| `ciw` | Change inner word |
| `cit` | Change inside tag |
| `di"` | Delete inside quotes |
| `>>`/ `<<` | Indent / unindent line |
| `=G` | Auto-indent from cursor to end |
| `+` | Increment number under cursor |
| `-` | Decrement number under cursor |

---

## Search & Replace
| Key | Action |
|-----|--------|
| `/word` | Search forward |
| `?word` | Search backward |
| `n` / `N` | Next / previous match |
| `:%s/old/new/g` | Replace all in file |
| `Ctrl+j` | Jump to next diagnostic error |

---

## Registers (Clipboard)
| Key | Action |
|-----|--------|
| `<Leader>p` | Paste from yank register (not cut) |
| `<Leader>d` | Delete without affecting clipboard |
| `<Leader>c` | Change without affecting clipboard |
| `Ctrl+a` | Select all |

---

## Splits & Tabs
| Key | Action |
|-----|--------|
| `ss` | Split horizontally |
| `sv` | Split vertically |
| `sh / sj / sk / sl` | Move between splits (left/down/up/right) |
| `Ctrl+w` + arrow | Resize split |
| `te` | New tab |
| `Tab` | Next tab |
| `Shift+Tab` | Previous tab |

---

## File Explorer (Neo-tree)
| Key | Action |
|-----|--------|
| `<Leader>e` | Toggle file explorer |
| `<Leader>E` | Focus file explorer |
| (inside explorer) `a` | Create file/folder |
| (inside explorer) `d` | Delete |
| (inside explorer) `r` | Rename |

---

## Fuzzy Finder (Telescope)
| Key | Action |
|-----|--------|
| `<Leader><Space>` | Find files |
| `<Leader>/` | Search in current file |
| `<Leader>fg` | Live grep (search in all files) |
| `<Leader>fb` | Browse open buffers |
| `<Leader>fr` | Recent files |
| `<Leader>fs` | Find symbol in workspace |

---

## LSP (Code Intelligence)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover docs (press twice to enter the popup) |
| `<Leader>ca` | Code actions |
| `<Leader>cr` | Rename symbol |
| `<Leader>cf` | Format file |
| `[d` / `]d` | Previous / next diagnostic |
| `<Leader>cd` | Show diagnostic detail |

---

## Git (Gitsigns)
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous hunk |
| `<Leader>ghs` | Stage hunk |
| `<Leader>ghr` | Reset hunk |
| `<Leader>ghb` | Blame line |
| `<Leader>ghd` | Diff this file |

---

## Useful Extras
| Key | Action |
|-----|--------|
| `<Leader>i` | Toggle inlay hints |
| `<Leader>cs` | Symbols outline (right panel) |
| `<Leader>cc` | Generate code annotation |
| `gcc` | Comment/uncomment line |
| `gc` (visual) | Comment/uncomment selection |
| `za` | Toggle fold |
| `zi` | Toggle all folds |

---

## Live Cheat Sheet
Press `<Space>` and **wait** — which-key shows what's available.
Press `<Space>?` to see all keymaps.
