@tool
extends Container

@export var item_size := 100.0
signal drop_data_button_pressed(data: Variant)

func _ready() -> void:
	pass

func add_item(drop_data: Variant) -> void:
	if drop_data is Dictionary:
		var item := HBoxContainer.new()

		var previewer := Button.new()
		previewer.set_meta("drop_data", drop_data)
		previewer.set_drag_forwarding(_get_item_drag_data.bind(previewer), Callable(), Callable())
		previewer.pressed.connect(drop_data_button_pressed.emit.bind(drop_data))
		previewer.expand_icon = true
		previewer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if drop_data.type == "resource":
			var resource : Resource = drop_data["resource"]
			if resource.resource_name:
				previewer.text = resource.resource_name
			elif resource.get_script() and resource.get_script().get_global_name():
				previewer.text = resource.get_script().get_global_name()
			elif resource.resource_path:
				previewer.text = resource.resource_path.get_file()
			else:
				resource.get_class()
			_create_resource_preview(resource, previewer)
		elif drop_data.type == "nodes":
			previewer.icon = EditorInterface.get_base_control().get_theme_icon("Node", &"EditorIcons")
			var nodes : Array = drop_data["nodes"]
			previewer.text = nodes[0].get_name(nodes[0].get_name_count() - 1)
		else:
			previewer.text = drop_data.type
		item.add_child(previewer)

		var delete_btn := Button.new()
		delete_btn.icon = EditorInterface.get_inspector().get_theme_icon("Close", "EditorIcons")
		delete_btn.pressed.connect(item.queue_free)
		item.add_child(delete_btn)

		add_child(item)
	else:
		push_error("Can't handle dropped data! %s" % drop_data)


func _create_resource_preview(resource: Resource, resource_previewer: Button) -> void:
	var preview := EditorInterface.get_resource_previewer()
	preview.queue_edited_resource_preview(resource, self, "_on_resource_preview", resource_previewer)

func _on_resource_preview(_path: String, preview: Texture2D, _thumbnail: Texture2D, user_data_previewer: Button) -> void:
	user_data_previewer.icon = preview

func _get_item_drag_data(_at_position: Vector2, item: Control) -> Variant:
	return item.get_meta("drop_data")