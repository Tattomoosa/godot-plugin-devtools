@tool

const H := preload("uid://bn7ppltfkj17y")
const Files := H.Files
const Strings := H.Strings

const FILE_EXTENSIONS := ["gd", "cfg", "cs"]

# TODO get_all_plugins or something, recursive version of this
# that returns a dictionary or something?
static func get_subplugin_roots(plugin: EditorPlugin) -> PackedStringArray:
	var path := get_plugin_root_dir(plugin)
	var subplugin_root_dir := path.path_join("addons")
	var subplugin_names := Files.get_subdirectories(subplugin_root_dir)
	return Files.path_join_all(subplugin_root_dir, subplugin_names)

static func get_plugin_root_dir(plugin: EditorPlugin) -> String:
	return (plugin.get_script() as Script).resource_path.get_base_dir()

static func get_plugin_root_dir_name(plugin: EditorPlugin) -> String:
	return get_plugin_root_dir(plugin).get_file()

static func get_subplugin_names(plugin: EditorPlugin) -> PackedStringArray:
	var path := get_plugin_root_dir(plugin)
	var subplugin_root_dir := path.path_join("addons")
	return Files.get_subdirectories(subplugin_root_dir)

static func get_subplugin_root_dir(plugin: EditorPlugin, subplugin_name: String) -> String:
	var path := get_plugin_root_dir(plugin)
	var subplugin_root_dir := path.path_join("addons")
	return subplugin_root_dir.path_join(subplugin_name)

static func get_plugin_exists(plugin_path: String) -> bool:
	var config_path := get_plugin_config_file_path(plugin_path)
	return FileAccess.file_exists(config_path)

# static func add_missing_subplugin_enable_settings(plugin: EditorPlugin) -> void:
# 	for subplugin_name in get_subplugin_names(plugin):
# 		var setting := get_subplugin_enabled_setting_name(plugin, subplugin_name)
# 		Settings.get_or_add(setting, true)

static func get_subplugin_enabled_setting_name(plugin: EditorPlugin, subplugin_name: String) -> String:
	var category := get_subplugin_category(plugin, subplugin_name)
	return category.path_join("enabled")

static func is_subplugin_enabled_in_settings(plugin: EditorPlugin, subplugin_name: String) -> bool:
	var setting_name := get_subplugin_enabled_setting_name(plugin, subplugin_name)
	return H.Settings.get_or_add(setting_name, true)

static func get_subplugin_category(plugin: EditorPlugin, subplugin_name: String) -> String:
	var plugin_name := get_plugin_root_dir_name(plugin)
	return plugin_name.path_join(subplugin_name)

static func enable_subplugins(plugin: EditorPlugin) -> void:
	for subplugin_name in get_subplugin_names(plugin):
		if is_subplugin_enabled_in_settings(plugin, subplugin_name):
			var setting_name := get_subplugin_enabled_setting_name(plugin, subplugin_name)
			var enabled : bool = H.Settings.get_or_add(setting_name, true)
			var enable_string := get_plugin_root_dir(plugin).path_join("addons").path_join(subplugin_name)
			enable_string = enable_string.replace("res://addons/", "")
			if !EditorInterface.is_plugin_enabled(enable_string):
				EditorInterface.set_plugin_enabled(enable_string, enabled)
	ProjectSettings.save()

static func disable_subplugins(plugin: EditorPlugin) -> void:
	for subplugin_name in get_subplugin_names(plugin):
		var enable_string := get_plugin_root_dir(plugin).path_join("addons").path_join(subplugin_name)
		enable_string = enable_string.replace("res://addons/", "")
		if EditorInterface.is_plugin_enabled(enable_string):
			EditorInterface.set_plugin_enabled(enable_string, false)

static func get_all_plugin_paths() -> PackedStringArray:
	var plugin_dirs := PackedStringArray()
	var cfg_file_paths := Files.get_all_files("res://addons/", ["cfg"])
	for cfg_path in cfg_file_paths:
		if cfg_path.get_file() == "plugin.cfg":
			plugin_dirs.push_back(cfg_path.get_base_dir())
	return plugin_dirs

static func get_plugin_enable_string_from_path(path: String) -> String:
	if path.get_extension() in FILE_EXTENSIONS:
		path = path.get_base_dir()
	return path.replace("res://addons/", "")

static func is_enabled(plugin_path: String) -> bool:
	var enable_string := get_plugin_enable_string_from_path(plugin_path)
	return EditorInterface.is_plugin_enabled(enable_string)

static func get_plugin_display_name(plugin_path: String) -> String:
	if plugin_path.get_extension() in FILE_EXTENSIONS:
		plugin_path = plugin_path.get_base_dir()
	var config_file := get_plugin_config_file(plugin_path)
	# hm I think they have to have a name, actually
	if config_file.has_section_key("plugin", "name"):
		return config_file.get_value("plugin", "name")
	# try to handle the bad case anyway
	return plugin_path.get_file().capitalize()

static func get_plugin_icon(plugin_path: String) -> Texture2D:
	var config_file := get_plugin_config_file(plugin_path)
	if config_file.has_section_key("plugin", "icon"):
		var icon_path : String = config_file.get_value("plugin", "icon", null)
		return load(icon_path)
	# Otherwise, have to guess	
	var img_files := Files.get_all_files(plugin_path, ["svg", "png", "tga", "webp"])
	var plugin_name := plugin_path.get_file()
	for file_path in img_files:
		var filename := Files.get_file_without_extension(file_path) 
		if plugin_name in filename or "icon" in filename:
			var tex := load(file_path)
			# check if texture
			if tex is Texture2D:
				# return if square
				var img_size = tex.get_size()
				if img_size.x == img_size.y:
					return tex
	return null

static func ensure_icon_16x16_at_editor_scale(tex: Texture2D) -> Texture2D:
	var img_size = tex.get_size()
	var desired_size : Vector2i = Vector2.ONE * 16 * EditorInterface.get_editor_scale()
	if img_size.is_equal_approx(desired_size):
		return tex
	else:
		var img : Image = tex.get_image()
		if tex is CompressedTexture2D:
			img.decompress()
		img.resize(desired_size.x, desired_size.y)
		return ImageTexture.create_from_image(img)

static func get_plugin_config_category(plugin_path: String) -> String:
	var plugin_enable_string := get_plugin_enable_string_from_path(plugin_path)
	return plugin_enable_string.replace("addons/", "")

static func get_plugin_config_file(plugin_path: String) -> ConfigFile:
	var config_file := ConfigFile.new()
	config_file.load(plugin_path.path_join("plugin.cfg"))
	return config_file

static func get_plugin_config_file_path(plugin_path: String) -> String:
	return plugin_path.path_join("plugin.cfg")

static func get_plugin_path_from_config_path(config_path: String) -> String:
	return config_path.get_base_dir()

static func get_plugin_script(plugin_path: String) -> Script:
	var config_file := get_plugin_config_file(plugin_path)
	var script_name : String = config_file.get_value("plugin", "script", "")
	var script : GDScript = load(plugin_path.path_join(script_name))
	return script

# Godot does not signal when a plugin is enabled or disabled...
# So this does.
class Watcher extends RefCounted:
	signal plugin_entered(plugin_path: String)
	signal plugin_exiting(plugin_path: String)

	func _init() -> void:
		var root := EditorInterface.get_base_control().get_window().get_child(0)
		root.child_entered_tree.connect(_on_root_child_entered)
		root.child_exiting_tree.connect(_on_root_child_exiting)

	# no need to disconnect, already cleaned up by predelete time!

	func subscribe(enter_callback: Callable, exit_callback: Callable) -> void:
		if !plugin_entered.is_connected(enter_callback):
			plugin_entered.connect(enter_callback)
		if !plugin_exiting.is_connected(exit_callback):
			plugin_exiting.connect(exit_callback)

	func unsubscribe(enter_callback: Callable, exit_callback: Callable) -> void:
		if plugin_entered.is_connected(enter_callback):
			plugin_entered.disconnect(enter_callback)
		if plugin_exiting.is_connected(exit_callback):
			plugin_exiting.disconnect(exit_callback)
	
	func _on_root_child_entered(node: Node) -> void:
		var script : Script = node.get_script()
		if script:
			var plugin_path := script.resource_path.get_base_dir()
			plugin_entered.emit(plugin_path)
	
	func _on_root_child_exiting(node: Node) -> void:
		var script : Script = node.get_script()
		var tree := node.get_tree()
		await node.tree_exited
		await tree.process_frame
		if script:
			var plugin_path := script.resource_path.get_base_dir()
			plugin_exiting.emit(plugin_path)
