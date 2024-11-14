-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set("n", "<leader>pv", ":Ex<CR>", { noremap = true, silent = true })
