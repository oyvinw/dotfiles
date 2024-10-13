let mapleader = ' '
" vim.keymap.set("n", "<leader>ve", load_init_file)

set number
set clipboard+=unnamedplus
set background=dark
set backspace=2 

set smartcase
set ignorecase
set hlsearch

" Tab completion settings
set wildmode=full     " Wildcard matches show a list, matching the longe
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.6           " Ignore Go compiled files
set wildignore+=*.pyc         " Ignore Python compiled files
set wildignore+=*.rbc         " Ignore Rubinius compiled files
set wildignore+=*.swp         " Ignore vim backups

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fe <cmd>Telescope everything<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

call plug#begin()

" Colorschemes
Plug 'ellisonleao/gruvbox.nvim'
Plug 'xero/miasma.nvim'

Plug 'tpope/vim-commentary'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'ray-x/go.nvim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"
"Plug 'Verf/telescope-everything.nvim'
Plug 'oyvinw/telescope-everything.nvim'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'natecraddock/telescope-zf-native.nvim'

call plug#end()


colorscheme miasma

lua <<EOF

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

--require('telescope').load_extension("zf-native")
require('telescope').load_extension('everything')
require('telescope').setup {
	defaults = {
		path_display = {"truncate"}
	},
	    extensions = {
       		 everything = {

            es_path = "f:/utils/es.exe",
	    path = false,
	    parent = false,
	    parent_path = true,
            case_sensitity = false,
            match_path = true,
            sort = true,
            regex = false,
            offset = 0,
            max_results = 100,
        }
    },
}


require("mason").setup()

require('nvim-treesitter.configs').setup {
	ensure_installed = {'c', 'c_sharp', 'gdscript', 'rust', 'zig', 'go', 'xml', 'json', 'graphql', 'vim', 'lua'},
  highlight = { enable = true },
  indent = { enable = true }
}

-- Set up nvim-cmp.
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    
    -- Tab and Shift-Tab for navigating through completion menu
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For snippet support
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for `:` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')["rust_analyzer"].setup {
  capabilities = capabilities
}
require('lspconfig')["gdscript"].setup {
  capabilities = capabilities
}
require('lspconfig')["ccls"].setup {
  capabilities = capabilities
}
require('lspconfig')["csharp_ls"].setup {
  capabilities = capabilities
}
require('lspconfig')["gopls"].setup {
  capabilities = capabilities
}
EOF

