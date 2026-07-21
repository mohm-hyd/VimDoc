local parser = require("vimdoc.parsers.rst")

local function read_file(path)
    local file = assert(io.open(path, "r"))
    local content = file:read("*a")
    file:close()

    return content
end


local function compare(actual, expected)
    for i, block in ipairs(expected) do
        local got = actual[i]

        assert(got, "Missing block " .. i)

        assert(
            got.type == block.type,
            "Block " .. i .. " type mismatch"
        )

        assert(
            got.text == block.text,
            "Block " .. i .. " text mismatch\n" ..
            "got: [" ..got.text .. "]\n" ..
            "expected: [" ..block.text .. "]"
        )

        if block.level then
            assert(
                got.level == block.level,
                "Block " .. i .. " level mismatch"
            )
        end
    end

    print("✓ parser test passed")
end


local raw = read_file(
    "tests/fixtures/rst/hump_timer.rst"
)

local expected = dofile(
    "tests/expected/hump_timer.lua"
)

local result = parser.parse(raw)

compare(result, expected)
