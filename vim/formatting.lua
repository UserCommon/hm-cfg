require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    nix = { "nixfmt" },
    ocaml = { "ocamlformat" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    rust = { "clippy" }
  },
})
