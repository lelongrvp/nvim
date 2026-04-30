return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = false, -- Don't automatically reveal/focus files in tree
      },
      bind_to_cwd = false, -- Don't change tree root when cwd changes
      hijack_netrw_behavior = "open_current",
    },
    window = {
      position = "left",
    },
  },
}
