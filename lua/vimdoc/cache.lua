local M = {}

function M.check_cache(path)
    return vim.fn.filereadable(path) == 1
end

return M
