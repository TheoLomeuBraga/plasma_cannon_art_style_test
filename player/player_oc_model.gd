@tool
extends Node3D
class_name PlayerOCModel

@onready var animation_tree : AnimationTree = $metarig/AnimationTree

@export_range(0.0,2.0,0.05) var walk_speed = 0.0 : 
	set(value):
		if animation_tree != null:
			walk_speed = value
			animation_tree.set("parameters/walk_speed/blend_position",value)

enum  Modes {FLOOR,AIR}
@export var mode : Modes = Modes.FLOOR :
	set(value):
		if animation_tree != null:
			mode = value
			match mode:
				Modes.FLOOR:
					animation_tree.set("parameters/estate/transition_request","floor")
				Modes.AIR:
					animation_tree.set("parameters/estate/transition_request","air")

func _ready() -> void:
	walk_speed = walk_speed
	mode = mode
