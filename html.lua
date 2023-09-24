-- formatted version of jdeseno(@github)'s html.lua
-- compatible with luacheck and luals

---@diagnostic disable:lowercase-global

local Attr = {}
local AttrMeta = {
    __index = Attr,
    __tostring = function(attr)
        local str = ""
        for k, v in pairs(attr.fields) do
            str = string.format("%s %s=%q", str, k, v)
        end
        return str
    end,
}

function Attr.merge(self, attr)
    for k, v in pairs(attr.fields) do
        if self.fields[k] ~= nil then
            self.fields[k] = self.fields[k] .. " " .. v
        else
            self.fields[k] = v
        end
    end
end

function is_attr(t)
    return getmetatable(t) == AttrMeta
end

function attr(fields)
    return setmetatable({ fields = fields }, AttrMeta)
end

local Tag = {}
local TagMeta = {
    __index = Tag,
    __concat = function(tag, x)
        return tostring(tag) .. tostring(x)
    end,
    __tostring = function(tag)
        if tag.options.is_singular then
            local closing_slash = " /"
            if tag.options.no_closing_slash then
                closing_slash = ""
            end
            return string.format("<%s%s%s>%s", tag.name, tag.attributes, closing_slash, tag:content())
        else
            return string.format("<%s%s>%s</%s>", tag.name, tag.attributes, tag:content(), tag.name)
        end
    end,
}

function Tag.content(tag)
    local str = ""
    for i, _ in ipairs(tag.contents) do
        str = str .. tag.contents[i]
    end
    return str
end

function Tag.append(self, ...)
    local args = { ... }
    for _, v in ipairs(args) do
        if is_attr(v) then
            self:attr(v)
        else
            table.insert(self.contents, v)
        end
    end
    return self
end

function Tag.attr(self, tattr)
    self.attributes:merge(tattr)
    return self
end

function tag(name, opt, ...)
    return setmetatable({
        name = name,
        options = opt,
        contents = {},
        attributes = attr({}),
    }, TagMeta):append(...)
end

local is_singular = {
    img = true,
    input = true,
    link = true,
    meta = true,
}

return setmetatable({
    tag = tag, -- make your own tags
    attr = attr, -- specify attributes
    doctype = function(...)
        -- example custom tag
        return tag("!DOCTYPE html", { is_singular = true, no_closing_slash = true }, ...)
    end,
}, {
    -- dynamically generate tags
    __index = function(t, name)
        t[name] = function(...)
            return tag(name, { is_singular = is_singular[name] }, ...)
        end
        return t[name]
    end,
})
