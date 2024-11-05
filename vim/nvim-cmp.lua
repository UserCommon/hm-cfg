vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.pumheight = 10
vim.opt.updatetime = 1000
vim.opt.shortmess:append "c"

local nvim_lsp = require('lspconfig')
local lspkind = require "lspkind"

lspkind.init {}

local cmp = require "cmp"
cmp.setup {
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:CursorLine",
      col_offset = 0,  -- смещение по горизонтали
      side_padding = 0, -- отступы по бокам
      max_height = 10,  -- максимальная высота окна подсказок
      max_width = 60,   -- максимальная ширина окна подсказок (если нужно)
    },
    documentation = {
      border = 'rounded', -- стиль границы для окна документации
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behaviour = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behaviour = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      {"i", "c"}
    ),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  }
}

local ls = require "luasnip"
ls.config.set_config {
  history = false,
  updateevents = "TextChanged,TextChangedI"
}


for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("custom/snipppets/*.lua", true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {silent = true})

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, {silent = true})

-- Список серверов LSP и общая настройка
local servers = { 'pyright', 'rust_analyzer', 'clangd', 'gopls', 'ts_ls' }
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
