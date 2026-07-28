--Block creation
 M = {}

function M.heading(text, level)
    return {
        type = "heading",
        level = level,
        text = text,
    }
end

 function M.paragraph(text)
    return {
        type = "paragraph",
        text = text
    }
end

 function M.code(text,lang)
    return {
        type = "code",
        content = {
            language = lang or "lua",
            text = text,
        },
    }
end

 function M.list(items)
    return {
        type = "list",
        items = items,
    }
end

return M
