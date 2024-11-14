return {
  "nvim-neo-tree/neo-tree.nvim",
  optional = true,
  opts = function(_, opts)
    opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
      or { "terminal", "Trouble", "qf", "Outline", "trouble" }
    table.insert(opts.open_files_do_not_replace_types, "edgy")

    -- Configure filesystem to show hidden files
    opts.filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files
        hide_dotfiles = false, -- Don't hide dotfiles
        hide_gitignored = true, -- Hide git ignored files
        hide_hidden = true, -- Only works on Windows for hidden files/directories
        hide_by_name = {
          -- Add specific filenames to hide if needed
        },
      },
    }
  end,
}
