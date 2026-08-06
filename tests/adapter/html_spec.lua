--local parser = require("vimdoc.parser")

local fixture_path = "tests/fixtures/basic.html"
--local expected_path = "tests/expected/basic_html.lua"

local function read_file(path)
    local file = assert(io.open(path, "r"))
    local content = file:read("*a")
    file:close()

    return content
end


---@param text string
---@param lang string
---@return TSTree
local function build_tree(text, lang)
    local parser = vim.treesitter.get_string_parser(text, lang)
    return parser:parse()[1]
end

local function parse(doc)
    local tree = build_tree(doc.raw, doc.source.format)
    return tree
end

---@param node TSNode
---@param lines string
---@return string
local function node_text(node, lines)
    return vim.treesitter.get_node_text(node, lines)
end

local doc = {
    raw = read_file(fixture_path),
    source = {
        format = "html",
    }
}

local dir = "tests/expected/html_test.txt"
---@param path string
---@param lines string
---@return boolean
local function write(path, lines)
    local dir = vim.fn.fnamemodify(path, ":h")

    vim.fn.mkdir(dir, "p")

    return vim.fn.writefile(lines, path) == 0
end

local function debug_dump(node, depth, output)
    depth = depth or 0

    table.insert(
        output,
        (string.rep("  ", depth) .. node:type())
    )

    if node:type() == "text" then
        table.insert(output, node_text(node, doc.raw))
    end

    for child in node:iter_children() do
        debug_dump(child, depth + 1, output)
    end
    return output
end

--local expected = dofile(expected_path)

local actual = parse(doc)

local root = actual:root()
local output = {}
write(dir, debug_dump(root, nil, output))

--print(vim.inspect(actual))

--[[local function assert_same(_actual, _expected)
    if not vim.deep_equal(_actual, _expected) then
        print("Expected:")
        print(vim.inspect(_expected))

        print("Actual:")
        print(vim.inspect(_actual))

        error("Assertion failed")
    end
end


assert_same(actual, expected)]]
