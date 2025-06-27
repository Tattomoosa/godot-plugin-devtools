@tool
extends Button

@export_enum("Placeholder") var icon_name : String:
	set(value):
		icon_name = value
		_update_icon()

@export_enum("InspectorActionButton","EditorLogFilterButton")
var button_type : String = "InspectorActionbutton":
	set(value):
		button_type = value
		_update_panel()

@export var icon_override : Texture2D:
	set(value):
		icon_override = value
		_update_icon()


func _ready() -> void:
	_update_icon()
	_update_panel()


func _update_panel() -> void:
	theme_type_variation = button_type


func _update_icon() -> void:
	var c := EditorInterface.get_base_control()
	if icon_override:
		add_theme_icon_override("icon", icon_override)
		return
	if icon_name:
		add_theme_icon_override("icon", c.get_theme_icon(icon_name, &"EditorIcons"))
		return
	remove_theme_icon_override("icon")


func _validate_property(property: Dictionary) -> void:
	if property.name == "icon":
		property.usage = PROPERTY_USAGE_NONE
	if property.name == "icon_name":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(EditorInterface.get_editor_theme().get_icon_list("EditorIcons"))
	if property.name == "button_type":
		var button_types := PackedStringArray([""])
		button_types.append_array(EditorInterface.get_editor_theme().get_type_variation_list("Button"))
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(button_types)
		
