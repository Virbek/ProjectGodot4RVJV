extends Node2D

@onready var player: CharacterBody2D = $player
@onready var sprite: AnimatedSprite2D = $player/AnimatedSprite2D

@onready var slime: CharacterBody2D = $slime
@onready var sprite_slime: AnimatedSprite2D = $slime/AnimatedSprite2D

# Connectez le piège au moment où le script est prêt
@onready var trap: Area2D = $trap

const SPEED = 300  # px per second

var direction: Vector2
var anim_direction: String = "down"

var direction_slime: Vector2 = Vector2.ZERO
var anim_direction_slime: String = "down"

# Variable pour l'immobilisation
var is_immobilized: bool = false  # Indique si le joueur est immobilisé
var has_played_sound: bool = false  # Indique si le son a déjà été joué

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.add_to_group("players")
	
	# Connexion du signal "player_immobilized" du piège
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


# Fonction pour immobiliser le joueur
func immobilize_player() -> void:
	is_immobilized = true
	player.set_physics_process(false)  # Désactive les mouvements du joueur
	
	# Griser le sprite
	sprite.modulate = Color(0.5, 0.5, 0.5)

# Fonction pour libérer le joueur après l'immobilisation
func free_player() -> void:
	is_immobilized = false
	player.set_physics_process(true)  # Réactive les mouvements du joueur
	
	# Rétablir la couleur d'origine
	sprite.modulate = Color(1, 1, 1)

# Fonction appelée lorsque le signal est reçu
func _on_Trap_immobilize_player() -> void:
	immobilize_player()
	# Libérer après 2 secondes
	await get_tree().create_timer(2.0).timeout
	free_player()
