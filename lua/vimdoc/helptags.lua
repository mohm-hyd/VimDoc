local M = {}

function M.update_helptags()
    local config = require("vimdoc.config")
    vim.cmd("helptags " .. vim.fn.fnameescape(config.options.output_dir))
end

return M
