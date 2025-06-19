@tool
abstract extends Container

const H := preload("uid://bn7ppltfkj17y")

signal mouse_hovered_button(item_name: String)
signal button_pressed

@export var theme_type : String
@export var item_size : float = 32.0
@export var load_count := 100
@export_tool_button("Reload") var reload_button := _populate
var item_names : PackedStringArray


func _ready() -> void:
	pass


func set_theme_type(type: String) -> void:
	theme_type = type
	_populate()


func _populate() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	item_names = _get_item_names()
	# var loaded := 0
	for item_name in item_names:
		var btn := _build_item(item_name)
		add_child(btn)
		btn.mouse_entered.connect(mouse_hovered_button.emit.bind(item_name))
		btn.mouse_exited.connect(mouse_hovered_button.emit.bind(""))
		btn.pressed.connect(button_pressed.emit)
		btn.pressed.connect(DisplayServer.clipboard_set.bind(_get_copy_format_string() % [item_name, theme_type]))
		btn.set_drag_forwarding(_get_item_drag_data.bind(btn), Callable(), Callable())
		btn.name = item_name
	var max_size_x = 0
	var max_size_y = 0
	for child in get_children():
		max_size_x = max(max_size_x, child.size.x)
		max_size_y = max(max_size_y, child.size.y)
	for child in get_children():
		child.custom_minimum_size.x = max_size_x
		child.custom_minimum_size.y = max_size_y


# override
func _build_item(_item_name: String) -> Button:
	return Button.new()


# override
func _get_item_names() -> PackedStringArray:
	return PackedStringArray()


func _get_item_drag_data(_pos: Vector2, _button: Button) -> Variant:
	return null


func _get_copy_format_string() -> String:
	return "%s,%s"


func set_item_size(new_size: float) -> void:
	for child in get_children():
		child.custom_minimum_size = Vector2.ONE * new_size * EditorInterface.get_editor_scale()


func filter(text: String) -> void:
	if text:
		var matches := H.Search.FuzzySearch.search(text, item_names)
		for child in get_children():
			child.visible = child.name in matches
	else:
		for child in get_children():
			child.show()
