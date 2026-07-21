local M = {}

local function new_heading(text, level)
    return {
        type = "heading",
        level = level,
        text = text,
    }
end

local function new_paragraph(lines)
    return {
        type = "paragraph",
        text = table.concat(lines, " ")
    }
end

local function new_code_block(lines)
    return {
        type = "code",
        text = table.concat(lines, "\n")
    }
end
local function push_previous(parser)
    if parser.previous then
        table.insert(parser.paragraph, parser.previous)
        parser.previous = nil
    end
end
local function flush_paragraph(parser)
    push_previous(parser)
    if #parser.paragraph > 0 then
        table.insert(parser.content, new_paragraph(parser.paragraph))
        parser.paragraph = {}
    end
end

local function is_heading(line)
    return line:match("^=+$") or line:match("^%-+$")
end

local function get_heading_level(line)
    if line:match("^=+$") then
        return 1
    elseif line:match("^%-+$") then
        return 2
    end
    return nil
end

local function is_code_start(line)
    return line:match("::$")
end

local function iter_lines(raw)
    return raw:gmatch("(.-)\n")
end

local states = {}

states.normal = function(parser, line)
    if is_code_start(line) then
        flush_paragraph(parser)
        parser.state = "waiting_for_code"
    elseif is_heading(line) then
        local heading_text = parser.previous
        local level = get_heading_level(line)
        parser.previous = nil 
        table.insert(parser.content, new_heading(heading_text, level))
    elseif line:match("^%s*$") then
        flush_paragraph(parser)
    elseif parser.previous then
        table.insert(parser.paragraph, parser.previous)
        parser.previous = line
    else
        parser.previous = line
    end
end

states.waiting_for_code = function(parser, line)
    if line:match("^%s+") then
        parser.state = "code"
        table.insert(parser.code_lines, line)
    elseif line:match("^%s*$") then
        --ignore blank line
        return
    else
        parser.state = "normal"
        states.normal(parser, line)
    end
end


states.code = function(parser, line)
    if line:match("^%s+") then
        table.insert(parser.code_lines, line)
    else
        table.insert(parser.content, new_code_block(parser.code_lines))
        parser.code_lines = {}
        parser.state = "normal"
        states.normal(parser, line)
    end
end

function M.parse(raw_text)
    local parser = {
        content = {},
        state = "normal",
        paragraph = {},
        code_lines = {},
        previous = nil,
    }

    for line in iter_lines(raw_text) do
        states[parser.state](parser, line)
    end

    flush_paragraph(parser)

    if parser.state == "code" then
        table.insert(parser.content, new_code_block(parser.code_lines))
    end

    return parser.content
end

return M
