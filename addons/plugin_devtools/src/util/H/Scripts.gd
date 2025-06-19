@tool

const H := preload("uid://bn7ppltfkj17y")
const Arrays := H.Arrays


## Useful to get the script name for scripts that don't have `class_name`
static func get_object_script_name(object: Object) -> String:
	var script : Script = object.get_script()
	return get_script_name(script)


## Useful to get the script name for scripts that don't have `class_name`
static func get_script_name(script: Script) -> String:
	if !script: return ""
	var file := script.resource_path.get_file()
	var extension := file.get_extension()
	return file.replace(".%s" % extension, "")


static func get_class_name_or_script_name(object: Object) -> String:
	var script : Script
	var cname : String
	if object is Script:
		script = object
	else:
		script = object.get_script()
	if script:
		cname = script.get_global_name()
		if !cname:
			cname = get_script_name(script)
	else:
		cname = object.get_class()
	return cname


## This used to be a lot harder! Probably can deprecate this
# TODO deprecate
static func get_object_class_name(object: Object) -> String:
	var script : Script = object.get_script()
	return get_script_class_name(script)


## This used to be a lot harder! Probably can deprecate this
# TODO deprecate
static func get_script_class_name(script: Script) -> String:
	if !script: return ""
	return script.get_global_name()


static func get_class_name_or_class(object: Object) -> String:
	if !object: return ""
	var script : Script = object.get_script()
	if script:
		var cname := script.get_global_name()
		if cname:
			return cname
	return object.get_class()


static func is_class_name(class_name_string: String) -> bool:
	if ClassDB.class_exists(class_name_string):
		return false
	var class_data := get_class_data(class_name_string)
	return !class_data.is_empty()


static func class_name_extends_from(child_class: String, parent_class: String) -> bool:
	var child_inheritance_list := get_base_class_names(child_class)
	return parent_class in child_inheritance_list


static func get_class_data(class_name_string: String) -> Dictionary:
	var class_list := ProjectSettings.get_global_class_list()
	var class_data := Arrays.get_first_dictionary_matching_property(class_list, "class", class_name_string)
	if !class_data:
		return {}
	return class_data


static func get_base_class_list(class_name_string: String) -> Array[Dictionary]:
	var class_inheritance_list : Array[Dictionary]
	var class_data := get_class_data(class_name_string)
	if !class_data:
		push_warning("class_name '%s' not found" % class_name_string)
		return []
	class_inheritance_list.push_back(class_data)
	var base_class_name : String = class_data.base
	while is_class_name(base_class_name):
		var base_class_data := get_class_data(base_class_name)
		class_inheritance_list.push_back(base_class_data)
		base_class_name = base_class_data.base
	# should be real class now
	class_inheritance_list.push_back({ "class": base_class_name})
	return class_inheritance_list


static func get_base_class_names(class_name_string: String) -> Array[String]:
	var class_inheritance_list := get_base_class_list(class_name_string)
	var name_list : Array[String] = []
	for dict in class_inheritance_list:
		name_list.push_back(dict.class)
	return name_list


static func get_icon(class_name_string: String) -> Texture2D:
	var inheritance_list := get_base_class_list(class_name_string)
	for data in inheritance_list:
		if data.icon:
			return load(data.icon)
	return null


static func get_path_from_class_name(class_name_string: String) -> String:
	var data := get_class_data(class_name_string)
	return data.path


static func get_script_from_class_name(class_name_string: String) -> Script:
	return load(get_path_from_class_name(class_name_string))


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")
