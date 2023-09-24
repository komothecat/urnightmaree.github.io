local H = require("html")
local layout
layout = function(title, ...)
	local head = H.head(H.title(title), H.meta(attr({
		name = "viewport",
		content = "width-device-width, initial-scale=1.0"
	})), H.meta(attr({
		charset = "utf-8"
	})))
	local body = H.body(...)
	body:append(H.div(attr({
		id = "copyright"
	})), "Content &copy;" .. tostring(os.date("%Y")))
	return H.doctype(H.html(head, body))
end
return print(layout("hello"))
