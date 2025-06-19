@tool
## Waits for a duration to elapse
static func wait(duration: float) -> void:
	await Engine.get_main_loop().create_timer(duration).timeout


## Waits a frame
static func wait_frame() -> void:
	await Engine.get_main_loop().process_frame


## Static class
func _init() -> void: assert(false, "Class can't be instantiated")

# TODO await any/all signals/callables
# class Awaiter extends RefCounted:
# 	signal finished

# 	func await_all(awaitables: Array) -> void:
# 		for awaitable in awaitables:
	

## Counts time, very accurately, from when it's instanced.
class Stopwatch extends RefCounted:
	var start_time : int
	var _use_usecs := false
	var elapsed : int:
		get: return get_elapsed()


	func _init(use_usecs := false) -> void:
		_use_usecs = use_usecs
		start_time = (
			Time.get_ticks_usec()
				if _use_usecs
				else Time.get_ticks_msec()
		)


	func get_elapsed() -> int:
		if _use_usecs:
			return Time.get_ticks_usec() - start_time
		else:
			return Time.get_ticks_msec() - start_time


	func get_elapsed_string() -> String:
		return "%d%s" % [
			elapsed,
			"us" if _use_usecs else "ms"
		]
	

	func get_elapsed_seconds() -> float:
		if _use_usecs:
			return elapsed / 1_000_000.0
		else:
			return elapsed / 1_000.0

## Counts frames from whenever it's instanced, either process (drawing) or physics
class FrameCounter extends RefCounted:
	var start_frame: int
	var _use_physics := false

	enum StartFrame { CURRENT_FRAME = -1, START_FRAME = 0 }


	func _init(use_physics := false, starting_frame := StartFrame.CURRENT_FRAME ) -> void:
		_use_physics = use_physics
		match starting_frame:
			StartFrame.CURRENT_FRAME:
				start_frame = Engine.get_physics_frames() if _use_physics else Engine.get_process_frames()
			StartFrame.START_FRAME:
				start_frame = 0
	

	func get_frames() -> int:
		var frame := Engine.get_physics_frames() if _use_physics else Engine.get_process_frames()
		return frame - start_frame