class V2:
	static func from_float(from: float) -> Vector2: return Vector2(from, from)
	static func from_v3_xz(from: Vector3) -> Vector2: return Vector2(from.x, from.z)
	static func from_v3_xy(from: Vector3) -> Vector2: return Vector2(from.x, from.y)
	static func with_x(from: Vector2, x: float) -> Vector2: return Vector2(x, from.y)
	static func with_y(from: Vector2, y: float) -> Vector2: return Vector2(from.x, y)

	## Extrapolates a moving Vector2 value, useful for software mouse cursors.
	class Extrapolator extends RefCounted:
		var _previous : Vector2
		var extrapolation_factor : float

		func _init(initial_value: Vector2, factor: float) -> void:
			_previous = initial_value
			extrapolation_factor = factor

		func extrapolate(current: Vector2) -> Vector2:
			var delta := current - _previous
			_previous = current
			return current + (delta * extrapolation_factor)
		
		func extrapolate_vector2i(current: Vector2) -> Vector2i:
			return Vector2i(extrapolate(current))

class V2i:
	static func from_int(from: int) -> Vector2i: return Vector2i(from, from)
	static func with_x(from: Vector2i, x: int) -> Vector2i: return Vector2i(x, from.y)
	static func with_y(from: Vector2i, y: int) -> Vector2i: return Vector2i(from.x, y)

class V3:
	static func from_float(from: float) -> Vector3: return Vector3(from, from, from)
	static func with_x(from: Vector3, x: float) -> Vector3: return Vector3(x, from.y, from.z)
	static func with_y(from: Vector3, y: float) -> Vector3: return Vector3(from.x, y, from.z)
	static func with_z(from: Vector3, z: float) -> Vector3: return Vector3(from.x, from.y, z)

class V3i:
	static func from_int(from: int) -> Vector3i: return Vector3i(from, from, from)
	static func with_x(from: Vector3i, x: int) -> Vector3i: return Vector3i(x, from.y, from.z)
	static func with_y(from: Vector3i, y: int) -> Vector3i: return Vector3i(from.x, y, from.z)
	static func with_z(from: Vector3i, z: int) -> Vector3i: return Vector3i(from.x, from.y, z)

class V4:
	static func from_float(from: float) -> Vector4: return Vector4(from, from, from, from)
	static func with_x(from: Vector4, x: float) -> Vector4: return Vector4(x, from.y, from.z, from.w)
	static func with_y(from: Vector4, y: float) -> Vector4: return Vector4(from.x, y, from.z, from.w)
	static func with_z(from: Vector4, z: float) -> Vector4: return Vector4(from.x, from.y, z, from.w)
	static func with_w(from: Vector4, w: float) -> Vector4: return Vector4(from.x, from.y, from.z, w)

class V4i:
	static func from_int(from: int) -> Vector4i: return Vector4i(from, from, from, from)
	static func with_x(from: Vector4i, x: int) -> Vector4i: return Vector4i(x, from.y, from.z, from.w)
	static func with_y(from: Vector4i, y: int) -> Vector4i: return Vector4i(from.x, y, from.z, from.w)
	static func with_z(from: Vector4i, z: int) -> Vector4i: return Vector4i(from.x, from.y, z, from.w)
	static func with_w(from: Vector4i, w: int) -> Vector4i: return Vector4i(from.x, from.y, from.z, w)