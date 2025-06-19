@tool
extends TabContainer

var tab_bar : TabBar

signal set_buttons_disabled(value: bool)

func _ready() -> void:
	tab_bar = get_tab_bar()
	tab_bar.tab_close_display_policy = TabBar.CLOSE_BUTTON_SHOW_ALWAYS
	tab_bar.set_tab_hidden(0, true)
	tab_bar.close_with_middle_mouse = true
	tab_bar.tab_close_pressed.connect(_close_tab)
	child_entered_tree.connect(_child_entered)
	child_exiting_tree.connect(_child_exiting)

func reload() -> void:
	var node := get_child(current_tab)
	var data : Variant = get_tab_metadata(current_tab)
	if data is Node:
		var new_node = data.duplicate()
		var idx := current_tab
		remove_child(node)
		add_child(new_node, true)
		move_child(new_node, idx)
		current_tab = idx
		set_tab_metadata(current_tab, data)
		node.queue_free()
	elif data is PackedScene:
		pass
	else:
		push_error("Can't reload %s" % data)

func _child_entered(_node: Node) -> void:
	if get_child_count() > 1:
		set_buttons_disabled.emit(false)
	await get_tree().process_frame
	if get_child_count() > 1 and current_tab == 0: 
		current_tab = 1

func _child_exiting(node: Node) -> void:
	await node.tree_exited
	if get_child_count() == 1:
		get_child(0).visible = true
		set_buttons_disabled.emit(true)

func _close_tab(idx: int) -> void:
	if idx == 0:
		push_error("Tab 0 cannot be closed!")
		return
	# hmm
	if idx > 1:
		current_tab = get_previous_tab()
	else:
		current_tab = 0
	get_child(idx).queue_free()

func _add_node(node: Node) -> void:
	add_child(node)
	if !node.visible:
		node.visible = true

func _dropped_data(data: Variant) -> void:
	if data is Dictionary and "type" in data:
		if data.type == "nodes":
			var node_paths := data.nodes as Array # NodePath[]
			var original_node := get_node(node_paths[0])
			var node := original_node.duplicate()
			_add_node(node)
			tab_bar.set_tab_metadata(node.get_index(), original_node)
		if data.type == "files":
			var paths : Array = data.files # String[]
			if paths.size() > 1:
				push_error("Can only drop a single scene file")
			var path : String = paths[0]
			if path.get_extension() not in ["tscn", "scn"]:
				push_error("Can only drop scene files!")
			var control_classes := PackedStringArray(["Control"])
			control_classes.append_array(ClassDB.get_inheriters_from_class(&"Control"))
			var scene_file : PackedScene = load(path)
			if scene_file.get_state().get_node_type(0) not in control_classes:
				push_error("Root node must be Control!")
			var node := scene_file.instantiate()
			_add_node(node)