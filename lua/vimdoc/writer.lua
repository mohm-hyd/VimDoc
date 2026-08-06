local M = {}

local WRAP_WIDTH = 78

---@param path string
---@param content string|string[]
---@return boolean
function M.write(path, content)
    local dir = vim.fn.fnamemodify(path, ":h")
    vim.fn.mkdir(dir, "p")

    ---@type string[]
    local lines
    if type(content) == "string" then
        lines = vim.split(content, "\n", { plain = true })
    else
        lines = { unpack(content) }
    end

    table.insert(lines, string.rep("=", WRAP_WIDTH))
    table.insert(lines, "vim:tw=78:ts=8:ft=help:norl:syntax=help")

    return vim.fn.writefile(lines, path) == 0
end

return M
