@tool
extends EditorThemeExplorerList

const EditorThemeExplorerList := preload("uid://dg4oc6ix73l6v")
const COPY_TEXT := 'EditorInterface.get_editor_theme().get_stylebox("%s", "%s")'


func _build_item(stylebox_name: String) -> Button:
	var t := EditorInterface.get_editor_theme()
	var btn := Button.new()
	var style := t.get_stylebox(stylebox_name, theme_type)
	if true: # styles
		for state in ["normal", "pressed", "hover"]:
			btn.add_theme_stylebox_override(state, style)
		if false: # hover style
			var hover_style := StyleBoxFlat.new()
			hover_style.border_color = Color.WHITE
			hover_style.set_border_width_all(5)
			if "bg_color" in style:
				hover_style.bg_color = style.bg_color
			else:
				hover_style.bg_color = Color.TRANSPARENT
			btn.add_theme_stylebox_override("hover", hover_style)
	btn.custom_minimum_size.y = item_size * EditorInterface.get_editor_scale()
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.text = stylebox_name
	btn.set_meta("stylebox", style)
	return btn


func _get_item_names() -> PackedStringArray:
	var t := EditorInterface.get_editor_theme()
	return t.get_stylebox_list(theme_type)


func _get_copy_format_string() -> String:
	return COPY_TEXT


func _get_item_drag_data(_pos: Vector2, button: Button) -> Variant:
	var d_offset := Control.new()
	var d_preview := button.duplicate()
	d_preview.size.x = item_size * H.Editor.Settings.scale
	d_offset.add_child(d_preview)
	d_preview.position -= Vector2(50,50)
	set_drag_preview(d_offset)
	return {
		"type": "resource",
		"resource": button.meta("stylebox")
	}
