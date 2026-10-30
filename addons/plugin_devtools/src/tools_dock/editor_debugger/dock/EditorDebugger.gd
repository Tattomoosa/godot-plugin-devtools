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
var _window_manager: WindowManager


func _ready() -> void:
	if is_part_of_edited_scene():
		set_process(false)
		return
	
	_window_manager = WindowManager.new()
	_window_manager.set_combined_input_callable(_combined_input)
	add_child(_window_manager)
	
	_ensure_control_highlighter.call_deferred(self)


func _exit_tree() -> void:
	if is_instance_valid(_control_highlighter):
		_control_highlighter.queue_free()
	if is_instance_valid(_window_manager): # called everytime exiting tree, including re-docking.
		_window_manager.disconnect_windows()


func highlight_checkbox_toggled(value: bool) -> void:
	if !value:
		_hide_control_highlighter()
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
		_select_node()
		_popup_menu.set_position(DisplayServer.mouse_get_position()) # gives proper position across windows
		_popup_menu.popup()

func _highlight_node(node: Node) -> void:
	
	if !_highlight_checkbox.button_pressed:
		_hide_control_highlighter()
		return
	
	_ensure_control_highlighter(node)
	if node is Control:
		var target_control := (node as Control)
		_control_highlighter.global_position = target_control.global_position
		_control_highlighter.size = target_control.size
		_control_highlighter.show()
	else:
		_hide_control_highlighter()

func _on_Tree_nothing_selected() -> void:
	_hide_control_highlighter()

# combined input receives the window to operate on
func _combined_input(event:InputEvent, window:Window) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F12:
			pick(window.get_mouse_position(), window)

func pick(mpos: Vector2, window:Window) -> void:
	var root := window
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


func _ensure_control_highlighter(target_node:Node) -> void:
	if not is_instance_valid(_control_highlighter):
		_control_highlighter = ColorRect.new()
		_control_highlighter.color = Color(EditorInterface.get_editor_theme().get_color("accent_color", &"Editor"), 0.1)
		_control_highlighter.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_control_highlighter.hide()
	
	if not is_instance_valid(target_node):
		return
	if _control_highlighter.get_window() != target_node.get_window():
		if is_instance_valid(_control_highlighter.get_parent()):
			_control_highlighter.reparent(target_node.get_viewport())
		else:
			target_node.get_viewport().add_child(_control_highlighter)


func _hide_control_highlighter() -> void:
	if is_instance_valid(_control_highlighter):
		_control_highlighter.hide()


class WindowManager extends Node:
	
	var _timer:Timer
	
	var _connected_windows:Array = []
	var _combined_input_callable:Callable
	
	
	func set_combined_input_callable(callable:Callable) -> void:
		_combined_input_callable = callable
	
	
	func _ready() -> void:
		connect_window_signals()
		
		_timer = Timer.new()
		_timer.autostart = true
		_timer.wait_time = 2.0
		_timer.timeout.connect(connect_window_signals)
		add_child(_timer)
	
	
	func connect_window_signals() -> void:
		_connected_windows.clear()
		
		for i in DisplayServer.get_window_list():
			var window = instance_from_id(DisplayServer.window_get_attached_instance_id(i))
			if not window.window_input.is_connected(_combined_input_callable):
				window.window_input.connect(_combined_input_callable.bind(window))
			_connected_windows.append(window)
	
	
	func disconnect_windows() -> void:
		for window in _connected_windows:
			if not is_instance_valid(window):
				continue
			if window.window_input.is_connected(_combined_input_callable):
				window.window_input.disconnect(_combined_input_callable)
		
		_connected_windows.clear()
