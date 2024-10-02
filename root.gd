extends Node2D
@onready var player: CharacterBody2D = $player
@onready var sprite: AnimatedSprite2D = $player/AnimatedSprite2D
@onready var slime: CharacterBody2D = $slime
@onready var sprite_slime: AnimatedSprite2D = $slime/AnimatedSprite2D
@onready var trap: Area2D = $trap
@onready var immobilization_label: Label = $player/immobilization_timer

const SPEED = 300 # px per second

var direction: Vector2
var anim_direction: String = "down"
var direction_slime: Vector2 = Vector2.ZERO
var anim_direction_slime: String = "down"

# Variable pour l'immobilisation
var is_immobilized: bool = false
var has_played_sound: bool = false
var immobilization_time_left: float = 0.0
var immobilization_duration: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#EventBus.level_started.emit()
	#EventBus.level_started.connect(func(): pass)
	player.add_to_group("players")
	trap.connect("player_immobilized", Callable(self, "_on_Trap_immobilize_player"))

func _physics_process(_dt: float) -> void:
	if not is_immobilized:
		# mouvements du joueur
		var ix = Input.get_axis("player_left", "player_right")
		var iy = Input.get_axis("player_up", "player_down")
		var iv = Vector2(ix, iy).normalized()
		direction = iv
		player.velocity = iv * SPEED
		player.move_and_slide()
	
		# animation du joueur
		var base_anim = "idle_" if direction.length() < .1 else "move_"
		var flip_x = false
		if direction.y > 0:
			anim_direction = "down"
		elif direction.y < 0:
			anim_direction = "up"
		elif direction.x < 0:
			anim_direction = "right"
			flip_x = true
		elif direction.x > 0:
			anim_direction = "right"
	
		var animation_name = base_anim + anim_direction
		sprite.play(animation_name)
		sprite.flip_h = flip_x
	
	# mouvements du slime
	if(slime != null):
		if(slime.PlayerIsInExploseRange() and not slime.isExplosing):
			slime.startExplose()
						
		var iv_slime = Vector2(player.position.x - slime.position.x,player.position.y - slime.position.y).normalized()
		if slime.isSeeingPlayer():
			direction_slime = iv_slime
			slime.velocity = iv_slime * SPEED/2
			slime.move_and_slide()
			
		# animation du slime
		var base_anim_slime = "idle_" if not slime.isSeeingPlayer() else "move_"
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
	
	# Réduire le temps restant
	immobilization_time_left -= _dt
	var seconds = floor(immobilization_time_left)
	var tenths = floor((immobilization_time_left - seconds) * 10)
	immobilization_label.text = str(seconds) + "." + str(tenths) + "s"


# Fonction pour immobiliser le joueur
func immobilize_player() -> void:
	immobilization_time_left = immobilization_duration
	is_immobilized = true
	player.set_physics_process(false)
	sprite.modulate = Color(0.5, 0.5, 0.5)
	immobilization_label.show()
	immobilization_label.text = str(immobilization_time_left)

# Fonction pour libérer le joueur après l'immobilisation
func free_player() -> void:
	is_immobilized = false
	player.set_physics_process(true)
	sprite.modulate = Color(1, 1, 1)
	immobilization_label.hide()

# Fonction appelée lorsque le signal est reçu
func _on_Trap_immobilize_player() -> void:
	immobilize_player()
	await get_tree().create_timer(immobilization_duration).timeout
	free_player()
