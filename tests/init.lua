vim.opt.runtimepath:prepend(vim.fn.getcwd())

require("vimdoc").setup({
    output_dir = "./doc",
    sources = {
        hump = {

            name = "hump",
            fetcher = "github",
            config = {
                repo = "vrld/hump",
                branch = "master",
                docs = "docs",
                format = "rst",
                extension = ".rst",
            }
        },

        moses = {
            name = "moses",
            fetcher = "github",
            config = {
                repo = "Yonaba/Moses",
                branch = "master",
                docs = "doc",
                format = "markdown",
                extension = ".md",
            }
        },

        love = {
            name = "love",
            fetcher = "mediawiki",
            config = {
                project_url = "https://love2d.org",
                endpoint = "/w/index.php",
                format = "mediawiki",
            }
        },

        arch = {
            name = "archlinux",
            fetcher = "mediawiki",
            config = {
                project_url = "https://wiki.archlinux.org",
                endpoint = "/api.php",
                format = "mediawiki",
            }
        }

    },
})
