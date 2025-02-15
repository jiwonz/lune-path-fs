local lib =  require("./src/lib")
export type Directory = lib.Directory
export type File = lib.File
export type Metadata = lib.Metadata
export type MetadataKind = lib.MetadataKind
export type MetadataPermissions = lib.MetadataPermissions
export type WriteOptions = lib.WriteOptions
export type Components = lib.Components
export type Path = lib.Path
export type AsPath = lib.AsPath
export type Component = lib.Component

return require("./src/lib")
