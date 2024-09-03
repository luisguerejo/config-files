set ignorecase
set autoindent
set number
set wildmode=longest, list
filetype plugin indent on
set mouse=a
set clipboard=unnamedplus
set shiftwidth=2
set tabstop=2
set termguicolors
set noshowmode
set relativenumber

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
" Themes
Plug 'connorholyday/vim-snazzy'
Plug 'rebelot/kanagawa.nvim'
Plug 'rose-pine/neovim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'JoshPorterDev/nvim-base16'
" LSP
Plug 'dense-analysis/ale'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'f-person/git-blame.nvim'
Plug 'vigoux/ltex-ls.nvim'
" More LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'ray-x/lsp_signature.nvim'
" QOL
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'wellle/context.vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production'}
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'andweeb/presence.nvim'
Plug 'chentoast/marks.nvim'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-commentary'

call plug#end()

colorscheme base16-gruvbox-dark-medium
syntax on

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let g:ale_linters = {
			\ 'rust' : ['analyzer'],
			\ 'go' : ['gopls'],
			\ 'python' : ['pylsp', 'pylint', 'pyright'],
			\ 'c' : ['clangd'],
			\ 'c++' : ['clangd'],
			\ 'sh' : ['language-server'],
			\ 'tex' : ['texlab', 'ltex']}

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ }

if !has('gui_running')
	set t_Co=256
endif
if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  " screen does not (yet) support truecolor
  set termguicolors
endif
lua <<EOF
  -- Set up nvim-cmp.
  local root_dir = vim.fn.getcwd()
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  -- Set up lspconfig.
  	local nvim_lsp = require'lspconfig'
	local util = require('lspconfig/util')
	nvim_lsp.ltex.setup{}
	nvim_lsp.pyright.setup {}
	nvim_lsp.gopls.setup ({ -- GO
    cmd = {"gopls"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  })
	nvim_lsp.ltex.setup{
		use_spellfile = false,
		window_border = 'single',
	}
	nvim_lsp.tsserver.setup{} -- JavaScipt
  nvim_lsp.texlab.setup{} -- Latex
  nvim_lsp.pylsp.setup{} -- Python lsp
  nvim_lsp.clangd.setup{} -- C-lang LSP
  nvim_lsp.rust_analyzer.setup({ -- Rust LSP
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})
	vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

	-- Buffer local mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local opts = { buffer = ev.buf }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<space>wl', function()
	  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<space>f', function()
	  vim.lsp.buf.format { async = true }
	end, opts)
	end,
})

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "cpp", "rust", "go", "latex", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
	matchup = {
		enable = true
	}
}
  vim.api.nvim_create_autocmd('FileType', { -- BASH lsp
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})
require("lsp_signature").setup{}
require("bufferline").setup{}
require("marks").setup{}
EOF
