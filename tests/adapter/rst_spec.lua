local parser = require("vimdoc.parser")

local fixture_path = "tests/fixtures/basic.rst"
local expected_path = "tests/expected/basic_rst.lua"

local function read_file(path)
    local file = assert(io.open(path, "r"))
    local content = file:read("*a")
    file:close()

    return content
end


local doc = {
    raw = read_file(fixture_path),
    source = {
        format = "rst",
    }
}

local expected = dofile(expected_path)

local actual = parser.parse(doc)

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








