--!strict

local fs = require("@lune/fs")
local types = require("types")
local pathfs = {}

type Contents = buffer | string

local function asPathToString(asPath: types.AsPath): string
	if type(asPath) == "string" then
		return asPath
	end
	return pathfs.Path.from(asPath):toString()
end

function pathfs.copy(from: types.AsPath, to: types.AsPath, overwriteOrOptions: (fs.WriteOptions | boolean)?)
	return fs.copy(asPathToString(from), asPathToString(to), overwriteOrOptions)
end

function pathfs.isDir(path: types.AsPath)
	return fs.isDir(asPathToString(path))
end

function pathfs.isFile(path: types.AsPath)
	return fs.isFile(asPathToString(path))
end

function pathfs.metadata(path: types.AsPath)
	return fs.metadata(asPathToString(path))
end

function pathfs.move(from: types.AsPath, to: types.AsPath, overwriteOrOptions: (fs.WriteOptions | boolean)?)
	return fs.move(asPathToString(from), asPathToString(to), overwriteOrOptions)
end

function pathfs.readDir(path: types.AsPath)
	return fs.readDir(asPathToString(path))
end

function pathfs.readFile(path: types.AsPath)
	return fs.readFile(asPathToString(path))
end

function pathfs.removeDir(path: types.AsPath)
	return fs.removeDir(asPathToString(path))
end

function pathfs.removeFile(path: types.AsPath)
	return fs.removeFile(asPathToString(path))
end

function pathfs.writeFile(path: types.AsPath, contents: Contents)
	return fs.writeFile(asPathToString(path), contents)
end

function pathfs.writeDir(path: types.AsPath)
	return fs.writeDir(asPathToString(path))
end

pathfs.Path = require("luau-path").Path :: {
	new: () -> (types.Path),
	from: (path: types.AsPath) -> (types.Path)
}

return pathfs
