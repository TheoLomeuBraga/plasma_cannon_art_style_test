extends Control

@export var transition_time = 5.0

@onready var rect : ColorRect = $ColorRect

var transparency_tween : Tween
var volume_tween : Tween

var scene_volume : float = 0 :
	set(value):
		scene_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), scene_volume)

func _ready() -> void:
	if Player.current != null:
		Player.current.set_process(false)
		Player.current.set_physics_process(false)
		Player.current.set_process_input(false)
		rect.color = Color(0.0, 0.0, 0.0, 1.0)
		scene_volume = -80
		
		await get_tree().create_timer(0.1).timeout
		
		transparency_tween = get_tree().create_tween()
		transparency_tween.tween_property(rect, "color", Color(0.0, 0.0, 0.0, 0.0), transition_time)
		
		volume_tween = get_tree().create_tween()
		volume_tween.tween_property(self, "scene_volume", 0.0, transition_time)
		
		await transparency_tween.finished
		await volume_tween.finished
		
		Player.current.set_process(true)
		Player.current.set_physics_process(true)
		Player.current.set_process_input(true)
	else:
		print("error no player")
	
