local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Summation Snippet
  s("sum", {
    t("\\sum_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("} "), i(0),
  }),

  -- Integral Snippet
  s("int", {
    t("\\int_{"), i(1, "a"), t("}^{"), i(2, "b"), t("} "), i(3, "\\, dx"), i(0),
  }),

  -- Fraction Snippet
  s("frac", {
    t("\\frac{"), i(1, "numerator"), t("}{"), i(2, "denominator"), t("} "), i(0),
  }),

  -- Aligned Equation Environment Snippet
  s("align", {
    t("\\begin{align}"), t({"", "\t"}), i(1),
    t({"", "\\end{align}"}), i(0),
  }),
}
