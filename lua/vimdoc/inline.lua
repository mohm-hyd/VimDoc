local M = {}


function M.text(text)
    return {
        type = "text",
        text = text,
    }
end

function M.link(children, target)
    return {
        type = "link",
        children = children,
        target = target,
    }
end

function M.inline_code(text)
    return {
        type = "inline_code",
        text = text,
    }
end

function M.strong(children)
    return {
        type = "strong",
        children = children,
    }
end

function M.emphasis(children)
    return {
        type = "emphasis",
        children = children,
    }
end

function M.anchor(id,children)
    return {
        type = "anchor",
        id = id,
        children =children
    }
end

return M
