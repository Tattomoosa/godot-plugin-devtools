@tool
extends CodeEdit

func on_drop(data: Variant) -> void:
	text = JSON.stringify(data, "\t", false)