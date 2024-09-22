---@class util.cmp
local M = {}

M.snippet = require('luasnip')

local function get_cmp()
  local ok_cmp, cmp = pcall(require, "cmp")
  return ok_cmp and cmp or {}
end

-- Enables completion when the cursor is inside a word. If the completion
-- menu is visible it will navigate to the next item in the list. If the
-- line is empty it uses the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.tab_complete(select_opts)
  local cmp = get_cmp()
  return cmp.mapping(function(fallback)
    local col = vim.fn.col('.') - 1

    if cmp.visible() then
      cmp.select_next_item(select_opts)
    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      fallback()
    else
      cmp.complete()
    end
  end, { 'i', 's' })
end

-- If the completion menu is visible navigate to the previous item
-- in the list. Else, use the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.select_prev_or_fallback(select_opts)
  local cmp = get_cmp()
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item(select_opts)
    else
      fallback()
    end
  end, { 'i', 's' })
end

-- If the completion menu is visible it cancels the
-- popup. Else, it triggers the completion menu.
---@param opts {modes?: string[]}
function M.toggle_completion(opts)
  opts = opts or {}
  local cmp = get_cmp()

  return cmp.mapping(function()
    if cmp.visible() then
      cmp.abort()
    else
      cmp.complete()
    end
  end, opts.modes)
end

---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.supertab(select_opts)
  local cmp = get_cmp()
  return {
    i = function(fallback)
      local col = vim.fn.col('.') - 1
      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif M.snippet and M.snippet.active({ direction = 1 }) then
        M.snippet.jump(1)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end,
    s = function(fallback)
      if M.snippet and M.snippet.active({ direction = 1 }) then
        M.snippet.jump(1)
      else
        fallback()
      end
    end,
  }
end

function M.supertab_shift(select_opts)
  local cmp = get_cmp()
  return {
    i = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      elseif M.snippet and M.snippet.active({ direction = -1 }) then
        M.snippet.jump(-1)
      else
        fallback()
      end
    end,
    s = function(fallback)
      if M.snippet and M.snippet.active({ direction = -1 }) then
        M.snippet.jump(-1)
      else
        fallback()
      end
    end,
  }
end

function M.snippet_next(select_opts)
  local cmp = get_cmp()

  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item(select_opts)
    elseif M.snippet and M.snippet.active({ direction = 1 }) then
      M.snippet.jump(1)
    else
      fallback()
    end
  end, { 'i', 's' })
end

function M.snippet_jump_forward()
  local cmp = get_cmp()

  return cmp.mapping(function(fallback)
    if M.snippet and M.snippet.active({ direction = 1 }) then
      M.snippet.jump(1)
    else
      fallback()
    end
  end, { 'i', 's' })
end

function M.snippet_jump_backward()
  local cmp = get_cmp()

  return cmp.mapping(function(fallback)
    if M.snippet and M.snippet.active({ direction = -1 }) then
      M.snippet.jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' })
end

return M
