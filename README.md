# lune-path-fs
luau-path + @lune/fs

## v0.4.0
### Added
- Add following new pathfs utilities: `pathfs.findFile(filePath: AsPath) -> File?`, `pathfs.findDirectory(dirPath: AsPath) -> Directory?`
- Expose `File.type` and `Directory.type` greentea types.

### Changed
- Rename `pathfs.gt` to `pathfs.types`.

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
pesde add jiwonz/pathfs -t lune
```

## Usage
```lua
pathfs.writeFile("something.json", "{ \"message\": \"Hello, world!\" }")

local path = pathfs.Path.from("something.json")

print(pathfs.readFile(path))

```
