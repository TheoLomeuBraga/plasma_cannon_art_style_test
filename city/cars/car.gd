extends PathFollow3D
class_name Car

static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@onready var car_model : CarModel = $cars

@export var speed : float = 20.0

func _ready() -> void:
	car_model.selected_car = rng.randi()
	car_model.apply()
	if speed > 0.0:
		car_model.rotation_degrees.y = 180

func _physics_process(delta: float) -> void:
	progress += speed * delta
