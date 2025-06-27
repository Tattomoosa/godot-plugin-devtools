@tool

## Converts from a usage flag bit to the corresponding string
## Note that PROPERTY_USAGE_DEFAULT is just PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR
const SPECIAL_USAGE_FLAG_STRINGS : Dictionary[int, StringName] = {
	0: &"PROPERTY_USAGE_NONE",
	6: &"PROPERTY_USAGE_DEFAULT",
}

const USAGE_FLAG_STRINGS : Dictionary[int, StringName] = {
	2: &"PROPERTY_USAGE_STORAGE",
	4: &"PROPERTY_USAGE_EDITOR",
	8: &"PROPERTY_USAGE_INTERNAL",
	16: &"PROPERTY_USAGE_CHECKABLE",
	32: &"PROPERTY_USAGE_CHECKED",
	64: &"PROPERTY_USAGE_GROUP",
	128: &"PROPERTY_USAGE_CATEGORY",
	256: &"PROPERTY_USAGE_SUBGROUP",
	512: &"PROPERTY_USAGE_CLASS_IS_BITFIELD",
	1024: &"PROPERTY_USAGE_NO_INSTANCE_STATE",
	2048: &"PROPERTY_USAGE_RESTART_IF_CHANGED",
	4096: &"PROPERTY_USAGE_SCRIPT_VARIABLE",
	8192: &"PROPERTY_USAGE_STORE_IF_NULL",
	16384: &"PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED",
	32768: &"PROPERTY_USAGE_SCRIPT_DEFAULT_VALUE",
	65536: &"PROPERTY_USAGE_CLASS_IS_ENUM",
	131072: &"PROPERTY_USAGE_NIL_IS_VARIANT",
	262144: &"PROPERTY_USAGE_ARRAY",
	524288: &"PROPERTY_USAGE_ALWAYS_DUPLICATE",
	1048576: &"PROPERTY_USAGE_NEVER_DUPLICATE",
	2097152: &"PROPERTY_USAGE_HIGH_END_GFX",
	4194304: &"PROPERTY_USAGE_NODE_PATH_FROM_SCENE_ROOT",
	8388608: &"PROPERTY_USAGE_RESOURCE_NOT_PERSISTENT",
	16777216: &"PROPERTY_USAGE_KEYING_INCREMENTS",
	33554432: &"PROPERTY_USAGE_DEFERRED_SET_RESOURCE",
	67108864: &"PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT",
	134217728: &"PROPERTY_USAGE_EDITOR_BASIC_SETTING",
	268435456: &"PROPERTY_USAGE_READ_ONLY",
	536870912: &"PROPERTY_USAGE_SECRET",
}

## To convert from a Variant.Type enum to the corresponding string -- NOT the same as type_string()
const TYPE_STRINGS : Array[String] = [
	&"TYPE_NIL",
	&"TYPE_BOOL",
	&"TYPE_INT",
	&"TYPE_FLOAT",
	&"TYPE_STRING",
	&"TYPE_VECTOR2",
	&"TYPE_VECTOR2I",
	&"TYPE_RECT2",
	&"TYPE_RECT2I",
	&"TYPE_VECTOR3",
	&"TYPE_VECTOR3I",
	&"TYPE_TRANSFORM2D",
	&"TYPE_VECTOR4",
	&"TYPE_VECTOR4I",
	&"TYPE_PLANE",
	&"TYPE_QUATERNION",
	&"TYPE_AABB",
	&"TYPE_BASIS",
	&"TYPE_TRANSFORM3D",
	&"TYPE_PROJECTION",
	&"TYPE_COLOR",
	&"TYPE_STRING_NAME",
	&"TYPE_NODE_PATH",
	&"TYPE_RID",
	&"TYPE_OBJECT",
	&"TYPE_CALLABLE",
	&"TYPE_SIGNAL",
	&"TYPE_DICTIONARY",
	&"TYPE_ARRAY",
	&"TYPE_PACKED_BYTE_ARRAY",
	&"TYPE_PACKED_INT32_ARRAY",
	&"TYPE_PACKED_INT64_ARRAY",
	&"TYPE_PACKED_FLOAT32_ARRAY",
	&"TYPE_PACKED_FLOAT64_ARRAY",
	&"TYPE_PACKED_STRING_ARRAY",
	&"TYPE_PACKED_VECTOR2_ARRAY",
	&"TYPE_PACKED_VECTOR3_ARRAY",
	&"TYPE_PACKED_COLOR_ARRAY",
	&"TYPE_PACKED_VECTOR4_ARRAY",
	&"TYPE_MAX",
]

## To convert from a Variant.Type enum to the corresponding string -- NOT the same as type_string()
const PROPERTY_HINT_STRINGS : Array[StringName] = [
	&"PROPERTY_HINT_NONE",
	&"PROPERTY_HINT_RANGE",
	&"PROPERTY_HINT_ENUM",
	&"PROPERTY_HINT_ENUM_SUGGESTION",
	&"PROPERTY_HINT_EXP_EASING",
	&"PROPERTY_HINT_LINK",
	&"PROPERTY_HINT_FLAGS",
	&"PROPERTY_HINT_LAYERS_2D_RENDER",
	&"PROPERTY_HINT_LAYERS_2D_PHYSICS",
	&"PROPERTY_HINT_LAYERS_2D_NAVIGATION",
	&"PROPERTY_HINT_LAYERS_3D_RENDER",
	&"PROPERTY_HINT_LAYERS_3D_PHYSICS",
	&"PROPERTY_HINT_LAYERS_3D_NAVIGATION",
	&"PROPERTY_HINT_FILE",
	&"PROPERTY_HINT_DIR",
	&"PROPERTY_HINT_GLOBAL_FILE",
	&"PROPERTY_HINT_GLOBAL_DIR",
	&"PROPERTY_HINT_RESOURCE_TYPE",
	&"PROPERTY_HINT_MULTILINE_TEXT",
	&"PROPERTY_HINT_EXPRESSION",
	&"PROPERTY_HINT_PLACEHOLDER_TEXT",
	&"PROPERTY_HINT_COLOR_NO_ALPHA",
	&"PROPERTY_HINT_OBJECT_ID",
	&"PROPERTY_HINT_TYPE_STRING",
	&"PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE",
	&"PROPERTY_HINT_OBJECT_TOO_BIG",
	&"PROPERTY_HINT_NODE_PATH_VALID_TYPES",
	&"PROPERTY_HINT_SAVE_FILE",
	&"PROPERTY_HINT_GLOBAL_SAVE_FILE",
	&"PROPERTY_HINT_INT_IS_OBJECTID",
	&"PROPERTY_HINT_INT_IS_POINTER",
	&"PROPERTY_HINT_ARRAY_TYPE",
	&"PROPERTY_HINT_LOCALE_ID",
	&"PROPERTY_HINT_LOCALIZABLE_STRING",
	&"PROPERTY_HINT_NODE_TYPE",
	&"PROPERTY_HINT_HIDE_QUATERNION_EDIT",
	&"PROPERTY_HINT_PASSWORD",
	&"PROPERTY_HINT_LAYERS_AVOIDANCE",
	&"PROPERTY_HINT_DICTIONARY_TYPE",
	&"PROPERTY_HINT_TOOL_BUTTON",
	&"PROPERTY_HINT_ONESHOT",
	&"UNUSED?", #41
	&"UNUSED?", #42
	&"UNUSED?", #43
	&"PROPERTY_HINT_MAX",
]

# TODO the idea is this is all the applicable hints for a given type
const HINT_MAP := {
	TYPE_NIL: [PROPERTY_HINT_NONE],
	TYPE_BOOL: [PROPERTY_HINT_NONE],
	TYPE_INT: [PROPERTY_HINT_NONE, PROPERTY_HINT_RANGE, PROPERTY_HINT_ENUM, PROPERTY_HINT_FLAGS, PROPERTY_HINT_LAYERS_2D_NAVIGATION, PROPERTY_HINT_LAYERS_2D_PHYSICS, PROPERTY_HINT_LAYERS_2D_RENDER, PROPERTY_HINT_LAYERS_3D_NAVIGATION, PROPERTY_HINT_LAYERS_3D_PHYSICS, PROPERTY_HINT_LAYERS_3D_RENDER, PROPERTY_HINT_LAYERS_AVOIDANCE, PROPERTY_HINT_INT_IS_OBJECTID, PROPERTY_HINT_INT_IS_POINTER],
	TYPE_FLOAT: [PROPERTY_HINT_NONE, PROPERTY_HINT_RANGE, PROPERTY_HINT_EXP_EASING],
	TYPE_STRING: [PROPERTY_HINT_NONE, PROPERTY_HINT_ENUM, PROPERTY_HINT_ENUM_SUGGESTION, PROPERTY_HINT_FILE, PROPERTY_HINT_GLOBAL_FILE, PROPERTY_HINT_DIR, PROPERTY_HINT_GLOBAL_DIR, PROPERTY_HINT_MULTILINE_TEXT, PROPERTY_HINT_SAVE_FILE, PROPERTY_HINT_GLOBAL_SAVE_FILE, PROPERTY_HINT_PASSWORD, PROPERTY_HINT_TYPE_STRING, PROPERTY_HINT_EXPRESSION],
	TYPE_VECTOR2: [PROPERTY_HINT_NONE, PROPERTY_HINT_LINK],
	TYPE_VECTOR2I: [PROPERTY_HINT_NONE, PROPERTY_HINT_LINK],
	TYPE_RECT2: [PROPERTY_HINT_NONE],
	TYPE_RECT2I: [PROPERTY_HINT_NONE],
	TYPE_VECTOR3: [PROPERTY_HINT_NONE, PROPERTY_HINT_LINK],
	TYPE_VECTOR3I: [PROPERTY_HINT_NONE, PROPERTY_HINT_LINK],
	TYPE_TRANSFORM2D: [PROPERTY_HINT_NONE],
	TYPE_VECTOR4: [PROPERTY_HINT_NONE, PROPERTY_HINT_LINK],
	TYPE_VECTOR4I: [PROPERTY_HINT_NONE, PROPERTY_HINT_LINK],
	TYPE_PLANE: [PROPERTY_HINT_NONE],
	TYPE_QUATERNION: [PROPERTY_HINT_NONE],
	TYPE_AABB: [PROPERTY_HINT_NONE],
	TYPE_BASIS: [PROPERTY_HINT_NONE],
	TYPE_TRANSFORM3D: [PROPERTY_HINT_NONE],
	TYPE_PROJECTION: [PROPERTY_HINT_NONE],
	TYPE_COLOR: [PROPERTY_HINT_NONE, PROPERTY_HINT_COLOR_NO_ALPHA],
	TYPE_STRING_NAME: [PROPERTY_HINT_NONE, PROPERTY_HINT_ENUM, PROPERTY_HINT_ENUM_SUGGESTION],
	TYPE_NODE_PATH: [PROPERTY_HINT_NONE, PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE, PROPERTY_HINT_NODE_PATH_VALID_TYPES],
	TYPE_RID: [PROPERTY_HINT_NONE],
	TYPE_OBJECT: [PROPERTY_HINT_NONE, PROPERTY_HINT_NODE_TYPE, PROPERTY_HINT_RESOURCE_TYPE],
	TYPE_CALLABLE: [PROPERTY_HINT_NONE],
	TYPE_SIGNAL: [PROPERTY_HINT_NONE],
	TYPE_DICTIONARY: [PROPERTY_HINT_NONE, PROPERTY_HINT_DICTIONARY_TYPE, PROPERTY_HINT_TYPE_STRING],
	TYPE_ARRAY: [PROPERTY_HINT_NONE, PROPERTY_HINT_ARRAY_TYPE, PROPERTY_HINT_TYPE_STRING],
	TYPE_PACKED_BYTE_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_INT32_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_INT64_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_FLOAT32_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_FLOAT64_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_STRING_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_VECTOR2_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_VECTOR3_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_COLOR_ARRAY: [PROPERTY_HINT_NONE],
	TYPE_PACKED_VECTOR4_ARRAY: [PROPERTY_HINT_NONE],
}


## Takes a property.usage bitflag int and returns all the flags as strings
static func get_usage_flag_names(usage: int) -> Array[StringName]:
	var used_flag_strings : Array[StringName] = []
	if usage in SPECIAL_USAGE_FLAG_STRINGS.keys():
		used_flag_strings.append(SPECIAL_USAGE_FLAG_STRINGS[usage])
	else:
		for flag in USAGE_FLAG_STRINGS.keys():
			if has_flag(usage, flag):
				used_flag_strings.append(USAGE_FLAG_STRINGS[flag])
	return used_flag_strings


static func has_flag(bits: int, flag: int) -> bool:
	return bits & flag != 0


## Gets a Variant.Type constant name -- not the "human readable" name from type_string()!
static func get_type_name(type: int) -> StringName:
	return TYPE_STRINGS[type]


## Gets a property hint enum name
static func get_property_hint_name(property_hint: int) -> StringName:
	return PROPERTY_HINT_STRINGS[property_hint]


## Pretties up an object property (Dictionary definition returned from get_property_list())
static func prettify(property: Dictionary) -> String:
	if "name" not in property:
		push_error(property)
		return "%s" % property
	var prop_str := "{\n"
	if "name" in property:
		prop_str += '\t&"name": "%s",\n' % property.name
	if "class_name" in property:
		prop_str += '\t&"class_name": "%s",\n' % property.class_name
	if "type" in property:
		prop_str += '\t&"type": %s, # (%d)\n' % [TYPE_STRINGS[property.type], property.type]
	if "hint" in property:
		prop_str += '\t&"hint": %s, # (%s)\n' % [
			PROPERTY_HINT_STRINGS[property.hint],
			property.hint,
		]
	if "hint_string" in property:
		prop_str += '\t&"hint_string": '
		if property.hint == PROPERTY_HINT_TYPE_STRING:
			prop_str += '"%s", # (%s)\n' % [
				property.hint_string,
				parse_hint_type_string(property.hint_string),
			]
		else:
			prop_str += "\"%s\",\n" % property.hint_string
	if "usage" in property:
		prop_str += '\t&"usage": %s, # (%s)\n' % [
			" | ".join(get_usage_flag_names(property.usage)),
			property.usage,
		]
	for key in property:
		if key not in ["name", "class_name", "type", "hint", "hint_string", "usage"]:
			prop_str += '\t&"%s": %s,\n' % [key, property[key]] 
	prop_str += "}"
	return prop_str


## PROPERTY_HINT_TYPE_STRING is especially hairy, this tells you what it's doing and is... 
## probably mostly correct?
# TODO Needs a lot of testing I haven't done!
# TODO doesn't do dictionaries right, I misunderstood the format!
# should be able to just split at ;
# and parse from there tho!
static func parse_hint_type_string(t_string: String) -> String:
	var parsed_str := ""
	var regex := RegEx.new()
	regex.compile(r"^((?:\d+\d*[\/]*\d*:;?)+)(\S*)$")
	var result := regex.search(t_string)
	if result:
		# last one is hint string
		var count := result.get_group_count()
		assert(count == 2, str(result))
		var section0 := result.get_string(1)
		var type_data := (
			Array(section0.split(":"))
				.filter(func(x): return !x.is_empty())
		)
		if ";" in section0:
			parsed_str += "{"
		for t in type_data:
			if "/" not in t:
				parsed_str += get_type_name(t.to_int())
				parsed_str += ":"
				continue
			else:
				t = t.split("/")
				parsed_str += get_type_name(t[0].to_int())
				parsed_str += "/"
				parsed_str += get_property_hint_name(t[1].to_int())
				if ";" in t[0]:
					parsed_str += "}:"
				else:
					parsed_str += ":"
		var hint_string := result.get_string(2)
		parsed_str += '"%s"' % hint_string
		return parsed_str
	return "???"


## PROPERTY_HINT_TYPE_STRING is especially hairy, this helps you construct it
static func construct_array_hint_type_string(
	types: Array[Variant.Type],
	usages: Array,
	hint_string : String
) -> String:
	var hint_str := ""
	for i in types.size():
		hint_str += str(types[i])
		if usages[i] > 0:
			hint_str += "/%d" % usages[i]
		hint_str += ":"
	hint_str += hint_string
	return hint_str
		

## Gets a property definition, like those returned from get_property_list(), but just one by name
static func get_property(object: Object, name: StringName) -> Dictionary:
	if !object:
		push_error("object is null")
	var props := object.get_property_list()
	for p in props:
		if p.name == name:
			return p
	return {}


## Generic way to just get a human-readable name from an object
static func get_object_name(object: Object) -> String:
	if "name" in object:
		return object.name
	if "resource_name" in object:
		return object.resource_name
	return "Object"


static func get_object_instantiate_property_editor_string(object: Object, name: StringName) -> String:
	var property := get_property(object, name)
	return get_instantiate_property_editor_string(property)


static func get_instantiate_property_editor_string(property: Dictionary) -> String:
	return "\n".join([
		"EditorInspector.instantiate_property_editor(",
			"\t%s," % "get_edited_object()",
			"\t%s," % TYPE_STRINGS[property.type],
			'\t"%s",' % property.name,
			"\t%s," % PROPERTY_HINT_STRINGS[property.hint],
			'\t"%s",' % property.hint_string,
			"\t%s," % " | ".join(get_usage_flag_names(property.usage)),
		")"])


static func instantiate_property_editor(object: Object, name: String) -> EditorProperty:
	if !Engine.is_editor_hint():
		return
	var property := get_property(object, name)
	if property.is_empty():
		return null
	return instantiate_custom_property_editor(object, property)


static func instantiate_custom_property_editor(object: Object, property: Dictionary) -> EditorProperty:
	if !Engine.is_editor_hint():
		return
	return EditorInspector.instantiate_property_editor(
		object,
		property.type,
		property.name,
		property.hint,
		property.hint_string,
		property.usage
	)


## Whether or not a given int property is bitflags
static func property_is_bitflags(property: Dictionary) -> bool:
		return (
			"usage" in property\
			and has_flag(property.usage, PROPERTY_USAGE_CLASS_IS_BITFIELD)\
			or property.hint in [
				PROPERTY_HINT_FLAGS,
				PROPERTY_HINT_LAYERS_2D_RENDER,
				PROPERTY_HINT_LAYERS_2D_PHYSICS,
				PROPERTY_HINT_LAYERS_2D_NAVIGATION,
				PROPERTY_HINT_LAYERS_3D_RENDER,
				PROPERTY_HINT_LAYERS_3D_PHYSICS,
				PROPERTY_HINT_LAYERS_3D_NAVIGATION,
				PROPERTY_HINT_LAYERS_AVOIDANCE,
			]
		)


func _init() -> void: assert(false, "Class can't be instantiated")