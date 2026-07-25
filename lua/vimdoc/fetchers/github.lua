local http = require("vimdoc.http")

local M = {}

local function genUrl(source, page)
    return "https://raw.githubusercontent.com/" .. source.repo ..
        "/refs/heads/" .. source.branch .. "/" .. source.doc_path .. "/" .. page .. source.extension
end

function M.fetch(doc)
    local url = genUrl(doc.source, doc.page)
    return http.get(url)
end

return M
