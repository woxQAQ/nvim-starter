return {
  -----------------------------------------------------------------------------
  -- Perform diffs on blocks of code
  {
    'AndrewRadev/linediff.vim',
    cmd = { 'Linediff', 'LinediffAdd' },
    keys = {
      { '<Leader>mdf', ':Linediff<CR>',          mode = 'x',              desc = 'Line diff' },
      { '<Leader>mda', ':LinediffAdd<CR>',       mode = 'x',              desc = 'Line diff add' },
      { '<Leader>mds', '<cmd>LinediffShow<CR>',  desc = 'Line diff show' },
      { '<Leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
    },
  },

  -----------------------------------------------------------------------------
  -- Delete surrounding function call
  {
    'AndrewRadev/dsf.vim',
    -- stylua: ignore
    keys = {
      { 'dsf', '<Plug>DsfDelete', noremap = true, desc = 'Delete Surrounding Function' },
      { 'csf', '<Plug>DsfChange', noremap = true, desc = 'Change Surrounding Function' },
    },
    init = function()
      vim.g.dsf_no_mappings = 1
    end,
  },
  -----------------------------------------------------------------------------
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'LazyVim',            words = { 'LazyVim' } },
        { path = 'lazy.nvim',          words = { 'LazyVim' } },
      },
    },
  },
  -- Manage libuv types with lazy. Plugin will never be loaded
  -- { 'Bilal2453/luvit-meta',      lazy = true },
  -- Add lazydev source to cmp
  {
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      table.insert(opts.sources, { name = 'lazydev', group_index = 0 })
    end,
  },
  -- Automatic indentation style detection
  { 'nmac427/guess-indent.nvim', lazy = false,          priority = 50, opts = {} },

  -- Display vim version numbers in docs
  { 'tweekmonster/helpful.vim',  cmd = 'HelpfulVersion' },

  -- An alternative sudo for Vim and Neovim
  { 'lambdalisue/suda.vim',      event = 'BufRead' },

  -----------------------------------------------------------------------------
  -- Ultimate undo history visualizer
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
    },
  },

  -----------------------------------------------------------------------------
  -- Search labels, enhanced character motions
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    vscode = true,
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        'ss',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash'
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter'
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash'
      },
      {
        'R',
        mode = { 'x', 'o' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search'
      },
      {
        '<C-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search'
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Jump to the edge of block
  {
    'haya14busa/vim-edgemotion',
    -- stylua: ignore
    keys = {
      {
        'gj',
        '<Plug>(edgemotion-j)',
        mode = { 'n', 'x' },
        desc = 'Move to bottom edge'
      },
      {
        'gk',
        '<Plug>(edgemotion-k)',
        mode = { 'n', 'x' },
        desc = 'Move to top edge'
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Distraction-free coding for Neovim
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      {
        '<Leader>zz',
        '<cmd>ZenMode<CR>',
        noremap = true,
        desc = 'Zen Mode'
      },
    },
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = vim.env.TMUX ~= nil },
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Code outline sidebar powered by LSP
  {
    'hedyhli/outline.nvim',
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = function()
      local defaults = require('outline.config').defaults
      local opts = {
        symbols = {
          icons = {},
          filter = vim.deepcopy(LazyVim.config.kind_filter),
        },
        keymaps = {
          up_and_jump = '<up>',
          down_and_jump = '<down>',
        },
      }

      for kind, symbol in pairs(defaults.symbols.icons) do
        opts.symbols.icons[kind] = {
          icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
      end
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Fancy window picker
  {
    's1n7ax/nvim-window-picker',
    event = 'VeryLazy',
    keys = function(_, keys)
      local pick_window = function()
        local picked_window_id = require('window-picker').pick_window()
        if picked_window_id ~= nil then
          vim.api.nvim_set_current_win(picked_window_id)
        end
      end

      local swap_window = function()
        local picked_window_id = require('window-picker').pick_window()
        if picked_window_id ~= nil then
          local current_winnr = vim.api.nvim_get_current_win()
          local current_bufnr = vim.api.nvim_get_current_buf()
          local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
          vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
          vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
        end
      end

      local mappings = {
        { 'sp', pick_window, desc = 'Pick window' },
        { 'sw', swap_window, desc = 'Swap picked window' },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      hint = 'floating-big-letter',
      show_prompt = false,
      filter_rules = {
        include_current_win = true,
        autoselect_one = true,
        bo = {
          filetype = { 'notify', 'noice', 'neo-tree-popup' },
          buftype = { 'prompt', 'nofile', 'quickfix' },
        },
      },
    },
  },
  {
    'dnlhc/glance.nvim',
    cmd = 'Glance',
    keys = {
      { 'gpd', '<cmd>Glance definitions<CR>' },
      { 'gpr', '<cmd>Glance references<CR>' },
      { 'gpy', '<cmd>Glance type_definitions<CR>' },
      { 'gpi', '<cmd>Glance implementations<CR>' },
    },
    opts = function()
      local actions = require('glance').actions
      return {
        folds = {
          fold_closed = '󰅂', -- 󰅂 
          fold_open = '󰅀', -- 󰅀 
          folded = true,
        },
        mappings = {
          list = {
            ['<C-u>'] = actions.preview_scroll_win(5),
            ['<C-d>'] = actions.preview_scroll_win(-5),
            ['sg'] = actions.jump_vsplit,
            ['sv'] = actions.jump_split,
            ['st'] = actions.jump_tab,
            ['p'] = actions.enter_win('preview'),
          },
          preview = {
            ['q'] = actions.close,
            ['p'] = actions.enter_win('list'),
          },
        },
      }
    end,
  }
}
