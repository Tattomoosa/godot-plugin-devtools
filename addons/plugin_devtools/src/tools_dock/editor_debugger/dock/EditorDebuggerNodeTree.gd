@tool
extends BaseEditorDebuggerTree

const H := preload("uid://bn7ppltfkj17y")
const BaseEditorDebuggerTree := preload("uid://d3ux6mcugmoxt")

signal updated_entries(entries: int, time: int)
signal signal_button_pressed(node: Node)

@export var updates_per_frame := 500
@export var wait_between_updates := 2.0
const METADATA_NODE = 0

enum {
	VISIBILITY_BUTTON = 100,
	IS_EDITOR_ONLY_CLASS = 99,
	IS_CONTROL = 98,
	HAS_SCRIPT = 97,
	FROM_SCENE = 96,
	HAS_SIGNALS = 95,
	IS_INTERNAL_CHILD = 90,
}

const COLOR_GODOT_BLUE := Color("478cbf")
const COLOR_EDITOR_ONLY_INTERNAL_CHILD := Color(COLOR_GODOT_BLUE, 0.5)
const COLOR_INTERNAL_CHILD := Color(Color.WHITE, 0.5)

var all_nodes := PackedStringArray()
var search_match_highlight : Color
var updates_this_frame := 0
var updated_this_update := 0
var updated_last_update := 0
var updating := false
var filtering := false

@onready var update_progress := %UpdateProgress

var visibility_parent_list : Array[Node] = []


func _enter_tree() -> void:
	# make a list of parents, we can't hide those!
	visibility_parent_list.clear()
	var parent : Node = self
	while parent:
		visibility_parent_list.push_back(parent)
		parent = parent.get_parent()


func _ready() -> void:
	add_theme_stylebox_override(&"panel", EditorInterface.get_editor_theme().get_stylebox("Background", "EditorStyles"))
	search_match_highlight = EditorInterface.get_editor_theme().get_color("accent_color", "Editor")
	search_match_highlight.a = 0.4
	visibility_changed.connect(update)
	button_clicked.connect(_button_clicked)
	item_mouse_selected.connect(_mouse_selected)


func update(force := false) -> void:
	if is_part_of_edited_scene(): return
	if !force:
		if updating: return
		if filtering: return
		if !visible: return

	var stopwatch := H.Timing.Stopwatch.new()
	updating = true
	updated_this_update = 0
	update_progress.modulate.a = 0.2
	all_nodes.clear()

	var root := get_tree().root
	if root == null:
		clear()
		return
	var root_item := get_root()
	if root_item == null:
		root_item = _create_tree_item(root, null, false)
	await _update_branch(root, root_item)

	updating = false
	updated_last_update = updated_this_update
	update_progress.modulate.a = 0.0

	updated_entries.emit(updated_this_update, stopwatch.get_elapsed())

	await get_tree().create_timer(wait_between_updates).timeout
	update.call_deferred()


func _mouse_selected(_position: Vector2, mouse_button_index: int) -> void:
	var item := get_selected()
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		if item.collapsed:
			item.collapsed = false


func _button_clicked(item: TreeItem, _column: int, id: int, mouse_button_index: int) -> void:
	var node : Node = item.get_metadata(METADATA_NODE)
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		match id:
			VISIBILITY_BUTTON:
				node.visible = !node.visible
			HAS_SCRIPT:
				EditorInterface.select_file(node.get_script().resource_path)
			HAS_SIGNALS:
				signal_button_pressed.emit(node)
				set_selected(item, 0)


func _update_branch(root_node: Node, root_item: TreeItem) -> void:
	updates_this_frame += 1
	updated_this_update += 1
	if updates_this_frame > updates_per_frame:
		update_progress.value = inverse_lerp(0, updated_last_update, updated_this_update)
		await get_tree().process_frame
		updates_this_frame = 0

	if !root_node or !is_instance_valid(root_node):
		root_item.get_parent().remove_child(root_item)
		return

	all_nodes.push_back(root_node.name + ":" + H.Scripts.get_class_name_or_script_name(root_node))
	var child_items := root_item.get_children()

	var non_internal_children := root_node.get_children()	
	for i in root_node.get_child_count(true):
		var child := root_node.get_child(i, true)
		if !child or !is_instance_valid(child):
			continue
		var internal := child not in non_internal_children
		var child_item: TreeItem
		if i >= len(child_items):
			child_item = _create_tree_item(child, root_item, internal)
			child_items.append(child_item)
		else:
			child_item = child_items[i]
			if child_item.get_metadata(METADATA_NODE) == child:
				_update_item_lazy(child, child_item)
			else:
				_update_tree_item(child, child_item, internal)
		await _update_branch(child, child_item)
	
	# Remove excess tree items
	if root_node.get_child_count(true) < len(child_items):
		for i in range(root_node.get_child_count(true), len(child_items)):
			child_items[i].free()


func _create_tree_item(node: Node, parent_item: TreeItem, internal: bool) -> TreeItem:
	assert(node is Node)
	assert(parent_item == null or parent_item is TreeItem)
	var item := create_item(parent_item)
	item.collapsed = true
	_update_tree_item(node, item, internal)
	return item


func _update_tree_item(node: Node, item: TreeItem, internal: bool) -> void:
	assert(node is Node)
	assert(item is TreeItem)

	var c_name := H.Scripts.get_class_name_or_class(node)
	var display_text := _get_node_name_display_text(node)
	
	var editor_node := false
	if _is_internal_editor_class(c_name, node):
		editor_node = true
	item.set_icon(0, _get_icon(node))

	item.clear_buttons()
	item.set_text(0, display_text)
	item.set_tooltip_text(0, node.get_path())

	if editor_node:
		item.set_custom_color(0, Color("478cbf"))
		item.add_button(0, _theme_icon("GodotMonochrome"), IS_EDITOR_ONLY_CLASS, true, "Editor Class (Cannot be Instantiated)")
		item.set_custom_font(0, EditorInterface.get_editor_theme().get_font("italic", "EditorFonts"))
	if node.get_script():
		item.add_button(0, _theme_icon("Script"), HAS_SCRIPT, false, "Script: %s" % node.get_script().resource_path.get_file())
	if internal:
		var color := COLOR_INTERNAL_CHILD if not editor_node else COLOR_EDITOR_ONLY_INTERNAL_CHILD
		item.set_custom_color(0, color)
		item.set_icon_modulate(0, Color(Color.WHITE, 0.5))
		item.add_button(0, _theme_icon("GuiSliderGrabber"), IS_INTERNAL_CHILD, true, "Internal Child")
	var scene_path := node.scene_file_path if node.scene_file_path else (node.owner.scene_file_path if (node.owner and "scene_file_path" in node.owner) else "")
	if scene_path:
		item.add_button(0, _theme_icon("PackedScene"), FROM_SCENE, false, "Scene: %s" % scene_path.get_file())

	var signals := node.get_signal_list()
	var signal_count := 0
	for s in signals:
		var connections := node.get_signal_connection_list(s.name)
		signal_count += connections.size()
	if signal_count > 0:
		item.add_button(0, _theme_icon("Signals"), HAS_SIGNALS, false, "Signals: %d" % signal_count)

	# last
	_update_visibility_button(node, item)

	item.set_metadata(METADATA_NODE, node)


func _update_item_lazy(node: Node, item: TreeItem) -> void:
	_update_visibility_button(node, item)


func _is_internal_editor_class(c_name: String, node: Node) -> bool:
	if !ClassDB.can_instantiate(c_name) and !node.get_script():
		return true
	return false


func _update_visibility_button(node: Node, item: TreeItem) -> void:
	if "visible" not in node:
		return
	var icon_name := "GuiVisibilityVisible" if node.visible else "GuiVisibilityHidden"
	var icon := _theme_icon(icon_name)

	# does button exist? then set it
	var btn_index := item.get_button_by_id(0, VISIBILITY_BUTTON)
	if btn_index >= 0:
		item.set_button(0, btn_index, icon)
		return

	var is_parent := node in visibility_parent_list
	var tooltip := "Toggle Visibility" if !is_parent else "Cannot Toggle Visibility of Parents"
	item.add_button(0, icon, VISIBILITY_BUTTON, is_parent, tooltip)


func focus_node(node: Node) -> void:
	var parent: Node = get_tree().root
	var path := node.get_path()
	var parent_view := get_root()
	
	var node_item: TreeItem = null
	
	for i in range(1, path.get_name_count()):
		var part := path.get_name(i)
		
		var child_view := parent_view.get_first_child()
		if child_view == null:
			_update_branch(parent, parent_view)
		
		child_view = parent_view.get_first_child()
		
		while child_view != null and child_view.get_metadata(METADATA_NODE).name != part:
			child_view = child_view.get_next()
		
		if child_view == null:
			node_item = parent_view
			break
		
		node_item = child_view
		parent = parent.get_node(NodePath(part))
		parent_view = child_view
	
	if node_item != null:
		_uncollapse_to_root(node_item)
		node_item.select(0)
		ensure_cursor_is_visible()


func get_item_node(item: TreeItem) -> Node:
	return item.get_metadata(METADATA_NODE)


static func _uncollapse_to_root(node_view: TreeItem) -> void:
	var parent_view := node_view.get_parent()
	while parent_view != null:
		parent_view.collapsed = false
		parent_view = parent_view.get_parent()


func collapse_except_selected() -> void:
	var selected := get_selected()
	get_root().set_collapsed_recursive(true)
	if selected:
		selected.uncollapse_tree()
		set_selected(selected, 0)


func _reset_tree_visibility(root: TreeItem = null) -> void:
	if !root:
		root = get_root()
	for item in root.get_children():
		item.visible = true
		item.set_custom_bg_color(0, Color.TRANSPARENT)
		_reset_tree_visibility(item)


func filter(text: String, root : TreeItem = null, data := PackedStringArray([""])) -> void:
	if !text:
		_reset_tree_visibility()
		collapse_except_selected()
		return
	if !root:
		root = get_root()
	for item in root.get_children():
		var item_text := item.get_text(0)
		data[0] = item_text
		var item_matches := false
		if false: # TODO allow selecting fuzzy search option
			var matches := H.Search.FuzzySearch.search(text, data)
			item_matches = item_text in matches
		else:
			item_matches = text.to_lower() in item_text.to_lower()
		if item_matches:
			item.visible = true
			item.set_custom_bg_color(0, search_match_highlight, true)
			item.uncollapse_tree()
			var parent := item.get_parent()
			while parent:
				parent.visible = true
				parent = parent.get_parent()
			continue
		item.visible = false
		item.set_custom_bg_color(0, Color.TRANSPARENT)
		filter(text, item, data)
