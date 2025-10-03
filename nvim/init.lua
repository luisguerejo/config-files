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

vim.opt.relativenumber = true
vim.opt.number = true
vim.cmd.colorscheme("base16-gruvbox-dark-hard")
vim.lsp.enable('rust_analyzer')
