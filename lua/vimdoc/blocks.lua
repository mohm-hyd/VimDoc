

--Block creation
 M = {}

function M.heading(text, level)
    return {
        type = "heading",
        level = level,
        text = text,
    }
end

 function M.paragraph(children)
    return {
        type = "paragraph",
        children = children
    }
end

 function M.code(text,lang)
    return {
        type = "code",
        children = {
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
