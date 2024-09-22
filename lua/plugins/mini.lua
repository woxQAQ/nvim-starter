return {
  {
    'echasnovski/mini.surround',
    -- stylua: ignore
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add,            desc = 'Add Surrounding',                     mode = { 'n', 'v' } },
        { opts.mappings.delete,         desc = 'Delete Surrounding' },
        { opts.mappings.find,           desc = 'Find Right Surrounding' },
        { opts.mappings.find_left,      desc = 'Find Left Surrounding' },
        { opts.mappings.highlight,      desc = 'Highlight Surrounding' },
        { opts.mappings.replace,        desc = 'Replace Surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = 'sa',             -- Add surrounding in Normal and Visual modes
        delete = 'ds',          -- Delete surrounding
        find = 'gzf',           -- Find surrounding (to the right)
        find_left = 'gzF',      -- Find surrounding (to the left)
        highlight = 'gzh',      -- Highlight surrounding
        replace = 'cs',         -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`
      },
    },
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        -- stylua: ignore
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' },                                                -- digits
          e = {                                                               -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          i = LazyVim.mini.ai_indent,                                -- indent
          g = LazyVim.mini.ai_buffer,                                -- buffer
          u = ai.gen_spec.function_call(),                           -- u for Usage
          U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
      LazyVim.on_load('which-key.nvim', function()
        vim.schedule(function()
          LazyVim.mini.ai_whichkey(opts)
        end)
      end)
    end,
  },
  -----------------------------------------------------------------------------
  -- Trailing whitespace highlight and remove
  {
    'echasnovski/mini.trailspace',
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      { '<Leader>cw', '<cmd>lua MiniTrailspace.trim()<CR>', desc = 'Erase Whitespace' },
    },
    opts = {},
  },
  -----------------------------------------------------------------------------
  -- Split and join arguments
  {
    'echasnovski/mini.splitjoin',
    -- stylua: ignore
    keys = {
      { 'sj', '<cmd>lua MiniSplitjoin.join()<CR>',  mode = { 'n', 'x' }, desc = 'Join arguments' },
      { 'sk', '<cmd>lua MiniSplitjoin.split()<CR>', mode = { 'n', 'x' }, desc = 'Split arguments' },
    },
    opts = {
      mappings = { toggle = '' },
    },
  },
}
