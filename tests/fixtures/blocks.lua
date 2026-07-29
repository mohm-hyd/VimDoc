return {
    {
        type = "heading",
        level = 1,
        text = "Test Document",
    },

    {
        type = "paragraph",
        children = { {
            type = "text",
            text = "This is a simple paragraph that should be parsed correctly.",
        }
        }
    },

    {
        type = "code",
        children = {
            language = "lua",
            text = 'print("hello world")\nprint("another line")'
        },
    },

    {
        type = "heading",
        level = 2,
        text = "Features",
    },

    {
        type = "list",
        items = {
            "First item",
            "Second item",
            "Third item",
        },
    },
}
