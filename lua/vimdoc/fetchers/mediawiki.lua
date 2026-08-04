local http = require("vimdoc.http")

local M = {}

---@param source MediaWikiSource
---@param title string
---@return string
local function genUrl(source, title)
    local params = {
        action = "query",
        titles = title,
        format ="json",
        prop ="revisions",
        rvprop ="content",
        rvslots="main"
    }

    local query = {}

    for key,value in pairs(params) do
        table.insert(query, key .."="..value)
    end

    local parameters = table.concat(query, "&")
    return source.project_url .. source.endpoint .."?".. parameters
end

---@param doc MediaWikiDocument
---@return string?
---@return string?
function M.fetch(doc)
    local url = genUrl(doc.source, doc.page)
    return http.get(url)
end

return M
