local M        = {}

local api      = require("vimdoc.core.api")
local cache    = require("vimdoc.core.cache")
local renderer = require("vimdoc.core.renderer")
local writer   = require("vimdoc.core.writer")
local utils    = require("vimdoc.core.utils")

local fetchers = {
    github = require("vimdoc.source.github"),
}

M.config       = {
    sources = {}
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend(
        "force",
        M.config,
        opts or {}
    )
end

function M.update()
    vim.cmd("helptags" .. vim.fn.fnameescape(M.config.output_dir))
end

function M.open(query)
    print("Getting the docs for:", query)

    local doc = utils.parse_query(query, M.config)

    if not doc.source then
        print("Unknown source: " .. doc.source_name)
        return
    end

    local path = M.config.output_dir .. "/" .. doc.source_name .. "/" .. doc.tag .. ".txt"

    if cache.chech_cache(path) then
        print("Doc already exists: " .. doc.tag)
        vim.cmd("h " .. doc.tag)
        return
    end

    local fetcher = fetchers[doc.source.fetcher]
    local raw = fetcher.fetch(doc)
    local rendered = renderer.render(raw, doc)
    writer.write(path, rendered)
    M.update()
end

return M
