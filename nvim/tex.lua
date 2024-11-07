vim.g.vimtex_view_method = "zathura"
-- From: https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt#L4671-L4713
vim.o.foldmethod = "expr"
vim.o.foldexpr="vimtex#fold#level(v:lnum)"
vim.o.foldtext="vimtex#fold#text()"
-- I like to see at least the content of the sections upon opening
vim.o.foldlevel=2

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        disable = { "latex", },
    },
})

-- Minimal lsp config
local lspconfig = require("lspconfig")
lspconfig.texlab.setup {}

