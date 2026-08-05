local tests = {
    "tests/adapter/rst_spec.lua",
    "tests/adapter/md_spec.lua",
    "tests/render/render_spec.lua",
}

for _, test in ipairs(tests) do
    print("Running " .. test)

    local ok, err = pcall(dofile, test)

    if not ok then
        error("Test failed: " .. test .. "\n" .. err)
        vim.cmd("cq")
    end
end

print("All tests passed \n")


vim.cmd("qa")
