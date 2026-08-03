local Block = require("vimdoc.blocks")
local adapt = require("vimdoc.adapters.helpers")
local tree = require("vimdoc.treesitter")

local M = {}

--Helpers


local function heading_level(section, lines)
    for i = 0, section:child_count() - 1 do
        local child = section:child(i)

        if child:type() == "adornment" then
            local text = adapt.node_text(child, lines)

            if text:match("^=+") then
                return 1
            elseif text:match("^%-+") then
                return 2
            end
        end
    end
    return 1
end

local function handle_section(node, blocks, lines, walk)
    local title

    for i = 0, node:child_count() - 1 do
        local child = node:child(i)
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

    for i = 0, node:child_count() - 1 do
        local child = node:child(i)

        if child:type() ~= "title" and child:type() ~= "adornment" then
            walk(child, blocks, lines)
        end
    end
end

local function handle_paragraph(node, blocks, lines)
    table.insert(
        blocks,
        Block.paragraph(
            adapt.rst_inline(node, lines)
        )
    )
end

local function handle_codeblock(node, blocks, lines)
    table.insert(
        blocks,
        Block.code(adapt.node_text(node, lines))
    )
end

local function handle_list(node, blocks, lines)
    local items = {}

    for i = 0, node:child_count() - 1 do
        local item = node:child(i)

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

local handlers = {
    section = handle_section,
    paragraph = handle_paragraph,
    literal_block = handle_codeblock,
    bullet_list = handle_list,
}

local function walk(node, blocks, lines)
    local handler = handlers[node:type()]

    if handler then
        handler(node, blocks, lines, walk)
        return
    end

    for i = 0, node:child_count() - 1 do
        walk(node:child(i), blocks, lines)
    end
end


function M.adapt(parsed_tree, raw)
    local blocks = {}
    local root = parsed_tree:root()

    walk(root, blocks, raw)

    return blocks
end

return M
