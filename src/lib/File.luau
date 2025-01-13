local luauPath = require("../../luau_packages/luau_path")
local Path = luauPath.Path
local fs = require("./fs")
local types = require("./types")
local gt = require("../../lune_packages/greentea")

local PathType = types.PathType
local AsPathType = types.AsPathType
local ContentsType = types.ContentsType
local optionalBooleanType = types.optionalBooleanType
local stringType = types.stringType
local booleanType = types.booleanType

local FileTableType = gt.build(gt.table({
	path = PathType:type(),
}))

export type File = typeof(setmetatable({} :: typeof(FileTableType:type()), {} :: FileImpl))

type FileImpl = {
	__index: FileImpl,
	new: (filePath: typeof(AsPathType:type())) -> File,
	fromExisting: (filePath: typeof(AsPathType:type())) -> File,
	create: (
		filePath: typeof(AsPathType:type()),
		initialContents: typeof(ContentsType:type()),
		overwrite: typeof(optionalBooleanType:type())
	) -> File,
	is: (value: any) -> boolean,
	isFile: (self: File) -> typeof(booleanType:type()),
	readFile: (self: File) -> typeof(stringType:type()),
	writeFile: (self: File, contents: typeof(ContentsType:type())) -> (),
	removeFile: (self: File) -> (),
}

local File = {} :: FileImpl
File.__index = File

function File.new(filePath)
	AsPathType:assert(filePath)

	return setmetatable({
		path = Path.from(filePath),
	}, File)
end

function File.fromExisting(filePath)
	AsPathType:assert(filePath)

	if not fs.isFile(filePath) then
		error(`There is no file at that path({filePath})`)
	end

	return setmetatable({
		path = Path.from(filePath),
	}, File)
end

function File.create(filePath, initialContents, overwrite)
	AsPathType:assert(filePath)
	ContentsType:assert(initialContents)
	optionalBooleanType:assert(overwrite)

	if fs.isFile(filePath) then
		if overwrite then
			fs.removeDir(filePath)
		else
			error(`Cannot create a new file. A file already exists at that path({filePath})`)
		end
	end
	if fs.isDir(filePath) then
		error(`Cannot create a new file. The directory already exists at that path({filePath})`)
	end
	fs.writeFile(filePath, initialContents)

	return setmetatable({
		path = Path.from(filePath),
	}, File)
end

function File.is(value)
	if type(value) == "table" and getmetatable(value) == File then
		FileTableType:assert(value)

		return true
	end
	return false
end

local FileType = gt.build(gt.custom(File.is, "File") :: File)

function File.isFile(self)
	FileType:assert(self)

	local isFile = fs.isFile(self.path)

	booleanType:assert(isFile)

	return isFile
end

function File.readFile(self)
	FileType:assert(self)

	local contents = fs.readFile(self.path)

	stringType:assert(contents)

	return contents
end

function File.writeFile(self, contents)
	FileType:assert(self)
	ContentsType:assert(contents)

	return fs.writeFile(self.path, contents)
end

function File.removeFile(self)
	FileType:assert(self)

	return fs.removeFile(self.path)
end

return File
