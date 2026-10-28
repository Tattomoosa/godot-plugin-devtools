@tool
extends EditorPlugin

const tools_dock_scene := preload("uid://bagj2x3qnhgkh")
const plugin_icon := preload("uid://d0mcyi8ajfh02")

var tools_dock : Control
var dock_popup : Popup
var add_to_bottom_button : Button
var _docks : Dictionary[DockSlot, Control] = {}

var editor_dock #:EditorDock un-typed for back compat

func _enable_plugin() -> void:
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	name = "PluginDevTools"
	tools_dock = tools_dock_scene.instantiate()
	
	var version = Engine.get_version_info()
	if version.minor < 6:
		add_control_to_bottom_panel(tools_dock, "Plugin DevTools")
	else:
		editor_dock = ClassDB.instantiate("EditorDock")
		editor_dock.available_layouts = editor_dock.DOCK_LAYOUT_ALL
		editor_dock.default_slot = editor_dock.DOCK_SLOT_BOTTOM
		editor_dock.dock_icon = plugin_icon
		editor_dock.add_child(tools_dock)
		call("add_dock", editor_dock)

	# set_dock_tab_icon(tools_dock, plugin_icon)
	# var tc : TabContainer = tools_dock.get_parent()
	# var popup := tc.get_popup()
	# popup.about_to_popup.connect(_add_bottom_panel_button_to_popup)
	# tools_dock.get_child(0).get_child(0).set_popup(popup)

func _exit_tree() -> void:
	var version = Engine.get_version_info()
	if version.minor < 6:
		remove_control_from_bottom_panel(tools_dock)
	else:
		call("remove_dock", editor_dock)
		editor_dock.queue_free()
	tools_dock.queue_free()

func _add_bottom_panel_button_to_popup() -> void:
	var tc : TabContainer = tools_dock.get_parent()
	var popup := tc.get_popup()
	var vbox := popup.get_child(1, true)
	for child in vbox.get_children(true):
		if child is Button:
			if child.text == "Move to Bottom":
				child.show()

func _get_docks() -> void:
	var dummy_control := Control.new()
	for slot in DOCK_SLOT_MAX:
		add_control_to_dock(slot, dummy_control)
		_docks[slot] = dummy_control.get_parent()
		remove_control_from_docks(dummy_control)
	dummy_control.queue_free()
