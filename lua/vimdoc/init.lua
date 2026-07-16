local M = {}

function M.open(page)
    print("Getting the docs for:", page)

    local source = require('vimdoc.source.github')
    local docs = source.fetch(page)
    require("vimdoc.core.renderer").render(docs)
end

return M
