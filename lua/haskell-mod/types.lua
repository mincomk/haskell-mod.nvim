---@class RootFinder
---@field find_haskell_root fun(app: App, file_path: FilePath): FilePath

---@class App
---@field get_current_buf_path fun(): FilePath
---@field list_dir_absolute fun(dir: FilePath): FilePath[]
---@field read_file fun(path: FilePath): string[]|nil
---@field current_buf_get_lines fun(start: integer, end: integer): string[]
---@field current_buf_set_lines fun(start: integer, end: integer, replacement: string[])
