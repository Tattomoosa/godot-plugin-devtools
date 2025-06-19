@tool
extends OptionButton

signal hint_selected(hint: int)

const H := preload("uid://bn7ppltfkj17y")
const HINT_STRINGS := H.PropertyInfo.PROPERTY_HINT_STRINGS
const HINT_MAP := H.PropertyInfo.HINT_MAP

var selected_id := 0

@export var type : Variant.Type = TYPE_NIL

func _ready() -> void:
	_update()
	item_selected.connect(_item_selected)

func set_type(p_type: int) -> void:
	type = p_type as Variant.Type
	_update()

func _update() -> void:
	clear()
	for hint_index in HINT_MAP[type]:
		add_item("%s (%d)" % [HINT_STRINGS[hint_index], hint_index], hint_index)
	if selected_id not in HINT_MAP[type]:
		select(PROPERTY_HINT_NONE)
	_item_selected(selected_id)

func _item_selected(index: int) -> void:
	selected_id = index
	var hint := get_item_id(index)
	hint_selected.emit(hint)
