@tool
extends "SearchMenu.gd"

func _ready() -> void:
	text = ""
	# todo get current tab and restrict to that?
	options = EditorInterface.get_editor_theme().get_type_list()
	super()

func _on_control_type_text_changed(new_text: String) -> void:
	options = EditorInterface.get_editor_theme().get_type_variation_list(new_text)
