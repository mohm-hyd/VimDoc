local M = {}

function M.chech_cache(path)
    return vim.fn.filereadable(path) == 1
end

return M
