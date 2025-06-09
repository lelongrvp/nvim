# Neovim IDE Configuration

A powerful Neovim configuration that transforms Neovim into a full-featured IDE with support for C++, Java, Go, HTML, CSS, JavaScript, TypeScript, React, Next.js, and Vue.js.

## Prerequisites

Before using this configuration, ensure you have:

1. Neovim 0.8.0 or later
2. Git
3. A C compiler (like gcc) for treesitter
4. Node.js and npm (for LSP servers)
5. ripgrep (for telescope live grep)

## Features

- 🚀 Full LSP (Language Server Protocol) support
- 🎨 Syntax highlighting via Treesitter
- 📁 File explorer with Neo-tree
- 🔍 Fuzzy finding with Telescope
- 🎯 Auto-completion
- 📝 Git integration
- 💅 Modern UI with Gruvbox theme (dark hard contrast)
- ⚡ Fast startup with lazy loading
- 💻 Integrated terminal (toggleterm)

## Included Language Support

- C/C++ (clangd)
- Java (jdtls)
- Go (gopls)
- HTML/CSS
- JavaScript/TypeScript
- React (via TypeScript)
- Vue.js
- And more...

## Key Mappings

### General
- `<Space>` is the leader key
- `<leader>c`: Toggle keybindings cheat sheet (press Space then c)
- `<leader>h`: Clear search highlights
- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>e`: Toggle file explorer
- `Ctrl + h/j/k/l`: Navigate between splits

### Terminal
- `Ctrl + /`: Toggle terminal
- `Esc`: Exit terminal mode (return to normal mode)
- `Ctrl + h/j/k/l`: Navigate between terminal and editor windows
- Terminal opens horizontally from the bottom (30% of screen height)

### LSP
- `gd`: Go to definition
- `K`: Hover documentation
- `<leader>vws`: Workspace symbol search
- `<leader>vd`: Show diagnostics
- `[d` / `]d`: Previous/next diagnostic
- `<leader>vca`: Code action
- `<leader>vrr`: Show references
- `<leader>vrn`: Rename symbol
- `<C-h>` (in insert mode): Show signature help
- `gR`: Show all references in Trouble panel

### Diagnostics (Trouble)
- `<leader>xx`: Toggle trouble panel
- `<leader>xw`: Show workspace diagnostics
- `<leader>xd`: Show document diagnostics
- `<leader>xl`: Show location list
- `<leader>xq`: Show quickfix list

### Telescope
- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fb`: Find buffers
- `<leader>fh`: Help tags

## First-Time Setup

1. Start Neovim - it will automatically install lazy.nvim
2. Wait for all plugins to install
3. Run `:Mason` and ensure all language servers are installed
4. Restart Neovim

## Customization

The configuration is organized in `init.lua` with clear sections for:
- Basic settings
- Plugin specifications
- LSP configuration
- Key mappings
- Plugin-specific settings

Feel free to modify any section to match your preferences.

## Troubleshooting

If you encounter issues:
1. Run `:checkhealth` to diagnose problems
2. Ensure all prerequisites are installed
3. Update plugins with `:Lazy update`
4. Update language servers with `:Mason`
