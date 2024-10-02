extends Node2D
@onready var player: CharacterBody2D = $player
@onready var sprite: AnimatedSprite2D = $player/AnimatedSprite2D
@onready var slime: CharacterBody2D = $slime
@onready var sprite_slime: AnimatedSprite2D = $slime/AnimatedSprite2D
@onready var trap: Area2D = $trap
@onready var immobilization_label: Label = $player/immobilization_timer

# Connectez le piège au moment où le script est prêt
@onready var trap: StaticBody2D = $trap

const SPEED = 300  # px per second

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
	add_to_group("players")  # Ajoutez le joueur au groupe "players"
	trap.connect("body_entered", _on_Trap_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Compte le temps écoulé pour l'immobilisation
	timer += delta

	# Si le temps écoulé dépasse le délai et que le joueur n'est pas déjà immobilisé
	if timer >= immobilize_delay and not is_immobilized and not has_been_immobilized:
		immobilize_player()

	# Si le joueur est immobilisé, gère la durée d'immobilisation
	if is_immobilized:
		if timer >= immobilize_delay + immobilize_duration:
			free_player()

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
	if is_immobilized:  # Vérifie si le joueur est effectivement immobilisé
		is_immobilized = false
		player.set_physics_process(true)  # Réactive les mouvements du joueur
		timer = 0.0  # Réinitialise le timer pour une éventuelle prochaine immobilisation
		print("Le joueur peut bouger à nouveau !")
		
		# Rétablir la couleur d'origine
		sprite.modulate = Color(1, 1, 1)  # Rétablit la couleur d'origine (blanc)

# Fonction pour détecter le contact avec le piège
func _on_Trap_body_entered(body: Node) -> void:
	if body.is_in_group("players"):  # Vérifiez si le corps est le joueur
		immobilize_player()  # Appelez la fonction d'immobilisation

		#var animation_name_slime = base_anim_slime + anim_direction_slime
		#if(!slime.isExplosing):
		#	sprite_slime.play(animation_name_slime)
		#sprite_slime.flip_h = flip_x_slime
