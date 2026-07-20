local M = {}

function M.write(path, lines)
    local dir = vim.fn.fnamemodify(path, ":h")

    vim.fn.mkdir(dir, "p")

    return vim.fn.writefile(lines, path) == 0
end


return M
