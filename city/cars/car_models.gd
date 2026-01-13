@tool
extends Node3D
class_name CarModel

@export_range(0,2,1) var selected_car : int

func apply() -> void:
	for c in get_children():
		c.visible = false
	
	selected_car = selected_car % (get_child_count() - 2)
	
	get_child(selected_car).visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		apply()
