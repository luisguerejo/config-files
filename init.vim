set nocompatible
set showmatch
set ignorecase
set autoindent
set number
set wildmode=longest, list
filetype plugin indent on
set mouse=a
set clipboard=unnamedplus
set shiftwidth=4
set tabstop=4
set termguicolors
set noshowmode

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'connorholyday/vim-snazzy'
Plug 'andweeb/presence.nvim'
Plug 'dense-analysis/ale'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'wellle/context.vim'

call plug#end()

colorscheme snazzy
syntax on

let g:jedi#use_splits_not_buffers = "right"
let g:ale_linters = {
			\ 'rust' : ['analyzer'],
			\ 'go' : ['gopls'],
			\ }
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ }


if !has('gui_running')
	set t_Co=256
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
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  nvim_lsp.gopls.setup ({
    cmd = {"gopls", "serve"},
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
require("bufferline").setup{}
EOF
