--!strict

local fs = require("@lune/fs")
local process = require("@lune/process")
local types = require("types")
local pathfs = {}

export type Path = types.Path
export type AsPath = types.AsPath
export type Metadata = fs.Metadata
export type MetadataKind = fs.MetadataKind
export type MetadataPermissions = fs.MetadataPermissions
export type WriteOptions = fs.WriteOptions
export type Contents = buffer | string

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

function pathfs.getScriptPath(): types.Path
	local path = string.match(debug.info(2, "s"), '%[string "([^"]*)"%]')
	local luauPath = path .. ".luau"
	local luaPath = path .. ".lua"
	if fs.isFile(luauPath) then
		return pathfs.Path.from(luauPath)
	elseif fs.isFile(luaPath) then
		return pathfs.Path.from(luaPath)
	elseif fs.isFile(path) then
		return pathfs.Path.from(path)
	else
		error("Failed to get script path")
	end
end

function pathfs.normalizePath(path: pathfs.Path): types.Path
	return pathfs.Path.from(path:components())
end

function pathfs.getAbsolutePathOf(path: pathfs.Path): types.Path
	return pathfs.normalizePath(pathfs.cwd:join(path))
end

function pathfs.getNoCurDirPathOf(path: pathfs.Path): types.Path
	local components = path:components()
	local firstComponent = components:next()
	if firstComponent.type == "curDir" then
		return pathfs.Path.from(components)
	end
	return path
end

pathfs.pathSeparator = process.os == "windows" and "\\" or "/"

-- selene: allow(global_usage)
_G.SYS_PATH_SEPARATOR = pathfs.pathSeparator

pathfs.Path = require("luau-path").Path :: {
	new: () -> (types.Path),
	from: (path: types.AsPath) -> (types.Path),
	is: (value: unknown) -> (boolean)
}

pathfs.cwd = pathfs.normalizePath(pathfs.Path.from(process.cwd))

return pathfs
