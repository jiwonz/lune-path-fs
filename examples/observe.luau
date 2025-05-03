local pathfs = require("../src/lib")
local task = require("@lune/task")

local disconnectObserver = pathfs.observeDescendantEntry(".playground/test", function(entry)
	print("Hello bro", entry)
	return function()
		print("Oh no I didn't")
	end
end)

task.wait(5)

disconnectObserver()
