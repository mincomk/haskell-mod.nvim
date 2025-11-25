local Array = require("haskell-mod.utils.array")
local FilePath = require("haskell-mod.utils.filepath")

---@type RootFinder
local M = {}

---@param file_path FilePath
---@return boolean
local function match_cabal(file_path)
    return file_path:extension() == "cabal"
end

--- Search upwards until `.git` or a filesystem root, looking for .cabal
---@param app App
---@param file_path FilePath
---@return FilePath | nil
local function find_cabal(app, file_path)
    local cur = file_path:clone()

    while not cur:is_root() do
        local files = app.list_dir_absolute(cur)

        local found = Array.find(files, match_cabal)
        if found ~= nil then
            return found
        else
            cur = cur:parent()
        end

        -- stop searching at `.git`. There's no 허접 that makes a code over git root
        if Array.any(files, function(path) return path:basename() == ".git" end) then
            return nil
        end
    end

    return nil
end

---@param cabal_content string[]
---@return string[]
local function get_hs_source_dirs1(cabal_content)
    local dirs = {}
    for _, line in ipairs(cabal_content) do
        line = line:gsub("%s*%-%-.*$", "")
        local value = line:match("^%s*hs%-source%-dirs%s*:%s*(.+)$")
        if value then
            for dir in value:gmatch("\\S+") do
                table.insert(dirs, dir)
            end
        end
    end
    return dirs
end

---@param cabal_content string[]
---@return string[]
local function get_hs_source_dirs(cabal_content)
    local dirs = {}
    local in_hs_dirs = false

    for _, line in ipairs(cabal_content) do
        line = line:gsub("%s*%-%-.*$", "")
        local trimmed = line:match("^%s*(.-)%s*$")

        if in_hs_dirs then
            if trimmed == "" or trimmed:match("^%s+:") then
                in_hs_dirs = false
            else
                -- add directory
                table.insert(dirs, trimmed)
            end
        end

        if not in_hs_dirs then
            local value = trimmed:match("^hs%-source%-dirs%s*:%s*(.*)$")
            if value ~= nil then
                if value ~= "" then
                    for dir in value:gmatch("%S+") do
                        table.insert(dirs, dir)
                    end
                end
                in_hs_dirs = true
            end
        end
    end


    return dirs
end

---Find Haskell source root of a file, like src dir
---@param app App
---@param file_path FilePath
---@return FilePath|nil
function M.find_haskell_root(app, file_path)
    local cabal_file = find_cabal(app, file_path:parent())
    if cabal_file == nil then return nil end

    local content = app.read_file(cabal_file)
    if content == nil then return nil end

    local source_dirs = get_hs_source_dirs(content)
    local cabal_dir = cabal_file:parent()
    source_dirs = Array.map(source_dirs, function(item) return cabal_dir:join(FilePath.new(item)) end)
    local under_dir = Array.find(source_dirs, function(item) return file_path:is_under(item) end)

    return under_dir
end

return M
