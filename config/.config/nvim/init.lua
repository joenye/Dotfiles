-- ============================================================================
-- ===                                 TIPS                                 ===
-- ============================================================================

-- :LspInfo
-- :LspInstallInfo
-- :TSModuleInfo
-- :TSUpdate
-- :checkhealth
-- :MasonLog
-- :Mason
-- :Lazy

-- ============================================================================
-- ===                               PLUGINS                                ===
-- ============================================================================

-- Install lazy.nvim, if not already installed.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
require('lazy').setup({
  -- Comments ("gc").
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      require('Comment').setup()
    end
  },

  -- Fuzzy-finding, buffer management.
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    config = function()
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          },
          file_browser = {
            theme = "ivy",
            hidden = true,
            hijack_netrw = true
          },
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8
            }
          }
        }
      }
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('file_browser')
      require('telescope').load_extension('undo')
      vim.keymap.set('n', '<leader>n', require('telescope').extensions.file_browser.file_browser)
      vim.keymap.set('n', '<leader>u', require('telescope').extensions.undo.undo)
    end,
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
      {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-tree/nvim-web-devicons'
        }
      },
      {
        'debugloop/telescope-undo.nvim'
      }
    }
  },

  -- Theme.
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        style = 'dark',
        transparent = true
      }
      require('onedark').load()
    end
  },
  {
    'xiyaowong/nvim-transparent',
    lazy = false
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'navarasu/onedark.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'onedark-nvim',
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' }
        }
      }
    end
  },

  -- Window resizing.
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup {
        default_amount = 3,
        resize_mode = {
          silent = true,
          quit_key = '<ESC>',
          resize_keys = { 'h', 'j', 'k', 'l' }
        }
      }
      vim.keymap.set('n', '<leader>e', require('smart-splits').start_resize_mode)
    end
  },

  -- Add indentation guides to all lines (including empty lines).
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup()
    end
  },

  -- Treesitter.
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
          'lua'
        },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm'
          }
        },
        indent = {
          enable = true
        }
      }
    end
  },

  -- Language Servers.
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- https://github.com/luals/lua-language-server
      require('lspconfig').lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = {
                'vim'
              }
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {
              enable = false
            },
            format = {
              enable = true,
              defaultConfig = {
                -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                -- Indentation has to come from editor (see last line of file).
                -- indent_style = 'space',
                -- indent_size = '2',
                trailing_table_separator = 'never'
              }
            }
          }
        }
      }
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
    end,
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        config = function()
          require('mason-lspconfig').setup {
            ensure_installed = {
              'lua_ls'
            }
          }
        end,
        dependencies = {
          {
            'williamboman/mason.nvim',
            config = function()
              require('mason').setup()
            end
          }
        }
      }
    }
  }
})

--  use 'hrsh7th/nvim-cmp'
--  use 'hrsh7th/cmp-nvim-lsp'
--end)
--
---- ============================================================================
---- ===                             VIM OPTIONS                              ===
---- ============================================================================
--
-- Smart searching.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Hide last command.
vim.o.showcmd = false

-- Hides buffers instead of closing them.
vim.o.hidden = true

-- Number of lines for command line.
vim.o.cmdheight = 1

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

---- Use only filetype.lua and do not load filetype.vim at all.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Highlight on yank.
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end
})

---- ============================================================================
---- ===                                  REMAPS                              ===
---- ============================================================================
--
---- Use space as leader key.
--vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
--vim.g.mapleader = ' '
--vim.g.maplocalleader = ' '
--
---- Ctrl-a behaviour.
--vim.keymap.set('', '<C-a>', '<ESC>ggVG<CR>')
--
---- Unsets the "last search pattern" upon return.
--vim.keymap.set('n', '<CR>', ':noh<CR><CR>')
--
---- Always search forwards with n and search backwards with N.
--vim.keymap.set('n', '<expr> n', 'Nn[v:searchforward]')
--vim.keymap.set('n', '<expr> N', 'nN[v:searchforward]')
--
---- Reverses default behaviour so that j and k move down/up by display lines,
---- while gj and gk move by real lines.
--vim.keymap.set('n', 'k', 'gk')
--vim.keymap.set('n', 'gk', 'k')
--vim.keymap.set('n', 'j', 'gj')
--vim.keymap.set('n', 'gj', 'j')
--
-- Use ctrl-[hjkl] to select the active split.
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { silent = true })
--
---- Handle word wrapping.
--vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
--vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
--
---- Diagnostics.
--vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)
--vim.keymap.set('n', '<leader>k', vim.diagnostic.goto_prev)
--
---- Telescope.
--vim.keymap.set('n', ',', require('telescope.builtin').buffers)
--vim.keymap.set('n', '<leader>sf', function() -- Search Files.
--  require('telescope.builtin').find_files { previewer = false }
--end)
--vim.keymap.set('n', '<leader>sw', require('telescope.builtin').git_files) -- Search (Git) Workspace.
--vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find) -- Search (current) Buffer.
--vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep) -- Search Grep.
--vim.keymap.set('n', '<leader>st', require('telescope.builtin').treesitter) -- Search Treesitter (current buffer).
--vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles) -- Search Old files.
--vim.keymap.set('n', '<leader>sd', function() -- Search Diagnostics (current buffer only).
--  require('telescope.builtin').diagnostics { bufnr = 0 }
--end)
--vim.keymap.set('n', '<leader>sD', require('telescope.builtin').diagnostics) -- Search Diagnostics (all buffers).
--vim.keymap.set('n', '<leader>gd', require('telescope.builtin').lsp_definitions) -- Go to Definitions.
--vim.keymap.set('n', '<leader>gi', require('telescope.builtin').lsp_implementations) -- Go to Implementations.
--vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references) -- Go to References.
--local telescope_mappings = {
--  i = {
--    ['<C-u>'] = false,
--    ['<C-d>'] = false,
--  },
--}
--
---- LSP.
--local opts = { noremap = true, silent = true }
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
--
--local on_attach = function(_, bufnr)
--  -- Enable completion triggered by "<c-x><c-o>".
--  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--  vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
--  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
--  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
--  vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
--  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
--  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
--  -- TODO: https://github.com/neovim/neovim/issues/18371 must resolve for range formatting.
--  vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
--end
--
---- nvim-tree.
--vim.keymap.set('n', '-', ':lua require("nvim-tree").open_replacing_current_buffer()<CR>', { noremap = true, silent = true })
--vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
--local nvim_tree_mappings = {
--  { key = '<CR>', action = 'edit_in_place' },
--  { key = 'u', action = 'dir_up' },
--}
--
---- nvim-cmp.
--local cmp = require 'cmp'
--local nvim_cmp_mappings = cmp.mapping.preset.insert({
--  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--  ['<C-f>'] = cmp.mapping.scroll_docs(4),
--  ['<C-Space>'] = cmp.mapping.complete(),
--  ['<CR>'] = cmp.mapping.confirm {
--    behavior = cmp.ConfirmBehavior.Replace,
--    select = true,
--  },
--  ['<Tab>'] = cmp.mapping(function(fallback)
--    if cmp.visible() then
--      cmp.select_next_item()
--    else
--      fallback()
--    end
--  end, { 'i', 's' }),
--  ['<S-Tab>'] = cmp.mapping(function(fallback)
--    if cmp.visible() then
--      cmp.select_prev_item()
--    else
--      fallback()
--    end
--  end, { 'i', 's' }),
--})
--
---- ============================================================================
---- ===                               PLUGIN CONFIG                          ===
---- ============================================================================

---- Enable better escape.
--require('better_escape').setup()
--
---- Highlight on yank.
--local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
--vim.api.nvim_create_autocmd('TextYankPost', {
--  callback = function()
--    vim.highlight.on_yank()
--  end,
--  group = highlight_group,
--  pattern = '*',
--})

---- Enable completions from LSP.
--cmp.setup {
--  mapping = nvim_cmp_mappings,
--  sources = {
--    { name = 'nvim_lsp' },
--  },
--}
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- vim: ts=2 sts=2 sw=2 et
