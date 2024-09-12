return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  cmd = { "ToggleTerm" },
  build = ":ToggleTerm",
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  keys = {
    {
      "<C-/>",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 0, LazyVim.root.get(), "horizontal")
      end,
      desc = "Toggleterm (horizontal root_dir)",
    },
  },
  opts = {
    size = 20,
    shell = "pwsh",
    direction = "horizontal",
    shade_filetypes = {},
    hide_numbers = true,
    insert_mappings = true,
    terminal_mappings = true,
    start_in_insert = true,
    close_on_exit = true,
  },
}
