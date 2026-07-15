vim.api.nvim_create_user_command(
    "VimDoc",
    function(opts)
        require("vimdoc").open(opts.args)
    end,
    {
        nargs = 1,
        complete = "file"
    }
)
