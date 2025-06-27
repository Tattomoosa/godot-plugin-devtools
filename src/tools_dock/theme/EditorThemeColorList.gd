@tool
extends EditorThemeExplorerList

const EditorThemeExplorerList := preload("uid://dg4oc6ix73l6v")
const COPY_TEXT := 'EditorInterface.get_editor_theme().get_color("%s", "%s")'


func _ready() -> void:
	theme_type = EditorInterface.get_editor_theme().get_color_type_list()[0]
	_populate()


func _get_item_names() -> PackedStringArray:
	var t := EditorInterface.get_editor_theme()
	return t.get_color_list(theme_type)


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
		"resource": button.icon
	}


func _build_item(color_name: String) -> Button:
	var b := ColorButton.new()
	b.color = EditorInterface.get_editor_theme().get_color(color_name, theme_type)
	b.text = color_name
	b.tooltip_text = color_name
	b.name = color_name
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# b.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_SHRINK_BEGIN
	return b


func _load_icon(icon_name: String) -> Texture2D:
	var t := EditorInterface.get_editor_theme()
	return t.get_icon(icon_name, theme_type)


func _get_copy_format_string() -> String:
	return COPY_TEXT

	
class ColorButton extends Button:
	var color : Color = Color.WHITE
	static var STYLE_BOX_EMPTY := StyleBoxEmpty.new()


	func _ready() -> void:
		for state in ["normal", "hover", "pressed"]:
			add_theme_stylebox_override(state, STYLE_BOX_EMPTY)
		var cr := ColorRect.new()
		cr.show_behind_parent = true
		cr.color = color
		cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cr.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
		if color.get_luminance() > 0.4 and color.a > 0.5:
			add_theme_color_override("font_color", Color.BLACK)
		add_child(cr)
