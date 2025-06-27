@tool
extends Button
# color_map_button.tscn

@export var og_color : Color:
	set(v):
		og_color = v
		if !is_node_ready(): return
		_update()
@export var mapped_color : Color:
	set(v):
		mapped_color = v
		if !is_node_ready(): return
		_update()
@export var gradient : GradientTexture1D

@onready var og_color_rect := %OriginalColor
@onready var mapped_color_rect := %MappedColor

func _ready() -> void:
	_update()

func _update() -> void:
	og_color_rect.color = og_color
	mapped_color_rect.color = mapped_color
	gradient.gradient.colors = [og_color, mapped_color]