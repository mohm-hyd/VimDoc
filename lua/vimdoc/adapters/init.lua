local M = {}

local adapters = {
    html = "vimdoc.adapters.html",
    markdown = "vimdoc.adapters.markdown",
    rst = "vimdoc.adapters.rst",
}

return setmetatable(M, {
    __index = function(tbl, key)
        local module_path = adapters[key]
        if module_path then
            local adapter = require(module_path)
            rawset(tbl, key, adapter)
            return adapter
        end
        return nil
    end,
})
