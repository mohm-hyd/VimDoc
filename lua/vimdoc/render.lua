local M = {}

--renderers

local function render_heading(block, output)
    table.insert(output, block.text)
    if block.level == 1 then
        table.insert(output, string.rep("=", #block.text))
    elseif block.level == 2 then
        table.insert(output, string.rep("=", #block.text))
    end
    table.insert(output, "")
end

local function render_paragraph(block, output)
    table.insert(output, block.text)
    table.insert(output, "")
end

local function render_code(block, output)
    table.insert(output, ">" .. block.content.language)
    for line in block.content.text:gmatch("[^\n]+") do
        table.insert(output, "    " .. line)
    end
    table.insert(output, "<")
    table.insert(output, "")
end

local function render_list(block, output)
    for _, item in ipairs(block.items) do
        table.insert(output, "*" .. item)
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
