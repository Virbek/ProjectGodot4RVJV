extends Area2D

signal player_immobilized

var is_active: bool = true  # Variable pour suivre l'état du piège

@onready var trap_sound: AudioStreamPlayer2D = $trap_sound  # Assurez-vous que le nœud est correctement référencé

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_Trap_body_entered"))

# Fonction appelée lorsque le joueur entre dans l'Area2D
func _on_Trap_body_entered(body: Node) -> void:
	if body.is_in_group("players") and is_active:
		# Jouer le son du piège
		if trap_sound:
			trap_sound.play()

		# Émettre le signal d'immobilisation
		emit_signal("player_immobilized")

		# Désactiver le piège
		deactivate_trap()

# Fonction pour désactiver le piège
func deactivate_trap() -> void:
	is_active = false  # Mettre à jour l'état du piège
	set_process(false)  # Désactiver le traitement du piège
	set_physics_process(false)  # Désactiver les processus physiques
	hide()  # Rendre le piège invisible
