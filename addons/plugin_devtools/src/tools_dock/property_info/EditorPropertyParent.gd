@tool
extends Container

signal property_updated(property: Dictionary)

const H := preload("uid://bn7ppltfkj17y")

var fake_object := FakeResource.new()
var type : Variant.Type = TYPE_STRING
var hint : int = PROPERTY_USAGE_NONE
var hint_string : String = ""
var usage : int = PROPERTY_USAGE_DEFAULT
var ep : EditorProperty

func _ready() -> void:
	_update()

func set_type(p_type: int) -> void:
	type = p_type as Variant.Type
	_update()

func set_hint(p_hint: int) -> void:
	hint = p_hint
	_update()

func set_hint_string(p_hint_string: String) -> void:
	hint_string = p_hint_string
	_update()

func set_usage(p_usage: int) -> void:
	usage = p_usage
	_update()

func _update() -> void:
	if is_part_of_edited_scene():
		return
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var props := {
		"name": "property",
		"type": type,
		"hint": hint,
		"hint_string": hint_string,
		"usage": usage,
	}
	if typeof(fake_object.property) != type:
		fake_object.property = type_convert(null, type)
	ep = H.PropertyInfo.instantiate_custom_property_editor(fake_object, props)
	ep.property_changed.connect(_property_changed)
	ep.set_object_and_property(fake_object, "property")
	ep.label = "Property"
	ep.update_property()
	add_child(ep)
	property_updated.emit(props)

func _property_changed(_property: StringName, value: Variant, _field: StringName, _changing: bool) -> void:
	fake_object.property = value
	ep.update_property()

class FakeResource:
	var property : Variant = null