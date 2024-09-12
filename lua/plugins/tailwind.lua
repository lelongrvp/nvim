return {
  "neovim/nvim-lspconfig",
  opt = {
    servers = {
      tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        root_dir = require("lspconfig/util").root_pattern(
          "tailwind.config.js",
          "tailwind.config.ts",
          "tailwind.config.cjs",
          "tailwind.config.mjs",
          "tailwind.config.json"
        ),
        settings = {
          tailwindCSS = {
            validate = true,
          },
        },
      },
    },
  },
}
