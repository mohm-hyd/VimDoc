local M = {}

M.config = {
    sources = {}
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend(
        "force",
        M.config,
        opts or {}
    )
end

function M.open(query)
    print("Getting the docs for:", query)
    local source_name, page = query:match("^([^.]+)%.(.+)$")
    local source_config = M.config.sources[source_name]
    if not source_config then
        print("Unknown source: " .. source_name)
        return
    end
    local fetcher = require("vimdoc.source." .. source_config.fetcher)
    local docs = fetcher.fetch(source_config, page)
    require("vimdoc.core.renderer").render(docs,source_config.format,query)
end

return M
