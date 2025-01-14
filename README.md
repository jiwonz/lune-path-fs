# lune-path-fs
luau-path + @lune/fs

## v0.3.1
### Added
- Added `Directory` utility class.
#### example:
```luau
local dir = pathfs.Directory.new("new_dir") -- just represents a directory path.
dir:writeDir()
dir:removeDir()

local dir = pathfs.Directory.create("new_dir") -- writes a directory if there is no file/dir at this path already.

local dir = pathfs.Directory.fromExisting("new_dir") -- gets/creates a Directory object from existing directory path.
```
- Added `File` utility class.
#### example:
```luau
local file = pathfs.File.new("new_file") -- just represents a file path.
file:writeFile("hello")
file:removeFile()

local file = pathfs.File.create("new_dir", "initial contents") -- writes a file if there is no file/dir at this path already.

local file = pathfs.File.fromExisting("new_dir") -- gets/creates a File object from existing file path.
```

### Changed
- Moved `fs` into `pathfs.fs`.
#### old:
```luau
local pathfs = require("./path/to/pathfs")

pathfs.writeFile("path")
```
#### new:
```luau
local pathfs = require("./path/to/pathfs")
local fs = pathfs.fs

fs.writeFile("path")
```

### etc
- Better function types and greentea runtime type checker rework.
- Organize the library source codes.

## Note
This library is based on [luau-path](https://github.com/seaofvoices/luau-path) by seaofvoices

## Features
- Includes typed `luau-path` utility (now fully typed)
- @lune/fs library but supports path objects (`AsPath` objects which include string and `Path` objects)
- Does not require `node` & `npm` anymore (now dependency `luau_path` is published to pesde!)
- Includes runtime type checkers via greentea.

## Installation
Install via pesde
```sh
pesde add jiwonz/pathfs
```

## Usage
```lua
pathfs.writeFile("something.json", "{ \"message\": \"Hello, world!\" }")

local path = pathfs.Path.from("something.json")

print(pathfs.readFile(path))

```
