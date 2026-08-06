local M = {}
---@param parsers InlineRule[]
---@return InlineParser
function M.make(parsers)
    local parse_inline

    ---@param text string?
    ---@return InlineNode[]
    parse_inline = function(text)
        if not text or type(text) ~= "string" or #text == 0 then
            return {}
        end

        local children = {}

        while #text > 0 do
            local matched = false

            for _, parser in ipairs(parsers) do
                local block, remaining = parser(text, parse_inline)

                if block then
                    if block.type ~= "ignore" then
                        table.insert(children, block)
                    end
                    text = remaining or ""
                    matched = true
                    break
                end
            end

            if not matched then
                error("Inline parser failed on remaining text: " .. text)
            end
        end

        return children
    end

    return parse_inline
end

return M
