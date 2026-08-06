local Block = require("vimdoc.blocks")
local adapt = require("vimdoc.adapters.helpers")

local M = {}

---@param node TSNode
---@param lines string
---@return string|nil
local function get_tag_name(node, lines)
    if node:type() ~= "element" then
        return nil
    end

    for child in node:iter_children() do
        local child_type = child:type()
        if child_type == "start_tag" or child_type == "self_closing_tag" then
            for tag_child in child:iter_children() do
                if tag_child:type() == "tag_name" then
                    return adapt.node_text(tag_child, lines):lower()
                end
            end
        end
    end
    return nil
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
---@param tag string
local function handle_heading(node, blocks, lines, tag)
    local level = tonumber(tag:match("^h(%d)$")) or 1
    table.insert(
        blocks,
        Block.heading(
            adapt.html_inline(node, lines),
            level
        )
    )
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_paragraph(node, blocks, lines)
    local content = adapt.html_inline(node, lines)
    if content and #content > 0 then
        table.insert(blocks, Block.paragraph(content))
    end
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_pre(node, blocks, lines)
    local text = adapt.node_text(node, lines)
    text = text:gsub("^%s*<pre[^>]*>", ""):gsub("</pre>%s*$", "")
    text = text:gsub("^%s*<code[^>]*>", ""):gsub("</code>%s*$", "")

    text = text:gsub("&lt;", "<")
        :gsub("&gt;", ">")
        :gsub("&amp;", "&")
        :gsub("&quot;", '"')
        :gsub("&apos;", "'")

    table.insert(blocks, Block.code(text, ""))
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_list(node, blocks, lines)
    local items = {}

    for child in node:iter_children() do
        if get_tag_name(child, lines) == "li" then
            table.insert(
                items,
                adapt.html_inline(child, lines)
            )
        end
    end

    table.insert(blocks, Block.list(items))
end

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function handle_table(node, blocks, lines)
    local rows = {}

    local function extract_rows(parent)
        for child in parent:iter_children() do
            local tag = get_tag_name(child, lines)
            if tag == "tr" then
                local row = {}
                for cell in child:iter_children() do
                    local cell_tag = get_tag_name(cell, lines)
                    if cell_tag == "td" or cell_tag == "th" then
                        table.insert(row, adapt.html_inline(cell, lines))
                    end
                end
                if #row > 0 then
                    table.insert(rows, row)
                end
            elseif tag == "tbody" or tag == "thead" then
                extract_rows(child)
            end
        end
    end

    extract_rows(node)
    table.insert(blocks, Block.table(rows))
end

---@type table<string, fun(node: TSNode, blocks: Block[], lines: string, tag: string)>
local tag_handlers = {
    h1 = handle_heading,
    h2 = handle_heading,
    h3 = handle_heading,
    h4 = handle_heading,
    h5 = handle_heading,
    h6 = handle_heading,
    p = handle_paragraph,
    pre = handle_pre,
    ul = handle_list,
    ol = handle_list,
    table = handle_table,
}

---@param node TSNode
---@param blocks Block[]
---@param lines string
local function walk(node, blocks, lines)
    local tag = get_tag_name(node, lines)

    if tag and tag_handlers[tag] then
        tag_handlers[tag](node, blocks, lines, tag)
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
