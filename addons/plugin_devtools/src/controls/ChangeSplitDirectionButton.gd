@tool
extends EditorIconButton

const EditorIconButton := preload("uid://83yq2e5cupld")

@export var split_container : SplitContainer
@export var hsplit_icon : Texture2D
@export var vsplit_icon : Texture2D


func _ready() -> void:
	pressed.connect(_change_split)
	await get_tree().process_frame
	_update_split_icon()


func _change_split() -> void:
	split_container.vertical = !split_container.vertical
	_update_split_icon()


func _update_split_icon() -> void:
	var split_icon := vsplit_icon
	if not vsplit_icon:
		split_icon = get_theme_icon("Panels2Alt", &"EditorIcons")
	if split_container.vertical:
		if hsplit_icon:
			split_icon = hsplit_icon
		else:
			split_icon = get_theme_icon("Panels2", &"EditorIcons")
	if icon_override != split_icon:
		icon_override = split_icon
