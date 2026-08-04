local Block = require("vimdoc.blocks")
local adapt = require("vimdoc.adapters.helpers")
local tree = require("vimdoc.treesitter")


local M = {}

---@param node TSNode
---@return integer
local function heading_level(node)
    local level = node:type():match("^atx_h(%d+)_marker$")
    assert(level)

    local number_level = tonumber(level)
    assert(number_level)

    return math.floor(number_level)
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_heading(node, blocks, lines)
    local level
    local inline_node

    for child in node:iter_children() do
        if not level then
            level = heading_level(child)
        end

        if child:type() == "inline" then
            inline_node = child
        end
    end
    if inline_node then
        table.insert(
            blocks,
            Block.heading(
                adapt.markdown_inline(inline_node, lines),
                level
            )
        )
    end
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_paragraph(node, blocks, lines)
    local inline_node = tree.find_descendant(node, "inline")

    table.insert(
        blocks,
        Block.paragraph(adapt.markdown_inline(inline_node, lines))
    )
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_codeblock(node, blocks, lines)
    local text
    local language

    for child in node:iter_children() do
        local type = child:type()

        if type == "info_string" then
            language = adapt.node_text(child, lines)
        elseif type == "code_fence_content" then
            text = adapt.node_text(child, lines)
        end
    end

    table.insert(
        blocks,
        Block.code(text, language)
    )
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_list(node, blocks, lines)
    local items = {}

    for item in node:iter_children() do
        if item:type() == "list_item" then
            local inline = tree.find_descendant(item, "inline")

            if inline then
                table.insert(
                    items,
                    adapt.markdown_inline(inline, lines)
                )
            end
        end
    end
    table.insert(
        blocks,
        Block.list(items)
    )
end

---@type  table<string,Handler>
local handlers = {
    atx_heading = handle_heading,
    paragraph = handle_paragraph,
    fenced_code_block = handle_codeblock,
    list = handle_list,
}
---@param node TSNode
---@param blocks Block[]
---@param lines string
local function walk(node, blocks, lines)
    local handler = handlers[node:type()]

    if handler then
        handler(node, blocks, lines)
        return
    end

    for child in node:iter_children() do
        walk(child, blocks, lines)
    end
end

---@param parsed_tree TSTree
---@param raw string
---@return Block[]
function M.adapt(parsed_tree, raw)
    local blocks = {}
    local root = parsed_tree:root()

    walk(root, blocks, raw)

    return blocks
end

return M
