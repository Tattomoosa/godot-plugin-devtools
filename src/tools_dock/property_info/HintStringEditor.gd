@tool
extends VBoxContainer

const H := preload("uid://bn7ppltfkj17y")

signal hint_string_constructed(h_string: String)

const VariantOptionButton := preload("uid://yavv35xcxv1h")
const HintOptionButton := preload("uid://bmbvnu24fet4c")

@export var type : Variant.Type:
	set(v):
		type = v
		if !is_node_ready(): return
		_update_hint()

@export var hint : int:
	set(v):
		hint = v
		if !is_node_ready(): return
		_update_hint()

func set_type(value: int) -> void:
	type = value as Variant.Type

func set_hint(value: int) -> void:
	hint = value


func _ready() -> void:
	_update_hint()


func _update_hint() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var builder := HintStringBuilder.new(type, hint)
	add_child(builder)

	builder.part_changed.connect(_hint_string_constructed.bind(builder))
	hint_string_constructed.emit(builder.get_string_value())


func _hint_string_constructed(builder: HintStringBuilder) -> void:
	hint_string_constructed.emit(builder.get_string_value())


class CollectionHintStringCombiner extends HintStringPartCombiner:
	var _type_editor := VariantTypeHintStringPartEditor.new("type", false)
	var _hint_editor := HintHintStringPartEditor.new()
	var _hint_string_editor : HintStringBuilder

	func _init() -> void:
		super([_type_editor, _hint_editor], "/")
		vertical = true
		_type_editor.part_changed.connect(_update_hint)
		_hint_editor.part_changed.connect(_update)
		part_changed.emit()
		# await get_tree().process_frame
	
	func _ready() -> void:
		_hint_editor._label.custom_minimum_size.x = _type_editor._label.size.x

	func _update_hint() -> void:
		_hint_editor.set_type(_type_editor.get_type())
		_update()

	func _update() -> void:
		# _hint_editor.set_type(_type_editor.get_type())
		if _hint_string_editor:
			remove_child(_hint_string_editor)
			_hint_string_editor.queue_free()

		# indent
		var hbox := HBoxContainer.new()
		var spacer := Control.new()
		spacer.custom_minimum_size.x = _hint_editor._label.size.x / 4.0
		hbox.add_child(spacer)
		add_child(hbox)
		# spacer.add_child(_hint_string_editor)

		_hint_string_editor = HintStringBuilder.new(_type_editor.get_type(), _hint_editor.get_hint())
		_hint_string_editor.part_changed.connect(part_changed.emit)
		hbox.add_child(_hint_string_editor)
		part_changed.emit()
	
	func get_string_value() -> String:
		var h_str := "%d" % _type_editor.get_type()
		# var hint := _hint_editor.get_hint()
		# if hint:
		h_str += "/%d:" % _hint_editor.get_hint()
		if _hint_string_editor:
			var hint_str := _hint_string_editor.get_string_value()
			if hint_str:
				h_str += "%s" % hint_str
		return h_str


class HintHintStringPartEditor extends HintStringPartEditor:
	var hint_option := HintOptionButton.new()

	func _init() -> void:
		super("hint", false)
		hint_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(hint_option)
		hint_option.item_selected.connect(part_changed.emit.unbind(1))
	
	func set_type(type: int) -> void:
		hint_option.set_type(type)
	
	func get_hint() -> int:
		return hint_option.get_selected_id()
	
	func get_string_value() -> String:
		return str(hint_option.get_selected_id())


class HintStringBuilder extends HintStringPartCombiner:

	func _init(type: Variant.Type, hint: int, separator := ",") -> void:
		match hint:
			PROPERTY_HINT_NONE:
				if type == TYPE_ARRAY:
					_add_row([VariantTypeHintStringPartEditor.new()])
				elif type not in [TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_COLOR]:
					_add_row([StringHintStringPartEditor.new("", false)])
			PROPERTY_HINT_FLAGS, PROPERTY_HINT_ENUM, PROPERTY_HINT_ENUM_SUGGESTION:
					_add_row([StringHintStringPartEditor.new("", false)])
			PROPERTY_HINT_EXP_EASING:
				_add_row([
					BoolHintStringPartEditor.new("attenuation"),
					BoolHintStringPartEditor.new("positive_only"),
				])
			PROPERTY_HINT_LINK: pass
			PROPERTY_HINT_RANGE:
				if type == TYPE_FLOAT:
					_add_row([FloatHintStringPartEditor.new("min", 0, false), FloatHintStringPartEditor.new("max", 100, false), FloatHintStringPartEditor.new("step", 0.1, false)])
					_add_row([BoolHintStringPartEditor.new("or_greater"), BoolHintStringPartEditor.new("or_less")])
				if type == TYPE_INT:
					_add_row([IntHintStringPartEditor.new("min", 0, false), IntHintStringPartEditor.new("max", 100, false), IntHintStringPartEditor.new("step", 1, false)])
					_add_row([BoolHintStringPartEditor.new("or_greater"), BoolHintStringPartEditor.new("or_less")])
			# PROPERTY_HINT_FLAGS:
			# PROPERTY_HINT_LAYERS_*: pass
			PROPERTY_HINT_FILE, PROPERTY_HINT_GLOBAL_FILE, PROPERTY_HINT_SAVE_FILE:
				_add_row([StringHintStringPartEditor.new("file_extensions", false)])
			PROPERTY_HINT_DIR:
				pass
			PROPERTY_HINT_ARRAY_TYPE:
				_add_row([VariantTypeHintStringPartEditor.new()])
			# PROPERTY_HINT_LAYERS_*: pass
			PROPERTY_HINT_DICTIONARY_TYPE:
				_add_row(
					[
						HintStringPartCombiner.new([
							VariantTypeHintStringPartEditor.new("Key"),
							VariantTypeHintStringPartEditor.new("Value")
						],
						";",
						true)
					]
				)
			PROPERTY_HINT_RESOURCE_TYPE:
				_add_row([ClassHintStringPartEditor.new("type", "Resource")])
			PROPERTY_HINT_NODE_TYPE:
				_add_row([ClassHintStringPartEditor.new("type", "Node")])
			PROPERTY_HINT_TYPE_STRING:
				if type == TYPE_STRING:
					_add_row([VariantTypeHintStringPartEditor.new()])
				elif type == TYPE_ARRAY:
					_add_row([CollectionHintStringCombiner.new()])
				elif type == TYPE_DICTIONARY:
					_add_row([DictionaryStringTypePartCombiner.new()])

		if type in [TYPE_INT, TYPE_FLOAT, TYPE_VECTOR2, TYPE_VECTOR2I, TYPE_VECTOR3, TYPE_VECTOR3I, TYPE_VECTOR4, TYPE_VECTOR4I, TYPE_QUATERNION, TYPE_RECT2, TYPE_RECT2I, TYPE_PROJECTION, TYPE_TRANSFORM2D, TYPE_TRANSFORM3D]:
				match hint:
					PROPERTY_HINT_NONE, PROPERTY_HINT_RANGE, PROPERTY_HINT_LINK:
						_add_row([StringHintStringPartEditor.new("suffix")])
		if type == TYPE_FLOAT:
			_add_row([
				BoolHintStringPartEditor.new("radians_as_degrees")
			])
		
		if _editors.is_empty():
			var label := Label.new()
			label.text = "No options available."
			label.modulate = Color(Color.WHITE, 0.4)
			add_child(label)
		else:
			super(_editors, separator, true)
			# for e in _editors:
			# 	add_child(e)
			# 	e.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			# 	e.part_changed.connect(part_changed.emit)
		
	# func get_string_value() -> String:
	# 	return super()

	func _add_row(editors: Array[HintStringPartEditor], separator := ",") -> void:
		var combiner := HintStringPartCombiner.new(editors, separator)
		_editors.push_back(combiner)

class DictionaryStringTypePartCombiner extends HintStringPartCombiner:
	func _init() -> void:
		super([
			CollectionHintStringCombiner.new(),
			CollectionHintStringCombiner.new(),
		], ";", true)
		var key_label := Label.new()
		key_label.text = "Key"
		add_child(key_label)
		move_child(key_label, 0)
		var value_label := Label.new()
		value_label.text = "Value"
		add_child(value_label)
		move_child(value_label, 2)
	
	func get_string_value() -> String:
		return super()

class HintStringPartCombiner extends HintStringPartEditor:
	var _editors : Array[HintStringPartEditor]
	var _separator : String

	func _init(editors: Array[HintStringPartEditor], separator := ",", p_vertical := false) -> void:
		vertical = p_vertical
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_separator = separator
		_editors = editors
		for e in _editors:
			add_child(e)
			e.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			e.part_changed.connect(part_changed.emit)
	
	func _ready() -> void:
		var label_max := 0
		if vertical:
			for e in _editors:
				if e._label:
					label_max = max(e._label.size.x, label_max)
			for e in _editors:
				if e._label:
					e._label.custom_minimum_size.x = label_max
		
	func get_string_value() -> String:
		var h_string_parts := PackedStringArray()

		for e in _editors:
			var value := e.get_string_value()
			if value != "":
				h_string_parts.push_back(value)

		var hint_string := ""
		if !h_string_parts.is_empty():
			hint_string = _separator.join(h_string_parts)
		return hint_string


class AddButton extends Button:
	func _init() -> void:
		icon = EditorInterface.get_inspector().get_theme_icon("Add", "EditorIcons")


class RemoveButton extends Button:
	func _init(watching: Node) -> void:
		icon = EditorInterface.get_inspector().get_theme_icon("Close", "EditorIcons")
		watching.child_entered_tree.connect(_update_disable.bind(watching).unbind(1))
		watching.child_exiting_tree.connect(_update_disable.bind(watching).unbind(1))
		_update_disable(watching)
	
	func _update_disable(watching: Node) -> void:
		await watching.get_tree().process_frame
		disabled = watching.get_child_count() == 1


class StringHintStringPartEditor extends HintStringPartEditor:
	var line_edit := LineEdit.new()
	func _init(label_text: String, use_label := true) -> void:
		super(label_text, use_label)
		add_child(line_edit)
		line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line_edit.text_changed.connect(part_changed.emit.unbind(1))
	
	func clone() -> HintStringPartEditor:
		return StringHintStringPartEditor.new(_label_text, _use_label)

	func _get_string_value() -> String:
		return line_edit.text


class VariantTypeHintStringPartEditor extends HintStringPartEditor:
	var variant_option := VariantOptionButton.new()
	var object_option : OptionButton
	var label_column := VBoxContainer.new()
	var editor_column := VBoxContainer.new()
	var object_label := Label.new()
	var object_row := HBoxContainer.new()
	var object_type_option := ClassHintStringPartEditor.new()
	var _use_object_selector := true

	func _init(label := "type", use_object_selector := true) -> void:
		super(label, false)
		_use_object_selector = use_object_selector
		_label.reparent(label_column)
		object_label.text = "Object"
		label_column.add_child(object_label)
		add_child(label_column)
		add_child(editor_column)
		editor_column.add_child(variant_option)
		editor_column.add_child(object_row)
		editor_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		variant_option.item_selected.connect(part_changed.emit.unbind(1))
		variant_option.item_selected.connect(_update.unbind(1))
		variant_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		_create_object_option()
		object_row.hide()
		object_label.hide()
	
	func _create_object_option() -> void:
		object_option = OptionButton.new()
		object_option.add_icon_item(
			EditorInterface.get_inspector().get_theme_icon("Object", "EditorIcons"),
			"Resource"
		)
		object_option.add_icon_item(
			EditorInterface.get_inspector().get_theme_icon("Node", "EditorIcons"),
			"Node"
		)
		object_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		object_option.item_selected.connect(_object_option_selected)
		object_row.add_child(object_option)
		object_row.add_child(object_type_option)

		object_type_option.part_changed.connect(part_changed.emit)
	
	func _object_option_selected(i: int) -> void:
		if i == 0:
			object_type_option.set_base_type("Resource")
		else:
			object_type_option.set_base_type("Node")
	
	func clone() -> HintStringPartEditor:
		return VariantTypeHintStringPartEditor.new()
	
	func get_type() -> Variant.Type:
		return variant_option.selected as Variant.Type
	
	func _update() -> void:
		if variant_option.selected == TYPE_OBJECT and _use_object_selector:
			object_row.show()
			object_label.show()
		else:
			object_row.hide()
			object_label.hide()

	func _get_string_value() -> String:
		if variant_option.selected == TYPE_OBJECT:
			return object_type_option._get_string_value()
		return "%s" % type_string(variant_option.selected)


class ClassHintStringPartEditor extends HintStringPartEditor:
	var btn := Button.new()
	var _value : StringName = &""
	var _base_type : String

	func _init(label_text: String = "", base_type := "Resource", use_label := false) -> void:
		super(label_text, use_label)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		set_base_type(base_type)
		add_child(btn)
		_value = base_type
		btn.pressed.connect(_create_dialog)
	
	func set_base_type(base_type: String) -> void:
		_base_type = base_type
		btn.text = "Select %s Type" % base_type
	
	func _create_dialog() -> void:
		EditorInterface.popup_create_dialog(
			_on_create_closed,
			_base_type,
			"",
			"Pick %s Type" % _base_type,
			[],
		)
	
	func _on_create_closed(type_name: StringName) -> void:
		_value = type_name
		btn.text = type_name
		btn.icon = H.Editor.IconGrabber.get_class_icon(type_name)
		part_changed.emit()
	
	func _get_string_value() -> String:
		return _value


class FloatHintStringPartEditor extends HintStringPartEditor:
	var _initial_value := 0
	var spinbox := SpinBox.new()
	func _init(p_label_text: String, value := 0.0, use_label := true) -> void:
		super(p_label_text, use_label)
		_initial_value = int(value)
		add_child(spinbox)
		spinbox.value = value
		spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		spinbox.value_changed.connect(part_changed.emit.unbind(1))
	
	func clone() -> HintStringPartEditor:
		return FloatHintStringPartEditor.new(_label_text, _initial_value)

	func _get_string_value() -> String:
		return "%.2f" % spinbox.value


class IntHintStringPartEditor extends FloatHintStringPartEditor:
	func _init(p_label_text: String, value := 0.0, use_label := true) -> void:
		super(p_label_text, value, use_label)
		spinbox.rounded = true

	func clone() -> HintStringPartEditor:
		return IntHintStringPartEditor.new(_label_text, _initial_value, _use_label)

	func _get_string_value() -> String:
		return "%d" % spinbox.value


class BoolHintStringPartEditor extends HintStringPartEditor:
	var checkbox := CheckBox.new()

	func _init(p_label_text: String) -> void:
		super(p_label_text, false)
		checkbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(checkbox)
		checkbox.toggled.connect(part_changed.emit.unbind(1))
	
	func clone() -> HintStringPartEditor:
		return BoolHintStringPartEditor.new(_label_text)

	func _get_string_value() -> String:
		if checkbox.button_pressed:
			return _label_text.to_lower()
		return ""


class HintStringPartEditor extends BoxContainer:
	@warning_ignore("unused_signal")
	signal part_changed
	var _label_text : String
	var _use_label := true

	var _label : Label

	func _init(label_text: String, use_label := true) -> void:
		_label_text = label_text
		if _label_text:
			_label = Label.new()
			_label.text = label_text.capitalize()
			add_child(_label)
		_use_label = use_label
	
	func _get_string_value() -> String:
		return ""
	
	func clone() -> HintStringPartEditor:
		return HintStringPartEditor.new(_label_text, _use_label)
	
	func get_string_value() -> String:
		var val := _get_string_value()
		if !val:
			return ""
		if _use_label:
			return "%s:%s" % [_label_text, _get_string_value()]
		else:
			return _get_string_value()
		
