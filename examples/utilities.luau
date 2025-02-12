local pathfs = require("../src/lib")

local file = pathfs.File.create("hi", "hello")
file:writeFile("hallo")
file:removeFile()

local dir = pathfs.Directory.create("hi")
dir:removeDir()
