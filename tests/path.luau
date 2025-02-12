local frktest = require("@frktest/")
local test = frktest.test
local check = frktest.assert.check
local pathfs = require("../src/lib")

return function()
	test.suite("joining paths", function()
		local expectedResultPath = pathfs.Path.from("tests/test1.txt")

		test.case("path and string", function()
			local path = pathfs.Path.from("tests")
			check.is_true(path:join("test1.txt"):equal(expectedResultPath))
		end)

		test.case("path and path", function()
			local path = pathfs.Path.from("tests")
			local path2 = pathfs.Path.from("test1.txt")
			check.is_true(path:join(path2):equal(expectedResultPath))
		end)

		test.case("path and components", function()
			local path = pathfs.Path.from("tests")
			local components = pathfs.Path.from("test1.txt"):components()
			check.is_true(path:join(components):equal(expectedResultPath))
		end)
	end)
end
