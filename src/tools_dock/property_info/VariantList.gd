@tool
extends HFlowContainer

const VariantIconButton := preload("uid://brxc57qlv7nkq")

func _ready() -> void:
	for i in TYPE_MAX:
		var btn := VariantIconButton.new()
		btn.type = i as Variant.Type
		add_child(btn)
		btn.size = Vector2.ONE * 32 * EditorInterface.get_editor_scale()