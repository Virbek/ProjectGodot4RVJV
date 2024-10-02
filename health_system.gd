extends Node

var player_health = 100
var tween: Tween

@onready var sprite_hit:Sprite2D = $"../player/Camera2D/masque_blessure"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_was_hit.connect(func(dmg: int):
		print("Damage taken: %d" % dmg)
		player_health -= dmg
		player_health = max(0, player_health)
		if player_health == 0:
			EventBus.player_died.emit()
		#sprite.material.set_shader_property("force", 1)
		var mat:ShaderMaterial = sprite_hit.material
		mat.set_shader_parameter("force", 1)
		tween_to_value(0., .5)
	)
	
	EventBus.player_died.connect(func():
		print("Player died!")
	)

func tween_to_value(value:float, duration:float) -> void:
	var shader_material = sprite_hit.material as ShaderMaterial
	tween = get_tree().create_tween()

	# Use the Tween node to interpolate the shader parameter
	tween.tween_property(
		shader_material, "shader_parameter/force", value, duration).set_trans(
			Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

	await tween.finished
	print("OK")
	# Optional: Connect the tween's completed signal to a function
	#tween.connect("tween_completed", self, "_on_tween_completed")
