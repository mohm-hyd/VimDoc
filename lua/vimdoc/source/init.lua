local M = {}

function M.fetch(url)
    local result = vim.system({
        "curl",
        "-s",
        url
    }):wait()

    return result.stdout
end


return M
