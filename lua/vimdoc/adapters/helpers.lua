local markdown = require("vimdoc.inline_parsers.markdown_inline")
local rst = require("vimdoc.inline_parsers.rst_inline")

local M = {}

function M.markdown_inline(node, lines)
    return markdown.parse(
        vim.treesitter.get_node_text(node, lines)
    )
end

function M.rst_inline(node, lines)
    return rst.parse(
        vim.treesitter.get_node_text(node, lines)
    )
end

function M.node_text(node, source)
    return vim.treesitter.get_node_text(node, source)
end

return M
