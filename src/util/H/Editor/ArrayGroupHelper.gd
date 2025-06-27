extends RefCounted

## Helper to make an "EditorArray" - or something that shows up in the inspector like a single
## group of properties in a list, but is actually backed by multiple data arrays holding associated
## data in each index. Useful when you don't want to make a Resource and deal with local_to_scene
## just to make a nice inspector, plus it's a little easier to use than an Array[Resource]
##
## Unfortunately, given the limitations, it is a bit hairy to setup. See PropertySyncNode for 
## an example. Real documentation someday... maybe.

var object: Object
var count_property_name : StringName
var display_name : String
var add_button_text : String
var prefix : String
var typed_data_arrays : Dictionary[String, Array]

signal array_about_to_change(key: String, index: int)
signal array_changed(key: String, index: int)

func _init(
	p_object: Object,
	p_display_name: String,
	p_add_button_text: String,
	p_count_property_name: StringName,
	p_prefix: String,
	p_typed_data_arrays: Dictionary[String, Array],
) -> void:
	object = p_object
	display_name = p_display_name
	count_property_name = p_count_property_name
	prefix = p_prefix
	typed_data_arrays = p_typed_data_arrays
	add_button_text = p_add_button_text
	for array in typed_data_arrays.values():
		assert(array.is_typed(), "Arrays must have a defined type")

func validate_property_helper(property: Dictionary) -> void:
	if property.name == count_property_name:
		property.class_name = ",".join([
			display_name,
			prefix,
			"unfoldable",
			"page_size=999",
			"add_button_text=" + add_button_text
		])
		property.usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_ARRAY

func get_property_list_helper() -> Array[Dictionary]:
	var props : Array[Dictionary] = []
	# TODO figure out how to make each one foldable?
	# for i in object.get(count_property_name):
	# 	var prop := {}
	# 	prop.type = TYPE_NIL
	# 	prop.usage = PROPERTY_USAGE_GROUP
	# 	prop.hint_string = prefix
	# 	prop.name = "%s %d" % [display_name, i]
	# 	props.push_back(prop)
	for key in typed_data_arrays:
		var array := typed_data_arrays[key]
		var prop := {}
		prop.type = array.get_typed_builtin()
		prop.usage = PROPERTY_USAGE_EDITOR
		if prop.type == TYPE_OBJECT:
			var c_name := array.get_typed_class_name()
			# TODO probably a bunch of these that need to be covered
			if c_name == "Resource":
				prop.hint = PROPERTY_HINT_RESOURCE_TYPE
			var script : Script = array.get_typed_script()
			var script_class_name := script.get_global_name()
			if script_class_name:
				prop.hint_string = script_class_name
		for i in object.get(count_property_name):
			var p := prop.duplicate()
			p.name = prefix + str(i) + "/" + key
			props.push_back(p)
	return props

func get_helper(property: StringName) -> Variant:
	if property.begins_with(prefix):
		var i := property.to_int()
		for key in typed_data_arrays:
			if property.ends_with(key):
				var arr := typed_data_arrays[key]
				if arr.size() <= i:
					arr.resize(i + 1)
				return typed_data_arrays[key][i]
	return null

func set_helper(property: StringName, value: Variant) -> bool:
	if property.begins_with(prefix):
		var i := property.to_int()
		for key in typed_data_arrays:
			if property.ends_with(key):
				if "is_node_ready" in object:
					if !object.is_node_ready():
						return true
				var arr := typed_data_arrays[key]
				arr.resize(object.get(count_property_name))
				array_about_to_change.emit(key, i)
				typed_data_arrays[key][i] = value
				array_changed.emit(key, i)
				object.notify_property_list_changed()
				return true
	return false
