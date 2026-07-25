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

 function M.code(text)
    return {
        type = "code",
        text = text
    }
end

 function M.list(items)
    return {
        type = "list",
        items = items,
    }
end

return M
