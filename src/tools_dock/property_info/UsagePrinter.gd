@tool
extends Label

const H := preload("uid://bn7ppltfkj17y")
const USAGE_INFO : Dictionary[int, String] = {
	PROPERTY_USAGE_STORAGE: "Serialized in packed scenes",
	PROPERTY_USAGE_EDITOR: "Shown in the Inspector",
	PROPERTY_USAGE_INTERNAL: "Excluded from class reference",
	PROPERTY_USAGE_CHECKABLE: "",
	PROPERTY_USAGE_CHECKED: "",
	PROPERTY_USAGE_GROUP: "",
	PROPERTY_USAGE_CATEGORY: "",
	PROPERTY_USAGE_SUBGROUP: "",
	PROPERTY_USAGE_CLASS_IS_BITFIELD: "Int is treated as a bitfield",
	PROPERTY_USAGE_NO_INSTANCE_STATE: "Not serialized in packed scenes",
	PROPERTY_USAGE_RESTART_IF_CHANGED: "Prompts for restarting the editor",
	PROPERTY_USAGE_SCRIPT_VARIABLE: "Is a script variable",
	PROPERTY_USAGE_STORE_IF_NULL: "Value is serialized even if null",
	PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED: "The Inspector will refresh the whole object if modified",
	PROPERTY_USAGE_SCRIPT_DEFAULT_VALUE: "???",
	PROPERTY_USAGE_CLASS_IS_ENUM: "Int is treated as an enum",
	PROPERTY_USAGE_NIL_IS_VARIANT: "Null values will have Variant EditorProperties",
	PROPERTY_USAGE_ARRAY: "Is an array",
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


func _ready() -> void:
	display_usage_info(0)


func display_usage_info(usage: int) -> void:
	if usage == 0:
		text = "No property usage"
		return
	var t := PackedStringArray()
	for bit in USAGE_INFO:
		if H.PropertyInfo.has_flag(usage, bit):
			t.push_back(USAGE_INFO[bit])
	text = "\n".join(t)
