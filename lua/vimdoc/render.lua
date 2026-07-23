local M = {}

function M.render(doc)
    local output = {}

    table.insert(output, "*" .. doc.tag .. "*")
    table.insert(output, "")

    for _, block in ipairs(doc.content) do
        if block.type == "heading" then
            table.insert(output, block.text)
            if block.level == 1 then
                table.insert(output, string.rep("=", #block.text))
            elseif block.level == 2 then
                table.insert(output, string.rep("=", #block.text))
            end
            table.insert(output, "")
        elseif block.type == "paragraph" then
            table.insert(output, block.text)
            table.insert(output, "")
        elseif block.type == "code" then
            table.insert(output, "    "..block.text)
            table.insert(output, "")
        elseif block.type == "list" then
            for _, item in ipairs(block.items) do
                table.insert(output, "*" ..item)
            end

            table.insert(output, "")
        end
    end
    return table.concat(output, "\n")
end

return M
