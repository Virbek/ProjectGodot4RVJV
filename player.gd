extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

func takedamage(damage:int) -> void:
	print(str(damage) + " dégats reçus")
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
