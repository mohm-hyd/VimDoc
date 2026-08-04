local M = {}

---@param node TSNode
---@param type string
---@return TSNode?
function M.find_descendant(node, type)
    if node:type() == type then
        return node
    end
    for child in node:iter_children() do
        local result = M.find_descendant(child, type)
        if result then
            return result
        end
    end
    return nil
end

return M
