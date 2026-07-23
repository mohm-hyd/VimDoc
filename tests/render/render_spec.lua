local renderer = require("vimdoc.render")

local fixture_path = "tests/fixtures/blocks.lua"
local expected_path = "tests/expected/rendered.txt"

local function read_file(path)
    local file = assert(io.open(path, "r"))
    local content = file:read("*a")
    file:close()

    return content
end


local doc = {
    tag = "render.test",
    content = dofile(fixture_path)
}

local expected = read_file(expected_path)

local actual = renderer.render(doc)


local function assert_same(_actual, _expected)
    if not vim.deep_equal(_actual, _expected) then
        print("Expected:")
        print(vim.inspect(_expected))

        print("Actual:")
        print(vim.inspect(_actual))

        error("Assertion failed")
    end
end

assert_same(actual, expected)

