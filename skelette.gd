extends CharacterBody2D


@onready var player: CharacterBody2D = %player

@export var SPEED:float = 70.0
@export var _MIN_DISTANCE:float = 200  # le skelette voudra pas etre plus proche que ca
@export var _ATTACK_RANGE:float = 400
@export var _AGGRO_LOSE_RANGE:float = 500
@export var _ATTACK_COOLDOWN:float = 2.5

const bone = preload("res://bone.tscn")
var HasAggro: bool = false
var _TimeSinceLastAttack:float = 0

func _ready() -> void:
	_MoveRandomly()

func _physics_process(delta: float) -> void:
	_TimeSinceLastAttack -= delta
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	if not _IsInAggroRange():
		HasAggro = false

	if _SeesThePlayer():
		HasAggro = true
		if not _IsInAttackCooldown():
			_Attack(player.position)
	if not HasAggro:	
		var r = randf()
		if r < .02: ## 1 chance sur 10 de changer de direction
			_MoveRandomly()
	else:
		_FollowThePlayer()
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _MoveRandomly() -> void:
	velocity.x = 0
	velocity.y = 0
	match(randi_range(0, 3)):
		0:
			velocity.x = -1 * SPEED
		1:
			velocity.x = 1 * SPEED
		2:
			velocity.y = -1 * SPEED
		3:
			velocity.y = 1 * SPEED

func _FollowThePlayer() -> void:
	## le squelette peut tirer qu'en ligne droite donc il va se diriger
	## soit a midi, 6h, etc. par rapport au joueur
	var midi = player.position + Vector2(-_MIN_DISTANCE, 0)
	var troish = player.position + Vector2(0, _MIN_DISTANCE)
	var sixh = player.position + Vector2(_MIN_DISTANCE, 0)
	var neufh = player.position + Vector2(0, -_MIN_DISTANCE)
	
	## selectionne le point du cadran le plus proche
	## il me semble qu'on python on peut le faire en une seule instruction, avec min(..., key=lambda)
	var nearestv = min(position.distance_to(midi), 
		position.distance_to(troish), 
		position.distance_to(sixh), 
		position.distance_to(neufh)
	)
	
	var nearest: Vector2
	for p in [midi, troish, sixh, neufh]:
		if is_equal_approx(p.distance_to(position), nearestv):
			nearest = p
			break
	## du coup on fait ca en 10 instructions en gdscript
	
	velocity = Vector2(
		clampi(nearest.x - position.x, -1, 1), 
		clampi(nearest.y - position.y, -1, 1)).normalized() * SPEED

func _IsInAggroRange() -> bool:
	return position.distance_to(player.position) < _AGGRO_LOSE_RANGE

func _SeesThePlayer() -> bool:
	return _IsInAggroRange() \
	&& (abs(player.position.x - position.x) < 10 \
	|| abs(player.position.y - position.y) < 10)

func _IsInAttackCooldown() -> bool:
	return _TimeSinceLastAttack > 0

func _Attack(target: Vector2) -> void:
	_TimeSinceLastAttack = _ATTACK_COOLDOWN
	var b = bone.instantiate()
	b.launch_toward(position, target)
	add_child(b)
