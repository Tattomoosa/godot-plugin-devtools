@tool
extends Container

signal usage_changed(usage: int)

const H := preload("uid://bn7ppltfkj17y")
const USAGES := H.PropertyInfo.USAGE_FLAG_STRINGS
const USAGE_INFO : Dictionary[int, String] = {
	PROPERTY_USAGE_STORAGE: "Serialized in packed scenes",
	PROPERTY_USAGE_EDITOR: "Shown in the Inspector",
	PROPERTY_USAGE_INTERNAL: "Excluded from class reference",
	# PROPERTY_USAGE_CHECKABLE: "",
	# PROPERTY_USAGE_CHECKED: "",
	# PROPERTY_USAGE_GROUP: "",
	# PROPERTY_USAGE_CATEGORY: "",
	# PROPERTY_USAGE_SUBGROUP: "",
	PROPERTY_USAGE_CLASS_IS_BITFIELD: "Int is treated as a bitfield",
	PROPERTY_USAGE_NO_INSTANCE_STATE: "Not serialized in packed scenes",
	PROPERTY_USAGE_RESTART_IF_CHANGED: "Prompts for restarting the editor",
	PROPERTY_USAGE_SCRIPT_VARIABLE: "Is a script variable",
	PROPERTY_USAGE_STORE_IF_NULL: "Value is serialized even if null",
	PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED: "The Inspector will refresh the whole object if modified",
	PROPERTY_USAGE_SCRIPT_DEFAULT_VALUE: "???",
	PROPERTY_USAGE_CLASS_IS_ENUM: "Int is treated as an enum",
	PROPERTY_USAGE_NIL_IS_VARIANT: "Null values will have Variant EditorProperties",
	# PROPERTY_USAGE_ARRAY: "Is an array",
	PROPERTY_USAGE_ALWAYS_DUPLICATE: "Always duplicate (Resource property)",
	PROPERTY_USAGE_NEVER_DUPLICATE: "Never duplicate (Resource property)",
	PROPERTY_USAGE_HIGH_END_GFX: "Not available in Compatability renderer",
	PROPERTY_USAGE_NODE_PATH_FROM_SCENE_ROOT: "NodePath is always relative to scene root",
	PROPERTY_USAGE_RESOURCE_NOT_PERSISTENT: "Each access gives a duplicated value",
	PROPERTY_USAGE_KEYING_INCREMENTS: "Adding an animation keyframe increments the value",
	PROPERTY_USAGE_DEFERRED_SET_RESOURCE: "???",
	PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT: "Automatically create a resource on this node",
	PROPERTY_USAGE_EDITOR_BASIC_SETTING: "Setting will appear even if Advanced Settings is disabled",
	PROPERTY_USAGE_READ_ONLY: "Property cannot be modified",
	PROPERTY_USAGE_SECRET: "Property contains confidential information",
}
const REFERENCE_TYPES := [TYPE_ARRAY, TYPE_DICTIONARY, TYPE_OBJECT, TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_FLOAT64_ARRAY, TYPE_PACKED_INT32_ARRAY, TYPE_PACKED_INT64_ARRAY, TYPE_PACKED_STRING_ARRAY, TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY, TYPE_PACKED_VECTOR4_ARRAY]


# var usages := PackedStringArray()
# var fake_object := FakeResource.new()
var flags : int = 6
var EXCLUDE_LIST := [
	# don't work in the preview
	PROPERTY_USAGE_CHECKABLE,
	PROPERTY_USAGE_CHECKED,
	PROPERTY_USAGE_GROUP,
	PROPERTY_USAGE_SUBGROUP,
	PROPERTY_USAGE_CATEGORY,
	PROPERTY_USAGE_ARRAY,
	# deprecated
	PROPERTY_USAGE_SCRIPT_DEFAULT_VALUE,
	PROPERTY_USAGE_DEFERRED_SET_RESOURCE,
]
var btn_to_usage : Dictionary[CheckBox, int]
var usage_to_btn : Dictionary[int, CheckBox]
var _type : Variant.Type = TYPE_NIL
var _hint : int
var _usage := PROPERTY_USAGE_DEFAULT as int

func set_type(type: int) -> void:
	_type = type as Variant.Type
	_usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
	_update()


func set_hint(hint: int) -> void:
	_hint = hint


func _ready() -> void:
	if is_part_of_edited_scene():
		return
	for usage in USAGES:
		if usage in EXCLUDE_LIST:
			continue
		var usage_string := USAGES[usage]
		usage_string = usage_string.replace("PROPERTY_USAGE_", "")
		var btn := CheckBox.new()
		btn.text = usage_string.capitalize()
		btn_to_usage[btn] = usage
		usage_to_btn[usage] = btn
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		# btn.pressed.connect(_update)
		btn.toggled.connect(_btn_toggled.bind(usage))
		add_child(btn)
		var label := Label.new()
		label.text = USAGE_INFO[usage]
		add_child(label)
	_update()


func _update() -> void:
	if _type == TYPE_ARRAY:
		_usage |= PROPERTY_USAGE_ARRAY
	# set readonly
	usage_to_btn[PROPERTY_USAGE_CLASS_IS_BITFIELD].disabled = _type != TYPE_INT
	# excluded... i think editor arrays would need their own builder
	# usage_to_btn[PROPERTY_USAGE_ARRAY].disabled = true
	usage_to_btn[PROPERTY_USAGE_NIL_IS_VARIANT].disabled = _type != TYPE_NIL
	usage_to_btn[PROPERTY_USAGE_NODE_PATH_FROM_SCENE_ROOT].disabled = _type != TYPE_NODE_PATH
	usage_to_btn[PROPERTY_USAGE_CLASS_IS_ENUM].disabled = _type not in [TYPE_INT, TYPE_STRING, TYPE_STRING_NAME]
	# should be Resource only.. would need more info than type
	usage_to_btn[PROPERTY_USAGE_RESOURCE_NOT_PERSISTENT].disabled = _type != TYPE_OBJECT
	# should be Node only.. would need more info than type
	usage_to_btn[PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT].disabled = _type != TYPE_OBJECT

	var always_duplicate := usage_to_btn[PROPERTY_USAGE_ALWAYS_DUPLICATE]
	var never_duplicate := usage_to_btn[PROPERTY_USAGE_NEVER_DUPLICATE]

	always_duplicate.disabled = _type not in REFERENCE_TYPES
	never_duplicate.disabled = _type not in REFERENCE_TYPES
	if _type in REFERENCE_TYPES:
		never_duplicate.disabled = always_duplicate.button_pressed
		always_duplicate.disabled = never_duplicate.button_pressed
	_update_checkbox_values()


func _btn_toggled(value: bool, flag: int) -> void:
	if value:
		_usage |= flag
	else:
		_usage &= ~flag
	usage_changed.emit(_usage)
	_update()


func _update_checkbox_values() -> void:
	for u in usage_to_btn:
		usage_to_btn[u].set_pressed_no_signal(_usage & u != 0)
