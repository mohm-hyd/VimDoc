local M = {}

--Block creation
local function new_heading(text, level)
    return {
        type = "heading",
        level = level,
        text = text,
    }
end

local function new_paragraph(text)
    return {
        type = "paragraph",
        text = text
    }
end

local function new_code_block(text)
    return {
        type = "code",
        text = text
    }
end

local function new_list_block(items)
    return {
        type = "list",
        items = items,
    }
end

--Helpers

local function node_text(node, source)
    return vim.treesitter.get_node_text(node, source)
end

local function heading_level(section, lines)
    for i = 0, section:child_count() - 1 do
        local child = section:child(i)

        if child:type() == "adornment" then
            local text = node_text(child, lines)

            if text:match("^=+") then
                return 1
            elseif text:match("^%-+") then
                return 2
            end
        end
    end
    return 1
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

--Type handlers
local function handle_section(node,blocks, lines,walk)

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
                new_heading(node_text(title, lines), heading_level(node, lines))
            )
        end

        for i = 0, node:child_count() - 1 do
            local child = node:child(i)

            if child:type() ~= "title" and child:type() ~= "adornment" then
                if child:type() == "section" then
                    walk(child, blocks, lines)
                else
                    walk(child, blocks, lines)
                end
            end
        end
end

local function handle_paragraph(node,blocks,lines)
        table.insert(
            blocks,
            new_paragraph(node_text(node, lines))
        )
end

local function handle_codeblock(node,blocks,lines)
        table.insert(
            blocks,
            new_code_block(node_text(node, lines))
        )
end

local function handle_list(node,blocks,lines)

        local items = {}

        for i = 0, node:child_count() - 1 do
            local item = node:child(i)
            if item:type() == "list_item" then
                local paragraph = find_descendant(item, "paragraph")
                if paragraph then
                    table.insert(items, node_text(paragraph,lines))
                end
            end
        end
        table.insert(
            blocks,
            new_list_block(items)
        )
end

local handlers = {
    section = handle_section,
    paragraph = handle_paragraph,
    literal_block = handle_codeblock,
    bullet_list = handle_list,
}
--Walk the tree
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
