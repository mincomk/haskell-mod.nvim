local Array = require("haskell-mod.utils.array")
local Search = require("haskell-mod.utils.search")

local M = {}

local CONFIG_FILES = { "stack.yaml", "package.yaml", "cabal.project" }

local TEMPLATE = {
    "#!/usr/bin/env stack",
    "{- stack script",
    "   --resolver lts",
    "   --package aeson",
    "   --package async",
    "   --package bytestring",
    "   --package containers",
    "   --package directory",
    "   --package filepath",
    "   --package mtl",
    "   --package process",
    "   --package text",
    "   --package time",
    "   --package turtle",
    "   --package unordered-containers",
    "   --package vector",
    "-}",
    "{-# LANGUAGE OverloadedStrings #-}",
    "",
    "main :: IO ()",
    "main = do",
    "    pure ()",
}

---@param file_path FilePath
---@return boolean
local function match_config(file_path)
    return file_path:extension() == "cabal" or Array.contains(CONFIG_FILES, file_path:basename())
end

---@param app App
---@param dir FilePath
---@return FilePath | nil
function M.find_project_config(app, dir)
    return Search.find_up(app, dir, match_config)
end

---@param lines string[]
---@return boolean
function M.has_module_decl(lines)
    return Array.any(lines, function(line) return line:match("^%s*module%s") ~= nil end)
end

---@param lines string[]
---@return boolean
function M.is_blank(lines)
    return not Array.any(lines, function(line) return line:match("^%s*$") == nil end)
end

---Belongs to no package, cannot be named as a module, and declares none
---@param app App
---@param file_path FilePath
---@param lines string[]
---@return boolean
function M.is_standalone(app, file_path, lines)
    if M.find_project_config(app, file_path:parent()) ~= nil then return false end
    if file_path:basename():match("^%u") ~= nil then return false end
    if M.has_module_decl(lines) then return false end

    return true
end

---@return string[]
function M.template_lines()
    return Array.map(TEMPLATE, function(line) return line end)
end

return M
