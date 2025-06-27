@tool
extends Tree

const IconGrabber := preload("uid://bn7ppltfkj17y").Editor.IconGrabber
const Scripts := preload("uid://bn7ppltfkj17y").Scripts
var base_node_icon : Texture2D

func _ready() -> void:
	base_node_icon = IconGrabber.get_class_icon("Node")

func _get_icon_class_name(c_name: String) -> Texture2D:
	var icon_c_name := c_name

	var icon_texture : Texture2D = null
	icon_texture = IconGrabber.get_class_icon(icon_c_name, "Node")
	if icon_texture == base_node_icon and !c_name.is_empty():	
		var parent_class := ClassDB.get_parent_class(c_name)
		var iter := 0
		while !parent_class.is_empty() and parent_class != "Object":
			icon_c_name = parent_class
			icon_texture = IconGrabber.get_class_icon(icon_c_name, "Node")
			if icon_texture != base_node_icon:
				break
			parent_class = ClassDB.get_parent_class(parent_class)
			iter += 1
			if iter > 10:
				break
	return icon_texture

func _get_icon(node: Node) -> Texture2D:
	var c_name := Scripts.get_class_name_or_class(node)
	return _get_icon_class_name(c_name)

func _get_node_name_display_text(node: Node) -> String:
	var c_name := Scripts.get_class_name_or_class(node)
	var node_name := &"" if "@" in node.name else node.name
	var display_text := '"%s" (%s)' % [node_name, c_name] if node_name else c_name
	return display_text

func _theme_icon(icon_name: String) -> Texture2D:
	return EditorInterface.get_inspector().get_theme_icon(icon_name, "EditorIcons")

# TODO ?
func _get_path_pretty(node: Node) -> void:
	var path := node.get_path()
	var display_name := ""
	# for i in path.get_name_count():
	# var parts := path.split("/")
