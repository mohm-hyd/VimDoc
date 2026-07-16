local M = {}

function M.fetch(page)
    local url = "https://raw.githubusercontent.com/vrld/hump/refs/heads/master/docs/" .. page .. ".rst"
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
