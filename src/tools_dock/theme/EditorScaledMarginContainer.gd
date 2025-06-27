@tool
extends MarginContainer

@export var margin : float = 0

func _ready() -> void:
	var s := EditorInterface.get_editor_scale()
	print(s)
	add_theme_constant_override("margin_top", margin * s)
	add_theme_constant_override("margin_left", margin * s)
	add_theme_constant_override("margin_bottom", margin * s)
	add_theme_constant_override("margin_right", margin * s)