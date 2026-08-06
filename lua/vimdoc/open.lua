local config   = require("vimdoc.config")
local fetchers = require("vimdoc.fetchers")
local parser   = require("vimdoc.parser")
local toc      = require("vimdoc.toc")
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

    local path = config.options.output_dir .. "/" .. doc.source.name .. "/doc/" .. doc.tag .. ".txt"

    if cache.check_cache(path) then
        print("Doc already exists: " .. doc.tag)
        vim.cmd("help " .. doc.tag)
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

    toc.inject(doc)

    doc.output = renderer.render(doc)

    writer.write(path, doc.output)

    local doc_dir = vim.fn.fnamemodify(path, ":h")
    if vim.fn.isdirectory(doc_dir) == 0 then
        vim.fn.mkdir(doc_dir, "p")
    end
    if not vim.o.runtimepath:find(doc_dir, 1, true) then
        vim.opt.runtimepath:append(doc_dir)
    end

    helptags.update_helptags()
    vim.cmd("help " .. doc.tag)
end

return M
