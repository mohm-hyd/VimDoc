local M = {}

---@param parsers InlineRule[]
---@return InlineParser
function M.make(parsers)
    local parse_inline

    ---@param text string
    ---@return InlineNode[]
    parse_inline = function(text)
        local children = {}

        while #text > 0 do
            local matched = false

            for _, parser in ipairs(parsers) do
                local block, remaining = parser(text, parse_inline)

                if block then
                    table.insert(children, block)
                    text = remaining
                    matched = true
                    break
                end
            end

            if not matched then
                error("Inline parser failed: " .. text)
            end
        end

        return children
    end

    return parse_inline
end

return M
