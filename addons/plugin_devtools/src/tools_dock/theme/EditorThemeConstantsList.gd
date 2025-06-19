@tool
extends EditorThemeExplorerList

const EditorThemeExplorerList := preload("EditorThemeExplorerList.gd")
const COPY_TEXT := 'EditorInterface.get_base_control().theme.get_constant("%s", "%s")'

func _populate() -> void:
	super()
	await get_tree().process_frame

func _build_item(constant_name: String) -> Button:
	var t := EditorInterface.get_editor_theme()
	var btn := Button.new()
	var constant := t.get_constant(constant_name, theme_type)
	btn.text = "%s (%s)" % [constant_name, constant]
	btn.custom_minimum_size.y = item_size * EditorInterface.get_editor_scale()
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.set_meta("constant", constant)
	return btn

func _get_item_names() -> PackedStringArray:
	var t := EditorInterface.get_editor_theme()
	return t.get_constant_list(theme_type)

func _get_copy_format_string() -> String:
	return COPY_TEXT

# func _get_item_drag_data(_pos: Vector2, button: Button) -> Variant:
# 	var d_offset := Control.new()
# 	var d_preview := TextureRect.new()
# 	d_preview.texture = button.icon
# 	d_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
# 	d_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
# 	d_preview.position -= Vector2(25,25) * EditorInterface.get_editor_scale()
# 	d_preview.modulate = Color(Color.WHITE, 0.5)
# 	d_preview.size = button.size
# 	d_offset.add_child(d_preview)
# 	set_drag_preview(d_offset)
# 	return {
# 		"type": "resource",
# 		"resource": button.icon
# 	}