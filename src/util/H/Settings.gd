## Gets a setting's current value, or sets it to the initial value and returns that
## Useful so a plugin doesn't need to care if its just initializing its settings or not.
static func get_or_add(setting : String, default_value : Variant) -> Variant:
	if !ProjectSettings.has_setting(setting):
		ProjectSettings.set_setting(setting, default_value)
		if default_value != null:
			ProjectSettings.set_initial_value(setting, default_value)
	return ProjectSettings.get_setting(setting)


static func get_setting(setting: String) -> Variant:
	return ProjectSettings.get_setting(setting)


static func globalize_path(path: String) -> void:
	if path.begins_with("res://") and !OS.has_feature("editor"):
		return OS.get_executable_path().get_base_dir().path_join(path.replace("res://", ""))
	return ProjectSettings.globalize_path(path)


func _init() -> void: assert(false, "Class can't be instantiated")