local vimdoc = require("vimdoc")

vim.api.nvim_create_user_command("Vimdoc",function(opts)
        if #opts.fargs < 2 then
            vim.notify("Usage: :Vimdoc <source> <page>", vim.log.levels.ERROR)
            return 
        end

        vimdoc.open({
            source = opts.fargs[1],
            page = opts.fargs[2],
        })
    end,
    {
        nargs = "+",
    }
)
