## Uses CSS rules
static func margin_container(
	margin0: int,
	margin1 := margin0,
	margin2 := margin0,
	margin3 := margin1,
) -> MarginContainer:
	var mc := MarginContainer.new()
	mc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mc.add_theme_constant_override("margin_top", margin0)
	mc.add_theme_constant_override("margin_right", margin1)
	mc.add_theme_constant_override("margin_bottom", margin2)
	mc.add_theme_constant_override("margin_left", margin3)
	return mc


static func v_shrink_begin(c: Control) -> Control:
	c.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	return c


static func h_shrink_begin(c: Control) -> Control:
	c.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	return c


static func v_shrink_end(c: Control) -> Control:
	c.size_flags_vertical = Control.SIZE_SHRINK_END
	return c


static func h_shrink_end(c: Control) -> Control:
	c.size_flags_horizontal = Control.SIZE_SHRINK_END
	return c

static func expand_fill(c: Control) -> Control:
	c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return c

static func v_expand_fill(c: Control) -> Control:
	c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return c

static func h_expand_fill(c: Control) -> Control:
	c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return c

static func label(text: String) -> Label:
	var l := Label.new()
	l.text = text
	return l

static func icon_button(icon: Texture2D, flat := false) -> Button:
	var button := Button.new()
	button.icon = icon
	button.flat = flat
	return button

static func icon_menu_button(icon: Texture2D, flat := false) -> MenuButton:
	var button := MenuButton.new()
	button.icon = icon
	button.flat = flat
	return button

# static func icon_toggle_button(pressed: bool, icon_on: Texture2D, icon_off: Texture2D, flat := false) -> Button:
# 	var button := icon_button(icon_off, flat)
# 	button.toggle_mode = true
# 	button.button_pressed = pressed
# 	var on_toggle := func(v: bool) -> void: button.icon = icon_on if v else icon_off
# 	on_toggle.call(pressed)
# 	button.toggled.connect(on_toggle)
# 	return button

static func create_vbox(
	separation: int = -1,
) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	if separation >= 0:
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.add_theme_constant_override("separation", separation)
	return vbox

static func create_vbox_with_children(
	children: Array[Control],
	separation: int = -1,
) -> VBoxContainer:
	var vbox := create_vbox(separation)
	for child in children:
		vbox.add_child(child)
	return vbox

static func create_hbox(
	separation: int = 0,
) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", separation)
	return hbox

static func create_hbox_with_children(
	children: Array[Control],
	separation: int = -1,
) -> HBoxContainer:
	var vbox := create_hbox(separation)
	for child in children:
		vbox.add_child(child)
	return vbox

static func add_children(parent: Control, controls: Array[Control], internal := Node.INTERNAL_MODE_DISABLED) -> void:
	for node in controls:
		if node.get_parent():
			node.get_parent().remove_child(node)
		parent.add_child(node, false, internal)

# ehhh
static func layout(controls: Dictionary) -> Control:
	var parent : Control = controls.control
	var children : Array = controls.children
	for item in children:
		var control : Control = item if item is Control else item.control
		if control.get_parent():
			control.get_parent().remove_child(control)
		if item is Control:
			parent.add_child(item)
		elif item is Dictionary:
			parent.add_child(
				control,
				item.get("force_readable_name", false),
				item.get("internal", Control.INTERNAL_MODE_DISABLED)
			)
			if "expand" in item:
				if item.expand:
					control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					control.size_flags_vertical = Control.SIZE_EXPAND_FILL
				else:
					control.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
					control.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
			if "position" in item:
				parent.move_child(control, item.position)
			if "children" in item:
				layout(item)
	return parent

# START EDITOR

# TODO editor references can't be in finished build I don't think
# they should all be separated.
static func get_editor_constant(path: String) -> int:
	var inspector := EditorInterface.get_inspector()
	var paths := path.split("/")
	return inspector.get_theme_constant(paths[2], paths[0])

static func get_editor_icon(icon: String) -> Texture2D:
	var inspector := EditorInterface.get_inspector()
	return inspector.get_theme_icon(icon, &"EditorIcons")

# END EDITOR


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")