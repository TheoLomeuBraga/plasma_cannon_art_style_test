extends CharacterBody3D
class_name Player

static var current : Player

@onready var player_oc_model : PlayerOCModel =  $player_oc_model
@onready var rotation_ref : Node3D = $rotation_ref

@export_category("camera")
@onready var camera_basis_y : Node3D = $camera_basis_y
@onready var camera_basis_x : Node3D = $camera_basis_y/camera_basis_x
@onready var camera : Camera3D = $camera_basis_y/camera_basis_x/SpringArm3D/Camera3D
@export var camera_sensitivity_mouse : float = 1.0
@export var camera_sensitivity_gamepad : float = 2.0

@onready var sfx_steps : AudioStreamPlayer3D = $sfx/steps
@onready var sfx_jump : AudioStreamPlayer3D = $sfx/jump
@onready var spring_arm_camera : SpringArm3D = $camera_basis_y/camera_basis_x/SpringArm3D

func _camera_process(delta : float) -> void:
	
	camera_basis_y.rotation.y += delta * Input.get_axis("look_right","look_left") * camera_sensitivity_gamepad
	camera_basis_x.rotation.x += delta * Input.get_axis("look_down","look_up") * camera_sensitivity_gamepad
	
	camera_basis_y.global_position = global_position
	camera_basis_x.rotation.x = clamp(camera_basis_x.rotation.x,deg_to_rad(-60.0),deg_to_rad(60.0))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mm : InputEventMouseMotion = event
		camera_basis_y.rotation.y -= (mm.relative.x * camera_sensitivity_mouse) / 100.0
		
		camera_basis_x.rotation.x -= (mm.relative.y * camera_sensitivity_mouse) / 100.0
	
	if Input.is_action_pressed("hide_cursor"):
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE

@export_category("floor_estate")
@export var speed : float = 10.0
@export var friction : float = 100.0
@export var rotation_speed : float = 10.0

@export_category("air_estate")
@export var jump_velocity : float = 4.5
@export var air_friction : float = 10.0

enum Estates {AIR,FLOOR}
var estate : Estates = Estates.AIR

func _ready() -> void:
	sfx_steps.play()
	current = self
	camera_basis_y.global_position = global_position
	camera_basis_y.global_rotation = global_rotation
	spring_arm_camera.add_excluded_object(self)

func rotate_charter_to_direction(delta: float,direction : Vector3) -> void:
	var new_direction : Vector3 = -Vector3(direction.x,0.0,direction.z).normalized()
	if rotation_ref.global_position != rotation_ref.global_position + new_direction:
		rotation_ref.look_at(rotation_ref.global_position + new_direction)
	
	player_oc_model.rotation.y = rotate_toward(player_oc_model.rotation.y,rotation_ref.rotation.y,rotation_speed * delta)

func _floor_process(delta: float) -> void:
	
	player_oc_model.mode = player_oc_model.Modes.FLOOR
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction : Vector3 = (camera_basis_y.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * speed, friction * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, friction * delta)
	
	player_oc_model.walk_speed = move_toward(player_oc_model.walk_speed,input_dir.length()* 2.0,delta * 5.0) 
	
	sfx_steps.volume_db = linear_to_db(input_dir.length()*0.05)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		sfx_jump.play()
	
	rotate_charter_to_direction(delta,direction)
	
	if not is_on_floor():
		estate = Estates.AIR

func _air_process(delta: float) -> void:
	
	sfx_steps.volume_db = linear_to_db(0.0)
	
	player_oc_model.mode = player_oc_model.Modes.AIR
	
	velocity += get_gravity() * delta
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction : Vector3 = (camera_basis_y.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * speed, air_friction * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, air_friction * delta)
	
	if is_on_floor():
		estate = Estates.FLOOR


func _physics_process(delta: float) -> void:
	
	_camera_process(delta)
	
	match estate:
		Estates.AIR:
			_air_process(delta)
		Estates.FLOOR:
			_floor_process(delta)
	move_and_slide()

func _exit_tree() -> void:
	current = null
