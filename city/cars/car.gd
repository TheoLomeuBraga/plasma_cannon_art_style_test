extends PathFollow3D
class_name Car

static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@onready var car_model : CarModel = $cars
@onready var shape_cast : ShapeCast3D = $cars/ShapeCast3D

@export var speed : float = 20.0

func _ready() -> void:
	car_model.selected_car = rng.randi()
	car_model.apply()
	if speed > 0.0:
		car_model.rotation_degrees.y = 180

func _physics_process(delta: float) -> void:
	
	for i in shape_cast.get_collision_count():
		print(shape_cast.get_collider(i) is CharacterBody3D)
		if shape_cast.get_collider(i) is CharacterBody3D:
			return
	
	progress += speed * delta
	
