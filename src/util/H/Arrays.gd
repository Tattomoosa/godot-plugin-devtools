## Array.reversed, but returns a new array
static func reversed(array: Array) -> Array:
	var a := array.duplicate()
	a.reverse()
	return a


## Array.shuffle, but returns a new array
static func shuffled(array: Array) -> Array:
	var a := array.duplicate()
	a.shuffle()
	return a


static func swap(array: Array, from: int, to: int) -> void:
	var a = array[from]
	var b = array[to]
	array[to] = a
	array[from] = b


## Array.find_custom, but also grabs the value
static func find_and_get(array: Array, callable: Callable) -> Variant:
	var index := array.find_custom(callable)
	return array[index] if index >= 0 else null


static func get_first_dictionary_matching_property(array: Array, key: String, value: Variant) -> Dictionary:
	var dict : Variant = find_and_get(
		array,
		func(x):
			return x is Dictionary and key in x and x[key] == value
	)
	if dict == null: return {}
	return dict

static func intersection(a: Variant, b: Variant) -> Array:
	if !is_array(a):
		if is_array(b):
			push_warning(a, " is not an array")
			return b
	if !is_array(b):
		return []
	var both := []
	for item in a:
		if item in b:
			both.push_back(item)
	return both


static func is_array(array: Variant) -> bool:
	if array is Array\
	or array is PackedByteArray\
	or array is PackedInt32Array\
	or array is PackedInt64Array\
	or array is PackedFloat32Array\
	or array is PackedFloat64Array\
	or array is PackedStringArray\
	or array is PackedVector2Array\
	or array is PackedVector3Array\
	or array is PackedColorArray\
	or array is PackedVector4Array:
		return true
	return false


static func is_in_typelist(value: Variant, type_list: Array) -> bool:
	for type in type_list:
		if value.is_instance_of(type):
			return true
	return false


## 'Static' class
func _init() -> void: assert(false, "Class can't be instantiated")
