local Block = require("vimdoc.blocks")

local M = {}

local function node_text(node, source)
    return vim.treesitter.get_node_text(node, source)
end


local function find_descendant(node, type)
    if node:type() == type then
        return node
    end
    for i = 0, node:child_count() - 1 do
        local result = find_descendant(node:child(i), type)
        if result then
            return result
        end
    end
    return nil
end

local function heading_level(node)
    local level = node:type():match("^atx_h(%d+)_marker$")
    return level and tonumber(level)
end

local function handle_heading(node, blocks, lines)
    local level
    local text

    for child in node:iter_children() do
        if not level then
            level = heading_level(child)
        end

        if child:type() == "inline" then
            text = node_text(child, lines)
        end
    end

    table.insert(
        blocks,
        Block.heading(text, level)
    )
end

local function handle_paragraph(node, blocks, lines)
    local text
    for child in node:iter_children() do
        if child:type() == "inline" then
            text = node_text(child, lines)
            break
        end
    end

    table.insert(
        blocks,
        Block.paragraph(text)
    )
end

local function handle_codeblock(node, blocks, lines)
    local text
    local language = nil

    for child in node:iter_children() do
        local type = child:type()

        if type == "info_string" then
            language = node_text(child, lines)
        elseif type == "code_fence_content" then
            text = node_text(child, lines)
        end
    end

    table.insert(
        blocks,
        Block.code(text, language)
    )
end

local function handle_list(node, blocks, lines)
    local items = {}

    for i = 0, node:child_count() - 1 do
        local item = node:child(i)
        if item:type() == "list_item" then
            local text = find_descendant(item, "inline")
            if text then
                table.insert(items, node_text(text, lines))
            end
        end
    end
    table.insert(
        blocks,
        Block.list(items)
    )
end

local handlers = {
    atx_heading = handle_heading,
    paragraph = handle_paragraph,
    fenced_code_block = handle_codeblock,
    list = handle_list,
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

function M.debug_dump(node, depth)
    depth = depth or 0

    print(string.rep("  ", depth) .. node:type())

    for i = 0, node:child_count() - 1 do
        M.debug_dump(node:child(i), depth + 1)
    end
end

function M.adapt(tree, raw)
    local blocks = {}
    local root = tree:root()

    walk(root, blocks, raw)

    return blocks
end

return M
