-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic Neovim Configuration

-- General Settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.mouse = 'a'           -- Enable mouse support
vim.opt.ignorecase = true     -- Ignore case in search
vim.opt.smartcase = true      -- But don't ignore it when search string contains uppercase
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.wrap = false          -- Don't wrap lines
vim.opt.breakindent = true    -- Preserve indentation in wrapped text
vim.opt.tabstop = 4           -- Number of spaces tabs count for
vim.opt.shiftwidth = 4        -- Size of an indent
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Insert indents automatically
vim.opt.termguicolors = true  -- True color support
vim.opt.showmode = false      -- Don't show mode since we have a statusline
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.backup = false        -- Don't create backup files
vim.opt.writebackup = false   -- Don't create backup files
vim.opt.swapfile = false      -- Don't create swap files
vim.opt.undofile = true       -- Enable persistent undo
vim.opt.updatetime = 300      -- Faster completion
vim.opt.timeoutlen = 500      -- By default timeoutlen is 1000 ms
vim.opt.completeopt = 'menuone,noselect' -- Better completion experience

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear search highlight
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Plugin Specifications
require("lazy").setup({
    -- LSP Support
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            {'L3MON4D3/LuaSnip'},
        }
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "cpp", "java", "go", "html", "css", "javascript", 
                    "typescript", "tsx", "vue", "lua"
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },

    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        }
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },

    -- Git integration
    'lewis6991/gitsigns.nvim',

    -- Theme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "hard",
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
            vim.o.background = 'dark'
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- Comment toggler
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },

    -- Diagnostics, references, trouble panel
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({
                position = "bottom",
                height = 10,
                padding = false,
                auto_preview = true,
                auto_fold = true,
                use_diagnostic_signs = true,
                action_keys = {
                    close = "q",
                    cancel = "<esc>",
                    refresh = "r",
                    jump = {"<cr>", "<tab>"},
                    toggle_mode = "m",
                    toggle_preview = "P",
                    hover = "K",
                    preview = "p",
                    close_folds = {"zM", "zm"},
                    open_folds = {"zR", "zr"},
                    toggle_fold = {"zA", "za"},
                    previous = "k",
                    next = "j"
                },
                signs = {
                    error = "",
                    warning = "",
                    hint = "",
                    information = "",
                    other = "﫠"
                },
            })

            -- Keymaps for Trouble
            vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
                {silent = true, noremap = true, desc = "Toggle trouble panel"}
            )
            vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
                {silent = true, noremap = true, desc = "Show workspace diagnostics"}
            )
            vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
                {silent = true, noremap = true, desc = "Show document diagnostics"}
            )
            vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
                {silent = true, noremap = true, desc = "Show location list"}
            )
            vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
                {silent = true, noremap = true, desc = "Show quickfix list"}
            )
            vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
                {silent = true, noremap = true, desc = "Show LSP references"}
            )
        end
    },

    -- Terminal
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            local powershell_options = {
                shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
                shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
                shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
                shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
                shellquote = "",
                shellxquote = "",
            }

            for option, value in pairs(powershell_options) do
                vim.opt[option] = value
            end

            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return vim.o.lines * 0.3
                    end
                end,
                open_mapping = [[<c-_>]], -- This is actually Ctrl+/, but needs to be mapped as Ctrl+_
                direction = 'horizontal',
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                close_on_exit = true,
                shell = powershell_options.shell,
            })

            -- Additional keymaps for terminal toggle
            vim.keymap.set({'n', 'i', 't'}, '<C-/>', '<CMD>ToggleTerm<CR>', {desc = 'Toggle terminal'})
        end
    },
})

-- Basic Key Mappings
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to below split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to above split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- LSP Keymaps
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
    
    local opts = {buffer = bufnr}
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
end)

-- Configure mason for LSP installer
require('mason').setup({
    ui = {
        check_outdated_packages_on_open = true,
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd',          -- C/C++
        'jdtls',          -- Java
        'gopls',          -- Go
        'html',           -- HTML
        'cssls',          -- CSS
        'eslint',         -- JavaScript/TypeScript linting
    },
    automatic_installation = false, -- Prevent automatic installation of missing servers
    handlers = {
        lsp.default_setup,
        -- Add custom handler for gopls
        gopls = function()
            local has_go = vim.fn.executable('go') == 1
            if has_go then
                require('lspconfig').gopls.setup({
                    capabilities = lsp.get_capabilities(),
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                        },
                    },
                })
            else
                vim.notify("Go is not installed. Please install Go to enable gopls.", vim.log.levels.WARN)
            end
        end,
    },
})

-- Telescope (Fuzzy Finder) setup
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Neo-tree setup
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>')

-- Lualine setup
require('lualine').setup {
    options = {
        theme = 'gruvbox'
    }
}

-- Gitsigns setup
require('gitsigns').setup()

-- Terminal keymaps
function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- Auto-command to set terminal keymaps when terminal opens
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Quality of life improvements
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Directory navigation
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', { desc = 'Change directory to current file' })
vim.keymap.set('n', '<leader>cD', ':cd<Space>', { desc = 'Change directory (prompt)' })

-- Code runner
vim.keymap.set('n', '<F5>', function()
    require('coderunner').run_code()
end, { desc = 'Run code' })

-- Cheat sheet toggle (moved to end after all plugins are loaded)
vim.keymap.set('n', '<leader>c', function()
    require('cheatsheet').toggle()
end, { desc = 'Toggle cheat sheet' })

-- Configure diagnostic display (inline errors like VS Code)
vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        source = "if_many",
        prefix = "●",
        spacing = 4,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
}) 
