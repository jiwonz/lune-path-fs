# lune-path-fs
luau-path + @lune/fs and some utilities

## v0.6.0-rc.1
### Changed
- `pathfs.normalizePath` now accepts `AsPath`.
- Rename `pathfs.normalizePath` to `pathfs.normalize`.

### Added
- Add some moonwave docs comments (not finished, docs soon)
- Add watch utilities (`pathfs.watchFile`, `pathfs.watchDirectories` source credits to [ffrostfall](https://github.com/ffrostfall/lunePackages/blob/e6335a8c44957afbf1b00e3ecca37ac6a03af14d/watch/init.luau))

## Note
This library is based on [luau-path](https://github.com/seaofvoices/luau-path) by seaofvoices

## Features
- Includes typed `luau-path` utility (now fully typed)
- @lune/fs library but supports path objects (`AsPath` objects which include string and `Path` objects)
- Does not require `node` & `npm` anymore (now dependency `luau_path` is published to pesde!)
- Includes runtime type checkers via greentea.
- Features useful path and fs related utilities (such as `watchFile`, `Directory`, `diff` and more!)

## Installation
Install via pesde
```sh
pesde add jiwonz/pathfs -t lune
```

## Usage
```lua
local pathfs = require("../lune_packages/pathfs")
local fs = pathfs.fs -- compat with lune's fs lib (@lune/fs)

fs.writeFile("something.json", "{ \"message\": \"Hello, world!\" }")

-- Using Path
local Path = pathfs.Path
local path = Path.from("something.json")

print(fs.readFile(path))

-- Some useful utilities
pathfs.script()
pathfs.absolute("relative/file/path")
pathfs.withoutCurDir("./to/remove/curdir/the/dot")
pathfs.diff("target", "base")
pathfs.findFile("path/to/file")
pathfs.findDir()
pathfs.watchFile("path/to/file", function()
	print("changed")
end)
pathfs.watchDirectories({ "dir1", "dir2" }, function()
	print("changed")
end)
pathfs.watchEntryAdded("path/to/dir", function()
	print("added")
end)
pathfs.watchEntryRemoved("path/to/dir", function()
	print("removed")
end)
pathfs.watchDescendantEntryAdded("path/to/dir", function()
	print("added")
end)
pathfs.watchDescendantEntryRemoved("path/to/dir", function()
	print("removed")
end)

```

## TO-DOs
- [ ] Generate markdown docs from moonwave comments for pesde docs
- [ ] Add utils tests
- [ ] Write CHANGELOG.md instead writing in README.md
