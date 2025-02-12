-- original source credits to: https://github.com/ffrostfall/lunePackages/blob/e6335a8c44957afbf1b00e3ecca37ac6a03af14d/getFilesUnderDirectory/init.luau

local fs = require("@lune/fs")

local function read(directory: string): { string }
	local paths: { string } = {}

	local contents = fs.readDir(directory)
	if not contents then
		return {}
	end

	for _, filePath in contents do
		if fs.isDir(directory .. "/" .. filePath) then
			local subdirectoryContents = read(directory .. "/" .. filePath)

			for _, element in subdirectoryContents do
				table.insert(paths, filePath .. "/" .. element)
			end
		else
			table.insert(paths, filePath)
		end
	end

	return paths
end

return read
