extends CharacterBody2D

@export var SPEED:float = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		_HandleCollision()


func launch_toward(from: Vector2, where: Vector2) -> void:
	velocity = (from.direction_to(where) * SPEED)
	
func _HandleCollision() -> void:
	EventBus.player_was_hit.emit(15)
	queue_free()
