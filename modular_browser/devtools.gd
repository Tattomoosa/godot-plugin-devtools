@tool
extends "res://addons/modular_browser/plugin/scripts_panels/panel_interface_base.gd"

class Data:
	const module = Modules.None
	const module_icon = null
	const nest_in_module = false
	const name = "Plugin Devtools Dock"
	const use_name_path = false
	const icons = []
	const scene_path = "uid://bagj2x3qnhgkh" # scene that actually instantiates in browser
	const ui_scene_path = keys.PanelTabData.NONE # ui scene for add panel window, can be none, used with interface
	const interface_path = keys.PanelTabData.NONE # path to this file, used with ui scene, if not set, defaults to this path
	const single_instance = SingleInstance.FALSE # if panel must be limited to 1 instance per 'instance' or global
	const requires_plugin = PanelTabData.NONE # name of plugin required to allow instancing


static func register_panel(): # return name and interface path for registering
	return _get_register_settings(Data)

static func get_panel_dialog_data(): # return data class
	return _get_panel_dialog_data(Data)


static func get_panel_dialog_ui(): # returns UI scene instance, null on fail
	return _get_panel_dialog_ui(Data)

# this will be configured here, data is written to file and read on panel instance. 
# Scene should have method below to handle this, reference UIData for keys
#func send_panel_dialog_data(tab_data):
	#pass

static func get_panel_ui_data():
	var data = {}
	return data


class UIData: # this class can be used to store keys for ui data, don't use the below keys VV
	pass

#keys.PanelTabData members
#const index = "panel_index"
#const name = "panel_name"
#const interface_path = "panel_interface_path"
#const scene_path = "panel_scene_path"
#const ui_scene_path = "panel_ui_scene_path"
#const single_instance = "single_instance"
#const editable = "editable"

