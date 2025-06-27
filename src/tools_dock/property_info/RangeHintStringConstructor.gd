@tool
extends Control

signal constructed_hint_string(h_string: String)

@export var rounded := false
@export var hint_string : String

var min_value: float
var max_value: float
var step: float
var suffix : String
var allow_greater := false
var allow_lesser := false

func set_min(value: float) -> void:
	min_value = value
	construct()

func set_max(value: float) -> void:
	max_value = value
	construct()

func set_step(value: float) -> void:
	step = value
	construct()

func set_suffix(value: String) -> void:
	suffix = value
	construct()

func set_allow_greater(value: bool) -> void:
	allow_greater = value
	construct()

func set_allow_lesser(value: bool) -> void:
	allow_lesser = value
	construct()

func construct() -> void:
	hint_string = ("%d,%d,%d" if rounded else "%f,%f,%f") % [min_value,max_value,step]
	if suffix:
		hint_string += ",suffix:%s" % suffix
	if allow_greater:
		hint_string += ",or_greater"
	if allow_lesser:
		hint_string += ",or_less"
	constructed_hint_string.emit(hint_string)
	

