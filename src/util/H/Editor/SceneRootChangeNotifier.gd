extends RefCounted

# https://github.com/godotengine/godot/issues/97427

signal scene_root_changed(node: Node)

func _init() -> void:
	var viewport_2d := EditorInterface.get_editor_viewport_2d()
	viewport_2d.child_entered_tree.connect(scene_root_changed.emit)
	viewport_2d.child_exiting_tree.connect(scene_root_changed.emit.bind(null).unbind(1))