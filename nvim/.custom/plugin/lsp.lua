-- Список серверов LSP и общая настройка
local servers = { 'pyright', 'rust_analyzer', 'clangd', 'gopls', 'ts_ls' }
local nvim_lsp = require('lspconfig')
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({
    on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Key mappings
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'cr', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  })
end

-- Настройка диагностики
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})

local bufnr = vim.api.nvim_get_current_buf()
-- Показать диагностику в плавающем окне
vim.api.nvim_create_autocmd('CursorHold', {
  buffer = bufnr,
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})

