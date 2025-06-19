@tool
extends PanelContainer

@export var restrict_to_types : Array[String] = []
@export var restrict_to_file_extensions : Array[String] = []

signal dropped_data(data: Variant)
signal something_dragging(value: bool)

func _ready() -> void:
	visible = false
	#mouse_filter = Control.MOUSE_FILTER_IGNORE

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_BEGIN:
			something_dragging.emit(true)
			if _can_drop_data(Vector2.ZERO, get_viewport().gui_get_drag_data()):
				visible = true
		NOTIFICATION_DRAG_END:
			something_dragging.emit(false)
			visible = false

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if restrict_to_types.is_empty():
		return true
	else:
		if data is Dictionary and "type" in data and data.type in restrict_to_types:
			if data.type == "files" and !restrict_to_file_extensions.is_empty():
				var extension : String = data.files[0].get_extension()
				return extension in restrict_to_file_extensions
			return true
		return false
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	dropped_data.emit(data)
	