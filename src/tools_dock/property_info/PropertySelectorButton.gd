@tool
extends Button

signal property_selected(property: String)

func _ready() -> void:
	add_theme_icon_override("icon", EditorInterface.get_editor_theme().get_icon("MemberProperty", &"EditorIcons"))

func _pressed() -> void:
	var object := EditorInterface.get_inspector().get_edited_object()
	EditorInterface.popup_property_selector(
		object,
		_set_controls_to_property,
		[],
		"" # TODO 
	)

func _set_controls_to_property(path: NodePath) -> void:
	var property := str(path)
	var paths := property.split(":")
	if paths.size() >= 2:
		property_selected.emit(paths[1])