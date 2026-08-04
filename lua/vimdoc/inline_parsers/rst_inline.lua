local inline = require("vimdoc.inline")
local engine = require("vimdoc.inline_parsers.engine")


---@param text string
---@return Text
---@return string remaining
local function parse_unknown(text)
    return inline.text(text:sub(1, 1)), text:sub(2)
end

---@param text string
---@return Text?
---@return string remaining
local function parse_text(text)
    local position = text:find("[%*`]")

    if not position then
        return inline.text(text), ""
    end

    if position == 1 then
        return nil, text
    end

    return inline.text(text:sub(1, position - 1)),
        text:sub(position)
end

---@param text string
---@param parse_inline InlineParser
---@return Link?
---@return string remaining
local function parse_link(text, parse_inline)
    local full, label, target =
        text:match("^(`(.-)%s+<(.-)>`_)")

    if not full then
        return nil, text
    end

    return inline.link(
        parse_inline(label),
        target
    ), text:sub(#full + 1)
end

---@param text string
---@return InlineCode?
---@return string remaining
local function parse_code(text)
    local full, content =
        text:match("^(%(``(.-)``%))")

    if not full then
        full, content = text:match("^(``(.-)``)")
    end

    if not full then
        return nil, text
    end

    return inline.inline_code(content),
        text:sub(#full + 1)
end

---@param text string
---@param parse_inline InlineParser
---@return Strong?
---@return string remaining
local function parse_strong(text, parse_inline)
    local full, content =
        text:match("^(%*%*(.-)%*%*)")

    if not full then
        return nil, text
    end

    return inline.strong(parse_inline(content)),
        text:sub(#full + 1)
end

---@param text string
---@param parse_inline InlineParser
---@return Emphasis?
---@return string remaining
local function parse_emphasis(text, parse_inline)
    local full, content =
        text:match("^(%*(.-)%*)")

    if not full then
        return nil, text
    end

    return inline.emphasis(parse_inline(content)),
        text:sub(#full + 1)
end

---@param text string
---@param parse_inline InlineParser
---@return Anchor?
---@return string remaining
local function parse_anchor(text, parse_inline)
    local full_match, id, content = text:match(
        "^(<a%s+name=['\"](.-)['\"]>(.-)</a>)"
    )

    if not full_match then
        return nil, text
    end

    return inline.anchor(id, parse_inline(content)),
        text:sub(#full_match + 1)
end

local parse_inline = engine.make({
    parse_anchor,
    parse_code,
    parse_link,
    parse_strong,
    parse_emphasis,
    parse_text,
    parse_unknown,
})

return {
    parse = parse_inline,
}
