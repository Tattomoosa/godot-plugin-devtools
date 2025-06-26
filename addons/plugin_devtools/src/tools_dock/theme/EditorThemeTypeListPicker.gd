@tool
extends OptionButton

signal type_selected(type_name: String)

enum Type {
	ICON,
	STYLE_BOX,
	COLOR,
	FONT,
	CONSTANT,
}
@export var type : Type
var type_list : PackedStringArray


func _ready() -> void:
	var initial_selection = selected
	_populate()
	item_selected.connect(_type_selected)
	selected = initial_selection
	_type_selected(selected)


func _populate() -> void:
	clear()
	var t := EditorInterface.get_editor_theme()
	match type:
		Type.ICON:
			type_list = t.get_icon_type_list()
		Type.STYLE_BOX:
			type_list = t.get_stylebox_type_list()
		Type.COLOR:
			type_list = t.get_color_type_list()
		Type.FONT:
			type_list = t.get_font_type_list()
		Type.CONSTANT:
			type_list = t.get_constant_type_list()
	for option in type_list:
		add_item(option)


func _type_selected(which: int) -> void:
	type_selected.emit(type_list[which])


func _validate_property(property: Dictionary) -> void:
	if property.name.begins_with("popup/item"):
		property.usage = PROPERTY_USAGE_NO_INSTANCE_STATE
