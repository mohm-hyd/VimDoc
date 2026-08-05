local config   = require("vimdoc.config")
local fetchers = require("vimdoc.fetchers")
local parser   = require("vimdoc.parser")
local renderer = require("vimdoc.render")
local writer   = require("vimdoc.writer")
local cache    = require("vimdoc.cache")
local helptags = require("vimdoc.helptags")

local M        = {}

---@param request OpenRequest
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

    ---@cast doc Document
    local raw, err = fetchers[doc.source.fetcher].fetch(doc)

    if not raw then
        vim.notify(
            "Failed to fetch " .. doc.tag .. ": " .. err,
            vim.log.levels.ERROR
        )
        return
    end

    doc.raw = raw
    doc.content = assert(parser.parse(doc))
    doc.output = renderer.render(doc)

    writer.write(path, doc.output)

    vim.opt.runtimepath:append(path)
    helptags.update_helptags()
    vim.cmd("help " .. doc.tag)
end

return M
