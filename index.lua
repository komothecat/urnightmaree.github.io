local H, declare_generator
do
	local _obj_0 = require("xml-generator")
	H, declare_generator = _obj_0.xml, _obj_0.declare_generator
end
local layout
layout = function(title, ...)
	local head = H.head({
		H.title(title),
		H.meta({
			name = "viewport",
			content = "width-device-width, initial-scale=1.0"
		}),
		H.meta({
			charset = "utf-8"
		})
	})
	local body = H.body({
		...
	})
	return "<!DOCTYPE html>" .. tostring(H.html({
		head,
		body
	}))
end
local command
command = function(cmd, res)
	local cmd_tag = H.div({
		class = "cmd",
		H.span({
			class = "ps1"
		}, "$"),
		"\" " .. tostring(cmd) .. "\""
	})
	local res_tag = H.div({
		class = "res"
	}, res)
	return (declare_generator(function()
		return cmd_tag
	end)) .. (declare_generator(function()
		return res_tag
	end))
end
return print(layout(command("whois", "UrNightmaree"), "UrNightmaree"))
