func any(array: Array) -> bool:
	for item in array:
		if item:
			return true
	return false


func all(array: Array) -> bool:
	for item in array:
		if !item:
			return false
	return true


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")