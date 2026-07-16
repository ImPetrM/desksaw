extends Node2D

var defpos: Vector2
@export var speed: float = 10.0
@export var attract_radius: float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defpos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = 1.0 - exp(-speed * delta)
	
	position = position.lerp(get_local_mouse_position(), t)
