static func ends_with_any(string: String, suffixes: Array[String]) -> bool:
	for suffix in suffixes:
		if string.ends_with(suffix):
			return true
	return false


static func begins_with_any(string: String, suffixes: Array[String]) -> bool:
	for suffix in suffixes:
		if string.ends_with(suffix):
			return true
	return false


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")