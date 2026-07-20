local M = {}

local function genUrl(source, page)
    return "https://raw.githubusercontent.com/" .. source.config.repo ..
        "/refs/heads/" .. source.config.branch .. "/" .. source.config.docs .. "/" .. page .. source.config.extension
end

function M.fetch(doc)
    local url = genUrl(doc.source, doc.page)
    print("Fetching:")
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
