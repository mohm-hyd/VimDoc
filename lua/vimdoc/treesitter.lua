local M = {}


function M.find_descendant(node, type)
    if node:type() == type then
        return node
    end
    for i = 0, node:child_count() - 1 do
        local result = M.find_descendant(node:child(i), type)
        if result then
            return result
        end
    end
    return nil
end

return M
