extends CharacterBody2D

@onready var vue_du_slime: CollisionShape2D = $VueDuSlime
@onready var player: CharacterBody2D = %player
@onready var explose_range: CollisionShape2D = $ExploseRange
@onready var slime_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_shake: Node2D = $"../player/Camera2D/camera_shake"
@onready var explosion_sound: AudioStreamPlayer2D = $explosion_sound
@onready var sprite_slime: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300 # px per second

var direction_slime: Vector2 = Vector2.ZERO
var anim_direction_slime: String = "down"

var isExplosing: bool = false
var isStopped: bool = false
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
	isStopped=true
	isExplosing = true
	slime_sprite.modulate = Color(0.9,0,0)
	slime_sprite.play("shaking")
	#vue_du_slime.shape.radius = 0
	
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot=true
	timer.connect("timeout",Callable(self, "badaboum"))
	timer.start()

func badaboum() -> void :
	if(PlayerIsInExploseRange()):
		EventBus.player_was_hit.emit(30)
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
	
func _physics_process(delta: float) -> void:
	# movements slime
	if(self != null):
		if(self.PlayerIsInExploseRange() && !self.isExplosing):
			self.startExplose()
						
		var iv_slime = Vector2(player.position.x - self.position.x,player.position.y - self.position.y).normalized()
		if self.isSeeingPlayer() and !self.isStopped:
			direction_slime = iv_slime
			self.velocity = iv_slime * SPEED/2
			self.move_and_slide()
			
		# animation
		var base_anim_slime = "idle_" if !self.isSeeingPlayer() else "move_"
		var flip_x_slime = false
		if direction_slime.y > 0.7:
			anim_direction_slime = "down"
		elif direction_slime.y < -0.7:
			anim_direction_slime = "up"
		elif direction_slime.x < -0.7:
			anim_direction_slime = "right"
			flip_x_slime = true
		elif direction_slime.x > 0.7:
			anim_direction_slime = "right"
		
		var animation_name_slime = base_anim_slime + anim_direction_slime
		if(!self.isExplosing):
			sprite_slime.play(animation_name_slime)
		sprite_slime.flip_h = flip_x_slime
