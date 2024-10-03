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

local currentDir: Path?

local function Path(path: AsPath): Path
	local p = pathfs.Path.from(path)
	if currentDir then
		return currentDir:join(p)
	end
	return p
end

local function asPathToString(asPath: AsPath): string
	if type(asPath) == "string" then
		return asPath
	end
	return Path(asPath):toString()
end

local function normalizePath(path: Path): Path
	return pathfs.Path.from(path:components())
end

local function extendTable(target, tbl)
	for _, v in tbl do
		table.insert(target, v)
	end
end

pathfs.pathSeparator = process.os == "windows" and "\\" or "/"

-- selene: allow(global_usage)
_G.SYS_PATH_SEPARATOR = pathfs.pathSeparator

pathfs.Path = require("luau-path").Path :: {
	new: () -> types.Path,
	from: (path: types.AsPath) -> types.Path,
	is: (value: unknown) -> boolean,
}

pathfs.Component = getmetatable(pathfs.Path.from("a"):components():collect()[1] :: any).__index :: types.Component

pathfs.normalizePath = normalizePath

pathfs.cwd = normalizePath(pathfs.Path.from(process.cwd))

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
function pathfs.copy(from: AsPath, to: AsPath, overwriteOrOptions: (fs.WriteOptions | boolean)?)
	return fs.copy(asPathToString(from), asPathToString(to), overwriteOrOptions)
end

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
function pathfs.isDir(path: AsPath)
	return fs.isDir(asPathToString(path))
end

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
function pathfs.isFile(path: AsPath)
	return fs.isFile(asPathToString(path))
end

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
function pathfs.metadata(path: AsPath)
	return fs.metadata(asPathToString(path))
end

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
function pathfs.move(from: AsPath, to: AsPath, overwriteOrOptions: (fs.WriteOptions | boolean)?)
	return fs.move(asPathToString(from), asPathToString(to), overwriteOrOptions)
end

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
function pathfs.readDir(path: AsPath)
	return fs.readDir(asPathToString(path))
end

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
function pathfs.readFile(path: AsPath)
	return fs.readFile(asPathToString(path))
end

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
function pathfs.writeDir(path: types.AsPath)
	return fs.writeDir(asPathToString(path))
end

--[=[
	Gets current script context's path. (default level is `2`)

	An error will be thrown in the following situations:

	* script path found in `debug.info(level)` is not resolvable.
]=]
function pathfs.getScriptPath(level: number?): Path
	local path = string.match(debug.info(level or 2, "s"), '%[string "([^"]*)"%]')
	if path then
		local luauPath = path .. ".luau"
		local luaPath = path .. ".lua"
		if fs.isFile(luauPath) then
			return pathfs.Path.from(luauPath)
		elseif fs.isFile(luaPath) then
			return pathfs.Path.from(luaPath)
		elseif fs.isFile(path) then
			return pathfs.Path.from(path)
		end
	end
	error("Failed to get script path")
end

--[=[
	Gets absolute path of given path just by joining the `pathfs.cwd` and the path.
]=]
function pathfs.getAbsolutePathOf(path: Path): Path
	return normalizePath(pathfs.cwd:join(path))
end

function pathfs.getNoCurDirPathOf(path: Path): Path
	local components = path:components()
	local firstComponent = components:next()
	if firstComponent and firstComponent.type == "curDir" then
		return Path(components)
	end
	return path
end

--[=[
	Sets the current directory path virtually.

	An error will be thrown in the following situations:

	* Given path is not a relative path.
]=]
function pathfs.setCurrentDir(path: AsPath)
	local newCurrentDir: Path = pathfs.Path.from(asPathToString(path))
	if not newCurrentDir:isRelative() then
		error("Current path must be a relative path")
	end
	currentDir = newCurrentDir
	pathfs.cwd = normalizePath(pathfs.Path.from(process.cwd):join(newCurrentDir))
end

-- inspired by https://github.com/Manishearth/pathdiff
--[=[
	Construct a relative path from a provided base directory path to the provided path.
]=]
function pathfs.diff(path: AsPath, base: AsPath, separator: string?): Path?
	separator = separator or pathfs.pathSeparator
	local targetPath = pathfs.Path.from(path)
	local basePath = pathfs.Path.from(base)

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
		return pathfs.Path.from(table.concat(strComps, separator))
	end
end

--[=[
	Returns the canonical, absolute form of a path with all intermediate components normalized and symbolic links resolved.
]=]
function pathfs.canonicalize(path: AsPath): Path
	local p = Path(path)
	local absolutePath = pathfs.getAbsolutePathOf(p)
	if pathfs.isFile(absolutePath) or pathfs.isDir(absolutePath) then
		return absolutePath
	end
	error(`Failed to canonicalize the path('{path}'). path does not exist`)
end

--[=[
	Creates a new `Path` based on the current dir path.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
function pathfs.fromDir(path: AsPath, relative: boolean?): Path
	local p = Path(path)
	local currentScriptPath = pathfs.getScriptPath(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		return parent:join(p)
	end
	error("Failed to perform 'fromDir'. parent does not exist in the script path")
end

--[=[
	Get the dir path based on the current script context.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
function pathfs.getDir(relative: boolean?): Path
	local currentScriptPath = pathfs.getScriptPath(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		return parent
	end
	error("Failed to get dir path. parent does not exist in the script path")
end

return pathfs
