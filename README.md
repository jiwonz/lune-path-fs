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

local path = pathfs.Path.from("something.json")

print(fs.readFile(path))

```
