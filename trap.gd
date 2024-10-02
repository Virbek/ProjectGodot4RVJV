extends Area2D

signal player_immobilized

var is_active: bool = true

@onready var trap_sound: AudioStreamPlayer2D = $trap_sound

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_Trap_body_entered"))

# Fonction appelée lorsque le joueur entre dans l'Area2D
func _on_Trap_body_entered(body: Node) -> void:
	if body.is_in_group("players") and is_active:
		if trap_sound:
			trap_sound.play()

		emit_signal("player_immobilized")

		deactivate_trap()

# Fonction pour désactiver le piège
func deactivate_trap() -> void:
	is_active = false
	set_process(false)
	set_physics_process(false)
	hide()
