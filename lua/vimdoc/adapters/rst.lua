local Block = require("vimdoc.blocks")
local adapt = require("vimdoc.adapters.helpers")
local tree = require("vimdoc.treesitter")

local M = {}

---@param node TSNode
---@param lines string
---@return integer
local function heading_level(node, lines)
    for child in node:iter_children() do
        if child:type() == "adornment" then
            local underline = adapt.node_text(child, lines)

            if underline:match("^=+$") then
                return 1
            elseif underline:match("^%-+$") then
                return 2
            elseif underline:match("^%~+$") then
                return 3
            end
        end
    end
    return 1
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_section(node, blocks, lines, walk)
    local title

    for child in node:iter_children() do
        if child:type() == "title" then
            title = child
            break
        end
    end

    if title then
        table.insert(
            blocks,
            Block.heading(
                adapt.rst_inline(title, lines),
                heading_level(node, lines)
            )
        )
    end

    for child in node:iter_children() do
        if child:type() ~= "title" and child:type() ~= "adornment" then
            walk(child, blocks, lines)
        end
    end
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_paragraph(node, blocks, lines)
    table.insert(
        blocks,
        Block.paragraph(
            adapt.rst_inline(node, lines)
        )
    )
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_codeblock(node, blocks, lines)
    table.insert(
        blocks,
        Block.code(adapt.node_text(node, lines))
    )
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_list(node, blocks, lines)
    local items = {}

    for item in node:iter_children() do
        if item:type() == "list_item" then
            local inline = tree.find_descendant(item, "paragraph")

            if inline then
                table.insert(
                    items,
                    adapt.rst_inline(inline, lines)
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
    section = handle_section,
    paragraph = handle_paragraph,
    literal_block = handle_codeblock,
    bullet_list = handle_list,
}

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function walk(node, blocks, lines)
    local handler = handlers[node:type()]

    if handler then
        handler(node, blocks, lines, walk)
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
