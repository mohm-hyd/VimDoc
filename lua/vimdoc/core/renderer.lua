local M = {}
function M.render(text,format)
    print("Documentation format: " ..format)
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        vim.split(text,"\n")
    )
    print("buffer: ", buf)
    print("lines: " , #vim.api.nvim_buf_get_lines(buf,0,-1,false))

    vim.api.nvim_set_current_buf(buf)

    print("DONE")
end

return M
