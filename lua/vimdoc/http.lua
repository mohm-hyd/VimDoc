local M = {}

---@param url string
---@return string?
---@return string?
function M.get(url)
    local result = vim.system({
        "curl",
        "-sS",
        url
    }):wait()

    if result.code ~= 0 then
        local err = result.stderr

        if err and err ~= "" then
            return nil, err
        end

        return nil, "curl failed with exit code " .. result.code
    end

    return result.stdout, nil
end

return M
