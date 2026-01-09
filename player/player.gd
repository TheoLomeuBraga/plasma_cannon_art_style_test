extends CharacterBody3D
class_name Player

@export_category("floor_estate")
@export var speed : float = 5.0
@export var friction : float = 50.0

@export_category("air_estate")
@export var jump_velocity : float = 4.5
@export var air_friction : float = 10.0

enum Estates {AIR,FLOOR}
var estate : Estates = Estates.AIR

func _floor_process(delta: float) -> void:
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * speed, friction * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, friction * delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if not is_on_floor():
		estate = Estates.AIR

func _air_process(delta: float) -> void:
	velocity += get_gravity() * delta
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * speed, air_friction * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, air_friction * delta)
	
	if is_on_floor():
		estate = Estates.FLOOR

func _physics_process(delta: float) -> void:
	
	match estate:
		Estates.AIR:
			_air_process(delta)
		Estates.FLOOR:
			_floor_process(delta)
	move_and_slide()
