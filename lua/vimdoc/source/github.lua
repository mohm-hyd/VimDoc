local M = {}

local function genUrl(source, page)
    return "https://raw.githubusercontent.com/" .. source.repo ..
        "/refs/heads/" .. source.branch .. "/" .. source.docs .. "/" .. page .. source.extension
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
