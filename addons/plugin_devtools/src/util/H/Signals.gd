## The most useful function for dealing with resource properties, ever!
##
## ``` gdscript
## @export var resource : SomeResource:
## 	 set(v):
##		 Signals.swap(resource, v, "changed", _on_changed)
##     resource = v
## ```
static func swap(from: Object, to: Object, signal_name: StringName, callable: Callable, flags: int = 0) -> void:
	if from:
		var signal_a : Signal = from.get(signal_name)
		disconnect_if_connected(signal_a, callable)
	if to:
		var signal_b : Signal = to.get(signal_name)
		connect_if_not_connected(signal_b, callable, flags)


static func connect_if_not_connected(p_signal: Signal, callable: Callable, flags: int = 0) -> void:
	if !p_signal.is_connected(callable):
		var result := p_signal.connect(callable, flags)
		if result != OK:
			push_warning(error_string(result))


static func disconnect_if_connected(p_signal: Signal, callable: Callable) -> void:
	if p_signal.is_connected(callable):
		p_signal.disconnect(callable)


static func get_objects_defining_signals(obj: Object) -> Dictionary[String, PackedStringArray]:
	return {}


# would be better to implement on the callable side I think actually, because you need to keep
# a callable reference to disconnect a signal anyway
class SignalDebouncer extends RefCounted:
	signal ready
	var dirty := false
	var _NO_ARG := RefCounted.new()
	var args : Array = []

	func _init() -> void:
		args.resize(10)

	func on_signal(
		arg0: Variant=_NO_ARG, arg1: Variant=_NO_ARG, arg2: Variant=_NO_ARG, arg3: Variant=_NO_ARG, arg4: Variant=_NO_ARG, arg5: Variant=_NO_ARG, arg6: Variant=_NO_ARG, arg7: Variant=_NO_ARG, arg8: Variant=_NO_ARG, arg9: Variant=_NO_ARG
	) -> void:
		args[0] = arg0; args[1] = arg1; args[2] = arg2; args[3] = arg3; args[4] = arg4; args[5] = arg5; args[6] = arg6; args[7] = arg7; args[8] = arg8; args[9] = arg9
		if !dirty:
			_set_clean.call_deferred()
		dirty = true
	
	func _set_clean() -> void:
		dirty = false
		var real_args := args.filter(func(x): return x is not RefCounted or x != _NO_ARG)
		ready.emit.callv(real_args)
		
func _init() -> void: assert(false, "Class can't be instantiated")
