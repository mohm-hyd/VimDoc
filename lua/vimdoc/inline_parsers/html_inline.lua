local inline = require("vimdoc.inline")
local engine = require("vimdoc.inline_parsers.engine")

local entity_map = {
    amp = "&",
    lt = "<",
    gt = ">",
    quot = '"',
    apos = "'",
    nbsp = " ",
}

---@param text string
---@return nil
---@return string remaining
local function parse_generic_tag(text)
    local full = text:match("^<[^>]+>")
    if not full then
        return nil, text
    end

    return inline.ignore(), text:sub(#full + 1)
end

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
    local position = text:find("[<&]")

    if not position then
        return inline.text(text), ""
    end

    if position == 1 then
        return nil, text
    end

    return inline.text(text:sub(1, position - 1)), text:sub(position)
end

---@param text string
---@return Text?
---@return string remaining
local function parse_entity(text)
    local full, entity_name = text:match("^(&(#?%w+);)")
    if not full then
        return nil, text
    end

    local decoded = entity_map[entity_name]
    if not decoded and entity_name:sub(1, 1) == "#" then
        local num = entity_name:sub(2):lower()
        local code = tonumber(num:sub(1, 1) == "x" and num:sub(2) or num, num:sub(1, 1) == "x" and 16 or 10)
        if code then decoded = string.char(code) end
    end

    return inline.text(decoded or full), text:sub(#full + 1)
end

---@param text string
---@param parse_inline InlineParser
---@return Link?
---@return string remaining
local function parse_link(text, parse_inline)
    local full, href, content = text:match("^(<a%f[%s>][^>]*href=[\"']([^\"']-)[\"'][^>]*>(.-)</a>)")

    if not full or not href then
        return nil, text
    end

    local block = inline.link(
        parse_inline(content or ""),
        href
    )

    return block, text:sub(#full + 1)
end

---@param text string
---@return InlineCode?
---@return string remaining
local function parse_code(text)
    local full, content = text:match("^(<code%f[%s>][^>]*>(.-)</code>)")

    if not full then
        return nil, text
    end

    return inline.inline_code(content or ""), text:sub(#full + 1)
end

---@param text string
---@param parse_inline InlineParser
---@return Strong?
---@return string remaining
local function parse_strong(text, parse_inline)
    local full, content = text:match("^(<strong%f[%s>][^>]*>(.-)</strong>)")

    if not full then
        full, content = text:match("^(<b%f[%s>][^>]*>(.-)</b>)")
    end

    if not full then
        return nil, text
    end

    return inline.strong(parse_inline(content or "")), text:sub(#full + 1)
end

---@param text string
---@param parse_inline InlineParser
---@return Emphasis?
---@return string remaining
local function parse_emphasis(text, parse_inline)
    local full, content = text:match("^(<em%f[%s>][^>]*>(.-)</em>)")

    if not full then
        full, content = text:match("^(<i%f[%s>][^>]*>(.-)</i>)")
    end

    if not full then
        return nil, text
    end

    return inline.emphasis(parse_inline(content or "")), text:sub(#full + 1)
end

local parse_inline = engine.make({
    parse_link,
    parse_code,
    parse_strong,
    parse_emphasis,
    parse_entity,
    parse_generic_tag,
    parse_text,
    parse_unknown,
})

return {
    parse = parse_inline,
}
