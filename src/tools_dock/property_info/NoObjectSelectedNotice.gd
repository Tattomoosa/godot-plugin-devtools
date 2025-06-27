@tool
extends PanelContainer

func _init() -> void:
	add_theme_stylebox_override(
		"panel",
		EditorInterface.get_base_control().get_theme_stylebox(
			"Background",
			"EditorStyles"
		)
	)
	EditorInterface.get_inspector().edited_object_changed.connect(_edited_object_changed)

func _edited_object_changed() -> void:
	visible = EditorInterface.get_inspector().get_edited_object() == null