extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Fonction qui est appelée lorsque l'Area2D entre en collision avec une autre



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		EventBus.player_was_hit.emit(30)
		print("touched")
	pass # Replace with function body.
