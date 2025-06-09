local M = {}

-- Terminal handling
local function create_term()
    local term = require('toggleterm.terminal').Terminal:new({
        hidden = true,
        direction = "horizontal",
        size = function()
            return vim.o.lines * 0.3
        end,
        on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n>", {noremap = true, silent = true})
        end,
    })
    return term
end

-- Build and run commands for different languages
local runners = {
    cpp = {
        build = function(file)
            local out = vim.fn.expand('%:r') .. '.exe'
            return string.format('g++ -std=c++17 "%s" -o "%s"', file, out)
        end,
        run = function(file)
            local out = vim.fn.expand('%:r') .. '.exe'
            return string.format('"%s"', out)
        end
    },
    java = {
        build = function(file)
            return string.format('javac "%s"', file)
        end,
        run = function(file)
            local classname = vim.fn.expand('%:r')
            return string.format('java %s', classname)
        end
    },
    go = {
        build = function(file)
            return string.format('go build "%s"', file)
        end,
        run = function(file)
            return string.format('go run "%s"', file)
        end
    }
}

-- Save the current buffer
local function save_buffer()
    vim.cmd('write')
end

-- Function to run code
function M.run_code()
    local filetype = vim.bo.filetype
    local runner = runners[filetype]
    
    if not runner then
        vim.notify(string.format("Running not supported for filetype: %s", filetype), vim.log.levels.WARN)
        return
    end

    -- Save the current buffer
    save_buffer()
    
    local file = vim.fn.expand('%:p')
    local term = create_term()

    -- Build and run
    term:toggle()
    
    if runner.build then
        local build_cmd = runner.build(file)
        term:send(build_cmd)
    end
    
    if runner.run then
        local run_cmd = runner.run(file)
        term:send(run_cmd)
    end
end

return M 