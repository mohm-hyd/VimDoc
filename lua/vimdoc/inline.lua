local M = {}

---@param text string
---@return Text
function M.text(text)
    return {
        type = "text",
        text = text,
    }
end

---@param children InlineNode[]
---@param target string
---@return Link
function M.link(children, target)
    return {
        type = "link",
        children = children,
        target = target,
    }
end

---@param text string
---@return InlineCode
function M.inline_code(text)
    return {
        type = "inline_code",
        text = text,
    }
end

---@param children InlineNode[]
---@return Strong
function M.strong(children)
    return {
        type = "strong",
        children = children,
    }
end

---@param children InlineNode[]
---@return Emphasis
function M.emphasis(children)
    return {
        type = "emphasis",
        children = children,
    }
end

---@param id string
---@param children InlineNode[]
---@return Anchor
function M.anchor(id, children)
    return {
        type = "anchor",
        id = id,
        children = children
    }
end

---@return table
function M.ignore()
    return { type = "ignore" }
end

return M
