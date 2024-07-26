# lune-path-fs
luau-path + @lune/fs

## Note
This library is based on [luau-path](https://github.com/seaofvoices/luau-path) by seaofvoices

## Features
- Includes typed `luau-path` utility.
- @lune/fs library but supports path objects. (`AsPath` objects which include string and `Path` objects)
- Does not require `node` & `npm` anymore since it includes built script of `luau-path`.

## Installation
Use git submodules.
```sh
git submodule add
```

## Usage
```lua
pathfs.writeFile("something.json", "{ \"message\": \"Hello, world!\" }")

local path = pathfs.Path.from("something.json")

print(pathfs.readFile(path))

```
