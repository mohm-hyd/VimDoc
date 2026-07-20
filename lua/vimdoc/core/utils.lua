local M = {}

function M.parse_query(query, config)
    local source_name, page = query:match("^([^.]+)%.(.+)$")
    local source = config.sources[source_name]

    return {
        tag = query,
        source_name = source_name,
        source = source,
        page = page,
    }
end

return M
