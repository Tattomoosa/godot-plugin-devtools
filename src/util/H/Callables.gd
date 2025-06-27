@tool
static var _NO_ARG = RefCounted.new()


static func truncate_args(callable: Callable, max_count: int) -> Callable:
		assert(max_count >= 0 and max_count <= 10)
		return func (a0 = _NO_ARG, a1 = _NO_ARG, a2 = _NO_ARG, a3 = _NO_ARG, a4 = _NO_ARG,
						a5 = _NO_ARG, a6 = _NO_ARG, a7 = _NO_ARG, a8 = _NO_ARG, a9 = _NO_ARG):
				var args := [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]
				for i in 10:
						if i == max_count or is_same(args[i], _NO_ARG):
								args.resize(i)
								break
				callable.callv(args)


static func unbind_all(callable: Callable) -> Callable:
	return truncate_args(callable, 0)


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")