local process = require("@lune/process")
local pathSeparator = process.os == "windows" and "\\" or "/"
-- selene: allow(global_usage)
_G.SYS_PATH_SEPARATOR = pathSeparator
local luauPath = require("../../luau_packages/luau_path")
local Path = luauPath.Path
local fs = require("./fs")
local gt = require("../../lune_packages/greentea")
local types = require("./types")
local vfs = require("./vfs")
local createPath = vfs.createPath
local normalizePath = vfs.normalizePath
local cwd = vfs.cwd
local Directory = require("./Directory")
local luneFileSystem = require("@lune/fs")
local File = require("./File")

export type Directory = Directory.Directory
export type File = File.File
export type Metadata = luneFileSystem.Metadata
export type MetadataKind = luneFileSystem.MetadataKind
export type MetadataPermissions = luneFileSystem.MetadataPermissions
export type WriteOptions = luneFileSystem.WriteOptions
export type Components = types.Components
export type Path = luauPath.Path
export type AsPath = luauPath.AsPath
export type Component = types.Component
local PathType = types.PathType
local AsPathType = types.AsPathType
local optionalBooleanType = types.optionalBooleanType

local pathfs = {}

pathfs.fs = fs
pathfs.Directory = Directory
pathfs.File = File
pathfs.pathSeparator = pathSeparator
pathfs.Component = getmetatable(Path.from("a"):components():collect()[1] :: any).__index :: Component & {
	normal: (value: string) -> Component,
	rootDir: () -> Component,
	curDir: () -> Component,
	parentDir: () -> Component,
	prefix: (raw: string, prefix: any) -> Component,
}
pathfs.normalizePath = normalizePath
pathfs.cwd = cwd
pathfs.Path = Path
pathfs.gt = {}
pathfs.gt.Path = PathType
pathfs.gt.AsPath = AsPathType

local function extendTable<K, V>(target: { V }, tbl: { [K]: V })
	for _, v in tbl do
		table.insert(target, v)
	end
end

local optionalNumberType = gt.build(gt.opt(gt.number()))
--[=[
	Gets current script context's path. (default level is `2`)

	An error will be thrown in the following situations:

	* script path found in `debug.info(level)` is not resolvable.
]=]
function pathfs.getScriptPath(level: typeof(optionalNumberType:type())): typeof(PathType:type())
	optionalNumberType:assert(level)

	local path = string.match(debug.info(level or 2, "s"), '%[string "([^"]*)"%]')
	if path then
		local luauOne = path .. ".luau"
		local luaOne = path .. ".lua"

		local result: typeof(PathType:type())
		if fs.isFile(luauOne) then
			result = Path.from(luauOne)
		elseif fs.isFile(luaOne) then
			result = Path.from(luaOne)
		elseif fs.isFile(path) then
			result = Path.from(path)
		end

		PathType:assert(result)

		return result
	end

	error("Failed to get script path")
end

--[=[
	Gets absolute path of given path just by joining the `pathfs.cwd` and the path.
]=]
function pathfs.absolute(path: typeof(AsPathType:type())): typeof(PathType:type())
	AsPathType:assert(path)

	-- selene: allow(shadowing)
	local path = createPath(path)

	if path:isAbsolute() then
		return path
	end

	local absolutePath = normalizePath(cwd():join(path))

	PathType:assert(absolutePath)

	return absolutePath
end

--[=[
	Gets a path without the current directory component.
]=]
function pathfs.withoutCurDir(path: typeof(AsPathType:type())): typeof(PathType:type())
	AsPathType:assert(path)

	-- selene: allow(shadowing)
	local path = createPath(path)
	local components = path:components()
	local firstComponent = components:next()
	if firstComponent and firstComponent.type == "curDir" then
		return createPath(components)
	end

	PathType:assert(path)

	return path
end

local optionalPathType = gt.build(gt.opt(PathType:type()))
local optionalStringType = gt.build(gt.opt(gt.string()))
--[=[
	Construct a relative path from a provided base directory path to the provided path.

	Implementation inspired by https://github.com/Manishearth/pathdiff
]=]
function pathfs.diff(
	target: typeof(AsPathType:type()),
	base: typeof(AsPathType:type()),
	separator: typeof(optionalStringType:type())
): typeof(optionalPathType:type())
	AsPathType:assert(target)
	AsPathType:assert(base)
	optionalStringType:assert(separator)

	separator = separator or pathfs.pathSeparator
	-- selene: allow(shadowing)
	local target = createPath(target)
	-- selene: allow(shadowing)
	local base = createPath(base)

	if target:isAbsolute() ~= base:isAbsolute() then
		if target:isAbsolute() then
			return target
		else
			return
		end
	else
		local ita = target:components()
		local itb = base:components()
		local comps = {}
		while true do
			local a, b = ita:next(), itb:next()
			if not a and not b then
				break
			elseif a and not b then
				table.insert(comps, a)
				extendTable(comps, ita:collect())
			elseif not a then
				table.insert(comps, pathfs.Component.parentDir())
			elseif a and b and #comps == 0 and a == b then
				continue
			elseif a and b and b.type == "curDir" then
				table.insert(comps, a)
			elseif a and b and b.type == "parentDir" then
				return
			elseif a and b then
				table.insert(comps, pathfs.Component.parentDir())
				for _, _ in itb do
					table.insert(comps, pathfs.Component.parentDir())
				end
				table.insert(comps, a)
				extendTable(comps, ita:collect())
				break
			end
		end
		local strComps = {}
		for _, comp in comps do
			table.insert(strComps, comp:toString())
		end
		local result = Path.from(table.concat(strComps, separator))

		optionalPathType:assert(result)

		return result
	end
end

--[=[
	Returns the canonical, absolute form of a path with all intermediate components normalized and symbolic links resolved.
]=]
function pathfs.canonicalize(path: typeof(AsPathType:type())): typeof(PathType:type())
	AsPathType:assert(path)

	-- selene: allow(shadowing)
	local path = createPath(path)
	local absolutePath = pathfs.absolute(path)
	if fs.isFile(absolutePath) or fs.isDir(absolutePath) then
		PathType:assert(absolutePath)

		return absolutePath
	end

	error(`Failed to canonicalize the path('{path}'). does not exist`)
end

--[=[
	Creates a new `Path` based on the current dir path.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
function pathfs.fromDir(
	path: typeof(AsPathType:type()),
	relative: typeof(optionalBooleanType:type())
): typeof(PathType:type())
	AsPathType:assert(path)
	optionalBooleanType:assert(relative)

	-- selene: allow(shadowing)
	local path = createPath(path)
	local currentScriptPath = pathfs.getScriptPath(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		local result = parent:join(path)

		PathType:assert(result)

		return result
	end
	error("Failed to perform 'fromDir'. parent does not exist in the script path")
end

--[=[
	Get the dir path based on the current script context.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
function pathfs.getDir(relative: typeof(optionalBooleanType:type())): typeof(PathType:type())
	optionalBooleanType:assert(relative)

	local currentScriptPath = pathfs.getScriptPath(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		PathType:assert(parent)

		return parent
	end
	error("Failed to get dir path. parent does not exist in the script path")
end

return pathfs
