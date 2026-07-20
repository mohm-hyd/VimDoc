local M = {}

M.options       = {
    output_dir = nil,
    sources = {}
}

function M.setup(opts)
    M.options = vim.tbl_deep_extend(
        "force",
        M.options,
        opts or {}
    )
end

return M
