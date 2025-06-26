@tool

const H := preload("uid://bn7ppltfkj17y")
const Strings := H.Strings
const Files := H.Files


static func get_all_files(
	path: String,
	file_extensions := [],
	include_hidden := false,
	files := PackedStringArray([])
) -> PackedStringArray:
	var dir := DirAccess.open(path)
	if !dir:
		push_error(error_string(DirAccess.get_open_error()))
		return files
	dir.include_hidden = include_hidden
	dir.include_navigational = false
	if DirAccess.get_open_error() != OK:
		push_error("Could not open directory at '%s'" % path, error_string(DirAccess.get_open_error()))
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path := dir.get_current_dir().path_join(file_name)
		if dir.current_is_dir():
			get_all_files(file_path, file_extensions, include_hidden, files)
		else:
			if !file_extensions or file_name.get_extension() in file_extensions:
				files.append(file_path)
		file_name = dir.get_next()
	return files


static func is_resource_path(path: String) -> bool:
	return path.begins_with("res://")


static func get_subdirectories(path: String) -> PackedStringArray:
	var dir := DirAccess.open(path)
	dir.include_navigational = false
	if DirAccess.get_open_error() != OK:
		push_error("Could not open directory at '%s'" % path, error_string(DirAccess.get_open_error()))
	return dir.get_directories()


static func path_join_all(root_path: String, paths: PackedStringArray) -> PackedStringArray:
	var joined := PackedStringArray()
	for path in paths:
		joined.push_back(root_path.path_join(path))
	return joined


static func strip_extension(filename: String) -> String:
	return filename.replace(filename.get_extension(), "")


static func get_file_without_extension(path: String) -> String:
	return path.get_file().replace("." + path.get_extension(), "")


static func get_uid(path: String) -> int:
	return ResourceLoader.get_resource_uid(path)


class DirWatcher extends RefCounted:
	const Files := H.Files

	## Emitted when files are created in the scanned directories.
	signal files_created(files: PackedStringArray)
	## Emitted when files are modified in the scanned directories (based on modified time).
	signal files_modified(files: PackedStringArray)
	## Emitted when files are deleted in the scanned directories.
	signal files_deleted(files: PackedStringArray)

	var _root : String
	var _extensions : Array[String]
	var _watched : Dictionary[String, WatchedFile] = {}
	var _first_pass := true
	var _include_hidden := false

	func _init(root := "res://", extensions : Array[String] = [], include_hidden := false) -> void:
		_root = root
		_extensions = extensions
		_include_hidden = include_hidden
		update()


	func update() -> void:
		for watched_file in _watched.values():
			watched_file.was_found = false
		var created := PackedStringArray()
		var modified := PackedStringArray()
		var file_paths := Files.get_all_files(_root, _extensions, _include_hidden)
		for path in file_paths:
			var modified_time := FileAccess.get_modified_time(path)
			if !path in _watched:
				_watched[path] = WatchedFile.new(modified_time)
				if !_first_pass:
					created.push_back(path)
			if _watched[path].has_been_modified(modified_time):
				modified.push_back(path)
			_watched[path].was_found = true
		var deleted := PackedStringArray()
		for path in _watched.keys():
			if !_watched[path].was_found:
				deleted.push_back(path)
				_watched.erase(path)
		if !modified.is_empty(): files_modified.emit(modified)
		if !created.is_empty(): files_created.emit(created)
		if !deleted.is_empty(): files_deleted.emit(deleted)
		_first_pass = false
	
	func get_files() -> PackedStringArray:
		return PackedStringArray(_watched.keys())
	
	class WatchedFile:
		var modified : int
		var was_found : bool = true


		func _init(p_modified : int) -> void:
			modified = p_modified


		func has_been_modified(p_modified: int) -> bool:
			if modified == p_modified:
				return false
			modified = p_modified
			return true


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")
