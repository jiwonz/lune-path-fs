local fs = require("@lune/fs")
local process = require("@lune/process")
local luauPath = require("./luau_packages/luau_path")
local Path = luauPath.Path
local gt = require("./lune_packages/greentea")

export type Components = typeof(Path.new():components())
export type Path = luauPath.Path

local PathType = gt.build(gt.custom(luauPath.Path.is, "Path") :: Path)
local Components = getmetatable(Path.from("a"):components() :: any).__index :: Components & {
    new: (path: string, prefix: any?, hasPhysicalRoot: boolean) -> Components,
    is: (value: unknown) -> boolean,
}
local ComponentsType = gt.build(gt.custom(Components.is, "Components") :: Components)
local AsPathType = gt.build(gt.union(
	gt.string(),
	PathType:type(),
	ComponentsType:type()
))
local ContentsType = gt.build(gt.union(
	gt.string(), gt.buffer()
))

export type Component = typeof(Path.new():components():collect()[1])
export type AsPath = typeof(AsPathType:type())
export type Metadata = fs.Metadata
export type MetadataKind = fs.MetadataKind
export type MetadataPermissions = fs.MetadataPermissions
export type WriteOptions = fs.WriteOptions
export type Contents = typeof(ContentsType:type())

local currentDir: Path?

local pathfs = {}

local function createPath(path: AsPath): Path
	local p = Path.from(path)
	if currentDir then
		return currentDir:join(p)
	end
	return p
end

local function asPathToString(asPath: AsPath): string
	if type(asPath) == "string" then
		return asPath
	end
	return createPath(asPath):toString()
end

local function normalizePath(path: Path): Path
	return Path.from(path:components())
end

local function extendTable<K, V>(target: { V }, tbl: { [K]: V })
	for _, v in tbl do
		table.insert(target, v)
	end
end

pathfs.pathSeparator = process.os == "windows" and "\\" or "/"

-- selene: allow(global_usage)
_G.SYS_PATH_SEPARATOR = pathfs.pathSeparator

pathfs.Path = Path

pathfs.Component = getmetatable(Path.from("a"):components():collect()[1] :: any).__index :: Component & {
    normal: (value: string) -> Component,
    rootDir: () -> Component,
    curDir: () -> Component,
    parentDir: () -> Component,
    prefix: (raw: string, prefix: any) -> Component,
}

pathfs.normalizePath = normalizePath

pathfs.cwd = normalizePath(Path.from(process.cwd))

--[=[
	@within FS

	Copies a file or directory recursively to a new path.

	Throws an error if a file or directory already exists at the target path.
	This can be bypassed by passing `true` as the third argument, or a dictionary of options.
	Refer to the documentation for `WriteOptions` for specific option keys and their values.

	An error will be thrown in the following situations:

	* The current process lacks permissions to read at `from` or write at `to`.
	* Some other I/O error occurred.

	@param from The path to copy from
	@param to The path to copy to
	@param overwriteOrOptions Options for the target path, such as if should be overwritten if it already exists
]=]
pathfs.copy = gt.wrapFn(gt.fn(
	gt.args(
		AsPathType:type(),
		AsPathType:type(),
		gt.any({ allowNil = true }) :: (fs.WriteOptions | boolean)?
	),
	gt.returns()
), function(from, to, overwriteOrOptions)
	return fs.copy(asPathToString(from), asPathToString(to), overwriteOrOptions)
end)

--[=[
	@within FS
	@tag must_use

	Checks if a given path is a directory.

	An error will be thrown in the following situations:

	* The current process lacks permissions to read at `path`.
	* Some other I/O error occurred.

	@param path The directory path to check
	@return If the path is a directory or not
]=]
pathfs.isDir = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type()),
	gt.returns(gt.boolean())
), function(path)
	return fs.isDir(asPathToString(path))
end)

--[=[
	@within FS
	@tag must_use

	Checks if a given path is a file.

	An error will be thrown in the following situations:

	* The current process lacks permissions to read at `path`.
	* Some other I/O error occurred.

	@param path The file path to check
	@return If the path is a file or not
]=]
pathfs.isFile = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type()),
	gt.returns(gt.boolean())
), function(path)
	return fs.isFile(asPathToString(path))
end)

--[=[
	@within FS
	@tag must_use

	Gets metadata for the given path.

	An error will be thrown in the following situations:

	* The current process lacks permissions to read at `path`.
	* Some other I/O error occurred.

	@param path The path to get metadata for
	@return Metadata for the path
]=]
pathfs.metadata = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type()),
	gt.returns(gt.any() :: fs.Metadata)
), function(path)
	return fs.metadata(asPathToString(path))
end)

--[=[
	@within FS

	Moves a file or directory to a new path.

	Throws an error if a file or directory already exists at the target path.
	This can be bypassed by passing `true` as the third argument, or a dictionary of options.
	Refer to the documentation for `WriteOptions` for specific option keys and their values.

	An error will be thrown in the following situations:

	* The current process lacks permissions to read at `from` or write at `to`.
	* The new path exists on a different mount point.
	* Some other I/O error occurred.

	@param from The path to move from
	@param to The path to move to
	@param overwriteOrOptions Options for the target path, such as if should be overwritten if it already exists
]=]
pathfs.move = gt.wrapFn(gt.fn(
	gt.args(
		AsPathType:type(),
		AsPathType:type(),
		gt.any({ allowNil = true }) :: (fs.WriteOptions | boolean)?
	),
	gt.returns()
), function(from, to, overwriteOrOptions)
	return fs.move(asPathToString(from), asPathToString(to), overwriteOrOptions)
end)

--[=[
	@within FS
	@tag must_use

	Reads entries in a directory at `path`.

	An error will be thrown in the following situations:

	* `path` does not point to an existing directory.
	* The current process lacks permissions to read the contents of the directory.
	* Some other I/O error occurred.

	@param path The directory path to search in
	@return A list of files & directories found
]=]
pathfs.readDir = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type()),
	gt.returns(gt.array(PathType:type()))
), function(path)
	local dirs = fs.readDir(asPathToString(path)) :: { any }

	for i, v in dirs do
		dirs[i] = Path.from(v)
	end

	return dirs
end)

--[=[
	@within FS
	@tag must_use

	Reads a file at `path`.

	An error will be thrown in the following situations:

	* `path` does not point to an existing file.
	* The current process lacks permissions to read the file.
	* Some other I/O error occurred.

	@param path The path to the file to read
	@return The contents of the file
]=]
pathfs.readFile = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type()),
	gt.returns(gt.string())
), function(path)
	return fs.readFile(asPathToString(path))
end)

--[=[
	@within FS

	Removes a directory and all of its contents.

	An error will be thrown in the following situations:

	* `path` is not an existing and empty directory.
	* The current process lacks permissions to remove the directory.
	* Some other I/O error occurred.

	@param path The directory to remove
]=]
function pathfs.removeDir(path: AsPath)
	AsPathType:assert(path)
	return fs.removeDir(asPathToString(path))
end

--[=[
	@within FS

	Removes a file.

	An error will be thrown in the following situations:

	* `path` does not point to an existing file.
	* The current process lacks permissions to remove the file.
	* Some other I/O error occurred.

	@param path The file to remove
]=]
function pathfs.removeFile(path: AsPath)
	AsPathType:assert(path)
	return fs.removeFile(asPathToString(path))
end

--[=[
	@within FS

	Writes to a file at `path`.

	An error will be thrown in the following situations:

	* The file's parent directory does not exist.
	* The current process lacks permissions to write to the file.
	* Some other I/O error occurred.

	@param path The path of the file
	@param contents The contents of the file
]=]
function pathfs.writeFile(path: AsPath, contents: Contents)
	AsPathType:assert(path)
	ContentsType:assert(contents)
	return fs.writeFile(asPathToString(path), contents)
end

--[=[
	@within FS

	Creates a directory and its parent directories if they are missing.

	An error will be thrown in the following situations:

	* `path` already points to an existing file or directory.
	* The current process lacks permissions to create the directory or its missing parents.
	* Some other I/O error occurred.

	@param path The directory to create
]=]
function pathfs.writeDir(path: AsPath)
	AsPathType:assert(path)
	return fs.writeDir(asPathToString(path))
end

--[=[
	Gets current script context's path. (default level is `2`)

	An error will be thrown in the following situations:

	* script path found in `debug.info(level)` is not resolvable.
]=]
pathfs.getScriptPath = gt.wrapFn(gt.fn(
	gt.args(gt.opt(gt.number())),
	gt.returns(PathType:type())
), function(level)
	local path = string.match(debug.info(level or 2, "s"), '%[string "([^"]*)"%]')
	if path then
		local luauOne = path .. ".luau"
		local luaOne = path .. ".lua"
		if fs.isFile(luauOne) then
			return Path.from(luauOne)
		elseif fs.isFile(luaOne) then
			return Path.from(luaOne)
		elseif fs.isFile(path) then
			return Path.from(path)
		end
	end
	error("Failed to get script path")
end)

--[=[
	Gets absolute path of given path just by joining the `pathfs.cwd` and the path.
]=]
pathfs.getAbsolutePathOf = gt.wrapFn(gt.fn(
	gt.args(PathType:type()),
	gt.returns(PathType:type())
), function(path)
	return normalizePath(pathfs.cwd:join(path))
end)

--[=[
	Gets a path without the current directory component.
]=]
pathfs.withoutCurrentDirectoryComponent = gt.wrapFn(gt.fn(
	gt.args(PathType:type()),
	gt.returns(PathType:type())
), function(path)
	local components = path:components()
	local firstComponent = components:next()
	if firstComponent and firstComponent.type == "curDir" then
		return createPath(components)
	end
	return path
end)

--[=[
	Sets the current directory path virtually.

	An error will be thrown in the following situations:

	* Given path is not a relative path.
]=]
function pathfs.setCurrentDir(path: AsPath)
	AsPathType:assert(path)
	local newCurrentDir: Path = Path.from(asPathToString(path))
	if not newCurrentDir:isRelative() then
		error("Current path must be a relative path")
	end
	currentDir = newCurrentDir
	pathfs.cwd = normalizePath(Path.from(process.cwd):join(newCurrentDir))
end

--[=[
	Construct a relative path from a provided base directory path to the provided path.

	Implementation inspired by https://github.com/Manishearth/pathdiff
]=]
pathfs.diff = gt.wrapFn(gt.fn(
	gt.args(
		AsPathType:type(),
		AsPathType:type(),
		gt.opt(gt.string())
	),
	gt.returns(gt.opt(PathType:type()))
), function(path, base, separator)
	separator = separator or pathfs.pathSeparator
	local targetPath = Path.from(path)
	local basePath = Path.from(base)

	if targetPath:isAbsolute() ~= basePath:isAbsolute() then
		if targetPath:isAbsolute() then
			return targetPath
		else
			return
		end
	else
		local ita = targetPath:components()
		local itb = basePath:components()
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
		return Path.from(table.concat(strComps, separator))
	end
end)

--[=[
	Returns the canonical, absolute form of a path with all intermediate components normalized and symbolic links resolved.
]=]
pathfs.canonicalize = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type()),
	gt.returns(PathType:type())
), function(path)
	local p = createPath(path)
	local absolutePath = pathfs.getAbsolutePathOf(p)
	if pathfs.isFile(absolutePath) or pathfs.isDir(absolutePath) then
		return absolutePath
	end
	error(`Failed to canonicalize the path('{path}'). path does not exist`)
end)

--[=[
	Creates a new `Path` based on the current dir path.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
pathfs.fromDir = gt.wrapFn(gt.fn(
	gt.args(AsPathType:type(), gt.opt(gt.boolean())),
	gt.returns(PathType:type())
), function(path, relative)
	local p = createPath(path)
	local currentScriptPath = pathfs.getScriptPath(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		return parent:join(p)
	end
	error("Failed to perform 'fromDir'. parent does not exist in the script path")
end)

--[=[
	Get the dir path based on the current script context.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
pathfs.getDir = gt.wrapFn(gt.fn(
	gt.args(gt.opt(gt.boolean())),
	gt.returns(PathType:type())
), function(relative)
	local currentScriptPath = pathfs.getScriptPath(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		return parent
	end
	error("Failed to get dir path. parent does not exist in the script path")
end)

return pathfs
