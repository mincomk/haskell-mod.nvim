local H = require("haskell-mod.handler")
local App = require("haskell-mod.app")

local M = {}

---@return table
function M.setup()
    vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*.hs",
        callback = function()
            H.handle_new_file(App)
        end
    })

    return M
end

return M
