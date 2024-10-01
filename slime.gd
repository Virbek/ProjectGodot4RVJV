extends CharacterBody2D
@onready var vue_du_slime: CollisionShape2D = $VueDuSlime
@onready var player: CharacterBody2D = %player
@onready var explose_range: CollisionShape2D = $ExploseRange
@onready var slime_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_shake: Node2D = $"../player/Camera2D/camera_shake"
@onready var explosion_sound: AudioStreamPlayer2D = $explosion_sound

var isExplosing: bool = false
var timer := Timer.new()
var timer_boum := Timer.new()


func isSeeingPlayer() -> bool:
	if vue_du_slime.shape is CircleShape2D and player:
		var player_global_pos = player.global_position
		var slime_global_pos = global_position

		var distance_to_player = slime_global_pos.distance_to(player_global_pos)

		#rayon du CircleShape2D
		var shape_radius = (vue_du_slime.shape as CircleShape2D).radius
		
		# Prendre en compte l'échelle globale du CollisionShape2D
		var global_scale = vue_du_slime.global_scale
		# Compense le rayon avec l'échelle globale
		var adjusted_radius = shape_radius * global_scale.x  # On utilise l'échelle sur l'axe X (ou y puisse que on a un scaling uniforme)

		if distance_to_player <= adjusted_radius:
			return true
	
	return false
	
func PlayerIsInExploseRange() -> bool:
	if explose_range.shape is CircleShape2D and player:
		var player_global_pos = player.global_position
		var slime_global_pos = global_position

		var distance_to_player = slime_global_pos.distance_to(player_global_pos)

		#rayon du CircleShape2D
		var shape_radius = (explose_range.shape as CircleShape2D).radius
		
		# Prendre en compte l'échelle globale du CollisionShape2D
		var global_scale = explose_range.global_scale
		# Compense le rayon avec l'échelle globale
		var adjusted_radius = shape_radius * global_scale.x  # On utilise l'échelle sur l'axe X (ou y puisse que on a un scaling uniforme)

		if distance_to_player <= adjusted_radius:
			return true
	
	return false
	
func startExplose() -> void:
	isExplosing = true
	slime_sprite.modulate = Color(0.9,0,0)
	slime_sprite.play("shaking")
	vue_du_slime.shape.radius = 0
	
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot=true
	timer.connect("timeout",Callable(self, "badaboum"))
	timer.start()

func badaboum() -> void :
	if(PlayerIsInExploseRange()):
		player.takedamage(5)
	explosion_sound.play()
	camera_shake.shake()
	slime_sprite.play("explose")
	add_child(timer_boum)
	timer_boum.wait_time = 1.0
	timer_boum.one_shot=true
	timer_boum.connect("timeout",Callable(self, "destroy_slime"))
	timer_boum.start()
	pass

func destroy_slime() ->void :
	slime_sprite.visible = false
	timer.stop()
	timer_boum.stop()
	queue_free()
