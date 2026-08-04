local M = {}

---@type table<string,InlineRenderer>
local inline_renderers = {}

local render_inline

---@param node Text
---@return string
inline_renderers.text = function(node)
    return node.text
end

---@param node Link
---@return string
inline_renderers.link = function(node)
    return render_inline(node.children)
end

---@param node InlineCode
---@return string
inline_renderers.inline_code = function(node)
    return "`" .. node.text .. "`"
end

---@param node Strong
---@return string
inline_renderers.strong = function(node)
    return render_inline(node.children)
end

---@param node Emphasis
---@return string
inline_renderers.emphasis = function(node)
    return render_inline(node.children)
end

---@param node Anchor
---@return string
inline_renderers.anchor = function(node)
    return render_inline(node.children)
end

---@param content InlineNode[]
---@return string
render_inline = function(content)
    local pieces = {}

    for _, node in ipairs(content) do
        local renderer = inline_renderers[node.type]

        if renderer then
            table.insert(
                pieces,
                renderer(node)
            )
        end
    end

    return table.concat(pieces)
end

---@param block Heading
---@param output string[]
local function render_heading(block, output)
    local text = render_inline(block.children)

    table.insert(output, text)

    if block.level == 1 then
        table.insert(output, string.rep("=", #text))
    elseif block.level == 2 then
        table.insert(output, string.rep("-", #text))
    end

    table.insert(output, "")
end

---@param block Paragraph
---@param output string[]
local function render_paragraph(block, output)
    table.insert(output, render_inline(block.children))
    table.insert(output, "")
end

---@param block Code
---@param output string[]
local function render_code(block, output)
    table.insert(
        output,
        ">" .. (block.language or "")
    )

    for line in block.text:gmatch("[^\n]+") do
        table.insert(output, "    " .. line)
    end

    table.insert(output, "<")
    table.insert(output, "")
end

---@param block List
---@param output string[]
local function render_list(block, output)
    for _, item in ipairs(block.items) do
        table.insert(
            output,
            "* " .. render_inline(item))
    end

    table.insert(output, "")
end

---@type table<string,BlockRenderer>
local renderers = {
    heading = render_heading,
    paragraph = render_paragraph,
    code = render_code,
    list = render_list,
}


---@param doc Document
---@return string
function M.render(doc)
    local output = {}

    table.insert(output, "*" .. doc.tag .. "*")
    table.insert(output, "")

    for _, block in ipairs(doc.content) do
        local render = renderers[block.type]

        if render then
            render(block, output)
        end
    end

    table.insert(output, "")
    table.insert(output, string.rep("=", 80))
    table.insert(output, "vim:tw=80:ts=2:ft=help:norl:syntax=help\n")
    return table.concat(output, "\n")
end

return M
