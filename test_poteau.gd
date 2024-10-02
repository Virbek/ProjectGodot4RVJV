extends Node2D

@onready var player: CharacterBody2D = $player
@onready var sprite: AnimatedSprite2D = $player/AnimatedSprite2D

const SPEED = 300 # px per second
const largeur = 1000
const hauteur = 1000
var direction: Vector2
var anim_direction: String = "down"
var spawn = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var ix = Input.get_axis("player_left", "player_right")
	var iy = Input.get_axis("player_up", "player_down")
	var iv = Vector2(ix, iy).normalized()
	direction = iv
	player.velocity = iv * SPEED
	player.move_and_slide()
	
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
	
	spawn += delta
	if spawn > 5.0:
		SpawnPoteau()
	
func SpawnPoteau() -> void:
	spawn = 0
	var prefab_scene = preload("res://assets/poteau.tscn")
	var instance = prefab_scene.instantiate()
	add_child(instance)
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randi_range(0, largeur)
	var rndY = rng.randi_range(0, hauteur)
	instance.position = Vector2(rndX, rndY)
