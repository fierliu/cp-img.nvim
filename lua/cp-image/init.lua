local core = require("niuiic-core")
local lib = require("cp-image.lib")
local static = require("cp-image.static")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

local paste_image = function()
	local root_path = core.file.root_path(static.config.root_pattern)
	-- get markdown filename
	local file_name = vim.fn.expand("%")
	-- delete .md of filename
	local file_name_short = string.sub(file_name, 0, string.len(file_name) - 3)
	local default_path = static.config.path(root_path)
	-- how to get clipboard img's file type?
	local date = os.date("%Y%m%d%H%M%S")
	print(date)
	vim.ui.input({ prompt = "Image path: ", default = default_path .. "/.assets/" .. file_name_short .. "/" }, function(input)
		if input == nil then
			input = default_path .. "/.assets/" .. file_name_short .. "/" .. date .. ".png"
		end
		local image_info = lib.get_image_info(input)
		if image_info.dir_path == nil or image_info.file_name == nil or image_info.image_type == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
			return
		end
		if string.find(input, root_path) == nil then
			vim.notify("wrong path", vim.log.levels.ERROR)
			return
		end
		lib.generate_image(static.config.cmd, input)
		local relative_path = string.sub(input, string.len(root_path) + 1)
		local pos = vim.api.nvim_win_get_cursor(0)
		core.text.insert(static.config.text(relative_path, image_info.file_name, image_info.image_type, input), {
			row = pos[1],
			col = pos[2],
		})
	end)
end

return {
	paste_image = paste_image,
	setup = setup,
}
