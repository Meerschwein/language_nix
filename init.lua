-- mod-version:3
-- https://nixos.wiki/wiki/Overview_of_the_Nix_Language
local syntax = require "core.syntax"

local function combine_patterns(t1, t2)
  local temp = { table.unpack(t1) }
  for _, t in ipairs(t2) do
    table.insert(temp, t)
  end
  return temp
end

local function merge_tables(a, b)
  for _, v in pairs(b) do
    table.insert(a, v)
  end
end

local default_symbols = {
  ["import"]   = "keyword2",
  ["with"]     = "keyword2",
  ["builtins"] = "keyword2",
  ["inherit"]  = "keyword2",
  ["assert"]   = "keyword2",
  ["let"]      = "keyword2",
  ["in"]       = "keyword2",
  ["rec"]      = "keyword2",
  ["if"]       = "keyword",
  ["else"]     = "keyword",
  ["then"]     = "keyword",
  ["true"]     = "literal",
  ["false"]    = "literal",
  ["null"]     = "literal",
}

local default_patterns = {}
local doubleQuoteString = {}
local multilineString = {}
local stringInterpolation = {}


merge_tables(stringInterpolation, {
  { pattern = {"%${", "}"}, type = "keyword2", syntax = {
    patterns = default_patterns,
    symbols = default_symbols,
  }},
  { pattern = '[%S][%w]*', type = "string" },
})

merge_tables(doubleQuoteString, {
  { pattern = { '"', '"'}, type = "string", syntax = {
    patterns = stringInterpolation,
    symbols = {},
  }},
})

merge_tables(multilineString, {
  { pattern = {"''", "''"}, type = "string", syntax = {
    patterns = stringInterpolation,
    symbols = {},
  }},
})

merge_tables(default_patterns,
  combine_patterns(
    combine_patterns(doubleQuoteString, multilineString), {
  { pattern = "#.-\n",            type = "comment" },
  { pattern = { "/%*", "%*/" },   type = "comment" },
  { pattern = "-?%.?%d+",         type = "number"  },
  -- interpolation
  { pattern = {"%${", "}"}, type = "keyword2", syntax = {
    patterns = default_patterns,
    symbols = default_symbols,
  }},
  -- operators
  { pattern = "[%+%-%?!<>%*/]", type = "operator" },
  { pattern = "//",             type = "operator" },
  { pattern = "&&",             type = "operator" },
  { pattern = "%->",            type = "operator" },
  { pattern = "||",             type = "operator" },
  { pattern = "==",             type = "operator" },
  { pattern = "!=",             type = "operator" },
  { pattern = ">=",             type = "operator" },
  { pattern = "<=",             type = "operator" },
  -- paths
  { pattern = "%.?%.?/[%w_%-/%.]+", type = "string" },
  { pattern = { "<", ">" },         type = "string" },
  -- every other symbol
  { pattern = "[%a%-%_][%w%-%_]*", type = "symbol" },
  { pattern = ";%.,:",             type = "normal" },
  { pattern = "%.%.%.",            type = "normal" },
}))

syntax.add {
  name = "Nix",
  files = { "%.nix$" },
  comment = "#",
  block_comment = { "/*", "*/" },
  patterns = default_patterns,
  symbols = default_symbols,
}
