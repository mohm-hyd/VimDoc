--local parser = require("vimdoc.parser")

local fixture_path = "./tests/moses.md"

local function read_file(path)
    local file = assert(io.open(path, "r"))
    local content = file:read("*a")
    file:close()

    return content
end

local function node_text(node, source)
    return vim.treesitter.get_node_text(node, source)
end

local function debug_dump(node, depth)
    depth = depth or 0

    print(string.rep("  ", depth) .. node:type())

    if node:type() == "inline" then
        print(node_text(node,Doc.raw))
        for child in node:iter_children() do
            print(
                child:type(),
                vim.inspect(node_text(child,Doc.raw))
            )
        end
    end

    for i = 0, node:child_count() - 1 do
        debug_dump(node:child(i), depth + 1)
    end
end


local function build_tree(text, lang)
    local parser = vim.treesitter.get_string_parser(text, lang)
    return parser:parse()[1]
end

local function parse(doc)
    local tree = build_tree(doc.raw, doc.source.format)
    return tree
end

Doc = {
    raw = read_file(fixture_path),
    source = {
        format = "markdown",
    }
}

local tree = parse(Doc)
local root = tree:root()

debug_dump(root)
