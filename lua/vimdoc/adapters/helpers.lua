local markdown = require("vimdoc.inline_parsers.markdown_inline")
local rst = require("vimdoc.inline_parsers.rst_inline")
local html = require("vimdoc.inline_parsers.html_inline")

local M = {}

---@param node TSNode
---@param lines string
---@return string
local function get_inner_html_text(node, lines)
    if node:type() ~= "element" then
        return vim.treesitter.get_node_text(node, lines)
    end

    local text = ""
    local chunks = {}
    for child in node:iter_children() do
        if child:type() ~= "start_tag" and child:type() ~= "end_tag" then
            table.insert(chunks, vim.treesitter.get_node_text(child, lines))
        end
    end
    return table.concat(chunks, "")
end

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
---@return InlineNode[]
function M.html_inline(node, lines)
    return html.parse(
        get_inner_html_text(node, lines)
    )
end

---@param node TSNode
---@param lines string
---@return string
function M.node_text(node, lines)
    return vim.treesitter.get_node_text(node, lines)
end

return M
