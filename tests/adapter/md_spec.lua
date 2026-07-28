
local parser = require("vimdoc.parser")

local fixture_path = "./README.md"

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
        print(node_text(node, Doc.raw))

    for i = 0, node:child_count() - 1 do
        debug_dump(node:child(i), depth + 1)
    end
end


Doc = {
    raw = read_file(fixture_path),
    source = {
        format = "markdown",
    }
}

local content = parser.parse(Doc)

vim.print(content)
