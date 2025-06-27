@tool
extends EditorPlugin

const tools_dock_scene := preload("uid://bagj2x3qnhgkh")
const plugin_icon := preload("uid://d0mcyi8ajfh02")

var tools_dock : Control
var dock_popup : Popup
var add_to_bottom_button : Button
var _docks : Dictionary[DockSlot, Control] = {}

func _get_plugin_name() -> String:
	return "PluginDevTools"

func _enable_plugin() -> void:
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	#name = "PluginDevTools"
	#tools_dock = tools_dock_scene.instantiate()
	#add_control_to_bottom_panel(tools_dock, "Plugin DevTools")
	pass

func _exit_tree() -> void:
	#remove_control_from_bottom_panel(tools_dock)
	#tools_dock.queue_free()
	pass

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
