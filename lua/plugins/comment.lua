return {
  -----------------------------------------------------------------------------
  -- Set the commentstring based on the cursor location
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- Powerful line and block-wise commenting
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    -- stylua: ignore
    keys = {
      { '<Leader>V', '<Plug>(comment_toggle_blockwise_current)', mode = 'n', desc = 'Comment' },
      { '<Leader>V', '<Plug>(comment_toggle_blockwise_visual)',  mode = 'x', desc = 'Comment' },
    },
    opts = function(_, opts)
      local ok, tcc =
          pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if ok then
        opts.pre_hook = tcc.create_pre_hook()
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Highlight, list and search todo comments in your projects
  {
    'folke/todo-comments.nvim',
    event = 'LazyFile',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- stylua: ignore
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next Todo Comment'
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous Todo Comment'
      },
      {
        '<leader>xt',
        '<cmd>Trouble todo toggle<cr>',
        desc = 'Todo (Trouble)'
      },
      {
        '<leader>xT',
        '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>',
        desc = 'Todo/Fix/Fixme (Trouble)'
      },
      {
        '<leader>st',
        '<cmd>TodoTelescope<cr>',
        desc = 'Todo'
      },
      {
        '<leader>sT',
        '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
        desc = 'Todo/Fix/Fixme'
      },
    },
    opts = { signs = false },
  },
}
