@tool
extends BaseEditorDebuggerTree

const BaseEditorDebuggerTree := preload("uid://d3ux6mcugmoxt")
const EditorDebuggerNodeTree := preload("uid://bh0onqu0jxa01")
const SCENE_TREE_ICON := preload("uid://cqeo30bsy7hen")
const REF_COUNTED_ICON := preload("uid://bj6lxwqsm1ci7")

@onready var _debugger_tree : EditorDebuggerNodeTree = %EditorDebuggerNodeTree
var _connected_fired_signals : Array[Signal] = []


func _ready() -> void:
	super()
	item_mouse_selected.connect(_mouse_select)
	get_parent().hide()


func _mouse_select(_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		var item := get_selected()
		if item.collapsed:
			item.collapsed = false
		var meta : Variant = item.get_metadata(0)
		prints(meta, type_string(typeof(meta)))
		if meta is Signal:
			return
		if meta is Callable:
			var c := meta as Callable
			var object := c.get_object()
			if object is Node:
				_debugger_tree.focus_node(object)


func update() -> void:
	_disconnect_watcher_signals()
	if !is_visible_in_tree():
		return
	clear()
	var debugger_item := _debugger_tree.get_selected()
	if !debugger_item:
		return
	var root := create_item()
	var node : Node = debugger_item.get_metadata(0)
	if is_instance_valid(root):
		root.set_icon(0, _get_icon(node))
		root.set_text(0, node.name)

	var object_signals := _get_object_defining_signals(node)
	for object_signal_info in object_signals:
		_build_object_signal_list_item(root, node, object_signal_info)


func _build_object_signal_list_item(parent: TreeItem, node: Node, object_signal_info: Dictionary) -> void:
	var c_name : String = object_signal_info["class"]
	var os_info : Array[Dictionary] = object_signal_info["signals"]
	var obj_item := create_item(parent)
	obj_item.set_icon(0, _get_icon_class_name(c_name))
	obj_item.set_text(0, c_name)
	os_info.sort_custom(func(a, b): return a.name < b.name)
	for s_info in os_info:
		_build_signal_item(obj_item, node, s_info)
	_collapse_objects_with_no_connections(obj_item)


func _collapse_objects_with_no_connections(obj_item: TreeItem) -> void:
		var has_a_connection := false
		for s_item in obj_item.get_children():
			if s_item.get_child_count() > 0:
				has_a_connection = true
				break
		if !has_a_connection:
			obj_item.collapsed = true


func _disconnect_watcher_signals() -> void:
	for _s in _connected_fired_signals:
		_s.disconnect(_on_fired)
	_connected_fired_signals.clear()


func _get_object_defining_signals(obj: Object) -> Array[Dictionary]:
	var sigs : Array[Dictionary]
	var script : Script = obj.get_script()
	if script:
		var global_name : String = script.get_global_name()
		sigs.push_back({
			"class": global_name if global_name else script.resource_path.get_file(),
			"signals": obj.get_signal_list()
		})
	var c_name := obj.get_class()
	var c_names := PackedStringArray([])
	while c_name:
		c_names.push_back(c_name)
		c_name = ClassDB.get_parent_class(c_name)
	for c in c_names:
		var signals := ClassDB.class_get_signal_list(c, true)
		if !signals.is_empty():
			sigs.push_back({
				"class": c,
				"signals": signals,
			})
		if script:
			for s in signals:
				var script_sigs : Array[Dictionary] = sigs[0]["signals"]
				var to_remove : Array[Dictionary] = []
				for ss in script_sigs:
					if s.name == ss.name:
						to_remove.push_back(ss)
				for ss in to_remove:
					script_sigs.erase(ss)
	return sigs


func _build_signal_item(parent: TreeItem, node: Node, signal_info: Dictionary) -> void:
	var connections := node.get_signal_connection_list(signal_info.name)
	var s : Signal = node.get(signal_info.name) 
	var signal_item := create_item(parent)
	signal_item.set_text(0, _signal_display_name(s, signal_info))
	signal_item.set_icon(0, _theme_icon("Signal"))
	signal_item.set_metadata(0, s)
	if connections.is_empty():
		signal_item.set_custom_color(0, Color(Color.WHITE, 0.5))
		signal_item.set_icon_modulate(0, Color(Color.WHITE, 0.5))
	else:
		s.connect(_on_fired.bind(signal_item))
		_connected_fired_signals.append(s)
		for c in connections:
			_build_callable_item(signal_item, c.callable)


func _build_callable_item(parent: TreeItem, callable: Callable) -> void:
	var item := create_item(parent)
	var c_object : Object = callable.get_object()
	item.collapsed = true
	item.set_metadata(0, callable)

	if c_object is Node:
		var c_node : Node = c_object
		var c_display := "%s :: %s" % [ _get_node_name_display_text(c_object), callable.get_method() ]
		item.set_text(0, c_display)
		item.set_icon(0, _get_icon(c_node))
	else:
		var c_display := "%s :: %s" % [c_object.get_class(), callable.get_method() ]
		item.set_text(0, c_display)

		if c_object is SceneTree: item.set_icon(0, SCENE_TREE_ICON)
		elif c_object is ThemeDB: item.set_icon(0, _theme_icon("Theme"))
		elif c_object is RefCounted: item.set_icon(0, REF_COUNTED_ICON)
		elif c_object is Object: item.set_icon(0, _theme_icon("Object"))
		else: item.set_text(0, "UNKNOWN: %s" + c_object.get_class())


func _signal_display_name(s: Signal, s_info: Dictionary) -> String:
	var text := s.get_name()
	text += "("
	var display_args := PackedStringArray()
	for arg in s_info.args:
		var t : String = arg.name
		t += ": %s" % (arg["class_name"] if arg.get("class_name", "") else type_string(arg["type"]))
		display_args.push_back(t)
	text += ", ".join(display_args)
	text += ")"
	return text


func _on_signal_button_pressed() -> void:
	get_parent().show()
	update()


# lol - so we can't know how many arguments a signal will have, we just want to get the corresponding tree item when its fired to highlight it
func _on_fired(_0 = null, _1 = null, _2 = null, _3 = null, _4 = null, _5 = null, _6 = null, _7 = null, _8 = null, _9 = null, _10 = null) -> void:
	if !is_inside_tree():
		return
	var item : TreeItem
	for arg in [_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10]:
		if !is_instance_valid(arg):
			continue
		if arg is TreeItem and arg.get_tree() == self:
			item = arg
			break
	if !is_instance_valid(item):
		return
	item.set_custom_bg_color(0, Color.RED)
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(item):
		item.clear_custom_bg_color(0)
