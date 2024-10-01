extends Node

var player_health = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_was_hit.connect(func(dmg: int):
		print("Damage taken: %d" % dmg)
		player_health -= dmg
		player_health = max(0, player_health)
		if player_health == 0:
			EventBus.player_died.emit())
	EventBus.player_died.connect(func():
		print("Player died!"))
