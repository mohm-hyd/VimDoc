local http = require("vimdoc.http")

local M = {}

---@param source GithubSource
---@param page string
---@return string
local function genUrl(source, page)
    return "https://raw.githubusercontent.com/" .. source.repo ..
        "/refs/heads/" .. source.branch .. "/" .. source.doc_path .. "/" .. page .. source.extension
end

---@param doc GithubDocument
---@return string?
---@return string?
function M.fetch(doc)
    local url = genUrl(doc.source, doc.page)
    return http.get(url)
end

return M
