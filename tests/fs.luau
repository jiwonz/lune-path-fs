local frktest = require("@frktest/")
local test = frktest.test
local check = frktest.assert.check
local pathfs = require("..")

return function()
	local test1 = "tests/test1.txt"
	local test2 = "tests/test2.txt"
	local test3 = "tests/test3.txt"
	local test_content = "Hello, world!"

	test.suite("writing files", function()
		test.case("from string paths", function()
			pathfs.writeFile(test1, test_content)
			pathfs.move(test1, test2)
			pathfs.copy(test2, test3)
			pathfs.writeFile(test2, "")
			pathfs.removeFile(test2)
			pathfs.removeFile(test3)
		end)

		test.case("from components", function()
			local components_test1 = pathfs.Path.from(test1):components()
			local components_test2 = pathfs.Path.from(test2):components()
			local components_test3 = pathfs.Path.from(test3):components()

			pathfs.writeFile(components_test1, test_content)
			pathfs.move(components_test1, components_test2)
			pathfs.copy(components_test2, components_test3)
			pathfs.writeFile(components_test2, "")
			pathfs.removeFile(components_test2)
			pathfs.removeFile(components_test3)
		end)

		test.case("from paths", function()
			local path_test1 = pathfs.Path.from(test1)
			local path_test2 = pathfs.Path.from(test2)
			local path_test3 = pathfs.Path.from(test3)

			pathfs.writeFile(path_test1, test_content)
			pathfs.move(path_test1, path_test2)
			pathfs.copy(path_test2, path_test3)
			pathfs.writeFile(path_test2, "")
			pathfs.removeFile(path_test2)
			pathfs.removeFile(path_test3)
		end)
	end)

	test.suite("reading files", function()
		test.case("from string paths", function()
			pathfs.writeFile(test1, test_content)
			check.equal(pathfs.readFile(test1), test_content)
			pathfs.move(test1, test2)
			check.equal(pathfs.readFile(test2), test_content)
			pathfs.copy(test2, test3)
			check.equal(pathfs.readFile(test3), test_content)
			pathfs.removeFile(test2)
			pathfs.removeFile(test3)
		end)

		test.case("from components", function()
			local components_test1 = pathfs.Path.from(test1):components()
			local components_test2 = pathfs.Path.from(test2):components()
			local components_test3 = pathfs.Path.from(test3):components()

			pathfs.writeFile(components_test1, test_content)
			check.equal(pathfs.readFile(components_test1), test_content)
			pathfs.move(components_test1, components_test2)
			check.equal(pathfs.readFile(components_test2), test_content)
			pathfs.copy(components_test2, components_test3)
			check.equal(pathfs.readFile(components_test3), test_content)
			pathfs.removeFile(components_test2)
			pathfs.removeFile(components_test3)
		end)

		test.case("from paths", function()
			local path_test1 = pathfs.Path.from(test1)
			local path_test2 = pathfs.Path.from(test2)
			local path_test3 = pathfs.Path.from(test3)

			pathfs.writeFile(path_test1, test_content)
			check.equal(pathfs.readFile(path_test1), test_content)
			pathfs.move(path_test1, path_test2)
			check.equal(pathfs.readFile(path_test2), test_content)
			pathfs.copy(path_test2, path_test3)
			check.equal(pathfs.readFile(path_test3), test_content)
			pathfs.removeFile(path_test2)
			pathfs.removeFile(path_test3)
		end)
	end)

	local test_dir = "tests/testdir"

	test.suite("writing directories", function()
		test.case("from string paths", function()
			pathfs.writeDir(test_dir)
			pathfs.removeDir(test_dir)
		end)

		test.case("from components", function()
			local components = pathfs.Path.from(test_dir):components()
			pathfs.writeDir(components)
			pathfs.removeDir(components)
		end)

		test.case("from paths", function()
			local path = pathfs.Path.from(test_dir)
			pathfs.writeDir(path)
			pathfs.removeDir(path)
		end)
	end)

	test.suite("reading directories", function()
		test.case("from string paths", function()
			pathfs.writeDir(test_dir)
			check.truthy(pathfs.readDir(test_dir))
			pathfs.removeDir(test_dir)
		end)

		test.case("from components", function()
			local components = pathfs.Path.from(test_dir):components()
			pathfs.writeDir(components)
			check.truthy(pathfs.readDir(components))
			pathfs.removeDir(components)
		end)

		test.case("from paths", function()
			local path = pathfs.Path.from(test_dir)
			pathfs.writeDir(path)
			check.truthy(pathfs.readDir(path))
			pathfs.removeDir(path)
		end)
	end)
end
