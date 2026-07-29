local M = {}

function M.text(text)
    return {
        type = "text",
        text = text,
    }
end

function M.link(text, target)
    return {
        type = "link",
        text = text,
        target = target,
    }
end

function M.inline_code(text)
    return {
        type = "inline_code",
        text = text,
    }
end

function M.strong(text)
    return {
        type = "strong",
        text = text,
    }
end

function M.emphasis(text)
    return {
        type = "emphasis",
        text = text,
    }
end

function M.anchor(id)
    return {
        type = "anchor",
        id = id,
    }
end

return M
