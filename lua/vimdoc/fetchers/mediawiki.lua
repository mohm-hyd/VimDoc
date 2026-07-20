local M = {}

function M.genUrl(source, title)
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
    return source.config.project_url .. source.config.endpoint .."?".. parameters
end

function M.fetch(doc)
    local url = M.genUrl(doc.source, doc.page)
    print(url)


    local result = vim.system({
        "curl",
        "-s",
        url
    }):wait()

    print("Curl finished")
    print("Exit code:", result.code)

    if result.stderr then
        print("stderr:", result.stderr)
    end

    print("Output length:", #(result.stdout or ""))
    return result.stdout
end

return M
