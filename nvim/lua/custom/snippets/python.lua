local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Добавим сниппет для Python
ls.add_snippets("python", {
  s("def", fmt("def {}({}):\n    {}    # TODO: Implement", { i(1, "function_name"), i(2, "args"), i(0) })),
})

