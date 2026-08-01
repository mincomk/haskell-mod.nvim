local Array = require("haskell-mod.utils.array")
local FilePath = require("haskell-mod.utils.filepath")

local M = {}

---Search upwards, stopping at `.git` or a filesystem root
---@param app App
---@param start FilePath
---@param predicate fun(file: FilePath): boolean
---@return FilePath | nil
function M.find_up(app, start, predicate)
    local cur = start:clone()

    while not cur:is_root() do
        local found = Array.find(app.list_dir_absolute(cur), predicate)
        if found ~= nil then
            return found
        end

        if app.path_exists(cur:join(FilePath.new(".git"))) then
            return nil
        end

        cur = cur:parent()
    end

    return nil
end

return M
