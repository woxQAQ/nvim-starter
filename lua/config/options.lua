-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

local g = vim.g
local o = vim.opt

local sudoUser = function()
  local USER = vim.env.USER or ''
  local SUDO_USER = vim.env.SUDO_USER or ''
  if
      SUDO_USER ~= '' and USER ~= SUDO_USER
      and vim.env.HOME ~= vim.fn.expand('~' .. USER, true)
      and vim.env.HOME == vim.fn.expand('~' .. SUDO_USER, true)
  then
    vim.opt_global.modeline = false
    vim.opt_global.undofile = false
    vim.opt_global.swapfile = false
    vim.opt_global.backup = false
    vim.opt_global.writebackup = false
    vim.opt_global.shadafile = 'NONE'
  end
end

local useG = function()
  g.mapleader = ' '
  g.autoformat = false
  g.root_spec = { ".lsp", { ".git", "lua" }, "cwd" }
  g.lazygit_config = true

  g.loaded_python3_provider = 0
  g.loaded_perl_provider = 0
  g.loaded_ruby_provider = 0
  g.loaded_node_provider = 0

  g.markdown_recommended_style = 0
end

local useO = function()
  o.title = true
  o.titlestring = '%<%F%=%l/%L - nvim'
  o.mouse = "nv"
  o.virtualedit = "block"
  o.confirm = true
  o.conceallevel = 2
  o.signcolumn = 'yes'

  o.spelllang = 'en'
  o.spelloptions:append("camel")
  o.spelloptions:append('noplainbuffer')

  o.updatetime = 200

  o.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  o.completeopt = 'menu,menuone,noselect'
  o.wildmode = "logest:full,full"

  o.diffopt:append({ 'indent-heuristic', 'algorithm:patience' })

  o.textwidth = 80
  o.tabstop = 2
  o.smartindent = true
  o.shiftwidth = 2
  o.shiftround = true

  o.undofile = true
  o.undolevels = 10000
  o.writebackup = false

  sudoUser()

  o.ignorecase = true
  o.smartcase = true
  o.inccommand = "nosplit"
  o.jumpoptions = 'view'

  o.wrap = false
  o.linebreak = true
  o.breakindent = true
  o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

  o.formatoptions = o.formatoptions - 'a' - 't' + 'c' + 'q' - 'o' + 'r' + 'n' + 'j' + 'z'

  o.termguicolors = true
  o.shortmess:append({ W = true, I = true, c = true })
  o.showcmd = false
  o.showmode = false
  o.laststatus = 3
  o.scrolloff = 4
  o.sidescroll = 8
  o.numberwidth = 2
  o.number = true
  o.ruler = false
  o.list = true
  o.foldlevel = 99
  o.cursorline = true
  o.splitbelow = true
  o.splitright = true
  o.splitkeep = 'screen'

  o.cmdheight = 0
  o.colorcolumn = '+0'
  o.showtabline = 2
  o.helpheight = 30
  o.winheight = 1
  o.winminheight = 1
  o.pumblend = 10
  o.pumheight = 10

  o.showbreak = '⤷  '
  o.listchars = {
    tab = '  ',
    extends = '⟫',
    precedes = '⟪',
    conceal = '',
    nbsp = '␣',
    trail = '·'
  }
  o.fillchars = {
    foldopen = '', -- 󰅀 
    foldclose = '', -- 󰅂 
    fold = ' ', -- ⸱
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft = '┫',
    vertright = '┣',
    verthoriz = '╋',
  }
  o.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
end

vim.filetype.add({
  filename = {
    Brewfile = 'ruby',
    justfile = 'just',
    Justfile = 'just',
    ['.buckconfig'] = 'toml',
    ['.flowconfig'] = 'ini',
    ['.jsbeautifyrc'] = 'json',
    ['.jscsrc'] = 'json',
    ['.watchmanconfig'] = 'json',
    ['helmfile.yaml'] = 'yaml',
    ['todo.txt'] = 'todotxt',
    ['yarn.lock'] = 'yaml',
  },
  pattern = {
    ['%.config/git/users/.*'] = 'gitconfig',
    ['%.kube/config'] = 'yaml',
    ['.*%.js%.map'] = 'json',
    ['.*%.postman_collection'] = 'json',
    ['Jenkinsfile.*'] = 'groovy',
  },
})

useG()
useO()
