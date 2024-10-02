extends Node2D

@onready var player: CharacterBody2D = %player
@onready var sprite: AnimatedSprite2D = %player/AnimatedSprite2D

@onready var slime: CharacterBody2D = %slime
@onready var sprite_slime: AnimatedSprite2D = $slime/AnimatedSprite2D
@onready var health_system: Node2D = $HealthSystem


const SPEED = 300 # px per second

var direction: Vector2
var anim_direction: String = "down"

var direction_slime: Vector2 = Vector2.ZERO
var anim_direction_slime: String = "down"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#EventBus.level_started.emit()
	#EventBus.level_started.connect(func(): pass)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_dt: float) -> void:
	_render_hud()
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
	
		
func _render_hud():
	var v = health_system.player_health
	%health_bar.value = v
	%health_text.text = "%d/100" % v
