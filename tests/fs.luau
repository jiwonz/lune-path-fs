local frktest = require("@frktest/")
local test = frktest.test
local check = frktest.assert.check
local pathfs = require("..")
local fs = pathfs.fs

return function()
	local test1 = "tests/test1.txt"
	local test2 = "tests/test2.txt"
	local test3 = "tests/test3.txt"
	local test_content = "Hello, world!"

	test.suite("writing files", function()
		test.case("from string paths", function()
			fs.writeFile(test1, test_content)
			fs.move(test1, test2)
			fs.copy(test2, test3)
			fs.writeFile(test2, "")
			fs.removeFile(test2)
			fs.removeFile(test3)
		end)

		test.case("from components", function()
			local components_test1 = pathfs.Path.from(test1):components()
			local components_test2 = pathfs.Path.from(test2):components()
			local components_test3 = pathfs.Path.from(test3):components()

			fs.writeFile(components_test1, test_content)
			fs.move(components_test1, components_test2)
			fs.copy(components_test2, components_test3)
			fs.writeFile(components_test2, "")
			fs.removeFile(components_test2)
			fs.removeFile(components_test3)
		end)

		test.case("from paths", function()
			local path_test1 = pathfs.Path.from(test1)
			local path_test2 = pathfs.Path.from(test2)
			local path_test3 = pathfs.Path.from(test3)

			fs.writeFile(path_test1, test_content)
			fs.move(path_test1, path_test2)
			fs.copy(path_test2, path_test3)
			fs.writeFile(path_test2, "")
			fs.removeFile(path_test2)
			fs.removeFile(path_test3)
		end)
	end)

	test.suite("reading files", function()
		test.case("from string paths", function()
			fs.writeFile(test1, test_content)
			check.equal(fs.readFile(test1), test_content)
			fs.move(test1, test2)
			check.equal(fs.readFile(test2), test_content)
			fs.copy(test2, test3)
			check.equal(fs.readFile(test3), test_content)
			fs.removeFile(test2)
			fs.removeFile(test3)
		end)

		test.case("from components", function()
			local components_test1 = pathfs.Path.from(test1):components()
			local components_test2 = pathfs.Path.from(test2):components()
			local components_test3 = pathfs.Path.from(test3):components()

			fs.writeFile(components_test1, test_content)
			check.equal(fs.readFile(components_test1), test_content)
			fs.move(components_test1, components_test2)
			check.equal(fs.readFile(components_test2), test_content)
			fs.copy(components_test2, components_test3)
			check.equal(fs.readFile(components_test3), test_content)
			fs.removeFile(components_test2)
			fs.removeFile(components_test3)
		end)

		test.case("from paths", function()
			local path_test1 = pathfs.Path.from(test1)
			local path_test2 = pathfs.Path.from(test2)
			local path_test3 = pathfs.Path.from(test3)

			fs.writeFile(path_test1, test_content)
			check.equal(fs.readFile(path_test1), test_content)
			fs.move(path_test1, path_test2)
			check.equal(fs.readFile(path_test2), test_content)
			fs.copy(path_test2, path_test3)
			check.equal(fs.readFile(path_test3), test_content)
			fs.removeFile(path_test2)
			fs.removeFile(path_test3)
		end)
	end)

	local test_dir = "tests/testdir"

	test.suite("writing directories", function()
		test.case("from string paths", function()
			fs.writeDir(test_dir)
			fs.removeDir(test_dir)
		end)

		test.case("from components", function()
			local components = pathfs.Path.from(test_dir):components()
			fs.writeDir(components)
			fs.removeDir(components)
		end)

		test.case("from paths", function()
			local path = pathfs.Path.from(test_dir)
			fs.writeDir(path)
			fs.removeDir(path)
		end)
	end)

	test.suite("reading directories", function()
		test.case("from string paths", function()
			fs.writeDir(test_dir)
			check.truthy(fs.readDir(test_dir))
			fs.removeDir(test_dir)
		end)

		test.case("from components", function()
			local components = pathfs.Path.from(test_dir):components()
			fs.writeDir(components)
			check.truthy(fs.readDir(components))
			fs.removeDir(components)
		end)

		test.case("from paths", function()
			local path = pathfs.Path.from(test_dir)
			fs.writeDir(path)
			check.truthy(fs.readDir(path))
			fs.removeDir(path)
		end)
	end)
end
