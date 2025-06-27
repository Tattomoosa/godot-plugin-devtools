@tool
extends MarginContainer

@onready var mb_options_target: MarginContainer = %MBOptionsTarget
@onready var tab_container: TabContainer = %TabContainer

func _ready() -> void:
	if EditorInterface.get_edited_scene_root() == self:
		return
	var m:Control = mb_options_target.get_parent()
	var spacer = m.get_child(0)
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.reparent(tab_container.get_tab_bar())
	m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#tab_container.get_tab_bar().hide()
	#tab_bar.reparent(tab_container.get_tab_bar())
