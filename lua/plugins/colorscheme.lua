return {
  "sainnhe/sonokai",
  priority = 1000,
  config = function()
    vim.g.sonokai_style = "shusia"
    vim.cmd.colorscheme("sonokai")
  end,
}
