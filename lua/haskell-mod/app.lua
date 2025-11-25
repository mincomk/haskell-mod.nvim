local FilePath = require("haskell-mod.utils.filepath")
local Array = require("haskell-mod.utils.array")

---@type App
local App = {}

function App.get_current_buf_path()
    local buf = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(buf)

    return FilePath.new(filepath)
end

function App.current_buf_get_lines(start, _end)
    local buf = vim.api.nvim_get_current_buf()
    return vim.api.nvim_buf_get_lines(buf, start, _end, false)
end

function App.current_buf_set_lines(start, _end, replacement)
    local buf = vim.api.nvim_get_current_buf()
    return vim.api.nvim_buf_set_lines(buf, start, _end, false, replacement)
end

function App.list_dir_absolute(path)
    local files = vim.fn.glob(path.path .. "/*", false, true)
    files = Array.map(files, function(file) return FilePath.new(file) end)

    return files
end

function App.read_file(path)
    local lines = vim.fn.readfile(path.path)

    return lines
end

return App
