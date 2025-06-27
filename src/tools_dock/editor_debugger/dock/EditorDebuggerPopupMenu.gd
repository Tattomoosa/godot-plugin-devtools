@tool
extends PopupMenu

signal save_branch_as_scene
signal copy_path_to_clipboard
signal copy_node_types_to_clipboard

const EditorDebuggerNodeTree := preload("EditorDebuggerNodeTree.gd")
@onready var _tree : EditorDebuggerNodeTree = %EditorDebuggerNodeTree

enum POPUP_ACTIONS {
	SAVE_BRANCH_AS_SCENE,
	COPY_PATH_TO_CLIPBOARD,
	COPY_NODE_TYPES_TO_CLIPBOARD,
}

const _popup_action_names = {
	POPUP_ACTIONS.SAVE_BRANCH_AS_SCENE: {
		"title": "Save branch as scene",
		"tooltip": "Save the branch as a new scene in a directory of your choice"
	},
	POPUP_ACTIONS.COPY_PATH_TO_CLIPBOARD: {
		"title": "Copy path to clipboard",
		"tooltip": "Copy the path to the node in the format \"/path/to/node\""
	},
	POPUP_ACTIONS.COPY_NODE_TYPES_TO_CLIPBOARD:{
		"title": "Copy typed path to clipboard",
		"tooltip": "Copy the path to the node in the format [[\"type\", \"node\"], [\"type\", \"node\"], ...]"
	},
}

func _ready() -> void:
	clear()
	for id in _popup_action_names:
		add_item(_popup_action_names[id].title, id)
		var index := get_item_index(id)
		set_item_tooltip(index, _popup_action_names[id].tooltip)
	id_pressed.connect(_on_popup_menu_id_pressed)

func _on_popup_menu_id_pressed(id: int) -> void:
	hide()
	match id:
		POPUP_ACTIONS.SAVE_BRANCH_AS_SCENE:
			save_branch_as_scene.emit()
		
		POPUP_ACTIONS.COPY_PATH_TO_CLIPBOARD:
			var item := _tree.get_selected()
			var node : Node = _tree.get_item_node(item)
			DisplayServer.clipboard_set(node.get_path())
			print("Copied to clipboard: %s"%[node.get_path()])
			copy_path_to_clipboard.emit()
		
		POPUP_ACTIONS.COPY_NODE_TYPES_TO_CLIPBOARD:
			copy_node_types_to_clipboard.emit()
			var item := _tree.get_selected()
			var node := _tree.get_item_node(item)
			var node_types := []
			while node.get_parent():
				var tuple := PackedStringArray([node.get_class(), node.name])
				node_types.append(tuple)
				node = node.get_parent()
			node_types.reverse()
			var node_types_str := "%s"%[node_types]
			DisplayServer.clipboard_set(node_types_str)
			print("Copied to clipboard: %s"%[node_types_str])
