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
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
require('lazy').setup(
  {
    -- Comments ("gc").
    {
      'numToStr/Comment.nvim',
      lazy = false,
      config = function()
        require('Comment').setup()
      end
    },
    -- Escape from insert mode without delay.
    {
      'max397574/better-escape.nvim',
      config = function()
        require('better_escape').setup {
          mapping = { 'jk', 'jj' },
          clear_empty_lines = false,
          keys = '<Esc>'
        }
      end
    },
    -- Fuzzy-finding, buffer management.
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.4',
      config = function()
        require('telescope').setup {
          defaults = {
            sorting_strategy = 'ascending'
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = false,
              override_file_sorter = true,
              case_mode = 'smart_case'
            },
            file_browser = {
              hidden = true,
              hijack_netrw = true
            },
            undo = {
              side_by_side = true
            }
          }
        }
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('file_browser')
        require('telescope').load_extension('undo')
      end,
      keys = {
        { '<Leader>n',  function() require('telescope').extensions.file_browser.file_browser() end },
        { '<Leader>u',  function() require('telescope').extensions.undo.undo() end },
        { '<Leader>,',  function() require('telescope.builtin').buffers() end },
        { '<Leader>sf', function() require('telescope.builtin').find_files { previewer = false } end },
        { '<Leader>r',  function() require('telescope.builtin').git_files() end },
        { '<Leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end },
        { '<Leader>a',  function() require('telescope.builtin').live_grep() end },
        { '<Leader>st', function() require('telescope.builtin').treesitter() end },
        { '<Leader>so', function() require('telescope.builtin').oldfiles() end },
        { '<Leader>sd', function() require('telescope.builtin').diagnostics { bufnr = 0 } end },
        { '<Leader>sD', function() require('telescope.builtin').diagnostics() end },
        { '<Leader>gd', function() require('telescope.builtin').lsp_definitions() end },
        { '<Leader>gi', function() require('telescope.builtin').lsp_implementations() end },
        { '<Leader>gr', function() require('telescope.builtin').lsp_references() end }
      },
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
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup {
          options = {
            theme = 'onedark',
            globalstatus = true,
            icons_enabled = true,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' }
          }
        }
      end,
      dependencies = {
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
        'nvim-tree/nvim-web-devicons'
      }
    },
    -- Window resizing.
    {
      'mrjones2014/smart-splits.nvim',
      config = function()
        require('smart-splits').setup {
          default_amount = 3,
          resize_mode = {
            silent = true,
            quit_key = '<Esc>',
            resize_keys = { 'h', 'j', 'k', 'l' }
          }
        }
      end,
      keys = {
        { '<C-e>', function() require('smart-splits').start_resize_mode() end }
      }
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
      lazy = false,
      keys = {
        { '<Leader>f', function() vim.lsp.buf.format { async = true } end }
      },
      dependencies = {
        {
          'williamboman/mason-lspconfig.nvim',
          config = function()
            local lspconfig = require('lspconfig')
            local cmp_nvim_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('mason-lspconfig').setup {
              -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
              ensure_installed = {
                'lua_ls',
                'tsserver'
              },
              automatic_installation = true,
              handlers = {
                function(server)
                  lspconfig[server].setup(
                    {
                      capabilities = cmp_nvim_lsp_capabilities
                    }
                  )
                end,
                -- https://github.com/typescript-language-server/typescript-language-server
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
                ['tsserver'] = function()
                  lspconfig.tsserver.setup {
                    settings = {
                      completions = {
                        completeFunctionCalls = true
                      }
                    }
                  }
                end,
                -- https://github.com/luals/lua-language-server
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
                ['lua_ls'] = function()
                  lspconfig.lua_ls.setup {
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
                          library = vim.api.nvim_get_runtime_file('', true)
                        },
                        telemetry = {
                          enable = false
                        },
                        format = {
                          enable = true,
                          defaultConfig = {
                            -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                            -- Indentation has to come from editor: https://github.com/LuaLS/lua-language-server/wiki/Formatter
                            -- indent_style = 'space',
                            -- indent_size = '2',
                            trailing_table_separator = 'never',
                            quote_style = 'single'
                          }
                        }
                      }
                    }
                  }
                end
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
    },
    -- Autocompletion.
    {
      'hrsh7th/nvim-cmp',
      config = function()
        local cmp = require('cmp')
        cmp.setup {
          mapping = cmp.mapping.preset.insert(
            {
              ['<C-u>'] = cmp.mapping.scroll_docs(-4),
              ['<C-d>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
              },
              ['<Tab>'] = cmp.mapping(
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end,
                { 'i', 's' }
              ),
              ['<S-Tab>'] = cmp.mapping(
                function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  else
                    fallback()
                  end
                end,
                { 'i', 's' }
              )
            }
          ),
          sources = {
            { name = 'nvim_lsp' }
          }
        }
      end,
      dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' }
      }
    },

    -- Extensible UI for Neovim notifications and LSP progress messages.
    {
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup()
      end
    }
  }
)

---- ============================================================================
---- ===                             VIM OPTIONS                              ===
---- ============================================================================

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

-- Ctrl-a behaviour.
vim.keymap.set('', '<C-a>', '<Esc>ggVG<CR>')

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
vim.keymap.set('n', '<Leader>j', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>k', vim.diagnostic.goto_prev)

-- vim: ts=2 sts=2 sw=2 et
