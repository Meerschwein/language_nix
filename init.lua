-- mod-version:3
-- https://nixos.wiki/wiki/Overview_of_the_Nix_Language


local syntax = require "core.syntax"

syntax.add {
  name = "Nix",
  files = { "%.nix$" },
  comment = "#",
  block_comment = {"/*", "*/"},
  patterns  = {
    { pattern = "#.-\n",            type = "comment" },
    { pattern = { "/%*", "%*/"   }, type = "comment" },
    { pattern = { "''", "''"     }, type = "string"  },
    { pattern = { '"', '"', "\\" }, type = "string"  },
    { pattern = "-?%.?%d+",         type = "number"  },

    -- interpolation
    { pattern = "%${().-()}", type = {"keyword2", "symbol", "keyword2"} },
    -- operators
    { pattern = "[%+%-%?!<>%*/]", type = "operator" },
    { pattern = "//",        type = "operator" },
    { pattern = "&&",        type = "operator" },
    { pattern = "%->",       type = "operator" },
    { pattern = "||",        type = "operator" },
    { pattern = "==",        type = "operator" },
    { pattern = "!=",        type = "operator" },
    { pattern = ">=",        type = "operator" },
    { pattern = "<=",        type = "operator" },
    -- paths
    { pattern = "%./[%w_%-/%.]+", type = "string" },
    { pattern = {"<", ">"},       type = "string" },
    -- every other symbol
    { pattern = "[%a%-][%w%-]*", type = "symbol" },
    { pattern = ";%.,:",         type = "normal" },
    { pattern = "%.%.%.",        type = "normal" },
  },
  symbols = {
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
  },
}


-- This is the start of proper string interpolation but I gave up
-- local function combine_patterns(t1, t2)
--   local temp = { table.unpack(t1) }
--   for _, t in ipairs(t2) do
--     table.insert(temp, t)
--   end
--   return temp
-- end
-- 
-- local function merge_tables(a, b)
--   for _, v in pairs(b) do
--     table.insert(a, v)
--   end
-- end
-- 
-- local doubleQuoteString = {}
-- 
-- local curlys = combine_patterns({
--   { pattern = {"%${", "}"},  type = "keyword2", syntax = {
--     patterns = doubleQuoteString,
--     symbols = {},
--   }},
--   { pattern = '[%a][%w]*', type = "string" },
-- }, normal)
-- 
-- merge_tables(doubleQuoteString, combine_patterns({
--   { pattern = { '"', '"', "\\"}, type = "string", syntax = {
--     patterns = curlys,
--     symbols = {},
--   }},
--   { pattern = "[%a][%w]*", type = "literal" },
--   }, normal)
-- )
