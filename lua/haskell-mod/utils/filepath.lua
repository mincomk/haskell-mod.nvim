---@class FilePath
---@field path string
local FilePath = {}
FilePath.__index = FilePath

---@return boolean
function FilePath:is_root()
    local path = self.path:gsub("\\", "/")
    path = path:gsub("/+$", "")

    if path == "" then
        return true
    end

    -- Unix root
    if path == "/" then
        return true
    end

    -- Windows root (e.g., C:/)
    if path:match("^[a-zA-Z]:$") then
        return true
    end

    return false
end

---@param path string
---@return FilePath
function FilePath.new(path)
    local self = setmetatable({}, FilePath)
    self.path = path:gsub("\\", "/")

    return self
end

---@return FilePath
function FilePath:clone()
    return FilePath.new(self.path)
end

---@return string
function FilePath:get_root()
    local path = self.path

    local root = ""
    local drive = path:match("^[a-zA-Z]:/")
    if drive then
        root = drive
        path = path:sub(#drive + 1)
    elseif path:sub(1, 1) == "/" then
        root = "/"
        path = path:sub(2)
    end

    return root
end

---Clone and normalize
---@return FilePath
function FilePath:normalize()
    local new_self = self:clone()

    local parts = {}
    for part in new_self.path:gmatch("[^/]+") do
        if part == ".." then
            table.remove(parts)
        elseif part ~= "." then
            table.insert(parts, part)
        end
    end

    local root = self:get_root()
    new_self.path = root .. table.concat(parts, "/")
    return new_self
end

---@return FilePath
function FilePath:parent()
    return self:join(FilePath.new(".."))
end

---@param subpath FilePath
---@return FilePath
function FilePath:join(subpath)
    local new_path = self.path .. "/" .. subpath.path
    return FilePath.new(new_path):normalize()
end

---@return string
function FilePath:basename()
    return self.path:match("^.+/(.+)$") or self.path
end

---@return string
function FilePath:dirname()
    return self.path:match("^(.+)/.+$") or "."
end

---Extension excluding the period
---@return string
function FilePath:extension()
    return self.path:match("%.([^./]+)$")
end

---@return string
function FilePath:basename_no_extension()
    return self:basename():match("^(.+)%.[^./]+$")
end

---@return string[]
function FilePath:split()
    local parts = {}
    for part in self.path:gmatch("[^/]+") do
        table.insert(parts, part)
    end
    return parts
end

---나는 좋아한다 미적분 w.r.t. Math
---@param base FilePath
---@return FilePath
function FilePath:with_respect_to(base)
    base = base:normalize()
    local base_parts = base:split()
    local self_parts = self:normalize():split()

    local i = 1
    while i <= #base_parts and i <= #self_parts and base_parts[i] == self_parts[i] do
        i = i + 1
    end

    local relative_parts = {}
    for j = i, #self_parts do
        table.insert(relative_parts, self_parts[j])
    end

    local str_name = table.concat(relative_parts, "/")
    return FilePath.new(str_name)
end

---@param base FilePath
---@return boolean
function FilePath:is_under(base)
    base = base:normalize()
    local base_parts = base:split()
    local self_parts = self:normalize():split()

    if #self_parts < #base_parts then
        return false
    end

    for i = 1, #base_parts do
        if self_parts[i] ~= base_parts[i] then
            return false
        end
    end

    return #self_parts > #base_parts
end

return FilePath
