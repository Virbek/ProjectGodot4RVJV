extends Node

var player_health = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $"../player/AnimatedSprite2D"
var timer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_was_hit.connect(func(dmg: int):
		print("Damage taken: %d" % dmg)
		player_health -= dmg
		player_health = max(0, player_health)
		animated_sprite_2d.modulate = Color(1,0,0)
		add_child(timer)
		timer.wait_time = 0.4
		timer.one_shot=false
		timer.connect("timeout",Callable(self, "anim_degat"))
		timer.start()
		if player_health == 0:
			EventBus.player_died.emit())
	EventBus.player_died.connect(func():
		print("Player died!"))

func anim_degat() -> void:
	animated_sprite_2d.modulate = Color(1,1,1)
