@tool
extends EditorIconButton

const EditorIconButton := preload("uid://83yq2e5cupld")

@export var type : Variant.Type = TYPE_NIL:
	set(v):
		type = v
		icon_name = type_string(type)
		_update_icon()

func _ready() -> void:
	icon_name = type_string(type)
	super()

func _validate_property(property: Dictionary) -> void:
	super(property)
	if property.name == "icon_name":
		property.usage = PROPERTY_USAGE_NONE
	if property.name == "icon_override":
		property.usage = PROPERTY_USAGE_NONE