@tool

static var scale :
	get:
		return EditorInterface.get_editor_scale()

static func scale_int(v: int) -> int:
	return v * scale

static func scale_float(v: float) -> float:
	return v * scale

static func scale_vector2(v: Vector2) -> Vector2:
	return v * scale