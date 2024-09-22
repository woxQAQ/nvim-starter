return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'grug-far', 'spectre_panel' },
    },
    keys = {
      {
        '<leader>up',
        function()
          vim.g.autopairs_disable = not vim.g.autopairs_disable
          if vim.g.autopairs_disable then
            require('nvim-autopairs').disable()
            LazyVim.warn('Disabled auto pairs', { title = 'Option' })
          else
            require('nvim-autopairs').enable()
            LazyVim.info('Enabled auto pairs', { title = 'Option' })
          end
        end,
        desc = 'Toggle auto pairs',
      },
    },
    config = function(_, opts)
      local autopairs = require('nvim-autopairs')
      autopairs.setup(opts)
    end,
  },
}
