@tool
extends TextureRect

var tween : Tween

func _ready() -> void:
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = EditorInterface.get_inspector().get_theme_icon("ActionCopy", &"EditorIcons")
	modulate = Color.TRANSPARENT

func show_and_fade() -> void:
	modulate = Color.WHITE
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, 0.5)

func _validate_property(property: Dictionary) -> void:
	if property.name == "texture":
		property.usage = PROPERTY_USAGE_NO_INSTANCE_STATE
