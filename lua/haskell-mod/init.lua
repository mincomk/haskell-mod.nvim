local H = require("haskell-mod.handler")
local App = require("haskell-mod.app")

local M = {}

---@return table
function M.setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.hs",
        callback = function()
            M.handle_new_file()
        end
    })

    return M
end

function M.handle_new_file()
    H.handle_new_file(App)
end

return M
