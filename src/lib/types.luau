local luauPath = require("../../luau_packages/luau_path")
local Path = luauPath.Path
local gt = require("../../lune_packages/greentea")

export type Components = typeof(Path.new():components())

local PathType = gt.build(gt.custom(luauPath.Path.is, "Path") :: luauPath.Path)
local Components = getmetatable(Path.from("a"):components() :: any).__index :: Components & {
	new: (path: string, prefix: any?, hasPhysicalRoot: boolean) -> Components,
	is: (value: unknown) -> boolean,
}
local ComponentsType = gt.build(gt.custom(Components.is, "Components") :: Components)
local AsPathType = gt.build(gt.union(gt.string(), PathType:type(), ComponentsType:type()))
local ContentsType = gt.build(gt.union(gt.string(), gt.buffer()))
local booleanType = gt.build(gt.boolean())
local stringType = gt.build(gt.string())
local optionalBooleanType = gt.build(gt.opt(gt.boolean()))
local arrayOfPathType = gt.build(gt.array(PathType:type()))

export type Component = typeof(Path.new():components():collect()[1])

export type Contents = typeof(ContentsType:type())

return {
	PathType = PathType,
	Components = Components,
	ComponentsType = ComponentsType,
	AsPathType = AsPathType,
	ContentsType = ContentsType,
	booleanType = booleanType,
	stringType = stringType,
	optionalBooleanType = optionalBooleanType,
	arrayOfPathType = arrayOfPathType,
}
