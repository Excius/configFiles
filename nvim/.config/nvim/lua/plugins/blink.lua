-- ~/.config/nvim/lua/plugins/blink.lua
return {
	"saghen/blink.cmp",
	opts = {
		keymap = {
			preset = "super-tab",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<CR>"] = { "select_and_accept", "fallback" },
		},
		completion = {
			list = {
				selection = { auto_insert = false },
			},
		},
	},
}
