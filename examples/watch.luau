local pathfs = require("../src/lib")

pathfs.watchDirectories({
	".playground/test",
	".playground/test2",
}, function()
	print("yolo")
end)
