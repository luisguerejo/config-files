vim.opt.shiftwidth = 8
vim.opt.softtabstop = 8
vim.opt.tabstop = 8
vim.opt.relativenumber = true
vim.opt.number = true
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.diagnostic.config({virtual_text = false})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	{"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
	{"f-person/git-blame.nvim", event = "VeryLazy"},
	{"chentoast/marks.nvim", event = "VeryLazy", opts = {}},
	{"tpope/vim-commentary"},
	{"wellle/context.vim"},
	{"preservim/nerdtree"},
	{"JoshPorterDev/nvim-base16", lazy = false },
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.inlay_hint.enable(true)
			vim.lsp.enable('rust_analyzer')
			vim.lsp.enable('gopls')

			vim.diagnostic.config({
				virtual_text = {
				  prefix = "●",
				  spacing = 4,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
		       })

			vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
			  local opts = { buffer = event.buf }
			  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			  vim.keymap.set("n", "<leader>f", function()
			    vim.lsp.buf.format { async = true }
			  end, opts)
			end,
		      })
		end
	},
	{
		"hrsh7th/nvim-cmp",
		 version = false, -- last release is way too old
		 event = "InsertEnter",
		 dependencies = {
		    "hrsh7th/cmp-nvim-lsp",
		    "hrsh7th/cmp-buffer",
		    "hrsh7th/cmp-path",
		 },
		 config = function()
			 local cmp = require("cmp")
			 cmp.setup({
				 snippet = {
					 expand = function() end,
				 },
				 mapping = cmp.mapping.preset.insert({
					 ["<Tab>"] = cmp.mapping.select_next_item(),
					 ["<S-Tab>"] = cmp.mapping.select_prev_item(),
					 ["<CR>"] = cmp.mapping.confirm({ select = true }),
					 ["<C-Space>"] = cmp.mapping.complete(),
				 }),
				 sources = cmp.config.sources({
					 { name = "nvim_lsp" },
				 }, {
					 { name = "buffer" },
					 { name = "path" },
				 }),
			 })
		 end,
	}
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "base16-gruvbox-dark-hard" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd.colorscheme("base16-gruvbox-dark-hard")
