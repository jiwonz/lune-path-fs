local pathfs = require("../")

local file = pathfs.File.create("hi", "hello")
file:writeFile("hallo")
file:removeFile()
