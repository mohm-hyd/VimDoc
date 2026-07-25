local adapters = require("vimdoc.adapters")

M = {}

local function build_tree(text, lang)
    local parser = vim.treesitter.get_string_parser(text, lang)
    return parser:parse()[1]
end

function M.parse(doc)
    local tree = build_tree(doc.raw, doc.source.format)
    return adapters[doc.source.format].adapt(tree, doc.raw)
end

return M
