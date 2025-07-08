# https://github.com/Zylann/godot_editor_debugger_plugin

@tool
@icon("uid://cducmivcy7t15")
extends Control

signal node_selected(node: Node)

@onready var _popup_menu : PopupMenu = get_node("PopupMenu")
@onready var _inspection_checkbox : CheckBox = %ShowInInspectorCheckbox
@onready var _highlight_checkbox : CheckBox = %HighlightNodeCheckbox
@onready var _tree : Tree = %EditorDebuggerNodeTree

const METADATA_NODE_NAME = 0
var _control_highlighter: ColorRect = null

var connected_windows = []

func _enter_tree() -> void:
	if is_part_of_edited_scene():
		set_process(false)
		return
	_control_highlighter = ColorRect.new()
	_control_highlighter.color = Color(EditorInterface.get_editor_theme().get_color("accent_color", &"Editor"), 0.1)
	_control_highlighter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_control_highlighter.hide()
	#get_viewport().add_child.call_deferred(_control_highlighter)
	EditorInterface.get_base_control().add_child.call_deferred(_control_highlighter)
	_connect_window_signals()
	if not EditorInterface.get_resource_filesystem().filesystem_changed.is_connected(_connect_window_signals):
		EditorInterface.get_resource_filesystem().filesystem_changed.connect(_connect_window_signals, 1)

func _exit_tree() -> void:
	if _control_highlighter != null:
		_control_highlighter.queue_free()
	_disconnect_window_signals()

func _connect_window_signals():
	var base_control = EditorInterface.get_base_control()
	if not base_control.get_viewport().window_input.is_connected(_editor_input):
		base_control.get_viewport().window_input.connect(_editor_input.bind(base_control.get_window()))
	
	for child in base_control.get_children():
		if child is Window:
			if not child.window_input.is_connected(_editor_input):
				child.window_input.connect(_editor_input.bind(child))
				if not child in connected_windows:
					connected_windows.append(child)

func _disconnect_window_signals():
	var base_control = EditorInterface.get_base_control()
	if base_control.get_viewport().window_input.is_connected(_editor_input):
		base_control.get_viewport().window_input.disconnect(_editor_input)
	var disconnected_windows = []
	for window in connected_windows:
		if not is_instance_valid(window):
			disconnected_windows.append(window)
			continue
		if window.window_input.is_connected(_editor_input):
			window.window_input.disconnect(_editor_input)
			disconnected_windows.append(window)
	for window in disconnected_windows:
		connected_windows.erase(window)

func highlight_checkbox_toggled(value: bool) -> void:
	if !value:
		_control_highlighter.hide()
	else:
		_select_node()

func inspection_checkbox_toggled(value: bool) -> void:
	if !value:
		var selected_item := _tree.get_selected()
		if !selected_item: return
		var node : Node = _tree.get_item_node(selected_item)
		var inspector := EditorInterface.get_inspector()
		if node == inspector.get_edited_object():
			inspector.edit(null)
	else:
		_select_node()

func _select_node() -> void:
	var node_view := _tree.get_selected()
	if !node_view:
		return
	var node : Node = _tree.get_item_node(node_view)
	_highlight_node(node)
	if _inspection_checkbox.button_pressed:
		EditorInterface.get_inspector().edit(node)
	node_selected.emit(node)

func _on_Tree_item_selected() -> void:
	_select_node()

func _on_Tree_item_mouse_selected(_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		if get_window() != EditorInterface.get_base_control().get_window():
			_popup_menu.reparent(get_window().get_child(0))
			await get_tree().process_frame
		
		_select_node()
		_popup_menu.set_position(DisplayServer.mouse_get_position())
		_popup_menu.popup()

func _highlight_node(node: Node) -> void:
	if !_highlight_checkbox.button_pressed:
		_control_highlighter.hide()
		return
	if node is Control:
		var target_control := (node as Control)
		_control_highlighter.global_position = target_control.global_position
		_control_highlighter.size = target_control.size
		_control_highlighter.show()
	else:
		_control_highlighter.hide()

func _on_Tree_nothing_selected() -> void:
	_control_highlighter.hide()

func _editor_input(event: InputEvent, window:Window) -> void:
	_check_input(event, window)

#func _input(event: InputEvent) -> void:
	#return
	#if get_viewport() == EditorInterface.get_base_control().get_viewport():
		#return
	#_check_input(event, get_viewport())

func _check_input(event: InputEvent, window:Window):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_F12:
				pick(window)

func pick(window:Window) -> void:
	var mpos = window.get_viewport().get_mouse_position()
	var root = window
	if window != EditorInterface.get_base_control().get_window():
		print("REP")
		_control_highlighter.reparent(window)
	else:
		_control_highlighter.reparent(EditorInterface.get_base_control())
	await get_tree().process_frame
	#var root := get_tree().root
	var node := _pick(root, mpos)
	if node != null:
		print("Picked ", node, " at ", node.get_path())
		_tree.focus_node(node)
	else:
		_highlight_node(null)

func _pick(root: Node, mpos: Vector2, level := 0) -> Node:
	var node: Node = null
	
	for i in root.get_child_count(true):
		var child := root.get_child(i, true)
		
		if (child is CanvasItem and not child.visible):
			continue
		if child is Viewport:
			continue
		if child == _control_highlighter:
			continue
		
		if child is Control and child.get_global_rect().has_point(mpos):
			var c := _pick(child, mpos, level + 1)
			if c != null:
				return c
			else:
				node = child
		else:
			var c := _pick(child, mpos, level + 1)
			if c != null:
				return c
	return node

static func override_ownership(root: Node, owners: Dictionary, include_internal: bool) -> void:
	assert(root is Node)
	_override_ownership_recursive(root, root, owners, include_internal)

static func _override_ownership_recursive(
	root: Node,
	node: Node,
	owners: Dictionary, 
	include_internal: bool
) -> void:
	# Make root own all children of node.
	for child in node.get_children(include_internal):
		if child.owner != null:
			owners[child] = child.owner
		child.set_owner(root)
		_override_ownership_recursive(root, child, owners, include_internal)

static func _get_index_path(node: Node) -> Array[int]:
	var ipath: Array[int] = []
	while node.get_parent() != null:
		ipath.append(node.get_index())
		node = node.get_parent()
	ipath.reverse()
	return ipath

static func restore_ownership(
	root: Node,
	owners: Dictionary,
	include_internal: bool
) -> void:
	assert(root is Node)
	# Remove all of root's children's owners.
	# Also restore node ownership to nodes which had their owner overridden.
	for child in root.get_children(include_internal):
		if owners.has(child):
			child.owner = owners[child]
			owners.erase(child)
		else:
			child.set_owner(null)
		restore_ownership(child, owners, include_internal)

func _on_SaveBranchFileDialog_file_selected(path: String) -> void:
	var node_view := _tree.get_selected()
	# var node := _get_node_from_view(node_view)
	var node : Node = _tree.get_item_node(node_view)
	# Make the selected node own all it's children.
	var owners := {}
	override_ownership(node, owners, true)
	# Pack the selected node and it's children into a scene then save it.
	var packed_scene := PackedScene.new()
	packed_scene.pack(node)
	ResourceSaver.save(packed_scene, path)
	# Revert ownership of all children.
	restore_ownership(node, owners, true)
