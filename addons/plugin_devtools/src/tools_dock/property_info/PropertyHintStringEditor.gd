@tool
extends Container
# scene property_hint_string_editor

signal hint_string_constructed(h_string: String)

@onready var line_edit := %HintStringLineEdit
@onready var no_editor := %NoEditor
@onready var range_editor := %RangeEditor
@onready var exp_easing := %ExpEasingEditor

@export var type : Variant.Type:
	set(v):
		type = v
		if !is_node_ready():
			return
		_update_type()
		_update_hint()
@export var hint : int:
	set(v):
		hint = v
		if !is_node_ready():
			return
		_update_hint()

var hint_string : String
# TODO i think float, int, vec2 etc can always take "suffix:" at least
var type_hint_string : String

func _ready() -> void:
	_update_type()
	_update_hint()

func set_hint(p_hint: int) -> void:
	hint = p_hint

func on_hint_string_changed(p_hint_string: String) -> void:
	hint_string = p_hint_string
	var emitted_string := hint_string
	if type_hint_string != "":
		emitted_string += "," + type_hint_string
	hint_string_constructed.emit(emitted_string)

func _update_type() -> void:
	hint_string = ""
	line_edit.text = ""
	on_hint_string_changed("")
	pass

func _update_hint() -> void:
	hint_string = ""
	line_edit.text = ""
	on_hint_string_changed("")
	if hint in [
			PROPERTY_HINT_LINK,
			PROPERTY_HINT_FLAGS,
			PROPERTY_HINT_LAYERS_2D_RENDER,
			PROPERTY_HINT_LAYERS_2D_PHYSICS,
			PROPERTY_HINT_LAYERS_2D_NAVIGATION,
			PROPERTY_HINT_LAYERS_3D_RENDER,
			PROPERTY_HINT_LAYERS_3D_PHYSICS,
			PROPERTY_HINT_LAYERS_3D_NAVIGATION,
			PROPERTY_HINT_COLOR_NO_ALPHA,
			PROPERTY_HINT_OBJECT_ID,
			PROPERTY_HINT_INT_IS_OBJECTID,
			PROPERTY_HINT_INT_IS_POINTER,
			PROPERTY_HINT_LOCALE_ID,
			PROPERTY_HINT_LOCALIZABLE_STRING,
			PROPERTY_HINT_HIDE_QUATERNION_EDIT,
			PROPERTY_HINT_PASSWORD,
			PROPERTY_HINT_LAYERS_AVOIDANCE,
			PROPERTY_HINT_ONESHOT]:
		no_editor.show()
		# hide line edit if im sure there's no options for it, otherwise useful for debug
		# line_edit.hide()
		return
	line_edit.show()
	match hint:
		PROPERTY_HINT_RANGE:
			range_editor.show()
		PROPERTY_HINT_EXP_EASING:
			exp_easing.show()
		PROPERTY_HINT_MULTILINE_TEXT, _:
			no_editor.show()
