local M = {}

---@generic T
---@generic R
---@param array T[]
---@param func fun(item: T): R
---@return R[]
function M.map(array, func)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = func(v)
    end
    return result
end

---@generic T
---@param array T[]
---@param value T
---@return boolean
function M.contains(array, value)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

---@generic T
---@param array T[]
---@param predicate fun(item: T): boolean
---@return T[]
function M.filter(array, predicate)
    local result = {}
    for _, v in ipairs(array) do
        if predicate(v) then
            table.insert(result, v)
        end
    end
    return result
end

---@generic T
---@param array T[]
---@param predicate fun(item: T): boolean
---@return T | nil
function M.find(array, predicate)
    for _, v in ipairs(array) do
        if predicate(v) then
            return v
        end
    end
    return nil
end

---@generic T
---@param array T[]
---@param predicate fun(item: T): boolean
---@return boolean
function M.any(array, predicate)
    for _, v in ipairs(array) do
        if predicate(v) then
            return true
        end
    end
    return false
end

return M
