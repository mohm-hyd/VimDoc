local markdown = require("vimdoc.inline_parsers.markdown_inline")
local rst = require("vimdoc.inline_parsers.rst_inline")

local M = {}

---@param node TSNode
---@param lines string
---@return InlineNode[]
function M.markdown_inline(node, lines)
    return markdown.parse(
        vim.treesitter.get_node_text(node, lines)
    )
end

---@param node TSNode
---@param lines string
---@return InlineNode[]
function M.rst_inline(node, lines)
    return rst.parse(
        vim.treesitter.get_node_text(node, lines)
    )
end

---@param node TSNode
---@param lines string
---@return string
function M.node_text(node, lines)
    return vim.treesitter.get_node_text(node, lines)
end

return M
