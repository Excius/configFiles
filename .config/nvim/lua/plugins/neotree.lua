return {
  "nvim-neo-tree/neo-tree.nvim",
  -- Configure filesystem to show hidden files
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files
        hide_dotfiles = false, -- Don't hide dotfiles
        hide_gitignored = false, -- Hide git ignored files
        hide_hidden = true, -- Only works on Windows for hidden files/directories
      },
    },
  },
}
