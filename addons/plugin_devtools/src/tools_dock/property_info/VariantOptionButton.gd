@tool
extends OptionButton

func _ready() -> void:
	clear()
	fit_to_longest_item = false
	for i in TYPE_MAX:
		add_icon_item(
			EditorInterface.get_inspector().get_theme_icon(type_string(i), "EditorIcons"),
			type_string(i)
		)