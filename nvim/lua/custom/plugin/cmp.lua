vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.pumheight = 10
vim.opt.updatetime = 1000
vim.opt.shortmess:append "c"

local lspkind = require "lspkind"

lspkind.init {}

local cmp = require "cmp"

cmp.setup {
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "cody" },
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
      vim.snippet.expand(args.body)
    end
  }
}

