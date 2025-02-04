local core = require("niuiic-core")
local config = require("cp-image.static").config

local get_image_info = function(full_path)
	local dir_path = string.match(full_path, "^([%s%S]*)/[^.^/]+.[^.^/]+$")
	print("dir_path:" .. dir_path)
	local image_type = string.match(full_path, "^[%s%S]*/[^.^/]+.([^.^/]+)$")
	print("image_type: " .. image_type)
	local file_name = string.match(full_path, "^[%s%S]*/([^.^/]+).[^.^/]+$")
	print("file_name: " .. file_name)
	return {
		dir_path = dir_path,
		image_type = image_type,
		file_name = file_name,
	}
end

local generate_image = function(cmd, full_path)
	local image_info = get_image_info(full_path)
	if core.file.file_or_dir_exists(image_info.dir_path) == false then
		vim.cmd(string.format("!%s %s", config.create_dir, image_info.dir_path))
	end
	vim.cmd(string.format("!" .. cmd(full_path, image_info.image_type)))
	vim.notify("paste image to " .. full_path, vim.log.levels.INFO)
end

return {
	get_image_info = get_image_info,
	generate_image = generate_image,
}
