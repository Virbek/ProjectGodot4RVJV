extends Node2D

@export var RANDOM_SHAKE_STRENGTH: float = 35.0
@export var SHAKE_DECAY_RATE: float = 6.0
@onready var rand = RandomNumberGenerator.new()
@onready var camera: Camera2D = $".."
var shake_strength: float = 0.0

func _ready() -> void:
	rand.randomize()
	
func shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH

func _process(delta: float) -> void:
	shake_strength =lerp(shake_strength,0.0,SHAKE_DECAY_RATE * delta)
	camera.offset = get_random_offset()

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength,shake_strength),
		rand.randf_range(-shake_strength,shake_strength)
	)
