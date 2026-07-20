vim.api.nvim_create_user_command(
    "Vimdoc",
    function(opts)
        require("vimdoc").open(opts.args)
    end,
    {
        nargs = 1,
    }
)
