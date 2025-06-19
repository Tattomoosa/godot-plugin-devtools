@tool
extends EditorThemeExplorerList

const EditorThemeExplorerList := preload("uid://dg4oc6ix73l6v")
const COPY_TEXT := 'EditorInterface.get_editor_theme().get_font("%s", "%s")'

func _build_item(font_name: String) -> Button:
	var t := EditorInterface.get_editor_theme()
	var btn := Button.new()
	var font := t.get_font(font_name, theme_type)
	if t.has_font_size(font_name, theme_type):
		var font_size_name = font_name
		font_size_name = font_size_name.replace("_msdf", "")
		font_size_name = font_size_name.replace("_bold", "")
		font_size_name = font_size_name.replace("_italic", "")
		font_size_name = font_size_name.replace("_mono", "")
		font_size_name += "_size"
		var font_size := t.get_font_size(font_size_name, theme_type)
		btn.add_theme_font_size_override("font_size", font_size)
	btn.add_theme_font_override("font", font)
	btn.custom_minimum_size.y = item_size * EditorInterface.get_editor_scale()
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.text = font_name
	btn.set_meta("font", font)
	return btn

func _get_item_names() -> PackedStringArray:
	var t := EditorInterface.get_editor_theme()
	return t.get_font_list(theme_type)

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
		"resource": button.get_meta("font") as Font
	}
