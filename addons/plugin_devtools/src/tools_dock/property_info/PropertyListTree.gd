@tool
extends Tree

const H := preload("uid://bn7ppltfkj17y")

signal property_selected(property_name: String)

# @export var search_match_highlight : Color = Color(Color.LIGHT_CYAN, 0.2)
var search_match_highlight : Color

var selected_property : String = ""
var properties := PackedStringArray()

func _ready() -> void:
	search_match_highlight = EditorInterface.get_editor_theme().get_color("accent_color", "Editor")
	search_match_highlight.a = 0.4
	EditorInterface.get_inspector().edited_object_changed.connect(_build_inspector_edited_property_tree)
	EditorInterface.get_inspector().property_selected.connect(_find_property)
	item_mouse_selected.connect(_on_item_selected.unbind(2))

func _build_inspector_edited_property_tree() -> void:
	var object := EditorInterface.get_inspector().get_edited_object()
	_build_tree(object)

# TODO this is a mess lol
func _build_tree(object: Object) -> void:
	clear()
	if !object:
		return
	var root := create_item()
	var parent = root
	var group_parent = null
	var subgroup_parent = null
	properties = PackedStringArray()
	for p in object.get_property_list():
		properties.append(p.name)
		var item : TreeItem
		if p.usage == PROPERTY_USAGE_CATEGORY:
			item = create_item(root)
			item.set_icon(0, H.Editor.IconGrabber.get_class_icon(p.name))
			item.set_custom_bg_color(0, Color(Color.WHITE, 0.05))
			parent = item
			group_parent = null
			subgroup_parent = null
		elif p.usage == PROPERTY_USAGE_GROUP:
			if subgroup_parent:
				parent = parent.get_parent()
			if group_parent:
				parent = parent.get_parent()
			item = create_item(parent)
			item.set_icon(0, EditorInterface.get_editor_theme().get_icon("Folder", &"EditorIcons"))
			item.set_custom_bg_color(0, Color(Color.WHITE, 0.02))
			group_parent = parent
			subgroup_parent = null
			parent = item
		elif p.usage == PROPERTY_USAGE_SUBGROUP:
			if subgroup_parent:
				parent = parent.get_parent()
			item = create_item(parent)
			item.set_icon(0, EditorInterface.get_editor_theme().get_icon("Folder", &"EditorIcons"))
			item.set_custom_bg_color(0, Color(Color.WHITE, 0.01))
			subgroup_parent = parent
			parent = item
		else:
			item = create_item(parent)
			var icon : Texture2D
			if p.type != TYPE_OBJECT:
				icon = H.Editor.IconGrabber.get_variant_icon(p.type)
			elif "hint" in p:
				if p.hint == PROPERTY_HINT_RESOURCE_TYPE:
					var type_hint : String = p.hint_string.split(",")[0]
					icon = H.Editor.IconGrabber.get_class_icon(type_hint)
					if type_hint == "shortcut_context":
						icon = EditorInterface.get_inspector().get_theme_icon("Node", &"EditorIcons")

					if icon == H.Editor.IconGrabber.UNKNOWN_ICON:
						icon = EditorInterface.get_editor_theme().get_icon("ObjectDark", &"EditorIcons")
			else:
				icon = EditorInterface.get_inspector().get_theme_icon("MemberProperty", &"EditorIcons")
			item.set_icon(0, icon)

		item.set_text(0, p.name)
		item.collapsed = true

func _find_property(property: String, root = null) -> void:
	if !root:
		root = get_root()
		for child in root.get_children():
			child.set_collapsed_recursive(true)
	for item : TreeItem in root.get_children():
		if item.get_text(0) == property:
			scroll_to_item(item)
			var parent := item
			while parent:
				parent.collapsed = false
				parent = parent.get_parent()
			item.select(0)
			return
		_find_property(property, item)

func filter(text: String) -> void:
	var root := get_root()
	if text == "":
		_reset_tree()
		return

	var matches := H.Search.FuzzySearch.search(text, properties)
	for child in root.get_children():
		child.set_collapsed_recursive(true)
	_filter_recurse(matches, root)

func _filter_recurse(matches: PackedStringArray, root: TreeItem) -> void:
	for item : TreeItem in root.get_children():
		if item.get_text(0) in matches:
			var parent := item
			item.set_custom_bg_color(0, search_match_highlight, true)
			if matches.size() == 1:
				# huh. says its doing it but its not...
				item.select(0)
			while parent:
				parent.collapsed = false
				parent.visible = true
				parent = parent.get_parent()
		else:
			# TODO font color from theme
			item.set_custom_color(0, Color(Color.WHITE, 0.5))
			item.set_custom_bg_color(0, Color.TRANSPARENT)
			item.visible = false
		_filter_recurse(matches, item)

func _reset_tree(root: TreeItem = null) -> void:
	if !root:
		root = get_root()
		root.set_collapsed(false)
		for child in root.get_children():
			child.set_collapsed_recursive(true)
	for item in root.get_children():
		item.set_custom_bg_color(0, Color.TRANSPARENT)
		item.clear_custom_color(0)
		item.visible = true
		_reset_tree(item)


func _on_item_selected() -> void:
	var item := get_selected()
	if !item:
		return
	item.collapsed = !item.collapsed
	var p_name := item.get_text(0)
	if p_name != selected_property:
		property_selected.emit(p_name)
		selected_property = p_name
