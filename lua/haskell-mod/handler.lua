local CabalRootFinder = require("haskell-mod.root_finder.cabal")
local FilePath = require("haskell-mod.utils.filepath")

local M = {}

---@param app App
function M.handle_new_file(app)
    local current_buf = app.get_current_buf_path()

    local haskell_root = CabalRootFinder.find_haskell_root(app, current_buf)
    if haskell_root == nil then return end

    local current_buf_no_ext = current_buf:parent():join(FilePath.new(current_buf:basename_no_extension()))
    local relative = current_buf_no_ext:with_respect_to(haskell_root)
    local module = relative.path:gsub("/", ".")

    local module_def = "module " .. module .. " where"

    local first_line = app.current_buf_get_lines(0, 1)[1]
    if first_line == "" then
        app.current_buf_set_lines(0, 0, { module_def })
    end
end

return M
