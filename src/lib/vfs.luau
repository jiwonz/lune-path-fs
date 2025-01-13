local types = require("./types")
local AsPathType = types.AsPathType
local luauPath = require("../../luau_packages/luau_path")
local Path = luauPath.Path
local process = require("@lune/process")

type Path = luauPath.Path
type AsPath = luauPath.AsPath

local vfs = {}

local currentDir: Path?

function vfs.normalizePath(path: Path): Path
	return Path.from(path:components())
end

local cwd = vfs.normalizePath(Path.from(process.cwd))

function vfs.createPath(path: AsPath): Path
	-- selene: allow(shadowing)
	local path = Path.from(path)
	if currentDir and not path:isAbsolute() then
		return currentDir:join(path)
	end
	return path
end

function vfs.asPathToString(asPath: AsPath): string
	if type(asPath) == "string" then
		return asPath
	end
	return vfs.createPath(asPath):toString()
end

--[=[
	Sets the current directory path virtually.

	An error will be thrown in the following situations:

	* Given path is not a relative path.
]=]
function vfs.setCurrentDir(path: AsPath)
	AsPathType:assert(path)

	local newCurrentDir: Path = Path.from(vfs.asPathToString(path))
	if not newCurrentDir:isRelative() then
		error("Current path must be a relative path")
	end
	currentDir = newCurrentDir
	cwd = vfs.normalizePath(Path.from(process.cwd):join(newCurrentDir))
end

function vfs.cwd(): Path
	return cwd
end

return vfs
