local M = {}

---@param text string
---@return string
local function slugify(text)
    return text:lower()
        :gsub("[^a-z0-9%s_-]", "")
        :gsub("%s+", "-")
        :gsub("-+", "-")
        :gsub("^-", "")
        :gsub("-$", "")
end

---@param children table[]
---@return string
local function get_inline_text(children)
    local parts = {}
    for _, node in ipairs(children or {}) do
        if node.type == "text" or node.type == "inline_code" then
            table.insert(parts, node.text or "")
        elseif node.children then
            table.insert(parts, get_inline_text(node.children))
        end
    end
    return table.concat(parts)
end

---@param doc Document
function M.inject(doc)
    local items = {}
    local base_prefix = (doc.tag and doc.tag ~= "") and doc.tag or nil

    for _, block in ipairs(doc.content or {}) do
        if block.type == "heading" and (block.level == 1 or block.level == 2) then
            local text = get_inline_text(block.children)
            if text ~= "" and text:upper() ~= "CONTENTS" then
                local tag_slug = base_prefix and (base_prefix .. "-" .. slugify(text)) or slugify(text)

                local prefix = block.level == 2 and "  " or ""

                table.insert(items, {
                    { type = "text", text = prefix .. text .. " " },
                    { type = "link", target = tag_slug,           children = {} }
                })
            end
        end
    end

    if #items == 0 then return end

    local toc_blocks = {
        {
            type = "heading",
            level = 1,
            children = { { type = "text", text = "CONTENTS" } }
        },
        {
            type = "list",
            items = items
        }
    }

    for i = #toc_blocks, 1, -1 do
        table.insert(doc.content, 1, toc_blocks[i])
    end
end

return M
