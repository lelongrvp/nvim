return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = true,
  keys = {
    {
      "<C-/>",
      "<cmd>ToggleTerm<cr>",
      desc = "Toggle terminal",
      mode = { "n", "t" },
    },
  },
  opts = {
    size = 20,
    shell = "zsh",
    direction = "horizontal",
    shade_filetypes = {},
    hide_numbers = true,
    insert_mappings = true,
    terminal_mappings = true,
    start_in_insert = true,
    close_on_exit = true,
    persist_size = true,
    persist_mode = true,
  },
}
