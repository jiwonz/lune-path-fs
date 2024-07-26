# lune-path-fs
luau-path + @lune/fs

## Installation
```sh
git submodule add
```

## Usage
```lua
pathfs.writeFile("something.json", "{ \"message\": \"Hello, world!\" }")

local path = pathfs.Path.from("something.json")

print(pathfs.readFile(path))

```
