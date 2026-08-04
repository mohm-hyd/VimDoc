vim.opt.runtimepath:prepend(vim.fn.getcwd())


require("nvim-treesitter").setup({
	ensure_installed = { "lua","rst","markdown","html"},
	highlight = { enable = true },
	indent = { enable = true },
	})


require("vimdoc").setup({
    output_dir = "./doc",
    sources = {
        rtd = {
            name = "readthedocs",
            fetcher = "github",
            repo = "readthedocs/readthedocs.org",
            branch = "main",
            doc_path = "docs/user",
            format = "rst",
            extension =".rst",
        },
        hump = {

            name = "hump",
            fetcher = "github",
            repo = "vrld/hump",
            branch = "master",
            doc_path = "docs",
            format = "rst",
            extension = ".rst",
        },

        moses = {
            name = "moses",
            fetcher = "github",
            repo = "Yonaba/Moses",
            branch = "master",
            doc_path = "doc",
            format = "markdown",
            extension = ".md",
        },

        love = {
            name = "love",
            fetcher = "mediawiki",
            project_url = "https://love2d.org",
            endpoint = "/w/index.php",
            format = "html",
        },

        arch = {
            name = "archlinux",
            fetcher = "mediawiki",
            project_url = "https://wiki.archlinux.org",
            endpoint = "/api.php",
            format = "html",
        }

    },
})
