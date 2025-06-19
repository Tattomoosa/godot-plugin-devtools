## Gets the bit value of a mask/flag int at a specific index
static func get_bit_value_at(mask: int, bit_index: int) -> bool:
	return mask & (1 << bit_index) != 0


## Returns a copy of a mask/flag with a bit set
static func with_bit_at(mask: int, bit_index: int) -> int:
	return mask | (1 << bit_index)


## Returns a copy of a mask/flag with a bit unset
static func without_bit_at(mask: int, bit_index: int) -> int:
	return mask & ~(1 << bit_index)


static func has_flag(mask: int, flag: int) -> bool:
	return mask & flag != 0


static func set_flag(mask: int, flag: int) -> bool:
	return mask | flag


static func unset_flag(mask: int, flag: int) -> bool:
	return mask & ~flag


static func has_any(mask: int, bits: Array[int]) -> bool:
	for bit in bits:
		if has_flag(mask, bit):
			return true
	return false


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")
