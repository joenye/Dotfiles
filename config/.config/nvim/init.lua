-- ============================================================================
-- ===                                 TIPS                                 ===
-- ============================================================================

-- :LspInfo
-- :LspInstallInfo
-- :TSModuleInfo
-- :TSUpdate
-- :checkhealth
-- :PackerSync
-- See https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins

-- ============================================================================
-- ===                               PLUGINS                                ===
-- ============================================================================

-- Install packer, if not already installed.
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- Automatically run :PackerCompile whenever plugins.lua is updated.
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

require('packer').startup(function(use)
  -- Package management.
  use 'wbthomason/packer.nvim'

  -- Comments ("gc").
  use 'numToStr/Comment.nvim'

  -- Fuzzy-finding, buffer management.
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Theme.
  use 'ful1e5/onedark.nvim'
  use 'xiyaowong/nvim-transparent'

  -- File explorer.
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
  }

  -- Status line.
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

  -- Undo tree.
  use 'mbbill/undotree'

  -- Window resizing (<C-e>).
  use 'simeji/winresizer'

  -- Return to last place in file upon re-opening.
  use 'farmergreg/vim-lastplace'

  -- Exit insert mode with configurable keys ("jj").
  use 'max397574/better-escape.nvim'

  -- Stabilise buffer content on window open/close.
  use 'luukvbaal/stabilize.nvim'

  -- Add indentation guides to all lines (including empty lines).
  use 'lukas-reineke/indent-blankline.nvim'

  -- Markdown preview.
  use 'ellisonleao/glow.nvim'

  -- Treesitter.
  use 'nvim-treesitter/nvim-treesitter'

  -- LSP client and sources.
  use {
    'williamboman/nvim-lsp-installer',
    'neovim/nvim-lspconfig'
  }
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
end)

-- ============================================================================
-- ===                             VIM OPTIONS                              ===
-- ============================================================================

-- Smart searching.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable line numbers.
vim.b.lnstatus = 'nonumber'

-- Hide last command.
vim.o.showcmd = false

-- Hides buffers instead of closing them.
vim.o.hidden = true

-- Number of lines for command line.
vim.o.cmdheight = 1

-- Enable mouse.
vim.o.mouse = 'a'

-- Automatically re-read file if external change detected.
vim.o.autoread = true

-- Keep backups centrally and don't litter swp files everywhere.
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath('config') .. '/backup'
vim.o.swapfile = true
vim.o.directory = vim.fn.stdpath('config') .. '/swap'
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('config') .. '/undo'

-- Show preview of changes when using :substitute.
vim.o.inccommand = 'nosplit'

-- Enable true colour support.
vim.o.termguicolors = true

-- Decrease default 4 seconds wait time (for example, lint updates).
vim.o.updatetime = 250
vim.o.signcolumn = 'yes'

-- Enable break indent.
vim.o.breakindent = true

-- Don't give completion messages like "match 1 of 2" or "the only match".
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Preview window appears at bottom.
vim.o.splitbelow = true

-- Disable displaying mode on cmdline (lualine already shows it).
vim.o.showmode = false

-- Set completeopt to have a better completion experience.
vim.o.completeopt = 'menuone,noselect'

-- Use only filetype.lua and do not load filetype.vim at all.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- ============================================================================
-- ===                                  REMAPS                              ===
-- ============================================================================

-- Use space as leader key.
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Ctrl-a behaviour.
vim.keymap.set('', '<C-a>', '<ESC>ggVG<CR>')

-- Unsets the "last search pattern" upon return.
vim.keymap.set('n', '<CR>', ':noh<CR><CR>')

-- Always search forwards with n and search backwards with N.
vim.keymap.set('n', '<expr> n', 'Nn[v:searchforward]')
vim.keymap.set('n', '<expr> N', 'nN[v:searchforward]')

-- Reverses default behaviour so that j and k move down/up by display lines,
-- while gj and gk move by real lines.
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gk', 'k')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'gj', 'j')

-- Use ctrl-[hjkl] to select the active split.
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { silent = true })

-- Handle word wrapping.
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostics.
vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev)

-- Telescope.
vim.keymap.set('n', ',', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>sf', function() -- Search Files.
  require('telescope.builtin').find_files { previewer = false }
end)
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').git_files) -- Search (Git) Workspace.
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find) -- Search (current) Buffer.
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep) -- Search Grep.
vim.keymap.set('n', '<leader>st', require('telescope.builtin').treesitter) -- Search Treesitter (current buffer).
vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles) -- Search Old files.
vim.keymap.set('n', '<leader>sd', function() -- Search Diagnostics (current buffer only).
  require('telescope.builtin').diagnostics { bufnr = 0 }
end)
vim.keymap.set('n', '<leader>sD', require('telescope.builtin').diagnostics) -- Search Diagnostics (all buffers).
vim.keymap.set('n', '<leader>gd', require('telescope.builtin').lsp_definitions) -- Go to Definitions.
vim.keymap.set('n', '<leader>gi', require('telescope.builtin').lsp_implementations) -- Go to Implementations.
vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references) -- Go to References.
local telescope_mappings = {
  i = {
    ['<C-u>'] = false,
    ['<C-d>'] = false,
  },
}

-- Treesitter.
local treesitter_incremental_selection_mappings = {
  init_selection = 'gnn',
  node_incremental = 'grn',
  scope_incremental = 'grc',
  node_decremental = 'grm',
}

-- LSP.
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(_, bufnr)
  -- Enable completion triggered by "<c-x><c-o>".
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
  -- TODO: https://github.com/neovim/neovim/issues/18371 must resolve for range formatting.
  vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
end



-- nvim-tree.
vim.keymap.set('n', '-', ':lua require("nvim-tree").open_replacing_current_buffer()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
local nvim_tree_mappings = {
  { key = '<CR>', action = 'edit_in_place' },
  { key = 'u', action = 'dir_up' },
}

-- nvim-cmp.
local cmp = require 'cmp'
local nvim_cmp_mappings = cmp.mapping.preset.insert({
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
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
})

-- ============================================================================
-- ===                               PLUGIN CONFIG                          ===
-- ============================================================================

-- Enable theme.
require('onedark').setup {
  transparent = true,
  transparent_sidebar = true,
}
require('transparent').setup {
  enable = true
}

-- Set statusbar.
require('lualine').setup {
  options = {
    theme = 'onedark-nvim',
    globalstatus = true,
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
}

-- Enable Comment.nvim.
require('Comment').setup()

-- Enable stabilize.nvim.
require('stabilize').setup()

-- Enable better escape.
require('better_escape').setup()

-- Highlight on yank.
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Indent blankline.
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Telescope.
require('telescope').setup {
  defaults = {
    mappings = telescope_mappings,
  },
}
require('telescope').load_extension 'fzf'

-- Treesitter.
require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  ignore_install = { 'phpdoc' },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = treesitter_incremental_selection_mappings,
  },
  indent = {
    enable = true,
  },
}

-- nvim-tree.
require 'nvim-tree'.setup {
  hijack_cursor = true,
  hijack_netrw = true,
  disable_netrw = true,
  view = {
    mappings = {
      list = nvim_tree_mappings
    },
  },
  git = {
    ignore = false, -- Show .gitignore files by default.
  }
}

-- Enable completions from LSP.
cmp.setup {
  mapping = nvim_cmp_mappings,
  sources = {
    { name = 'nvim_lsp' },
  },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- ============================================================================
-- ===                           LSP PLUGIN CONFIG                          ===
-- ============================================================================

-- LSP plugins to automatically install.
require('nvim-lsp-installer').setup({
  ensure_installed = { 'sumneko_lua', 'tsserver' },
  automatic_installation = true,
  ui = {
    icons = {
      server_installed = '✓',
      server_pending = '➜',
      server_uninstalled = '✗'
    }
  }
})

-- lua-language-server (https://github.com/sumneko/lua-language-server).
-- require 'lspconfig'.sumneko_lua.setup {
--   on_attach = on_attach,
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' }
--       },
--       format = {
--         -- Override via project .editorconfig.
--         -- TODO: https://github.com/sumneko/lua-language-server/issues/1068 must resolve to work.
--         defaultConfig = {
--           indent_style = 'space',
--           indent_size = '2',
--         }
--       },
--       telemetry = {
--         enable = false,
--       }
--     }
--   }
-- }

-- tsserver (https://github.com/Microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29).
require 'lspconfig'.tsserver.setup {
  on_attach = on_attach,
}


-- TODO: https://github.com/sumneko/lua-language-server/issues/1068 must resolve before we can remove.
-- vim: ts=2 sts=2 sw=2 et
