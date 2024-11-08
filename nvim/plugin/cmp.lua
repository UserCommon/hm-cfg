vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.pumheight = 10
vim.opt.updatetime = 1000
vim.opt.shortmess:append "c"

local lspkind = require "lspkind"

lspkind.init {}

local cmp = require "cmp"
local ls = require "luasnip"

require("luasnip.loaders.from_vscode").lazy_load()
ls.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "cody" },
    { name = "path" },
    { name = "buffer" },
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
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
}

ls.config.set_config {
  history = false,
  updateevents = "TextChanged,TextChangedI"
}

-- Doesn't work because of nix moment
local paths = vim.api.nvim_get_runtime_file("custom/snippets/*.lua", true)
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("custom/snippets/*.lua", true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })

-- Snippets because home-manager makes everything hard to make.
-- TODO: Remake whole configuration!
-- local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("latex", {
  -- Sum snippet
  s("sum", fmt("\\sum_{{{}}}^{{{}}} {{ {} }}", { i(1), i(2), i(0) })),

  -- Fraction snippet
  s("frac", fmt("\\frac{{ {} }}{{ {} }}", { i(1), i(2) })),

  -- Equation snippet
  s("eq", fmt("\\begin{{equation}} \n {} \n\\end{{equation}}", { i(1) })),

  -- Integral snippet (fixed escape sequences)
  s("int", fmt("\\int_{{ {} }}^{{ {} }} {} \\, dx", { i(1), i(2), i(0) })),

  -- Matrix snippet
  s("matrix", fmt("\\begin{{pmatrix}} \n {} \n\\end{{pmatrix}}", { i(1) })),
})

