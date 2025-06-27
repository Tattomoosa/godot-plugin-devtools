@tool


static func get_or_add_meta(object: Object, meta: String, default: Variant) -> Variant:
	if !object.has_meta(meta):
		object.set_meta(meta, default)
	return object.get_meta(meta)


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")