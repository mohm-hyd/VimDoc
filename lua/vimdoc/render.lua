local M = {}

local WRAP_WIDTH = 78
local str_width = vim.api.nvim_strwidth

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

---@param text string
---@param limit integer
---@param indent string|nil
---@return string[]
local function wrap_text(text, limit, indent)
    indent = indent or ""
    limit = limit or WRAP_WIDTH
    local lines = {}
    local current = indent

    for word in text:gmatch("%S+") do
        if #current + #word + 1 > limit then
            table.insert(lines, current)
            current = indent .. word
        else
            if #current > #indent then
                current = current .. " " .. word
            else
                current = current .. word
            end
        end
    end

    if #current > #indent then
        table.insert(lines, current)
    end

    return lines
end

---@type table<string, fun(node: table): string>
local inline_renderers = {}

local render_inline

---@param node Text
---@return string
inline_renderers.text = function(node)
    return node.text or ""
end

---@param node Link
---@return string
inline_renderers.link = function(node)
    local target = node.target or ""
    local text = render_inline(node.children)

    local lower_target = target:lower()
    local is_url = lower_target:find("^https?://")
        or lower_target:find("^ftp://")
        or lower_target:find("^www%.")

    if is_url then
        if text ~= "" and text ~= target then
            return text .. " (" .. target .. ")"
        end
        return target
    end

    if target ~= "" then
        local tag = target:gsub("^#", "")
        return "|" .. tag .. "|"
    end
    return text
end

---@param node InlineCode
---@return string
inline_renderers.inline_code = function(node)
    return "`" .. (node.text or "") .. "`"
end

---@param node Strong
---@return string
inline_renderers.strong = function(node)
    return "`" .. render_inline(node.children) .. "`"
end

---@param node Emphasis
---@return string
inline_renderers.emphasis = function(node)
    return "_" .. render_inline(node.children) .. "_"
end

---@param node Anchor
---@return string
inline_renderers.anchor = function(node)
    local raw_tag = (node.id and node.id ~= "") and node.id or render_inline(node.children)

    if not raw_tag or raw_tag == "" then
        return ""
    end

    local tag = raw_tag:gsub("%s+", "-")
    return "*" .. tag .. "*"
end

---@param content InlineNode[]
---@return string
render_inline = function(content)
    if not content then return "" end
    local pieces = {}

    for _, node in ipairs(content) do
        local renderer = inline_renderers[node.type]
        if renderer then
            table.insert(pieces, renderer(node))
        end
    end

    return table.concat(pieces)
end

---@param block Heading
---@param output string[]
---@param doc Document
local function render_heading(block, output, doc)
    local text = render_inline(block.children)

    local base_prefix = (doc and doc.tag and doc.tag ~= "") and doc.tag or nil
    local tag_slug = base_prefix and (base_prefix .. "-" .. slugify(text)) or slugify(text)
    local tag = "*" .. tag_slug .. "*"

    if block.level == 1 then
        table.insert(output, string.rep("=", WRAP_WIDTH))
        local title = text:upper()
        local gap = WRAP_WIDTH - str_width(title) - str_width(tag)

        if gap >= 2 then
            table.insert(output, title .. string.rep(" ", gap) .. tag)
        else
            table.insert(output, title)
            table.insert(output, string.rep(" ", math.max(0, WRAP_WIDTH - str_width(tag))) .. tag)
        end
    elseif block.level == 2 then
        table.insert(output, string.rep("-", WRAP_WIDTH))
        local header = text:upper() .. "~"
        local gap = WRAP_WIDTH - str_width(header) - str_width(tag)

        if gap >= 2 then
            table.insert(output, header .. string.rep(" ", gap) .. tag)
        else
            table.insert(output, header)
            table.insert(output, string.rep(" ", math.max(0, WRAP_WIDTH - str_width(tag))) .. tag)
        end
    else
        table.insert(output, text .. "~")
    end

    table.insert(output, "")
end
---@param block Paragraph
---@param output string[]
local function render_paragraph(block, output)
    local text = render_inline(block.children)
    local wrapped = wrap_text(text, WRAP_WIDTH)

    for _, line in ipairs(wrapped) do
        table.insert(output, line)
    end

    table.insert(output, "")
end

---@param block Code
---@param output string[]
local function render_code(block, output)
    table.insert(output, ">")

    for line in (block.text or ""):gmatch("[^\r\n]+") do
        table.insert(output, "    " .. line)
    end

    table.insert(output, "<")
    table.insert(output, "")
end

---@param block List
---@param output string[]
local function render_list(block, output)
    for _, item in ipairs(block.items) do
        local children = item.children or item
        local item_text = render_inline(children)

        local leading_spaces = item_text:match("^(%s*)") or ""
        local trimmed_text = item_text:sub(#leading_spaces + 1)

        local item_indent = leading_spaces .. "  "
        local wrapped = wrap_text(trimmed_text, WRAP_WIDTH, item_indent)

        if #wrapped > 0 then
            wrapped[1] = leading_spaces .. "- " .. wrapped[1]:sub(#leading_spaces + 3)
            for _, line in ipairs(wrapped) do
                table.insert(output, line)
            end
        end
    end

    table.insert(output, "")
end

---@param block Table
---@param output string[]
local function render_table(block, output)
    if not block.rows or #block.rows == 0 then
        return
    end

    local rendered_rows = {}
    local col_widths = {}

    for r_idx, row in ipairs(block.rows) do
        rendered_rows[r_idx] = {}
        for c_idx, cell in ipairs(row) do
            local cell_text = render_inline(cell)
            rendered_rows[r_idx][c_idx] = cell_text

            local len = #cell_text
            if not col_widths[c_idx] or len > col_widths[c_idx] then
                col_widths[c_idx] = len
            end
        end
    end

    for _, row in ipairs(rendered_rows) do
        local line_parts = {}
        for c_idx, cell_text in ipairs(row) do
            local is_last = (c_idx == #row)

            if is_last then
                table.insert(line_parts, cell_text)
            else
                local target_width = col_widths[c_idx] or 0
                local padding = string.rep(" ", target_width - #cell_text + 2)
                table.insert(line_parts, cell_text .. padding)
            end
        end

        table.insert(output, table.concat(line_parts))
    end

    table.insert(output, "")
end

---@type table<string, fun(block: table, output: string[], doc: Document)>
local renderers = {
    heading = render_heading,
    paragraph = render_paragraph,
    code = render_code,
    list = render_list,
    table = render_table,
}

---@param doc Document
---@return string
function M.render(doc)
    local output = {}

    if doc.tag and doc.tag ~= "" then
        table.insert(output, "*" .. doc.tag .. "*")
        table.insert(output, "")
    end

    for _, block in ipairs(doc.content) do
        local render = renderers[block.type]
        if render then
            render(block, output, doc)
        end
    end

    return table.concat(output, "\n")
end

return M
