local M = {}

--renderers
local inline_renderers = {}

local render_inline

inline_renderers.text = function(node)
    return node.text
end

inline_renderers.link = function(node)
    return render_inline(node.children)
end

inline_renderers.inline_code = function(node)
    return node.text
end

inline_renderers.strong = function(node)
    return render_inline(node.children)
end

inline_renderers.emphasis = function(node)
    return render_inline(node.children)
end

inline_renderers.anchor = function(node)
    return render_inline(node.children)
end


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


local function render_heading(block, output)

    local text = render_inline(block.children)

    table.insert(output,text)

    if block.level == 1 then
        table.insert(output,string.rep("=", #text))
    elseif block.level == 2 then
        table.insert(output,string.rep("-", #text))
    end

    table.insert(output,"")
end

local function render_paragraph(block, output)
    table.insert(output, render_inline(block.children))
    table.insert(output, "")
end

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

local function render_list(block, output)
    for _, item in ipairs(block.items) do
        table.insert(
            output,
            "* " .. render_inline(item))
    end

    table.insert(output, "")
end


local renderers = {
    heading = render_heading,
    paragraph = render_paragraph,
    code = render_code,
    list = render_list,
}

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

    return table.concat(output, "\n")
end

return M
