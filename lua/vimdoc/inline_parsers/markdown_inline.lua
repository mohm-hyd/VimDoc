local inline = require("vimdoc.inline")

local M = {}

local parse_inline

local function parse_unknown(text)
    return inline.text(text:sub(1, 1)), text:sub(2)
end

local function parse_text(text)
    local position = text:find("[%[%`*_]")

    if not position then
        return inline.text(text), ""
    end

    if position == 1 then
        return nil, text
    end

    return inline.text(text:sub(1, position - 1)),
        text:sub(position)
end

local function parse_link(text)
    local label, target = text:match("^%[([^]]+)%]%(([^)]+)%)")

    if not label then
        return nil, text
    end

    local block = inline.link(
        parse_inline(label),
        target
    )

    local consumed = #label + #target + 4

    return block, text:sub(consumed + 1)
end

local function parse_code(text)
    local full, content = text:match("^(`([^`]+)`)")

    if not full then
        return nil, text
    end

    return inline.inline_code(content),
        text:sub(#full + 1)
end

local function parse_strong(text)
    local full, content =
        text:match("^(%*%*(.-)%*%*)")

    if not full then
        full, content =
            text:match("^(__(.+)__)")
    end

    if not full then
        return nil, text
    end

    return inline.strong(
            parse_inline(content)
        ),
        text:sub(#full + 1)
end

local function parse_emphasis(text)
    local full, content =
        text:match("^(%*(.-)%*)")

    if not full then
        full, content =
            text:match("^_(.-)_")
    end

    if not full then
        return nil, text
    end

    return inline.emphasis(
            parse_inline(content)
        ),
        text:sub(#full + 1)
end

local function parse_anchor(text)
    local full_match, id, content = text:match(
        "^(<a%s+name=['\"](.-)['\"]>(.-)</a>)"
    )

    if not full_match then
        return nil, text
    end

    return inline.anchor(id, parse_inline(content)),
        text:sub(#full_match + 1)
end

local parsers = {
    parse_anchor,
    parse_code,
    parse_link,
    parse_strong,
    parse_emphasis,
    parse_text,
    parse_unknown,

}

parse_inline = function(text)
    local children = {}

    while #text > 0 do
        local matched = false

        for _, parser in ipairs(parsers) do
            local block, remaining = parser(text)

            if block then
                table.insert(children, block)
                text = remaining
                matched = true
                break
            end
        end

        if not matched then
            error("Inline parser failed to consume input: " .. text)
        end
    end
    return children
end

function M.parse(text)
    return parse_inline(text)
end

return M
