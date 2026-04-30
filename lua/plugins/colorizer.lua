return {
  "norcalli/nvim-colorizer.lua",
  priority = 1000,
  config = function()
    require("colorizer").setup({ "*" })
  end,
}
