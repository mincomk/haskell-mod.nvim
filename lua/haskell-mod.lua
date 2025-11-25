local api = vim.api
local fn = vim.fn

--- @return table
local function setup()
    vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*.hs",
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            local filepath = vim.api.nvim_buf_get_name(buf)
            local root = vim.fn.finddir(".git/..", filepath .. ";")
            if root == "" then
                return
            end
            local module_path = filepath:gsub("^" .. root .. "/", "")
            module_path = module_path:gsub("%.hs$", "")
            module_path = module_path:gsub("/", ".")
            local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
            if first_line == "" then
                vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "module " .. module_path .. " where", "" })
            end
        end
    })
end

return {
    setup = setup
}
