-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open LazyExtras to browse and install plugin extras
vim.keymap.set("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })

-- Override :q to close buffers instead of quitting Neovim
vim.api.nvim_create_user_command("Q", function()
  local buf_count = #vim.fn.getbufinfo({ buflisted = 1 })
  
  if buf_count > 1 then
    -- Close current buffer but keep window
    vim.cmd("bdelete")
  else
    -- Last buffer - open dashboard instead of quitting
    vim.cmd("bdelete")
    if pcall(require, "snacks") then
      vim.schedule(function()
        require("snacks").dashboard.open()
      end)
    end
  end
end, { desc = "Close buffer or show dashboard" })

-- Make :q behave like :Q
vim.cmd([[cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() == 'q') ? 'Q' : 'q']])
