extends CharacterBody2D


const SPEED = 70.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	var r = randf()
	if r < .02: ## 1 chance sur 10 de changer de direction
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
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
