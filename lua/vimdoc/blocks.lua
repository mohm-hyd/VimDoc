M = {}


---@param children InlineNode[]
---@param level integer
---@return Heading
function M.heading(children, level)
    return {
        type = "heading",
        level = level,
        children = children,
    }
end

---@param children InlineNode[]
---@return Paragraph
function M.paragraph(children)
    return {
        type = "paragraph",
        children = children
    }
end

---@param text string
---@param lang string
---@return Code
function M.code(text, lang)
    return {
        type = "code",
        language = lang or "lua",
        text = text,
    }
end

---@param items ListItem[]
---@return List
function M.list(items)
    return {
        type = "list",
        items = items,
    }
end

return M
