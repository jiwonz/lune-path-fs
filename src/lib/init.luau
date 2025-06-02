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
local task = require("@lune/task")

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
local ContentsType = types.ContentsType

--[=[
	@class pathfs

	luau-path + @lune/fs and some utilities
]=]
local pathfs = {}

--[=[
	@within pathfs

	`require("@lune/fs")` compat module

	### Example
	```lua
	local fs = require("path/to/pathfs").fs

	fs.readFile("path/to/file")
	fs.writeFile("path/to/file", "content")
	...
	```
]=]
pathfs.fs = fs
--[=[
	@within pathfs

	A `Directory` class

	### Example
	```lua
	local dir = Directory.from("path/to/dir")
	dir:removeDir()
	```
]=]
pathfs.Directory = Directory
--[=[
	@within pathfs

	A `File` class

	### Example
	```lua
	local file = File.from("path/to/file")
	file:writeFile("content")
	```
]=]
pathfs.File = File
--[=[
	@within pathfs

	Current path separator

	### Example
	```lua
	if process.os == "windows" then
		print(pathfs.pathSeparator) -- "\\" (Windows)
	else
		print(pathfs.pathSeparator) -- "/" (other OS, maybe Linux)
	end
	```
]=]
pathfs.pathSeparator = pathSeparator
--[=[
	@within pathfs

	A `Component` class exported from `luau-path`
]=]
pathfs.Component = getmetatable(Path.from("a"):components():collect()[1] :: any).__index :: Component & {
	normal: (value: string) -> Component,
	rootDir: () -> Component,
	curDir: () -> Component,
	parentDir: () -> Component,
	prefix: (raw: string, prefix: any) -> Component,
}
pathfs.normalize = normalizePath
pathfs.cwd = cwd
--[=[
	@within pathfs

	A `Path` class exported from `luau-path`

	### Example
	```lua
	local path = Path.from("path/to/file")
	```
]=]
pathfs.Path = Path
pathfs.types = {}
pathfs.types.Path = PathType
pathfs.types.AsPath = AsPathType

local function extendTable<K, V>(target: { V }, tbl: { [K]: V })
	for _, v in tbl do
		table.insert(target, v)
	end
end

local optionalNumberType = gt.build(gt.opt(gt.number()))
--[=[
	@within pathfs

	Gets current script context's path. (default level is `2`)

	An error will be thrown in the following situations:

	* script path found in `debug.info(level)` is not resolvable.
]=]
function pathfs.script(level: typeof(optionalNumberType:type())): typeof(PathType:type())
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
	@within pathfs

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
	@within pathfs

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
	@within pathfs

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
	@within pathfs

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
	@within pathfs

	Creates a new `Path` based on the current dir path.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.script(3)`.
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
	local currentScriptPath = pathfs.script(3)
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
	@within pathfs

	Get the dir path based on the current script context.

	An error will be thrown in the following situations:

	* Errors while calling `pathfs.getScriptPath()`.
	* Current script path's parent path does not exist.
]=]
function pathfs.getDir(relative: typeof(optionalBooleanType:type())): typeof(PathType:type())
	optionalBooleanType:assert(relative)

	local currentScriptPath = pathfs.script(3)
	local resolved = if relative == true then currentScriptPath else pathfs.canonicalize(currentScriptPath)
	local parent = resolved:parent()
	if parent then
		PathType:assert(parent)

		return parent
	end
	error("Failed to get dir path. parent does not exist in the script path")
end

--[=[
	@within pathfs

	Finds a file at the given file path.
	@param filePath -- The path to the file, of type AsPathType.
	@return File? -- A File object if the file exists, otherwise nil.
]=]
function pathfs.findFile(filePath: typeof(AsPathType:type())): File?
	AsPathType:assert(filePath)

	-- selene: allow(shadowing)
	local dirPath = createPath(filePath)
	if fs.isFile(dirPath) then
		local file = File.fromExisting(dirPath)

		File.type:assert(file)

		return file
	end

	return
end

--[=[
	@within pathfs

	Finds a directory at the given directory path.
	@param dirPath -- The path to the directory, of type AsPathType.
	@return dir -- A Directory object if the directory exists, otherwise nil.
]=]
function pathfs.findDir(dirPath: typeof(AsPathType:type())): Directory?
	AsPathType:assert(dirPath)

	-- selene: allow(shadowing)
	local dirPath = createPath(dirPath)
	if fs.isDir(dirPath) then
		local dir = Directory.fromExisting(dirPath)

		Directory.type:assert(dir)

		return dir
	end

	return
end

local directoryType = gt.build(gt.union(Directory.type:type(), AsPathType:type()))

type DirEntry = {
	name: string,
	file: File?,
	dir: Directory?,
	path: Path,
}

local function hashDirEntry(entry: DirEntry): string
	return entry.path:toString()
end

local function directoryToPath(dir: typeof(directoryType:type())): typeof(PathType:type())
	local path: typeof(PathType:type()) = if Directory.is(dir)
		then (dir :: Directory).path
		else createPath(dir :: typeof(AsPathType:type()))

	if not fs.isDir(path) then
		error(`The provided path \`{path}\` is not a valid directory`)
	end

	return path
end

--[=[
	@within pathfs

	Get the entries of a directory.

	### Example
	```lua
	for _, entry in pathfs.getEntries("path/to/dir") do
		print(entry.name) -- File name of this directory entry without any leading path component(s)
		print(entry.file) -- File object if it exists
		print(entry.directory) -- Directory object if it exists
	end
	```

	@param dir -- The directory to get entries from, of type Directory or AsPathType.
	@return entries -- A table containing the entries in the directory.
]=]
function pathfs.getEntries(directory: typeof(directoryType:type())): { DirEntry }
	directoryType:assert(directory)

	-- selene: allow(shadowing)
	local directory = directoryToPath(directory)
	local entries: { DirEntry } = {}

	for _, entryName in fs.readDir(directory) do
		local path = directory:join(entryName)
		table.insert(entries, {
			name = entryName,
			file = pathfs.findFile(path),
			directory = pathfs.findDir(path),
			path = path,
		})
	end

	return entries
end

--[=[
	@within pathfs

	Get the entries of a directory.

	### Example
	```lua
	for _, entry in pathfs.getDescendantEntries("path/to/dir") do
		print(entry.name) -- File name of this directory entry without any leading path component(s)
		print(entry.file) -- File object if it exists
		print(entry.directory) -- Directory object if it exists
	end
	```

	@param dir -- The directory to get entries from, of type Directory or AsPathType.
	@return entries -- A table containing the entries in the directory.
]=]
function pathfs.getDescendantEntries(directory: typeof(directoryType:type())): { DirEntry }
	directoryType:assert(directory)

	-- selene: allow(shadowing)
	local directory = directoryToPath(directory)
	local entries: { DirEntry } = {}

	for _, entryName in fs.readDir(directory) do
		local path = directory:join(entryName)

		table.insert(entries, {
			name = entryName,
			file = pathfs.findFile(path),
			directory = pathfs.findDir(path),
			path = path,
		})

		if fs.isDir(path) then
			local deepEntries = pathfs.getDescendantEntries(path)

			for _, deepEntry: DirEntry in deepEntries do
				table.insert(entries, deepEntry)
			end
		end
	end

	return entries
end

-- original source credits to: https://github.com/ffrostfall/lunePackages/blob/e6335a8c44957afbf1b00e3ecca37ac6a03af14d/watch/init.luau
local function watchPaths(paths: { string }, callback: () -> ())
	local lastModified = {}

	for _, path in paths do
		lastModified[path] = fs.metadata(path).modifiedAt
	end

	while true do
		local changed = false

		for path, modified in lastModified do
			local newModified = fs.metadata(path).modifiedAt
			if newModified ~= modified then
				lastModified[path] = newModified
				changed = true
				break
			end
		end

		if changed then
			task.spawn(callback)
		end

		task.wait(1)
	end
end

local directoriesArrayType = gt.build(gt.array(directoryType:type()))
local callbackType = gt.build(gt.anyfn())
--[=[
	@within pathfs

	Watch directories for changes.

	### Example
	```lua
	pathfs.watchDirectories({"path/to/dir1", "path/to/dir2"}, function()
		print("Changed!")
	end)
	```
]=]
function pathfs.watchDirectories(
	directories: typeof(directoriesArrayType:type()),
	onChanged: typeof(callbackType:type())
): thread
	directoriesArrayType:assert(directories)
	callbackType:assert(onChanged)

	local paths = {}

	for _, dir in directories do
		-- selene: allow(shadowing)
		local dir = directoryToPath(dir)
		for _, filePath in pathfs.getDescendantEntries(dir) do
			table.insert(paths, filePath.path:toString())
		end
	end

	task.spawn(onChanged)
	return task.spawn(watchPaths, paths, onChanged)
end

--[=[
	@within pathfs

	Watch a file for changes.

	### Example
	```lua
	pathfs.watchFile("path/to/file", function()
		print("Changed!")
	end)
	```
]=]
function pathfs.watchFile(fileName: typeof(AsPathType:type()), onChanged: typeof(callbackType:type())): thread
	AsPathType:assert(fileName)
	callbackType:assert(onChanged)

	task.spawn(onChanged)
	return task.spawn(function()
		local lastModified = fs.metadata(fileName).modifiedAt

		while true do
			local newModified = fs.metadata(fileName).modifiedAt
			if newModified ~= lastModified then
				task.spawn(onChanged)

				lastModified = newModified
			end

			task.wait(1)
		end
	end)
end

local function watchEntryAdded(
	getEntries: (directory: typeof(directoryType:type())) -> { DirEntry },
	directory: typeof(directoryType:type()),
	onAdded: typeof(callbackType:type() :: (addedEntry: DirEntry) -> ())
): thread
	directoryType:assert(directory)
	callbackType:assert(onAdded)

	local oldEntries: { [string]: DirEntry } = {}
	for _, entry in getEntries(directory) do
		oldEntries[hashDirEntry(entry)] = entry
	end

	return task.spawn(function()
		while true do
			local newEntries: { [string]: DirEntry } = {}
			do
				local ok, entries = pcall(getEntries, directory)
				if not ok then -- This may no longer be a valid directory
					return
				end
				for _, entry in entries do
					newEntries[hashDirEntry(entry)] = entry
				end
			end
			for _, newEntry in newEntries do
				if not oldEntries[hashDirEntry(newEntry)] then
					task.spawn(onAdded, newEntry)
				end
			end

			oldEntries = newEntries

			task.wait(1)
		end
	end)
end

--[=[
	@within pathfs

	Watch a directory for added entries.

	### Example
	```lua
	pathfs.watchEntryAdded("path/to/dir", function(addedEntry)
		print("Added entry:", addedEntry.name)
	end)
	```

	@param directory -- The directory to watch, of type Directory or AsPathType.
	@param onAdded -- The callback function to call when an entry is added.
]=]
function pathfs.watchEntryAdded(
	directory: typeof(directoryType:type()),
	onAdded: typeof(callbackType:type() :: (addedEntry: DirEntry) -> ())
): thread
	return watchEntryAdded(pathfs.getEntries, directory, onAdded)
end

--[=[
	@within pathfs

	Watch a directory for added descendant entries.

	### Example
	```lua
	pathfs.watchDescendantEntryAdded("path/to/dir", function(addedEntry)
		print("Added entry:", addedEntry.name)
	end)
	```

	@param directory -- The directory to watch, of type Directory or AsPathType.
	@param onAdded -- The callback function to call when an entry is added.
]=]
function pathfs.watchDescendantEntryAdded(
	directory: typeof(directoryType:type()),
	onAdded: typeof(callbackType:type() :: (addedEntry: DirEntry) -> ())
): thread
	return watchEntryAdded(pathfs.getDescendantEntries, directory, onAdded)
end

local function watchEntryRemoved(
	getEntries: (directory: typeof(directoryType:type())) -> { DirEntry },
	directory: typeof(directoryType:type()),
	onRemoved: typeof(callbackType:type() :: (removedEntry: DirEntry) -> ())
): thread
	directoryType:assert(directory)
	callbackType:assert(onRemoved)

	local oldEntries: { [string]: DirEntry } = {}
	for _, entry in getEntries(directory) do
		oldEntries[hashDirEntry(entry)] = entry
	end

	return task.spawn(function()
		while true do
			local newEntries: { [string]: DirEntry } = {}
			do
				local ok, entries = pcall(getEntries, directory)
				if not ok then -- This may no longer be a valid directory
					return
				end
				for _, entry in entries do
					newEntries[hashDirEntry(entry)] = entry
				end
			end
			for _, oldEntry in oldEntries do
				if not newEntries[hashDirEntry(oldEntry)] then
					task.spawn(onRemoved, oldEntry)
				end
			end

			oldEntries = newEntries

			task.wait(1)
		end
	end)
end

--[=[
	@within pathfs

	Watch a directory for removed entries.

	### Example
	```lua
	pathfs.watchEntryRemoved("path/to/dir", function(removedEntry)
		print("Removed entry:", removedEntry.name)
	end)
	```

	@param directory -- The directory to watch, of type Directory or AsPathType.
	@param onRemoved -- The callback function to call when an entry is removed.
]=]
function pathfs.watchEntryRemoved(
	directory: typeof(directoryType:type()),
	onRemoved: typeof(callbackType:type() :: (removedEntry: DirEntry) -> ())
): thread
	return watchEntryRemoved(pathfs.getEntries, directory, onRemoved)
end

--[=[
	@within pathfs

	Watch a directory for removed descendant entries.

	### Example
	```lua
	pathfs.watchDescendantEntryRemoved("path/to/dir", function(removedEntry)
		print("Removed entry:", removedEntry.name)
	end)
	```

	@param directory -- The directory to watch, of type Directory or AsPathType.
	@param onRemoved -- The callback function to call when an entry is removed.
]=]
function pathfs.watchDescendantEntryRemoved(
	directory: typeof(directoryType:type()),
	onRemoved: typeof(callbackType:type() :: (removedEntry: DirEntry) -> ())
): thread
	return watchEntryRemoved(pathfs.getDescendantEntries, directory, onRemoved)
end

local FileOrAsPathType = gt.build(gt.union(File.type:type(), AsPathType:type()))
function pathfs.writeFileAll(fileOrPath: typeof(FileOrAsPathType:type()), contents: typeof(ContentsType:type()))
	FileOrAsPathType:assert(fileOrPath)
	ContentsType:assert(contents)

	-- selene: allow(shadowing)
	local path = createPath(if File.is(fileOrPath) then (fileOrPath :: File).path else fileOrPath :: AsPath)
	local parent = path:parent()
	if parent then
		fs.writeDir(parent)
	end
	fs.writeFile(path, contents)
end

type ObserveState = "__inflight__" | "__dead__"
type EntryValue = {
	stateOrCleanup: ObserveState | (() -> ())?,
	entry: DirEntry,
}

local function observeEntry(
	getEntries: (directory: typeof(directoryType:type())) -> { DirEntry },
	directory: typeof(directoryType:type()),
	callback: typeof(callbackType:type() :: (entry: DirEntry) -> (() -> ())?)
): () -> ()
	directoryType:assert(directory)
	callbackType:assert(callback)

	local entryValues: {
		[string]: EntryValue?,
	} = {}
	local disconnected = false
	local function attemptStartup(entryValue: EntryValue)
		entryValue.stateOrCleanup = "__inflight__"

		task.defer(function()
			if entryValue.stateOrCleanup ~= "__inflight__" then
				return
			end

			local success, errOrCleanup = pcall(function()
				local cleanup = callback(entryValue.entry)
				if cleanup ~= nil and type(cleanup) ~= "function" then
					error("observeDescendantEntry's callback must return a cleanup function or nil")
				end
				return cleanup
			end)

			if not success then
				print(`Error in observeDescendantEntry callback:\n\t{errOrCleanup}`)
				return
			end

			if entryValue.stateOrCleanup == "__inflight__" then
				entryValue.stateOrCleanup = errOrCleanup
			elseif type(errOrCleanup) == "function" then
				task.spawn(errOrCleanup)
			end
		end)
	end

	local function attemptCleanup(entryValue: EntryValue)
		local cleanup = entryValue.stateOrCleanup
		entryValue.stateOrCleanup = "__dead__"
		if type(cleanup) == "function" then
			task.spawn(cleanup)
		end
	end

	local function onAdded(entry: DirEntry)
		if disconnected then
			return
		end
		local hash = hashDirEntry(entry)
		if entryValues[hash] then
			return
		end

		local entryValue = {
			stateOrCleanup = "__dead__" :: "__dead__",
			entry = entry,
		}
		entryValues[hash] = entryValue

		attemptStartup(entryValue)
	end

	local function onRemoved(entry: DirEntry)
		local hash = hashDirEntry(entry)
		local entryValue = entryValues[hash]
		if not entryValue then
			return
		end

		attemptCleanup(entryValue)
		entryValues[hash] = nil
	end

	local addedWatchingThread = watchEntryAdded(getEntries, directory, onAdded)
	local removedWatchingThread = watchEntryRemoved(getEntries, directory, onRemoved)

	task.defer(function()
		if disconnected then
			return
		end
		for _, entry in getEntries(directory) do
			task.spawn(onAdded, entry)
		end
	end)

	return function()
		disconnected = true
		task.cancel(addedWatchingThread)
		task.cancel(removedWatchingThread)
		local value
		do
			local _, newValue = next(entryValues)
			value = newValue
		end
		while value do
			onRemoved(value.entry)
			local _, newValue = next(entryValues)
			value = newValue
		end
	end
end

--[=[
	@within pathfs

	Observe a directory for changes.

	### Example
	```lua
	pathfs.observeEntry("path/to/dir", function(entry)
		print("Entry changed:", entry.name)

		return function()
			print("Entry cleanup:", entry.name)
		end
	end)
	```

	@param directory -- The directory to observe, of type Directory or AsPathType.
	@param callback -- The callback function to call when an entry is added or removed.
]=]
function pathfs.observeEntry(
	directory: typeof(directoryType:type()),
	callback: typeof(callbackType:type() :: (entry: DirEntry) -> (() -> ())?)
): () -> ()
	return observeEntry(pathfs.getEntries, directory, callback)
end

--[=[
	@within pathfs

	Observe a directory for changes in its descendants.

	### Example
	```lua
	pathfs.observeDescendantEntry("path/to/dir", function(entry)
		print("Descendant entry changed:", entry.name)

		return function()
			print("Cleanup for entry:", entry.name)
		end
	end)
	```

	@param directory -- The directory to observe, of type Directory or AsPathType.
	@param callback -- The callback function to call when an entry is added or removed.
]=]
function pathfs.observeDescendantEntry(
	directory: typeof(directoryType:type()),
	callback: typeof(callbackType:type() :: (entry: DirEntry) -> (() -> ())?)
): () -> ()
	return observeEntry(pathfs.getDescendantEntries, directory, callback)
end

return pathfs
