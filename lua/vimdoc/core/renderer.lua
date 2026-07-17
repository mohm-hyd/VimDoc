local M = {}
function M.render(text, format, tag)
    print("Documentation format: ", format)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "vimdoc://" .. tag)
    vim.bo[buf].filetype = "help"
    local header = {
        "============================================================================",
        tag .. "                                                       *" .. tag .. "*",
        "",
    }
    local lines = vim.split(text, "\n")
    vim.list_extend(header, lines)
    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        header
    )
    print("buffer: ", buf)
    print("lines: ", #vim.api.nvim_buf_get_lines(buf, 0, -1, false))

    vim.api.nvim_set_current_buf(buf)

    print("DONE")
end

return M
