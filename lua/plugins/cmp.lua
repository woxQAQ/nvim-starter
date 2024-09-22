return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    main = 'lazyvim.util.cmp',
    dependencies = {
      -- nvim-cmp source for neovim builtin LSP client
      'hrsh7th/cmp-nvim-lsp',
      -- nvim-cmp source for buffer words
      'hrsh7th/cmp-buffer',
      -- nvim-cmp source for path
      'hrsh7th/cmp-path',
      -- nvim-cmp source for emoji
      'hrsh7th/cmp-emoji',
    },
    opts = function()
      vim.api.nvim_set_hl(
        0,
        'CmpGhostText',
        { link = 'Comment', default = true }
      )
      local cmp         = require('cmp')
      local defaults    = require("cmp.config.default")()
      local util        = require('util')
      local auto_select = false
      return {
        auto_brackets = {},
        completion = {
          completeopt = 'meni,menuone,noinsert' ..
              (auto_select and '' or ',noselect')
        },
        preselect = auto_select
            and cmp.PreselectMode.Item
            or cmp.PreselectMode.None,
        view = {
          entries = { follow_cursor = true },
        },
        sorting = defaults.sorting,
        experimental = {
          ghost_text = {
            hl_group = 'Comment',
          },
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 50 },
          { name = 'path',     priority = 40 },
        }, {
          { name = 'buffer', priority = 50, keyword_length = 3 },
          { name = 'emoji',  insert = true, priority = 20 },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = auto_select }),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<S-CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ['<C-CR>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Tab>'] = util.cmp.supertab({
            behavior = require('cmp').SelectBehavior.Select,
          }),
          ['<S-Tab>'] = util.cmp.supertab_shift({
            behavior = require('cmp').SelectBehavior.Select,
          }),
          ['<C-j>'] = util.cmp.snippet_jump_forward(),
          ['<C-k>'] = util.cmp.snippet_jump_backward(),
          ['<C-d>'] = cmp.mapping.select_next_item({ count = 5 }),
          ['<C-u>'] = cmp.mapping.select_prev_item({ count = 5 }),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-c>'] = function(fallback)
            cmp.close()
            fallback()
          end,
          ['<C-e>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end),
        }),
        formatting = {
          format = function(entry, item)
            -- Prepend with a fancy icon from config.
            local icons = LazyVim.config.icons.kinds
            if entry.source.name == 'git' then
              item.kind = icons.misc.git
            else
              local icon = icons.kinds[item.kind]
              if icon ~= nil then
                item.kind = icon .. item.kind
              end
            end
            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
              end
            end
            return item
          end,
        },
      }
    end
  },
  {
    'nvim-cmp',
    dependencies = {
      {
        'garymjr/nvim-snippets',
        opts = {
          friendly_snippets = true,
        },
        dependencies = {
          -- Preconfigured snippets for different languages
          'rafamadriz/friendly-snippets',
        },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          return vim.cmp.expand(item.body)
        end,
      }
      if LazyVim.has('nvim-snippets') then
        table.insert(opts.sources, { name = 'snippets' })
      end
    end,
  },
}
