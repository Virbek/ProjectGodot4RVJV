extends Sprite2D


func _ready():
	# Get the viewport size (height)
	var viewport_size = get_viewport_rect().size

	# Get the height of the texture applied to the sprite
	if texture != null:
		var texture_height = texture.get_height()
		
		# Calculate the required scale factor to match the viewport height
		#var scale_factor = viewport_height / texture_height
		
		# Apply the scale to the sprite, keeping the aspect ratio consistent
		scale = Vector2(viewport_size.x, viewport_size.y)  # Scaling uniformly

func _on_resize():
	# Optional: Recalculate the scale if the window is resized
	_ready()
