local H = require("haskell-mod.handler")
local App = require("haskell-mod.app")

local M = {}

---@return table
function M.setup()
    local group = vim.api.nvim_create_augroup("haskell-mod", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
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
