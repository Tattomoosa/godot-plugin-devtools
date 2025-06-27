## Override if scene root is not going to be the last child of root, such as when using a
## scene manager or placing the played scene in a subviewport.
## `is_scene_root` respects this value
static var scene_root : Node = null


## Gets the first child of the specified type
static func get_first_child_with_type(node: Node, type: Variant, include_internal := false) -> Node:
	for child in node.get_children(include_internal):
		if is_instance_of(child, type):
			return child
	return null


## Gets the first ancestor (parent, grandparent, etc) of the specified type
static func get_first_ancestor_with_type(node: Node, type: Variant) -> Node:
	var parent := node.get_parent()
	while parent:
		if is_instance_of(parent, type):
			return parent
		parent = parent.get_parent()
	return null


## Gets all children with a specified type
static func get_children_with_type(node: Node, type: Variant, include_internal := false) -> Array[Node]:
	var type_children : Array[Node] = []
	for child in node.get_children(include_internal):
		if is_instance_of(child, type):
			type_children.push_back(child)
	return type_children


## Calls `queue_free()` on all children
static func queue_free_children(node: Node, include_internal := false) -> void:
	for child in node.get_children(include_internal):
		child.queue_free()


## Gets the node's next sibling
static func get_next_sibling(node: Node) -> Node:
	var index := node.get_index()
	return node.get_parent().get_child(index + 1)


## Gets the node's previous sibling
static func get_previous_sibling(node: Node) -> Node:
	var index := node.get_index()
	return node.get_parent().get_child(index - 1)


## Checks if the current node is scene root, useful if you want a different behavior when
## playing a single scene than when that scene is instanced.
static func is_scene_root(node: Node) -> bool:
	if scene_root:
		return scene_root == node
	return node.get_tree().current_scene == node


## Gets all children, grandchildren, etc
static func get_descendents(node: Node) -> Array[Node]:
	var arr : Array[Node]
	var parent_stack : Array[Node] = [node]
	while parent_stack.size():
		var parent = parent_stack.pop_front()
		for child in parent.get_children():
			parent_stack.push_back(child)
			arr.push_back(child)
	return arr


## Gets all children, grandchildren, etc with a given type
## Optionally does not go deeper than the first chlid of that type found in any sub-tree
static func get_descendents_with_type(node: Node, type: Variant, stop_at_type := false) -> Array[Node]:
	var arr : Array[Node]
	var parent_stack : Array[Node] = [node]
	while parent_stack.size():
		var parent = parent_stack.pop_front()
		for child in parent.get_children():
			if !stop_at_type or !is_instance_of(child, type):
				parent_stack.push_back(child)
			if is_instance_of(child, type):
				arr.push_back(child)
	return arr


## Gets children, but reversed
static func get_children_reversed(node: Node, include_internal := Node.INTERNAL_MODE_DISABLED) -> Array[Node]:
	var children := node.get_children(include_internal)
	children.reverse()
	return children


## Gets descendant count
static func get_child_count_recursive(node: Node) -> int:
	var count := 1
	for child in node.get_children():
		count += get_child_count_recursive(child)
	return count


static func add_children(parent: Node, nodes: Array[Node], internal := Node.INTERNAL_MODE_DISABLED) -> void:
	for node in nodes:
		parent.add_child(node, false, internal)


static func move_relative(node: Node, by := 1) -> void:
	var index := node.get_index()
	var parent := node.get_parent()
	parent.move_child(node, index + by)


static func get_nth_parent(node: Node, n := 1) -> Node:
	for i in n:
		node = node.get_parent()
	return node


static func get_all_ancestors(node: Node) -> Array[Node]:
	var ancestors : Array[Node] = []
	while node:
		node = node.get_parent()
		if node: ancestors.push_back(node)
	return ancestors


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")