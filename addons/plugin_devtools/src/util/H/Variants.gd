static func get_default_value(type: Variant.Type) -> Variant:
	return type_convert(null, type)

## Static class
func _init() -> void: assert(false, "Class can't be instantiated")