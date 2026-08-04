local M = {}

---@param path string
---@return boolean
function M.check_cache(path)
    return vim.fn.filereadable(path) == 1
end

return M
