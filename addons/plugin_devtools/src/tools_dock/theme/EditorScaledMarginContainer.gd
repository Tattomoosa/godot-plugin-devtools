@tool
extends MarginContainer

func _ready() -> void:
	var s := EditorInterface.get_editor_scale()
	add_theme_constant_override("margin_top", get("theme_override_constants/margin_top") * s)
	add_theme_constant_override("margin_left", get("theme_override_constants/margin_left") * s)
	add_theme_constant_override("margin_bottom", get("theme_override_constants/margin_bottom") * s)
	add_theme_constant_override("margin_right", get("theme_override_constants/margin_right") * s)