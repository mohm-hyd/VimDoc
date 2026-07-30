 local markdown = require("vimdoc.inline_parsers.markdown_inline")

local M = {}

function M.node_inline(node, lines)
    return markdown.parse(
        vim.treesitter.get_node_text(node, lines)
    )
end

function M.node_text(node, source)
    return vim.treesitter.get_node_text(node, source)
end
return M
