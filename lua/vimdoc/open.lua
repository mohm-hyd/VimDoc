local M          = {}

local helptags   = require("vimdoc.helptags")
local config     = require("vimdoc.config")
local cache      = require("vimdoc.cache")
local writer     = require("vimdoc.writer")
local fetchers   = require("vimdoc.fetchers")
local parsers = require("vimdoc.parsers")
local renderers  = require("vimdoc.renderers")


function M.open(request)

    print("Getting the docs for:", request.page)
    local source = config.options.sources[request.source]

    if not source then
        print("Unknown source: " .. request.source)
        return
    end

    local doc = {
        source = source,
        page = request.page,
        tag = request.source .. "." .. request.page,
    }

    local path = config.options.output_dir .. "/" .. doc.source.name .. "/" .. doc.tag .. ".txt"

    if cache.check_cache(path) then
        print("Doc already exists: " .. doc.tag)
        vim.cmd("h " .. doc.tag)
        return
    end

    doc.raw = fetchers[doc.source.fetcher].fetch(doc)
    assert(doc.raw, "Fetcher returned no data")

    doc.content = parsers[doc.source.config.format].parse(doc.raw)
    assert(doc.content, "Parser returned no content")

    doc.output = renderers[doc.source.config.format].render(doc)
    writer.write(path, doc.output)

    helptags.update()
    vim.cmd("h " .. doc.tag)
end

return M
