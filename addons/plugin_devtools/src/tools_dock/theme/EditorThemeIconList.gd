@tool
extends EditorThemeExplorerList

const EditorThemeExplorerList := preload("uid://dg4oc6ix73l6v")
const COPY_TEXT := 'EditorInterface.get_editor_theme().get_icon("%s", "%s")'


func _ready() -> void:
	_populate()


func _build_item(item_name: String) -> Button:
	var icon_button := Button.new()
	icon_button.expand_icon = true
	icon_button.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_SHRINK_BEGIN
	icon_button.icon = _load_icon(item_name)
	icon_button.custom_minimum_size = Vector2.ONE * item_size * H.Editor.Settings.scale
	icon_button.tooltip_text = item_name
	icon_button.name = item_name
	return icon_button


func _get_item_names() -> PackedStringArray:
	return EditorInterface.get_editor_theme().get_icon_list(theme_type)


func _load_icon(icon_name: String) -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon(icon_name, theme_type)


func _get_copy_format_string() -> String:
	return COPY_TEXT


func _get_item_drag_data(_pos: Vector2, button: Button) -> Variant:
	var d_offset := Control.new()
	var d_preview := TextureRect.new()
	d_preview.texture = button.icon
	d_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	d_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	d_preview.position -= Vector2(25,25) * EditorInterface.get_editor_scale()
	d_preview.modulate = Color(Color.WHITE, 0.5)
	d_preview.size = button.size
	d_offset.add_child(d_preview)
	set_drag_preview(d_offset)
	return {
		"type": "resource",
		"resource": button.icon.duplicate()
	}
