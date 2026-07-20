local M = {}


function M.render(doc)
    print("Documentation format: ", doc.source.config.format)
    local header = {
        "*" .. doc.tag .. "*",

        "",
    }
    local lines = vim.split(doc.content, "\n")
    vim.list_extend(header, lines)
    return header
end

function M.preview(doc)
    local buf = vim.api.nvim_create_buf(false, true)
    print("Documentation format: ", doc.source.config.format)
    vim.api.nvim_buf_set_name(buf, "vimdoc://" .. doc.tag)
    vim.bo[buf].filetype = "help"
    local header = {
        "*" .. doc.tag .. "*",
        "",
    }
    local lines = vim.split(doc.content, "\n")
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
end

return M
