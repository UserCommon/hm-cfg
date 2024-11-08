-- Настройка LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Добавление сниппетов
ls.add_snippets("tex", {
  s("sum", fmt("\\sum_{{{}}}^{{{}}} {{ {} }}", { i(1), i(2), i(0) })),
  s("frac", fmt("\\frac{{ {} }}{{ {} }}", { i(1), i(2) })),
  s("eq", fmt("\\begin{{equation}} \n {} \n\\end{{equation}}", { i(1) })),
  s("int", fmt("\\int_{{ {} }}^{{ {} }} {} \\, dx", { i(1), i(2), i(0) })),
  s("matrix", fmt("\\begin{{pmatrix}} \n {} \n\\end{{pmatrix}}", { i(1) })),
})

