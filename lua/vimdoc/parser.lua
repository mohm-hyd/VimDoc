local adapters = require("vimdoc.adapters")

M = {}

---@param doc Document
---@return Block[]
function M.parse(doc)
    local format = doc.source.format or "html"
    local adapter = adapters[format]

    if not adapter then
        error("[vimdoc] No adapter found for format: " .. tostring(format))
    end

    local ok, ts_parser = pcall(vim.treesitter.get_string_parser, doc.raw, format)
    if not ok or not ts_parser then
        error("[vimdoc] Tree-sitter parser for '" .. tostring(format) .. "' is not installed.")
    end

    local trees = ts_parser:parse()

    if not trees or #trees == 0 then
        error("[vimdoc] Tree-sitter failed to parse buffer content")
    end

    return adapter.adapt(trees[1], doc.raw)
end

return M
