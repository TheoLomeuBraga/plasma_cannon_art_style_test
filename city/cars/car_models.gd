@tool
extends Node3D
class_name CarModel

@export_range(1,3,1) var selected_car : int

func apply() -> void:
	for c in get_children():
		c.visible = false
	
	get_child((selected_car - 1) % get_child_count()).visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		apply()
