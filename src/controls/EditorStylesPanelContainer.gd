@tool
extends PanelContainer

@export_enum("Placeholder") var panel_style : String:
	set(value):
		panel_style = value
		_update_panel()

func _update_panel() -> void:
	add_theme_stylebox_override(
		&"panel",
		EditorInterface.get_editor_theme().get_stylebox(
			panel_style,
			"EditorStyles",
		)
	)

func _validate_property(property: Dictionary) -> void:
	if property.name == "panel_style":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(EditorInterface.get_editor_theme().get_stylebox_list("EditorStyles"))
