local M = {}

function M.extract(doc)
    local data = vim.json.decode(doc.raw)

    for _, page in pairs(data.query.pages)do
        return page.revisions[1].slots.main["*"]
    end
end


return M
