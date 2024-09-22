return {
  -----------------------------------------------------------------------------
  -- Pretty lists to help you solve all code diagnostics
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { '<Leader>xx', '<cmd>Trouble diagnostics toggle<CR>',                    desc = 'Diagnostics (Trouble)' },
      { '<Leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',       desc = 'Buffer Diagnostics (Trouble)' },
      { '<Leader>xs', '<cmd>Trouble symbols toggle<CR>',                        desc = 'Symbols (Trouble)' },
      { '<Leader>xS', '<cmd>Trouble lsp toggle<CR>',                            desc = 'LSP references/definitions/... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                        desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                         desc = 'Quickfix List (Trouble)' },

      { 'gR',         function() require('trouble').open('lsp_references') end, desc = 'LSP References (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },
}
