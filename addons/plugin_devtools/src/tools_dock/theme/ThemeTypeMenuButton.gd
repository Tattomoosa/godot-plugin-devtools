@tool
extends MenuButton
# TODO UGHGHGHHGHGH TODO this doesn't work

var _popup : PopupMenu

func _ready() -> void:
	_popup = get_popup()
	_popup.set_script(ThemePopup)
	var t := EditorInterface.get_editor_theme()
	_popup.type_list = t.get_constant_type_list()
	_popup._ready()

class ThemePopup extends PopupMenu:
	var base_type := ""
	var type_list : PackedStringArray

	func _ready() -> void:
		var t := EditorInterface.get_editor_theme()
		for type in type_list:
			if t.get_type_variation_base(type) == base_type:
				var subtype_list := t.get_type_variation_list(type)
				if !subtype_list.is_empty():
					var subpopup := ThemePopup.new()
					subpopup.type_list = subtype_list
					subpopup.base_type = type
					add_child(subpopup)
					add_submenu_node_item(type, subpopup)
				else:
					add_item(type)

