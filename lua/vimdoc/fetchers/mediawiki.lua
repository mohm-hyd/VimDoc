local http = require("vimdoc.http")

local M = {}

---@param request string
---@return string? html
---@return string? error
local function extract(request)
    local ok, data = pcall(vim.json.decode, request)
    if not ok or not data then
        return nil, "Failed to decode JSON response"
    end

    if data.error then
        return nil, data.error.info or "MediaWiki API error"
    end

    if data.parse and data.parse.text and data.parse.text["*"] then
        return data.parse.text["*"], nil
    end

    return nil, "No HTML content found in response"
end

---@param source MediaWikiSource
---@param title string
---@return string
local function genUrl(source, title)
    local params = {
        action = "parse",
        page = vim.uri_encode(title),
        format = "json",
        prop = "text",
        redirects = "1",
    }

    local query = {}
    for key, value in pairs(params) do
        table.insert(query, key .. "=" .. value)
    end

    local parameters = table.concat(query, "&")
    return source.project_url .. source.endpoint .. "?" .. parameters
end

---@param doc MediaWikiDocument
---@return string? raw_html
---@return string? err
function M.fetch(doc)
    local url = genUrl(doc.source, doc.page)
    local request = http.get(url)

    if not request then
        return nil, "HTTP request failed for URL: " .. url
    end

    return extract(request)
end

return M
