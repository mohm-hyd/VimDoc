return
{ {
    children = { {
        text = "Test Document",
        type = "text"
    } },
    level = 1,
    type = "heading"
}, {
    children = { {
        text = "This is a simple paragraph that should be parsed correctly.",
        type = "text"
    } },
    type = "paragraph"
}, {
    language = "lua",
    text = '    print("hello world")\n    print("another line")\n',
    type = "code"
}, {
    children = { {
        text = "Features",
        type = "text"
    } },
    level = 2,
    type = "heading"
}, {
    items = { { {
        text = "First item",
        type = "text"
    } }, { {
        text = "Second item",
        type = "text"
    } }, { {
        text = "Third item",
        type = "text"
    } } },
    type = "list"
} }
