local luauPath = require("../../luau_packages/luau_path")
local Path = luauPath.Path
local fs = require("./fs")
local gt = require("../../lune_packages/greentea")
local types = require("./types")

local PathType = types.PathType
local AsPathType = types.AsPathType
local optionalBooleanType = types.optionalBooleanType
local arrayOfPathType = types.arrayOfPathType
local booleanType = types.booleanType

local DirectoryTableType = gt.build(gt.table({
	path = PathType:type(),
}))

export type Directory = typeof(setmetatable({} :: typeof(DirectoryTableType:type()), {} :: DirectoryImpl))

type DirectoryImpl = {
	__index: DirectoryImpl,
	new: (dirPath: typeof(AsPathType:type())) -> Directory,
	fromExisting: (dirPath: typeof(AsPathType:type())) -> Directory,
	create: (dirPath: typeof(AsPathType:type()), overwrite: typeof(optionalBooleanType:type())) -> Directory,
	is: (value: any) -> boolean,
	isDir: (self: Directory) -> typeof(booleanType:type()),
	readDir: (self: Directory) -> typeof(arrayOfPathType:type()),
	writeDir: (self: Directory) -> (),
	removeDir: (self: Directory) -> (),
}

local Directory = {} :: DirectoryImpl
Directory.__index = Directory

function Directory.new(dirPath)
	AsPathType:assert(dirPath)

	return setmetatable({
		path = Path.from(dirPath),
	}, Directory)
end

function Directory.fromExisting(dirPath)
	AsPathType:assert(dirPath)

	if not fs.isDir(dirPath) then
		error(`There is no directory at that path({dirPath})`)
	end

	return setmetatable({
		path = Path.from(dirPath),
	}, Directory)
end

function Directory.create(dirPath, overwrite)
	AsPathType:assert(dirPath)
	optionalBooleanType:assert(overwrite)

	if fs.isDir(dirPath) then
		if overwrite then
			fs.removeDir(dirPath)
		else
			error(`Cannot create a new directory. A directory already exists at that path({dirPath})`)
		end
	end
	if fs.isFile(dirPath) then
		error(`Cannot create a new directory. The file already exists at that path({dirPath})`)
	end
	fs.writeDir(dirPath)

	return setmetatable({
		path = Path.from(dirPath),
	}, Directory)
end

function Directory.is(value)
	if type(value) == "table" and getmetatable(value) == Directory then
		DirectoryTableType:assert(value)

		return true
	end
	return false
end

local DirectoryType = gt.build(gt.custom(Directory.is, "Directory") :: Directory)

function Directory.isDir(self)
	DirectoryType:assert(self)

	local isDir = fs.isDir(self.path)

	booleanType:assert(isDir)

	return isDir
end

function Directory.readDir(self)
	DirectoryType:assert(self)

	return fs.readDir(self.path)
end

function Directory.writeDir(self)
	DirectoryType:assert(self)

	return fs.writeDir(self.path)
end

function Directory.removeDir(self)
	DirectoryType:assert(self)

	return fs.removeDir(self.path)
end

return Directory
