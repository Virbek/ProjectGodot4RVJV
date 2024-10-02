extends Node2D

@onready var player: CharacterBody2D = $player
@onready var sprite: AnimatedSprite2D = $player/AnimatedSprite2D

@onready var slime: CharacterBody2D = $slime
@onready var sprite_slime: AnimatedSprite2D = $slime/AnimatedSprite2D

# Connectez le piège au moment où le script est prêt
@onready var trap: StaticBody2D = $trap

const SPEED = 300  # px per second

var direction: Vector2
var anim_direction: String = "down"

var direction_slime: Vector2 = Vector2.ZERO
var anim_direction_slime: String = "down"

# Variables pour l'immobilisation
var immobilize_delay: float = 3.0  # Le joueur sera immobilisé après 3 secondes
var immobilize_duration: float = 2.0  # Durée pendant laquelle le joueur est immobilisé
var timer: float = 0.0  # Compteur de temps pour déclencher l'immobilisation
var is_immobilized: bool = false  # Indique si le joueur est immobilisé
var has_been_immobilized: bool = false  # Indique si le joueur a déjà été immobilisé

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
	# movements player
	var ix = Input.get_axis("player_left", "player_right")
	var iy = Input.get_axis("player_up", "player_down")
	var iv = Vector2(ix, iy).normalized()
	direction = iv
	player.velocity = iv * SPEED
	player.move_and_slide()
	
	# animation
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
	
	# movements slime
	if(slime != null):
		if(slime.PlayerIsInExploseRange() && !slime.isExplosing):
			slime.startExplose()
			
		var iv_slime = Vector2(player.position.x - slime.position.x,player.position.y - slime.position.y).normalized()
		if slime.isSeeingPlayer():
			direction_slime = iv_slime
			slime.velocity = iv_slime * SPEED/2
			slime.move_and_slide()
			
		# animation
		var base_anim_slime = "idle_" if !slime.isSeeingPlayer() else "move_"
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
	has_been_immobilized = true  # Indique que le joueur a été immobilisé
	print("Le joueur est immobilisé !")
	
	# Griser le sprite
	sprite.modulate = Color(0.5, 0.5, 0.5)

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
