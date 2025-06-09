local M = {}

-- Content of the cheat sheet
M.content = {
    ["General"] = {
        ["<Space>"] = "Leader key",
        ["<leader>w"] = "Save file",
        ["<leader>q"] = "Quit",
        ["<leader>e"] = "Toggle file explorer (Neo-tree)",
        ["<leader>h"] = "Clear search highlights",
        ["<leader>c"] = "Toggle this cheat sheet",
        ["<leader>cd"] = "Change directory to current file",
        ["<leader>cD"] = "Change directory (with prompt)",
        ["<C-h/j/k/l>"] = "Navigate between splits",
        ["j/k"] = "Move up/down (works with wrapped lines)",
    },

    ["Code Running"] = {
        ["F5"] = "Run current file (C++, Java, Go)",
        ["q"] = "Close runner window",
        ["<Esc>"] = "Exit runner terminal mode",
    },

    ["Terminal"] = {
        ["<C-/>"] = "Toggle terminal",
        ["<C-_>"] = "Alternative toggle terminal",
        ["<Esc>"] = "Exit terminal mode",
        ["<C-h/j/k/l>"] = "Navigate from terminal",
    },

    ["LSP (Code Intelligence)"] = {
        ["gd"] = "Go to definition",
        ["gR"] = "Show all references",
        ["K"] = "Show documentation hover",
        ["<leader>vws"] = "Search workspace symbols",
        ["<leader>vd"] = "Show diagnostics float",
        ["[d"] = "Go to previous diagnostic",
        ["]d"] = "Go to next diagnostic",
        ["<leader>vca"] = "Code action menu",
        ["<leader>vrr"] = "Show references",
        ["<leader>vrn"] = "Rename symbol",
        ["<C-h>"] = "Show signature help (in insert mode)",
    },

    ["Diagnostics (Trouble)"] = {
        ["<leader>xx"] = "Toggle trouble panel",
        ["<leader>xw"] = "Show workspace diagnostics",
        ["<leader>xd"] = "Show document diagnostics",
        ["<leader>xl"] = "Show location list",
        ["<leader>xq"] = "Show quickfix list",
        ["q"] = "Close trouble panel",
        ["<esc>"] = "Cancel action",
        ["r"] = "Refresh diagnostics",
        ["<enter>/tab"] = "Jump to diagnostic",
        ["K"] = "Show diagnostic details",
        ["p"] = "Preview diagnostic location",
    },

    ["File Navigation"] = {
        ["<leader>ff"] = "Find files (fuzzy finder)",
        ["<leader>fg"] = "Live grep (search in files)",
        ["<leader>fb"] = "Find buffers",
        ["<leader>fh"] = "Search help tags",
    },

    ["Git Integration"] = {
        ["<leader>gj"] = "Next git hunk",
        ["<leader>gk"] = "Previous git hunk",
        ["<leader>gh"] = "Preview git hunk",
        ["<leader>gb"] = "Blame line",
        ["<leader>gd"] = "Git diff view",
    },

    ["Comments"] = {
        ["gcc"] = "Toggle line comment",
        ["gbc"] = "Toggle block comment",
        ["gc"] = "Toggle line comment (with motion)",
        ["gb"] = "Toggle block comment (with motion)",
    },

    ["Window Management"] = {
        ["<C-w>v"] = "Split window vertically",
        ["<C-w>s"] = "Split window horizontally",
        ["<C-w>q"] = "Close current window",
        ["<C-w>="] = "Make all windows equal size",
        ["<C-w>>"] = "Increase window width",
        ["<C-w><"] = "Decrease window width",
        ["<C-w>+"] = "Increase window height",
        ["<C-w>-"] = "Decrease window height",
    },

    ["Text Objects"] = {
        ["w"] = "Word",
        ["s"] = "Sentence",
        ["p"] = "Paragraph",
        ["b"] = "Block/parentheses",
        ["B"] = "Block/curly braces",
        ["t"] = "HTML/XML tag",
    },

    ["Useful Commands"] = {
        [":Mason"] = "Open Mason (LSP installer)",
        [":Lazy"] = "Open plugin manager",
        [":checkhealth"] = "Run health check",
        [":TSUpdate"] = "Update treesitter parsers",
        [":LspInfo"] = "Show LSP status",
    }
}

-- Function to create the cheat sheet window
function M.create_window()
    -- Calculate window size
    local width = 60
    local height = 0
    
    -- Calculate content height
    for section, _ in pairs(M.content) do
        height = height + 1 -- Section title
        for _, _ in pairs(M.content[section]) do
            height = height + 1
        end
        height = height + 1 -- Empty line after section
    end

    -- Create the buffer
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Calculate position
    local win_height = vim.api.nvim_get_option("lines")
    local win_width = vim.api.nvim_get_option("columns")
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)

    -- Window options
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " 🔍 Neovim Cheat Sheet ",
        title_pos = "center",
    }

    -- Create window
    local win = vim.api.nvim_open_win(buf, true, opts)
    
    -- Set window options
    vim.api.nvim_win_set_option(win, "winblend", 10)
    vim.api.nvim_win_set_option(win, "cursorline", true)
    
    -- Buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    -- Generate content
    local lines = {}
    for section, bindings in pairs(M.content) do
        table.insert(lines, string.format("━━━ %s ━━━", section))
        for key, desc in pairs(bindings) do
            table.insert(lines, string.format("%-20s %s", key, desc))
        end
        table.insert(lines, "")
    end

    -- Set content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    -- Set keymaps for the cheat sheet buffer
    local close_keys = {'q', '<Esc>', '<C-c>', '<leader>c'}
    for _, key in ipairs(close_keys) do
        vim.api.nvim_buf_set_keymap(buf, 'n', key, ':close<CR>', {
            noremap = true,
            silent = true,
            nowait = true
        })
    end

    -- Set buffer local autocmd to close on cursor leave
    vim.api.nvim_create_autocmd({"BufLeave"}, {
        buffer = buf,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end,
    })
end

-- Toggle function
local cheatsheet_visible = false
function M.toggle()
    if cheatsheet_visible then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_option(buf, "buftype") == "nofile" then
                vim.api.nvim_win_close(win, true)
            end
        end
        cheatsheet_visible = false
    else
        M.create_window()
        cheatsheet_visible = true
    end
end

return M 