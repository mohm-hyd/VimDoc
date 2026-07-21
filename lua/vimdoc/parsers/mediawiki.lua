local M = {}

function M.parse(raw_text)
    local data = vim.json.decode(raw_text)

    for _, page in pairs(data.query.pages)do
        return page.revisions[1].slots.main["*"]
    end
end


return M
