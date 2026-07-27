local Block=require("vimdoc.blocks")

local M = {}

local function node_text(node, source)
    return vim.treesitter.get_node_text(node, source)
end

local handlers = {
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
