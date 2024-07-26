--!strict

local fs = require("@lune/fs")
local pathfs = {}

export type Path = {
    toString: (self: Path) -> string,

    toPathBuf: (self: Path) -> Path,
    isAbsolute: (self: Path) -> boolean,
    isRelative: (self: Path) -> boolean,
    hasRoot: (self: Path) -> boolean,
    parent: (self: Path) -> Path?,
    --ancestors: (self: Path) -> Ancestors,
    fileName: (self: Path) -> string?,
    stripPrefix: (self: Path, base: AsPath) -> Path?,
    startsWith: (self: Path, base: AsPath) -> boolean,
    endsWith: (self: Path, child: AsPath) -> boolean,

    fileStem: (self: Path) -> string?,
    filePrefix: (self: Path) -> string?,
    extension: (self: Path) -> string?,
    join: (self: Path, path: AsPath) -> Path,

    withFileName: (self: Path, fileName: string) -> Path,
    withExtension: (self: Path, extension: string) -> Path,
    --components: (self: Path) -> Components,

    equal: (self: Path, other: Path) -> boolean,

    -- PathBuf
    push: (self: Path, path: AsPath) -> (),
    pop: (self: Path) -> boolean,
    setFileName: (self: Path, fileName: string) -> (),
    setExtension: (self: Path, extension: string) -> boolean,
    clear: (self: Path) -> (),
}

export type AsPath = string | Path --| Components

type Contents = buffer | string

local function asPathToString(asPath: AsPath):string
	if type(asPath) == "string" then
		return asPath
	end
	return asPath:toString()
end

function pathfs.copy(from: AsPath, to: AsPath, overwriteOrOptions: (fs.WriteOptions | boolean)?)
	return fs.copy(asPathToString(from), asPathToString(to), overwriteOrOptions)
end

function pathfs.isDir(path: AsPath)
	return fs.isDir(asPathToString(path))
end

function pathfs.isFile(path: AsPath)
	return fs.isFile(asPathToString(path))
end

function pathfs.metadata(path: AsPath)
	return fs.metadata(asPathToString(path))
end

function pathfs.move(from: AsPath, to: AsPath, overwriteOrOptions: (fs.WriteOptions | boolean)?)
	return fs.move(asPathToString(from), asPathToString(to), overwriteOrOptions)
end

function pathfs.readDir(path: AsPath)
	return fs.readDir(asPathToString(path))
end

function pathfs.readFile(path: AsPath)
	return fs.readFile(asPathToString(path))
end

function pathfs.removeDir(path: AsPath)
	return fs.removeDir(asPathToString(path))
end

function pathfs.removeFile(path: AsPath)
	return fs.removeFile(asPathToString(path))
end

function pathfs.writeFile(path: AsPath, contents: Contents)
	return fs.writeFile(asPathToString(path), contents)
end

function pathfs.writeDir(path: AsPath)
	return fs.writeDir(asPathToString(path))
end

pathfs.Path = require("../luau-path").Path :: {
	new: () -> (Path),
	from: (path: string) -> (Path)
}

return pathfs
